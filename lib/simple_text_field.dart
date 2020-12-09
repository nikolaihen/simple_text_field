library simple_text_field;

import 'package:flutter/material.dart';

class SimpleTextField extends StatefulWidget {
  
  /// Controls the text being edited.
  /// 
  /// If null, this widget will create its own [TextEditingController].
  final TextEditingController controller;

  final FocusNode focusNode;

  /// The hint text of the text field.
  final String hintText;

  /// Whether the text field should have a background color or not.
  final bool filled;

  /// The color to fill the text field's background with.
  /// Must not be null when [filled] is true.
  final Color fillColor;

  /// The style used for the text input.
  final TextStyle textStyle;

  /// The style used for the hint text.
  final TextStyle hintStyle;

  /// The vertical size of the text field.
  final double height;
  
  /// The horizontal, internal padding of the text field.
  final double horizontalContentPadding;

  /// The border radius of the text field.
  final BorderRadius borderRadius;

  /// A list of shadows cast by this box behind the text field.
  final List<BoxShadow> shadow;

  /// Whether this text field is editable.
  final bool enabled;

  /// Whether the text field should be disabled if [onTap] is not null. 
  /// 
  /// Overrides [enabled].
  final bool disableIfOnTapNotNull;

  /// Called when the text field is tapped.
  final void Function() onTap;

  final void Function(String) onChanged;

  final String Function(String) validator;

  /// Called when [validInputIcon] is tapped.
  final void Function() onValidInputIconTap;

  final IconData prefixIcon;

  final IconData suffixIcon;

  /// Whether a button to clear the text field should show in the [suffixIcon]
  /// position when the text field is not empty.
  /// 
  /// Overrides [suffixIcon].
  final bool enableClearButton;

  /// The icon showing in the [suffixIcon] position when the input is valid.
  final IconData validInputIcon;

  final AutovalidateMode autovalidateMode;

  /// The constraints for the prefix and suffic icon.
  /// 
  /// This can be used to modify the [BoxConstraints] 
  /// surrounding [prefixIcon] and [suffixIcon].
  final BoxConstraints iconConstraints;

  /// Whether the [InputDecorator.child] is part of a dense form 
  /// (i.e., uses less vertical space).
  /// 
  /// Defaults to true.
  final bool isDense;

  final bool obscureText;

  /// The styling for the border. Defaults to
  final BorderSide borderSide;

  /// The default horizontal content padding
  static const defaultHorizontalContentPadding = 12.0;

  SimpleTextField({
    @required this.hintText,
    this.controller,
    this.focusNode,
    this.filled = false,
    this.fillColor,
    this.textStyle,
    this.hintStyle,
    this.height,
    this.borderRadius,
    this.shadow,
    this.enabled = true,
    this.disableIfOnTapNotNull = true,
    this.onTap,
    this.onChanged,
    this.onValidInputIconTap,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.enableClearButton = false,
    this.validInputIcon,
    this.iconConstraints,
    this.isDense = true,
    this.obscureText = false,
    this.borderSide,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.horizontalContentPadding = defaultHorizontalContentPadding
  }) : 
    assert(height != null, 'A height must be provided.'),
    assert(
      !filled || (filled && fillColor != null),
      'When filled == true, a fillColor must be provided.'
    ),
    assert(
      textStyle == null && hintStyle == null ||
      (
        textStyle != null && hintStyle != null && 
        textStyle.fontSize == hintStyle.fontSize
      ),
      'Either no styles must be given, OR both textStyle and hintStyle MUST NOT be null AND have the same font size'
    ),
    assert(
      onValidInputIconTap == null || 
      (onValidInputIconTap != null && validInputIcon != null),
      'A callback when tapping the validInputIcon was provided, but validInputIcon == null.'
    );

  factory SimpleTextField.regular({
    String hintText,
    TextEditingController controller,
    FocusNode focusNode,
    double height = 44,
    Color fillColor = Colors.white,
    bool filled = true,
    IconData prefixIcon,
    IconData suffixIcon,
    IconData validInputIcon,
    void Function (String) onChanged,
    void Function() onValidInputIconTap,
    void Function() onTap,
    String Function(String) validator,
    bool enableClearButton = true,
    TextStyle textStyle,
    bool isDense = true,
    Offset shadowOffset = const Offset(0, 2),
    double shadowBlurRadius = 5.0,
    double shadowSpreadRadius = 1.0,
    Color shadowColor,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    BorderSide borderSide,
    bool enabled = true,
    bool disableIfOnTapNotNull = false,
    bool obscureText = false
  }) {
    return SimpleTextField(
      hintText: hintText,
      controller: controller,
      focusNode: focusNode,
      height: height,
      fillColor: fillColor,
      filled: filled,
      onChanged: onChanged,
      onValidInputIconTap: onValidInputIconTap,
      onTap: onTap,
      shadow: [
        BoxShadow(
          offset: shadowOffset,
          blurRadius: shadowBlurRadius,
          spreadRadius: shadowSpreadRadius,
          color: shadowColor ?? Colors.grey.shade400
        )
      ],
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      validator: validator,
      borderRadius: BorderRadius.circular(5),
      enableClearButton: enableClearButton,
      textStyle: textStyle,
      hintStyle: textStyle,
      isDense: isDense,
      autovalidateMode: autovalidateMode,
      validInputIcon: validInputIcon,
      borderSide: borderSide,
      enabled: enabled,
      disableIfOnTapNotNull: disableIfOnTapNotNull,
      obscureText: obscureText
    );
  }

  @override
  _SimpleTextFieldState createState() => _SimpleTextFieldState();
}

class _SimpleTextFieldState extends State<SimpleTextField> {

  bool _passwordVisible = false;

  TextStyle getTextStyle(BuildContext context) =>
      widget.textStyle ?? Theme.of(context).textTheme.subtitle1;

  /// Returns the padding to use inside of the textfield that will 
  /// match the given [widget.height].
  EdgeInsets getContentPadding(BuildContext context) {

    // The size of the rendered font used in the text field.
    // If no text style is given, use the default font size
    // used internally by the TextField widget.
    final double _fontSize = 
        widget.textStyle?.fontSize ?? Theme.of(context).textTheme.subtitle1.fontSize;

    final bool heightTooSmallForPadding = (widget.height <= _fontSize);

    double _verticalContentPadding;

    if (heightTooSmallForPadding) {
      _verticalContentPadding = 0;
    } else {
      _verticalContentPadding = (widget.height - _fontSize) / 2;
    }

    return EdgeInsets.only(
      left: widget.horizontalContentPadding,
      top: _verticalContentPadding.roundToDouble(),
      right: hasPrefixIcon() ? 0.0 : widget.horizontalContentPadding,
      bottom: _verticalContentPadding.roundToDouble()
    );
  }

  bool hasPrefixIcon() {
    return 
        widget.enableClearButton || 
        widget.suffixIcon != null || 
        widget.validInputIcon != null;
  }

  OutlineInputBorder _buildBorder() {
    return OutlineInputBorder(
      borderSide: widget.borderSide ?? BorderSide(
        style: BorderStyle.none
      ),
      borderRadius: widget.borderRadius
    );
  }

  Widget _buildSuffixIcon() {
    if (!widget.enableClearButton || widget.controller.text.isEmpty) {
      return Icon(widget.suffixIcon);
    } else {

      if (widget.obscureText) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
          child: Icon(
            _passwordVisible
                ? Icons.visibility_off
                : Icons.visibility
            ),
        );
      }

      if (widget.controller.text.isNotEmpty) {
        if (widget.validator(widget.controller.text) == null && widget.validInputIcon != null) {
          final Icon icon = Icon(widget.validInputIcon);

          if (widget.onValidInputIconTap == null) {
            return icon;
          } else {
            return GestureDetector(
              onTap: widget.onValidInputIconTap,
              child: icon,
            );
          }
        } else {
          return GestureDetector(
            onTap: () {
              widget.controller.clear();
              setState(() {});
            },
            child: Icon(Icons.clear),
          );
        }
      }

      return null;
    }
  }

  BoxConstraints getPrefixIconConstraints() {
    return widget.prefixIcon != null
        ? BoxConstraints.tight(
            Size(widget.height, widget.height)
          )
        : BoxConstraints(maxWidth: widget.horizontalContentPadding);
  }

  BoxConstraints getSuffixIconConstraints() {
    if (widget.suffixIcon != null || 
        widget.enableClearButton || 
        widget.validInputIcon != null
    ) {
      return BoxConstraints.tight(
        Size(widget.height, widget.height)
      );
    }

    return BoxConstraints(maxWidth: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: widget.height,
          decoration: BoxDecoration(
            boxShadow: widget.shadow,
            borderRadius: widget.borderRadius
          ),
        ),
        GestureDetector(
          onTap: widget.onTap,
          child: TextFormField(
            style: widget.textStyle,
            validator: widget.validator,
            onChanged: widget.onChanged,
            onTap: widget.onTap,
            enabled: (widget.onTap != null && widget.disableIfOnTapNotNull) 
                ? false 
                : widget.enabled,
            controller: widget.controller,
            focusNode: widget.focusNode,
            textAlignVertical: TextAlignVertical.center,
            autovalidateMode: widget.autovalidateMode,
            obscureText: widget.obscureText && !_passwordVisible,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelText: widget.hintText,
              prefixIcon: Icon(widget.prefixIcon),
              suffixIcon: _buildSuffixIcon(),
              prefixIconConstraints: getPrefixIconConstraints(),
              suffixIconConstraints: getSuffixIconConstraints(),
              filled: widget.filled,
              fillColor: widget.fillColor,
              isDense: widget.isDense,
              hintText: widget.hintText,
              hintStyle: widget.hintStyle,
              contentPadding: getContentPadding(context),
              border: _buildBorder(),
              disabledBorder: _buildBorder(),
              enabledBorder: _buildBorder(),
              errorBorder: _buildBorder(),
              focusedBorder: _buildBorder(),
              focusedErrorBorder: _buildBorder(),
            ),
          )
        ),
      ],
    );
  }
}
