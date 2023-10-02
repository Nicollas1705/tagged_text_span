import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Used to map a part of a [String] to a specific config, like [style], [recognizer], and more.
///
/// [openingTag] is used to get the initial mark of config, and [closingTag] is used to get the end
/// mark of config. Note: if [closingTag] is null, then it will be the same of [openingTag].
///
/// Note: despite [closingTag] is not needed, it is good to be set if the text has another
/// opening/closing tag only between this current opening/closing tag.
/// For example the following text (using the 'usage example' of TextTags):
/// `**bold ((another config **bold again**)) bold rest**`.
/// Since opening/closing tags is the same, it will asume the second `**` (before `bold again`) is
/// the closing one, getting a wrong result.
///
/// Usage examples:
/// ```dart
/// TextTag(openingTag: '**', style: TextStyle(fontWeight: FontWeight.bold)); // **text**
/// TextTag(openingTag: '((', closingTag: '))', style: TextStyle(color: Colors.red)); // ((text))
/// ```
///
/// Check [TextTag.custom] out to set a custom [TextSpanConfig] based on the tagged text.
class TextTag extends TextSpanConfig {
  /// Mapping a part of a [String] to a specific config, like [style], [recognizer], and more.
  ///
  /// To apply a custom [TextSpanConfig] based on the tagged text, check [TextTag.custom] out.
  const TextTag({
    required this.openingTag,
    String? closingTag,
    this.applyToText,
    super.style,
    super.recognizer,
    super.mouseCursor,
    super.onEnter,
    super.onExit,
    super.locale,
    super.semanticsLabel,
    super.spellOut,
  })  : closingTag = closingTag ?? openingTag,
        fromText = null;

  /// Mapping a part of a [String] to a specific config based on itself using [fromText], like
  /// [style], [recognizer], and more.
  ///
  /// Example usage:
  /// ```dart
  /// final tag = TextTag.custom(
  ///   openingTag: '##',
  ///   fromText: (text) {
  ///     final hexColor = text.split('|').first;
  ///     return TextSpanConfig(style: TextStyle(color: Color(int.parse(hexColor))));
  ///   },
  ///   applyToText: (text) => text.split('|').last,
  /// );
  /// ```
  ///
  /// Final result applied to text:
  /// `Colors: ##0xFFFF0000|red##; ##0xFF00FF00|green##; ##0xFF0000FF|blue##`
  ///
  /// ![](https://github.com/Nicollas1705/Nicollas1705/assets/58062436/9d01eb70-717d-41be-8ccf-dd5694e7f392)
  const TextTag.custom({
    required this.openingTag,
    String? closingTag,
    required TextSpanConfig Function(String text) this.fromText,
    this.applyToText,
  }) : closingTag = closingTag ?? openingTag;

  final String openingTag;
  final String closingTag;
  final TextSpanConfig Function(String text)? fromText;
  final String Function(String text)? applyToText;
}

/// A simple class to store the [TextSpan] settings.
class TextSpanConfig {
  const TextSpanConfig({
    this.style,
    this.recognizer,
    this.mouseCursor,
    this.onEnter,
    this.onExit,
    this.locale,
    this.semanticsLabel,
    this.spellOut,
  });

  final TextStyle? style;
  final Locale? locale;
  final MouseCursor? mouseCursor;
  final void Function(PointerEnterEvent event)? onEnter;
  final void Function(PointerExitEvent event)? onExit;
  final GestureRecognizer? recognizer;
  final String? semanticsLabel;
  final bool? spellOut;
}
