import 'package:flutter/material.dart';

import 'text_tag.dart';

abstract interface class TaggedTextDelegate {
  List<InlineSpan> generate(String text, Iterable<TextTag> tags);
  bool checkIfTextTagsIsValid(String text, Iterable<TextTag> tags);
}

class GenerateTaggedTextDelegate implements TaggedTextDelegate {
  const GenerateTaggedTextDelegate();

  @override
  @visibleForTesting
  List<InlineSpan> generate(String text, Iterable<TextTag> tags) {
    List<InlineSpan> result = [];

    ft() => _firstTag(text, tags);
    for (var tag = ft(); tag != null; tag = ft()) {
      final startIndex = text.indexOf(tag.openingTag);
      final untaggedText = text.substring(0, startIndex);
      if (untaggedText.isNotEmpty) result.add(_textSpan(untaggedText));

      var taggedText = text.substring(startIndex + tag.openingTag.length);
      final endIndex = taggedText.indexOf(tag.closingTag);

      final hasClosingTag = endIndex >= 0;
      if (hasClosingTag) {
        text = taggedText.substring(endIndex + tag.closingTag.length);
        taggedText = taggedText.substring(0, endIndex);
      } else {
        text = '';
      }

      // Before 'applyToText' changes the text
      final hasSubtag = _firstTag(taggedText, tags) != null;
      TextSpanConfig? config = tag.fromText?.call(taggedText) ?? tag;

      final maybeApplyToText = tag.applyToText?.call(taggedText);
      if (maybeApplyToText != null) taggedText = maybeApplyToText;

      result.add(hasSubtag //
          ? _textSpan(null, config, generate(taggedText, tags))
          : _textSpan(taggedText, config));
    }

    if (text.isNotEmpty) result.add(_textSpan(text));
    return result;
  }

  TextSpan _textSpan(
    String? text, [
    TextSpanConfig? config,
    List<InlineSpan>? children,
  ]) {
    return TextSpan(
      text: text,
      children: children,
      style: config?.style,
      recognizer: config?.recognizer,
      mouseCursor: config?.mouseCursor,
      onEnter: config?.onEnter,
      onExit: config?.onExit,
      locale: config?.locale,
      semanticsLabel: config?.semanticsLabel,
      spellOut: config?.spellOut,
    );
  }

  TextTag? _firstTag(String text, Iterable<TextTag> tags) {
    if (text.isEmpty) return null;

    TextTag? result;
    int? minIndex;
    for (var tag in tags) {
      final marking = tag.openingTag;
      if (marking.isEmpty) continue;

      final index = text.indexOf(marking);
      if (index < 0 || (minIndex != null && index >= minIndex)) continue;

      minIndex = index;
      result = tag;
    }
    return result;
  }

  @override
  @visibleForTesting
  bool checkIfTextTagsIsValid(String text, Iterable<TextTag> tags) {
    final closingMarksList = <String>[];

    for (; text.isNotEmpty; text = text.substring(1)) {
      for (final tag in tags) {
        final openingTag = tag.openingTag;
        final closingTag = tag.closingTag;

        if (text.startsWith(openingTag)) {
          final shouldAddMark = openingTag != closingTag ||
              closingMarksList.isEmpty ||
              closingTag != closingMarksList.last;
          if (shouldAddMark) {
            closingMarksList.add(closingTag);
            break;
          }

          closingMarksList.removeLast();
          break;
        } else if (text.startsWith(closingTag)) {
          if (closingMarksList.isEmpty) return false;

          final last = closingMarksList.removeLast();
          if (closingTag != last) return false;
          break;
        }
      }
    }

    return closingMarksList.isEmpty;
  }
}
