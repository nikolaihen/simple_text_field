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
  DateTime currentDate;
  TextEditingController controllerDate;
  TextEditingController controllerRegular;
  TextEditingController controllerPassword;
  double textFieldHeight = 50;
  TextStyle textFieldStyle = TextStyle(
    fontSize: 16.0
  );
  bool isDense = true;
  bool formValid = false;

  @override
  void initState() {
    controllerDate = TextEditingController();
    controllerRegular = TextEditingController();
    controllerPassword = TextEditingController();
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
                labelText: 'Phone number',
                controller: controllerRegular,
                validator: (String val) {
                  if (val.length < 8) {
                    return 'Must be 8 characters or more!';
                  }
                  return null;
                },
                prefixIcon: Icon(Icons.phone),
                height: textFieldHeight,
                isDense: isDense,
                textStyle: textFieldStyle,
                validInputIcon: Icon(Icons.check_circle),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 30),
              SimpleTextField.regular(
                labelText: 'Password',
                controller: controllerPassword,
                obscureText: true,
                prefixIcon: Icon(Icons.lock),
              ),
              SizedBox(height: 30),
              SimpleDateTextField(
                labelText: 'Regular date field',
                controller: controllerDate,
                initialDate: DateTime.now(),
                firstDate: DateTime.now().subtract(Duration(days: 365)),
                lastDate: DateTime.now().add(Duration(days: 365)),
                prefixIcon: Icon(Icons.date_range),
                borderRadius: BorderRadius.circular(5),
                textStyle: textFieldStyle,
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
    controllerDate.dispose();
    controllerRegular.dispose();
    controllerPassword.dispose();
    super.dispose();
  }
}