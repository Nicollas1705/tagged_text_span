import 'package:flutter_test/flutter_test.dart';
import 'package:tagged_text_span/tagged_text_span.dart';

void main() {
  const delegate = GenerateTaggedTextDelegate();

  group('When [checkIfTextTagsIsValid] is called,', () {
    test('it should return the correct value.', () {
      // Arrange
      const tags = [
        TextTag(openingTag: '**'),
        TextTag(openingTag: '##'),
        TextTag(openingTag: '((', closingTag: '))'),
        TextTag(openingTag: '{{', closingTag: '}}'),
        TextTag(openingTag: '<<', closingTag: '>>'),
      ];
      final mapped = <String, bool>{
        'Text: **((L))orem {{((I))psum}}** is simply ((dummy)) {{text}} of the printing and **typesetting** <<industry>>.':
            true,
        '<<>> Colorful with ##0xFF5EC8F8|blue <<>>## color <<>>': true,
        '**bold ((another config **bold again**)) bold rest**': true,
        '**bold ((another config **bold again**)) bold rest': false,
        '((something {{another)) thing}}': false,
      };

      for (final entry in mapped.entries) {
        // Act
        final result = delegate.checkIfTextTagsIsValid(entry.key, tags);

        // Assert
        expect(result, entry.value);
      }
    });
  });
}
