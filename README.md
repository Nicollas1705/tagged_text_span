# tagged_text_span

This package provides a way to map tags in a given text appling a custom span configuration to it, returning a `TextSpan`.

<br>
<img WIDTH="60%" src="https://user-images.githubusercontent.com/84534787/120998591-a95c6980-c7a1-11eb-9435-7d7587f0b32b.png">
<br>
<br>

# TODO README

<!-- TODO
https://medium.com/dscddu/how-to-create-flutter-package-and-publish-it-on-pub-dev-34913475cf55

---------
README
	TextTag (openingTag + closngTag + applyToText + style (examples))
	TextTag.custom (returning TextSpanConfig)
	TaggedTextSpan (text + tags + mainStyle (+ write about other params) + useDefaultTags + ignoreTextTagsCheckingComputation (isTextTagsValid) + toWidget)
		static methods (generate + checkIfTextTagsIsValid)
	Example codes (from docs)
License - https://help.github.com/en/github/building-a-strong-community/adding-a-license-to-a-repository
Project example
Add homepage to pubspec
	homepage: https://github.com/parth58/Social-SignIn-Buttons

---------
Review files (changelog, readme, pubspec)
Run
	flutter pub publish --dry-run
Adjustments if needed
Run
	flutter pub publish -->

## Usage

1. Add the dependency into pubspec.yaml.

```yaml
dependencies:
  tagged_text_span:
```

2. Import the library:

```dart
import 'package:tagged_text_span/tagged_text_span.dart';
```

3. Create the tags and apply it to the text:

```dart
const text = 'Normal **bold**';
const tags = [
  TextTag(openingTag: '**', style: TextStyle(fontWeight: FontWeight.bold)),
];
```

4. Create the `TaggedTextSpan`:

```dart
final span = TaggedTextSpan(text, tags: tags);
```

5. (Optional) Get the `Widget` to display on screen:

```dart
final widget = span.toWidget();
```

### Final code:

```dart
void main() {
  const text = 'Normal **bold**';
  const tags = [
    TextTag(openingTag: '**', style: TextStyle(fontWeight: FontWeight.bold)),
  ];
  final widget = TaggedTextSpan(text, tags: tags).toWidget();
  runApp(MaterialApp(home: Material(child: Center(child: widget))));
}
```

### Result:

![](https://github.com/Nicollas1705/Nicollas1705/assets/58062436/3702aa5d-3b82-4a2f-b3da-8cb6f08d4ab1)

# TextTag

## 








## Parameters

### Multiple masks (automatically updated according to the text size)

```dart
final controller = TextMaskingController(
  masks: ["000.000.000-00", "00.000.000/0000-00"],
);
```

### Costumizing the filters

To set a Map filter, use the key (example: "_") and the regex pattern (example: r'[01]').

```dart
final controller = TextMaskingController(
  mask: "_ _ _ _",
  filters: {"_": r'[01]'}, // Binary code
);
```

### Initializing a text

```dart
final controller = TextMaskingController(
  masks: ["(00) 00000-0000"],
  initialText: "12345678901", // Result: (12) 34567-8901
);
```

### Completing the mask quickly

It will complete the mask as quick as possible:

Mask example: "00--00".

When input only 2 numbers ("12"), the result will be: "12--|" (the cursor will go to the final).

Note: The cursor is represented by this character: "|" (pipe).

```dart
final controller = TextMaskingController(
  mask: "+00 (00) 00000-0000",
  maskAutoComplete: MaskAutoComplete.quick,
  initialText: "1234", // Result: +12 (34) 
);
```


## Methods

### Update to another single mask or masks

Use the "mask" parameter to update to a single mask.

Use the "masks" parameter to update to a multiple masks.

```dart
controller.updateMask(mask: "000-000");
```

### Update the thext using updateText() method
```dart
controller.updateText("123456");
```

### Get the default filters (it is an static method)
```dart
Map<String, String> defaultFilters = TextMaskingController.defaultFilters;
```

### Get the current mask

It will returns the mask being used by the current text.

It can be null because the "mask" and "masks" parameters can be null.

```dart
String? mask = controller.currentMask;
```

### Get the clean text (without the mask)

Mask example: "00-00-00".

Input example: "123456" (resulting: "12-34-56").

The unmasked text will be: "123456".

```dart
String text = controller.unmaskedText;
```

### Check if the current mask is properly filled

Masks example: ["00-00", "0000-0000"].

Input example: "1234" (resulting: "12-34"). This is filled.

Input example: "123456" (resulting: "1234-56"). This is not filled.

```dart
bool filled = controller.isFilled;
```


## Default style tags (optional)

`TaggedTextSpan` also have default tags to specific styles.
It is used by default, but can be desativated by setting `useDefaultTags` parameter to `false`.

<table>
  <tr>
    <th>Tag</th>
    <th>Regex pattern</th>
  </tr>
  <tr>
    <td><code>**</code></td>
    <td>Bold</td>
  </tr>
  <tr>
    <td><code>//</code></td>
    <td>Italic</td>
  </tr>
  <tr>
    <td><code>__</code></td>
    <td>Underlined</td>
  </tr>
  <tr>
    <td><code>--</code></td>
    <td>Line through text</td>
  </tr>
  <tr>
    <td><code>^^</code></td>
    <td>Overlined</td>
  </tr>
  <tr>
    <td><code>..</code></td>
    <td>Underline dotted</td>
  </tr>
  <tr>
    <td><code>~~<code></td>
    <td>Underline wavy</td>
  </tr>
</table>


## Example masks

```dart
final cpfAndCnpj = TextMaskingController(
  masks: ["000.000.000-00", "00.000.000/0000-00"],
);

final brazilianPhones = TextMaskingController(
  masks: 
    "+00 (00) 00000-0000",
    "+00 (00) 0000-0000",
    "(00) 00000-0000",
    "(00) 0000-0000",
    "00000-0000",
    "0000-0000",
  ],
);

final date = TextMaskingController(mask: "00/00/0000");
```


## Note

This package was developed based on [flutter_masked_text2](https://pub.dev/packages/flutter_masked_text2) and [mask_text_input_formatter](https://pub.dev/packages/mask_text_input_formatter) packages.


## Main differences

### Can use multiple masks easily

Just set the "masks" parameter to update the mask according to the text size.

### This package saves the user cursor

The cursor will be saved even if it changes the mask from masks parameter.

Masks example: ["00-00", "000-000", "0000-0000"].

Note: The cursor will be represented by this character: "|" (pipe).

Result text from an input: "12-|34". If the user add some number (example: "123"), the result will be: "1212-3|34".

Adding each character ("123"):
<table>
  <tr>
    <th>Text</th>
    <th>Input</th>
    <th>Result</th>
  </tr>
  <tr>
    <td>"12-|34"</td>
    <td>"1"</td>
    <td>"121-|34"</td>
  </tr>
  <tr>
    <td>"121-|34"</td>
    <td>"2"</td>
    <td>"121-2|34"</td>
  </tr>
  <tr>
    <td>"121-2|34"</td>
    <td>"3"</td>
    <td>"1212-3|34"</td>
  </tr>
</table>


## TODO

### [ ] Convert lower-upper case inputs

Nowadays, the code doesn't convert the letter case.

Example:

```dart
final controller = TextMaskingController(
  mask: "AAA",
);
```

If the user types "abc" (lower case), the text will not be insert. It will only be insert if the user type upper case letters.


### [ ] Make a way to update the mask automatically based on the first digits (not only by the text size).

Example:

```dart
final controller = TextMaskingController(
  masks: ["A-00", "B-0000", "C-000000"],
  filters: {
    "A": r'[A]', 
    "B": r'[B]', 
    "C": r'[C]', 
    "0": r'[0-9]',
  },
);
```

If the user starts typing "A", it will be only able to type 2 more numbers. If starts with "B", 4 more numbers. If starts with "C", 6 more numbers.
