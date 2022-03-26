import 'package:flutter/material.dart';

class FulfillRequest extends StatefulWidget {
  const FulfillRequest({ Key? key }) : super(key: key);

  @override
  _FulfillRequestState createState() => _FulfillRequestState();
}

class _FulfillRequestState extends State<FulfillRequest> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color:Colors.white,
      child:const Center(
        child:Text("Fulfill Request")
      )
    );
  }
}