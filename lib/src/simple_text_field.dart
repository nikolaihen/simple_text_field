import 'package:flutter/material.dart';
import 'utils/shadows.dart';

enum SimpleTextFieldDataType {
  Text,
  Number,
  Date
}

class SimpleTextField extends StatefulWidget {
  
  /// Controls the text being edited.
  /// 
  /// If null, this widget will create its own [TextEditingController].
  final TextEditingController controller;

  final FocusNode focusNode;

  /// The hint text of the text field.
  final String labelText;

  /// The counter text of the text field
  final String counterText;

  /// Whether the text field should have a background color or not.
  final bool filled;

  /// The color to fill the text field's background with.
  /// Must not be null when [filled] is true.
  final Color fillColor;

  /// The style used for the text input.
  final TextStyle textStyle;

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

  /// Called when [suffixIcon] or [validInputIcon] is tapped.
  final void Function() suffixIconOnTap;

  final Icon prefixIcon;

  final Icon suffixIcon;

  /// Whether a button to clear the text field should show in the [suffixIcon]
  /// position when the text field is not empty.
  /// 
  /// Overrides [suffixIcon].
  final bool enableClearButton;

  /// The icon showing in the [suffixIcon] position when the input is valid.
  final Icon validInputIcon;

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

  final bool readOnly;
  
  final TextInputType keyboardType;

  /// The default horizontal content padding
  static const defaultHorizontalContentPadding = 12.0;

  SimpleTextField({
    @required this.labelText,
    this.counterText,
    this.controller,
    this.focusNode,
    this.filled = false,
    this.fillColor,
    this.textStyle,
    this.height,
    this.borderRadius,
    this.shadow,
    this.enabled = true,
    this.disableIfOnTapNotNull = true,
    this.onTap,
    this.onChanged,
    this.suffixIconOnTap,
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
    this.readOnly = false,
    this.keyboardType,
    this.horizontalContentPadding = defaultHorizontalContentPadding,
  }) : 
    assert(height != null, 'A height must be provided.'),
    assert(
      !filled || (filled && fillColor != null),
      'When filled == true, a fillColor must be provided.'
    ),
    assert(
      suffixIconOnTap == null || 
      (suffixIconOnTap != null && suffixIcon != null),
      'A callback when tapping the suffixIcon was provided, but suffixIcon == null.'
    );

  factory SimpleTextField.regular({
    @required String labelText,
    @required TextEditingController controller,
    FocusNode focusNode,
    double height = 44,
    String Function(String) validator,
    TextStyle textStyle,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    BorderSide borderSide,
    TextInputType keyboardType,
    Color fillColor = Colors.white,
    Color shadowColor,
    Icon prefixIcon,
    Icon suffixIcon,
    Icon validInputIcon,
    void Function (String) onChanged,
    void Function() suffixIconOnTap,
    void Function() onTap,
    bool filled = true,
    bool isDense = true,
    bool enabled = true,
    bool disableIfOnTapNotNull = false,
    bool obscureText = false,
    bool readOnly = false,
    bool enableClearButton = true,
  }) {
    return SimpleTextField(
      labelText: labelText,
      controller: controller,
      focusNode: focusNode,
      height: height,
      fillColor: fillColor,
      filled: filled,
      onChanged: onChanged,
      suffixIconOnTap: suffixIconOnTap,
      onTap: onTap,
      shadow: SimpleTextFieldShadows.regular(),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      validator: validator,
      borderRadius: BorderRadius.circular(5),
      enableClearButton: enableClearButton,
      textStyle: textStyle,
      isDense: isDense,
      autovalidateMode: autovalidateMode,
      validInputIcon: validInputIcon,
      borderSide: borderSide,
      enabled: enabled,
      disableIfOnTapNotNull: disableIfOnTapNotNull,
      obscureText: obscureText,
      readOnly: readOnly,
      keyboardType: keyboardType
    );
  }

  @override
  _SimpleTextFieldState createState() => _SimpleTextFieldState();
}

class _SimpleTextFieldState extends State<SimpleTextField> {

  bool _obscureText = false;
  FocusNode _focusNode;

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
      right: hasSuffixIcon() ? 0.0 : widget.horizontalContentPadding,
      bottom: _verticalContentPadding.roundToDouble()
    );
  }

  bool hasSuffixIcon() {
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
    if ((!widget.enableClearButton || widget.controller.text.isEmpty) && 
          widget.suffixIcon != null
    ) {
      if (widget.suffixIconOnTap == null) {
        return widget.suffixIcon;
      } else {
        return GestureDetector(
          onTap: widget.suffixIconOnTap,
          child: widget.suffixIcon,
        );
      }
    } else {
      if (widget.obscureText) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(
            _obscureText
                ? Icons.visibility_off
                : Icons.visibility
            ),
        );
      }

      if (widget.controller.text.isNotEmpty) {
        if (widget.validator != null && (
          widget.validator(widget.controller.text) == null && widget.validInputIcon != null
        )) {
          if (widget.suffixIconOnTap == null) {
            return widget.validInputIcon;
          } else {
            return GestureDetector(
              onTap: widget.suffixIconOnTap,
              child: widget.validInputIcon,
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

  /// Make sure to rebuild the text field when the text changes such
  /// that the suffix icon updates properly
  void _controllerListener() {
    setState(() {});
  }

  @override
  void initState() {
    widget.controller.addListener(_controllerListener);
    _focusNode = widget.focusNode ?? FocusNode();
    super.initState();
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
            focusNode: _focusNode,
            textAlignVertical: TextAlignVertical.center,
            autovalidateMode: widget.autovalidateMode,
            obscureText: widget.obscureText && !_obscureText,
            readOnly: widget.readOnly,
            keyboardType: widget.keyboardType,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelText: widget.labelText,
              labelStyle: widget.textStyle,
              counterText: widget.counterText,
              prefixIcon: widget.prefixIcon,
              suffixIcon: hasSuffixIcon() ? _buildSuffixIcon() : null,
              prefixIconConstraints: getPrefixIconConstraints(),
              suffixIconConstraints: getSuffixIconConstraints(),
              filled: widget.filled,
              fillColor: widget.fillColor,
              isDense: widget.isDense,
              hintText: widget.labelText,
              hintStyle: widget.textStyle,
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

  @override
  void dispose() {
    widget.controller?.removeListener(_controllerListener);
    _focusNode?.dispose();
    super.dispose();
  }
}
