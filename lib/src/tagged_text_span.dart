import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'generate_tagged_text_delegate.dart';
import 'text_tag.dart';

/// Creates a custom [TextSpan] based on [TextTag] to config parts of the [text].
///
/// Usage example:
/// ```dart
/// void main() => runApp(MaterialApp(
///       home: Scaffold(body: Container(
///         padding: const EdgeInsets.all(8.0),
///         alignment: Alignment.center,
///         child: TaggedTextSpan(
///           'Text: **((L))orem {{((I))psum}}** is simply ((dummy)) {{text}} of the printing and **typesetting** <<industry>>.',
///           mainStyle: const TextStyle(color: Colors.purple),
///           tags: [
///             const TextTag(openingTag: '**', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
///             const TextTag(openingTag: '((', closingTag: '))', style: TextStyle(color: Colors.red)),
///             const TextTag(openingTag: '{{', closingTag: '}}', style: TextStyle(fontSize: 22)),
///             TextTag(openingTag: '<<', closingTag: '>>', applyToText: (text) => '###'),
///           ],
///         ).toWidget(),
///       )),
///     ));
/// ```
///
/// Example output:
///
/// ![](https://github.com/Nicollas1705/Nicollas1705/assets/58062436/c05e7bbd-d5e1-41e6-8dae-08f5a3e9c775)
///
/// To display as [Widget], use [toWidget] method (returns a [Text] widget).
class TaggedTextSpan extends TextSpan {
  const TaggedTextSpan._({
    required this.isTextTagsValid,
    super.children,
    super.style,
    super.locale,
    super.mouseCursor,
    super.onEnter,
    super.onExit,
    super.recognizer,
    super.semanticsLabel,
    super.spellOut,
  });

  /// Generates a [TextSpan] with the correct config according to its [TextTag].
  ///
  /// If [useDefaultTags] is true, then [defaultTags] (check this out) will be added to [tags].
  ///
  /// If [ignoreTextTagsCheckingComputation] is true, then it will ignore the checking of
  /// [isTextTagsValid], being always true.
  factory TaggedTextSpan(
    String text, {
    required List<TextTag> tags,
    TextStyle? mainStyle,
    Locale? locale,
    MouseCursor? mouseCursor,
    void Function(PointerEnterEvent event)? onEnter,
    void Function(PointerExitEvent event)? onExit,
    GestureRecognizer? recognizer,
    String? semanticsLabel,
    bool? spellOut,
    bool useDefaultTags = true,
    bool ignoreTextTagsCheckingComputation = false,
  }) {
    // Avoiding const lists
    final textTags = [
      ...tags,
      if (useDefaultTags) ...defaultTags,
    ];

    return TaggedTextSpan._(
      children: generate(text, textTags),
      isTextTagsValid: ignoreTextTagsCheckingComputation //
          ? true
          : checkIfTextTagsIsValid(text, textTags),
      style: mainStyle,
      locale: locale,
      mouseCursor: mouseCursor,
      onEnter: onEnter,
      onExit: onExit,
      recognizer: recognizer,
      semanticsLabel: semanticsLabel,
      spellOut: spellOut,
    );
  }

  static const TaggedTextDelegate _delegate = GenerateTaggedTextDelegate();

  /// Default tags configuration:
  ///
  /// | **Tag** | **Style**
  /// | :------ | :--------
  /// | `**`    | Bold
  /// | `//`    | Italic
  /// | `__`    | Underlined
  /// | `--`    | Line through text
  /// | `^^`    | Overlined
  /// | `..`    | Underline dotted
  /// | `~~`    | Underline wavy
  static const defaultTags = <TextTag>[
    TextTag(openingTag: '**', style: TextStyle(fontWeight: FontWeight.bold)),
    TextTag(openingTag: '//', style: TextStyle(fontStyle: FontStyle.italic)),
    TextTag(openingTag: '__', style: TextStyle(decoration: TextDecoration.underline)),
    TextTag(openingTag: '--', style: TextStyle(decoration: TextDecoration.lineThrough)),
    TextTag(openingTag: '^^', style: TextStyle(decoration: TextDecoration.overline)),
    TextTag(
        openingTag: '..',
        style: TextStyle(
          decoration: TextDecoration.underline,
          decorationStyle: TextDecorationStyle.dotted,
        )),
    TextTag(
        openingTag: '~~',
        style: TextStyle(
          decoration: TextDecoration.underline,
          decorationStyle: TextDecorationStyle.wavy,
        )),
  ];

  /// Checks either the text has correct tags or not, checking its ordering of opening and closing.
  ///
  /// Examples considering the [defaultTags] :
  /// - Valid text: `Text **bold and //italic//**`
  /// - Invalid text: `Text **bold and //italic**//` (bold closing in wrong sequence)
  final bool isTextTagsValid;

  /// Genereates a [InlineSpan] list according to [TextTag]s.
  static List<InlineSpan> generate(String text, List<TextTag> tags) =>
      _delegate.generate(text, tags);

  /// Used to check if a [text] has a correct sequence of opening/closing tags following [tags].
  ///
  /// Check [isTextTagsValid] out.
  static bool checkIfTextTagsIsValid(String text, List<TextTag> tags) =>
      _delegate.checkIfTextTagsIsValid(text, tags);

  /// It returns a [Text.rich] with the current [TaggedTextSpan].
  Widget toWidget({
    Key? key,
    TextStyle? style,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    Locale? locale,
    Color? selectionColor,
    String? semanticsLabel,
    bool? softWrap,
    StrutStyle? strutStyle,
    TextDirection? textDirection,
    TextHeightBehavior? textHeightBehavior,
    double? textScaleFactor,
    TextWidthBasis? textWidthBasis,
  }) {
    return Text.rich(
      this,
      key: key,
      style: style,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      locale: locale,
      selectionColor: selectionColor,
      semanticsLabel: semanticsLabel,
      softWrap: softWrap,
      strutStyle: strutStyle,
      textDirection: textDirection,
      textHeightBehavior: textHeightBehavior,
      textScaleFactor: textScaleFactor,
      textWidthBasis: textWidthBasis,
    );
  }
}
