

# tagged_text_span

This package provides a way to map tags in a given text appling a custom span configuration to it, returning a `TextSpan`.

<br>
<img WIDTH="60%" src="https://user-images.githubusercontent.com/84534787/120998591-a95c6980-c7a1-11eb-9435-7d7587f0b32b.png">
<br>
<br>

# Examples

### Simple example

Text input: `Normal **bold**`
Output:  <img  align="center" src="https://github.com/Nicollas1705/Nicollas1705/assets/58062436/3702aa5d-3b82-4a2f-b3da-8cb6f08d4ab1">

### Code example

```dart
void main() => runApp(MaterialApp(
      home: Scaffold(body: Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: TaggedTextSpan(
          'Text: **((L))orem {{((I))psum}}** is simply ((dummy)) {{text}} of the printing and **typesetting** <<industry>>.',
          mainStyle: const TextStyle(color: Colors.purple),
          tags: [
            const TextTag(openingTag: '**', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
            const TextTag(openingTag: '((', closingTag: '))', style: TextStyle(color: Colors.red)),
            const TextTag(openingTag: '{{', closingTag: '}}', style: TextStyle(fontSize: 22)),
            TextTag(openingTag: '<<', closingTag: '>>', applyToText: (text) => '###'),
          ],
        ).toWidget(),
      )),
    ));
```

Output:
![](https://github.com/Nicollas1705/Nicollas1705/assets/58062436/c05e7bbd-d5e1-41e6-8dae-08f5a3e9c775)


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

Used  to  map  a  part of  a `String` to  a  specific  configuration, like `style`, `recognizer`, `mouseCursor`, and  more.

## Parameters

Use `openingTag` parameter to  get  the  initial  mark  of  config in the given text, and `closingTag` is  used  to  get  the  end one. Note:  if `closingTag` is  null, then  it  will  be  the  same  of `openingTag`.

Note:  despite `closingTag` is  not  needed, it  is  good  to  be  set  if  the  text  has  another opening/closing  tag  only  between  this  current  opening/closing  tag.

For  example  the  following  text (using  the  'usage example' of `TextTags`): `**bold ((another  config  **bold again**)) bold  rest**`.

Since  opening/closing  tags  is  the  same, it  will  asume  the  second `**` (before `bold  again`) is 
the  closing  one, getting  a  wrong  result.

### Example

```dart
// Setting only openingTag
TextTag(openingTag: '**', style: TextStyle(fontWeight: FontWeight.bold)); // **text**

// Setting both openingTag and closingTag
TextTag(openingTag: '((', closingTag: '))', style: TextStyle(color: Colors.red)); // ((text))
```

## Custom Constructor: `TextTag.custom`

Used to map a part of a `String` to a specific configuration based on itself using `fromText` param, returning a `TextSpanConfig`. 

The `TextSpanConfig` class takes the main parameters of a normal `TextSpan`, like the `style` of the text, `recognizer`, `mouseCursor`, and more, defining its configuration.

### Example

```dart
final tag = TextTag.custom(
  openingTag: '##',
  fromText: (text) {
    final hexColor = text.split('|').first;
    return TextSpanConfig(style: TextStyle(color: Color(int.parse(hexColor))));
  },
  applyToText: (text) => text.split('|').last, // Removing the config from output text
);
```

Applying to the following text: `Colors: ##0xFFFF0000|red##; ##0xFF00FF00|green##; ##0xFF0000FF|blue##`

#### Result:  <img  align="center" src="https://github.com/Nicollas1705/Nicollas1705/assets/58062436/9d01eb70-717d-41be-8ccf-dd5694e7f392">

# `TaggedTextSpan`

Creates a custom `TextSpan` based on the `TextTags` list to configure parts of the given `text`. It also has almost the same amount of parameters of a normal `TextSpan` to set the untagged text configuration, like `mainStyle`, `recognizer`, `mouseCursor`, and more.

### Example

```dart
TaggedTextSpan(
  'Some **text** example.',
  mainStyle: const TextStyle(color: Colors.purple),
  tags: [
    const TextTag(openingTag: '**', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
  ],
);
```

## More

### `useDefaultTags`

This is by default `true`, and it is used to set a list of `TextTags` to apply different `TextStyles` according to some tags to the given `text`.

These `TextTags` list can be accessed on the static value of `defaultTags` (`TaggedTextSpan.defaultTags`).

Default tags and its `TextStyle` when using `useDefaultTags` as `true`:

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


### `ignoreTextTagsCheckingComputation`

This is by default `false`, validating the given `text` based on `TextTags`, checking its ordering of opening and closing. This validation is made when the `TaggedTextSpan` is created. The result whether the `text` is valid or not can be obtained by `isTextTagsValid` parameter.

##### Valid text: `Text **bold and //italic//**`
##### Invalid text: `Text **bold and //italic**//` (bold closing in wrong sequence)

As it only gives a feedback whether the `text` is valid or not, when not used (the `isTextTagsValid`), this computation is not needed, and the `ignoreTextTagsCheckingComputation` can be `true`. In this case, `isTextTagsValid` will be always `true`.

### `toWidget` method

This method returns a `Text.rich` with the current `TaggedTextSpan`.

Code example: `TaggedTextSpan('some text', tags: const []).toWidget();`

## Static functions

`TaggedTextSpan` has some static functions that can be used:

### `generate`

Genereates a `InlineSpan` list according to the given `text` and `TextTags` list.

Code example: `TaggedTextSpan.generate('some text', const []);`

### `checkIfTextTagsIsValid`

 Used to check if a given `text` has a correct sequence of opening/closing tags following `tags` (a list of `TextTags`).

Note: this is the method used to validate the `text` and set `isTextTagsValid` when `ignoreTextTagsCheckingComputation` is `false`.


<!-- TODO
https://medium.com/dscddu/how-to-create-flutter-package-and-publish-it-on-pub-dev-34913475cf55

---------
README
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
	
