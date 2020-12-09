import 'package:flutter/material.dart';
import 'package:simple_text_field/simple_text_field.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ExamplePage()
    );
  }
}

class ExamplePage extends StatefulWidget {

  @override
  _ExamplePageState createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController controller;
  double textFieldHeight = 50;
  TextStyle textFieldStyle = TextStyle(
    fontSize: 16.0
  );
  bool isDense = true;
  bool formValid = false;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text('SimpleTextField example'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 40
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SimpleTextField.regular(
                hintText: 'Regular',
                controller: controller,
                onChanged: (String val) {
                  setState(() {
                    formValid = val.length >= 5;
                  });
                },
                validator: (String val) {
                  if (val.length < 5) {
                    return 'Must be 5 characters or more!';
                  }
                  return null;
                },
                validInputIcon: Icons.check_circle,
                onTap: () => print('Tapped'),
              ),
              SizedBox(height: 30),
              SimpleTextField(
                hintText: 'Custom',
                controller: controller,
                height: textFieldHeight,
                fillColor: Colors.white,
                filled: true,
                onChanged: (String val) {
                  setState(() {
                    formValid = val.length >= 5;
                  });
                },
                shadow: [
                  BoxShadow(
                    offset: Offset(0, 2),
                    blurRadius: 5,
                    spreadRadius: 1,
                    color: Colors.grey.shade400
                  )
                ],
                prefixIcon: Icons.email,
                suffixIcon: formValid 
                    ? Icons.check_circle 
                    : null,
                validator: (String val) {
                  if (val.length < 5) {
                    return 'Must be 5 characters or more!';
                  }
                  return null;
                },
                borderRadius: BorderRadius.circular(5),
                enableClearButton: true,
                textStyle: textFieldStyle,
                hintStyle: textFieldStyle,
                isDense: isDense,
              ),
              SizedBox(height: 30),
              RaisedButton(
                onPressed: () {
                  _formKey.currentState.validate();
                },
                child: Text('Validate'),
              ),
              SizedBox(height: 30),
              Text('CUSTOM TEXTFIELD CONTROLS'),
              Slider(
                value: textFieldHeight,
                onChanged: (double val) {
                  setState(() {
                    textFieldHeight = val;
                  });
                },
                min: 10,
                max: 150,
                label: textFieldHeight.round().toString(),
              ),
              Text('TextField height: ${textFieldHeight.round()}'),
              SizedBox(height: 15),
              Slider(
                value: textFieldStyle.fontSize,
                onChanged: (double val) {
                  setState(() {
                    textFieldStyle = textFieldStyle.copyWith(
                      fontSize: val
                    );
                  });
                },
                min: 8,
                max: 64,
                label: textFieldStyle.fontSize.round().toString(),
              ),
              Text('TextField font size: ${textFieldStyle.fontSize.round()}'),
              SizedBox(height: 15),
              CheckboxListTile(
                title: Text('TextField isDense: $isDense'),
                value: isDense, 
                onChanged: (bool val) {
                  setState(() {
                    isDense = val;
                  });
                }
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}