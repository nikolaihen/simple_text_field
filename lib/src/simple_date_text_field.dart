import 'package:flutter/material.dart';

import '../simple_text_field.dart';
import 'utils/shadows.dart';


class DateFormatter {
   
   static String format(DateTime date) {
     final int day = date.day;
     final int month = date.month;
     final int year = date.year;

     return '$day/$month/$year';
   }
}

class SimpleDateTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final DateTime firstDate;
  final DateTime initialDate;
  final DateTime lastDate;

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

  /// Called when the text field is tapped.
  final void Function() onTap;

  final void Function(String) onChanged;

  /// Formats the picked [DateTime] to a human-readable string. If not assigned,
  /// the [DateFormatter] class is used as a default.
  final String Function(DateTime) onDateFormat;

  final Icon prefixIcon;

  final Icon suffixIcon;

  /// Whether a button to clear the text field should show in the [suffixIcon]
  /// position when the text field is not empty.
  /// 
  /// Overrides [suffixIcon].
  final bool enableClearButton;

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

  final bool disableIfOnTapNotNull;

  /// The styling for the border. Defaults to
  final BorderSide borderSide;

  SimpleDateTextField({
    @required this.controller,
    @required this.labelText,
    @required this.firstDate,
    @required this.initialDate,
    @required this.lastDate,
    this.borderRadius,
    this.borderSide,
    this.fillColor = Colors.white,
    this.filled = true,
    this.height = 44.0,
    this.hintStyle,
    this.horizontalContentPadding = 12.0,
    this.iconConstraints,
    this.isDense = true,
    this.onChanged,
    this.onDateFormat,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
    this.shadow,
    this.textStyle,
    this.enableClearButton = true,
    this.disableIfOnTapNotNull = false
  });

  @override
  _SimpleDateTextFieldState createState() => _SimpleDateTextFieldState();
}

class _SimpleDateTextFieldState extends State<SimpleDateTextField> {
  DateTime _pickedDate;
  bool _initialDatePicked = false;

  @override
  Widget build(BuildContext context) {
    return SimpleTextField(
      labelText: widget.labelText,
      controller: widget.controller,
      readOnly: true,
      enabled: true,
      height: widget.height,
      borderSide: widget.borderSide,
      borderRadius: widget.borderRadius,
      shadow: widget.shadow ?? SimpleTextFieldShadows.regular(),
      enableClearButton: widget.enableClearButton,
      fillColor: widget.fillColor,
      filled: widget.filled,
      isDense: widget.isDense,
      onChanged: widget.onChanged,
      prefixIcon: widget.prefixIcon,
      suffixIcon: widget.suffixIcon,
      textStyle: widget.textStyle,
      horizontalContentPadding: widget.horizontalContentPadding,
      iconConstraints: widget.iconConstraints,
      disableIfOnTapNotNull: widget.disableIfOnTapNotNull,
      obscureText: false,
      onTap: () async {
        if (widget.onTap != null) widget.onTap();

        DateTime _date = await showDatePicker(
          context: context,
          initialDate: _initialDatePicked ? _pickedDate : widget.initialDate, 
          firstDate: widget.firstDate, 
          lastDate: widget.lastDate
        );

        if (_date != null) {
          String _formattedDate;

          if (widget.onDateFormat != null) {
            _formattedDate = widget.onDateFormat(_date);
          } else {
            _formattedDate = DateFormatter.format(_date);
          }

          _initialDatePicked = true;
          _pickedDate = _date;
          widget.controller.text = _formattedDate;
        }

        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
      },
    );
  }
}