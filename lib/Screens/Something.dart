import 'package:flutter/widgets.dart';

class SomeThing extends StatefulWidget {
  const SomeThing({ Key? key }) : super(key: key);

  @override
  _SomeThingState createState() => _SomeThingState();
}

class _SomeThingState extends State<SomeThing> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child:Text("Something")
    );
  }
}