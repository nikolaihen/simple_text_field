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
        textSelectionColor: Colors.white,
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
    fontSize: 16.0,
    color: Colors.white
  );
  bool isDense = true;
  bool formValid = false;
  DateTime pickedDate;

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
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text('SimpleTextField example'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 40
        ),
        child: SimpleTextField(
          labelText: 'Password',
          controller: controllerPassword,
          prefixIcon: Icon(Icons.lock),
          obscureText: true,
          headerText: Text('Password'),
          height: 44,
          borderRadius: BorderRadius.circular(5),
          filled: true,
          fillColor: Colors.white,
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