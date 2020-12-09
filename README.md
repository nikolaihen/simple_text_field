# Simple Text Field

If you're like me, you don't like making forms in Flutter because of the unneccessary boilerplate and complexity related to Flutter's built-in TextFormField. Even setting a fixed height can be troublesome, and this is quite annoying especially when trying to follow a strict design which needs to be pixel perfect. Therefore I made this package to simplify all that by applying some default styling and functionality which is very common in most apps today (which can be enabled/disabled when needed). Core features and functionality that comes out of the box is:

- Set the height directly without the need to mess with the content padding while also respecting the font size
- Add shadows directly as a parameter which behaves as you would expect, even when the text field rezises in response to validation errors etc.
- When not empty, display a button to clear the text
- When text is obscure, display a button to show/hide the text (a must for passwords etc.)
- Auto-validation feedback using the suffix icon to elegantly notify the user of a valid input

# Usage
If you simply need a modern-looking text field with all the standard functionalities you see in most apps nowadays, then this is all you need:

```dart
SimpleTextField.regular(
  hintText: 'Your hint text',
  height: yourHeight, // defaults to 44px (material spec)
  controller: yourController,
  validator: yourValidator,
  onChanged: yourOnChanged,
  validInputIcon: Icons.check_circle,
),
```

This will produce a modern-looking text field exactly "yourHeight" high, with a filled background, some border radius, a clear-text button, a validInputIcon which appears in the suffixIcon position when the input is valid, and some light shadows.
