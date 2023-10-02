import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tagged_text_span/tagged_text_span.dart';

// TODO: improve tests (maybe rendering and comparing (golden test?))
void main() {
  const style = TextStyle(fontWeight: FontWeight.bold, color: Colors.blue);

  test('When tagging a text, should return the correct config of it.', () {
    // Arrange
    const mainStyle = TextStyle(color: Colors.green);
    const style1 = TextStyle(color: Colors.blue);
    const style2 = TextStyle(color: Colors.red);
    final tagged = TaggedTextSpan(
      '1**2((3))4**5',
      mainStyle: mainStyle,
      tags: const [
        TextTag(openingTag: '**', style: style1),
        TextTag(openingTag: '((', closingTag: '))', style: style2),
      ],
    );

    // Separated TextSpan result
    final TextSpan spanLayer1 = tagged;
    final TextSpan spanLayer2 = spanLayer1.children![1] as TextSpan;
    final TextSpan spanLayer3 = spanLayer2.children![1] as TextSpan;

    final textSpan1 = spanLayer1.children!.first as TextSpan;
    final textSpan2 = spanLayer2.children!.first;
    final textSpan3 = spanLayer3;
    final textSpan4 = spanLayer2.children!.last;
    final textSpan5 = spanLayer1.children!.last as TextSpan;

    // Expected values
    const expectedValue1 = TextSpan(text: '1');
    const expectedValue2 = TextSpan(text: '2');
    const expectedValue3 = TextSpan(text: '3', style: style2);
    const expectedValue4 = TextSpan(text: '4');
    const expectedValue5 = TextSpan(text: '5');

    // Assert
    expect(textSpan1, equals(expectedValue1));
    expect(textSpan2, equals(expectedValue2));
    expect(textSpan3, equals(expectedValue3));
    expect(textSpan4, equals(expectedValue4));
    expect(textSpan5, equals(expectedValue5));

    expect(spanLayer1.style, equals(mainStyle));
    expect(spanLayer2.style, equals(style1));
    expect(spanLayer3.style, equals(style2));
  });

  test('When sending a simple text with no [tags], should return the same text.', () {
    // Arrange
    final tagged = TaggedTextSpan('Text', tags: const []);

    // Assert
    const expectedValue = TextSpan(text: 'Text');
    expect((tagged.children!.first as TextSpan), equals(expectedValue));
  });

  test('When setting the [mainStyle], should return the same text with the correct style.', () {
    // Arrange
    final tagged = TaggedTextSpan('Text', mainStyle: style, tags: const []);

    // Assert
    const expectedValue = TextSpan(text: 'Text');
    expect(tagged.style, equals(style));
    expect((tagged.children!.first as TextSpan), equals(expectedValue));
  });

  test('When using only [openTag], should remove it from the final text and apply the config.', () {
    // Arrange
    final tagged = TaggedTextSpan('*Text*', tags: const [
      TextTag(openingTag: '*', style: style),
    ]);

    // Assert
    const expectedValue = TextSpan(text: 'Text', style: style);
    expect((tagged.children!.first as TextSpan), equals(expectedValue));
  });

  test('When using both tags, should remove it from the final text and apply the config.', () {
    // Arrange
    final tagged = TaggedTextSpan('(Text)', tags: const [
      TextTag(openingTag: '(', closingTag: ')', style: style),
    ]);

    // Assert
    const expectedValue = TextSpan(text: 'Text', style: style);
    expect((tagged.children!.first as TextSpan), equals(expectedValue));
  });

  test('When using [applyToText], should replace to the correct one given.', () {
    // Arrange
    final tagged = TaggedTextSpan('(Text)', tags: [
      TextTag(openingTag: '(', closingTag: ')', applyToText: (text) => '###'),
    ]);

    // Assert
    const expectedValue = TextSpan(text: '###');
    expect((tagged.children!.first as TextSpan), equals(expectedValue));
  });
}
