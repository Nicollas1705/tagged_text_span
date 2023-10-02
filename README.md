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

## ...



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
