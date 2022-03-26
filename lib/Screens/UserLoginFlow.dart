import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_app/Components/Button.dart';
import 'package:donation_app/Components/TextField.dart';
import 'package:donation_app/Service/CustomUser.dart';
import 'package:donation_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:donation_app/globals/colors.dart' as colors;
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class UserDetailsFill extends StatefulWidget {
  final CustomUser user;
  const UserDetailsFill({ Key? key,required this.user }) : super(key: key);

  @override
  _UserDetailsFillState createState() => _UserDetailsFillState();
}

class _UserDetailsFillState extends State<UserDetailsFill> {

  final phoneController = TextEditingController();
  String errorText = "";

  proceed() {
    widget.user.phone = phoneController.value.text.trim();
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => VerifyOTP(user:widget.user),
      transitionsBuilder: (context, animation, secondaryAnimation,child) =>
        SlideTransition(
          position:animation.drive(Tween(begin:const Offset(1, 0), end: Offset.zero)),
          child: child
        )
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:Container(
          color:Colors.white,
          height:MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              SingleChildScrollView(
                child:Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment:Alignment.centerLeft,
                        child:IconButton(
                          onPressed:(){
                            if(Navigator.of(context).canPop()){
                              Navigator.of(context).pop();
                            }
                          },
                          icon:const Icon(Icons.arrow_back_rounded,color:colors.darkGrey),
                        )
                      ),
                      const Padding(
                        padding:EdgeInsets.all(14),
                        child:Text(
                          "Please confirm your details and verify your mobile number",
                          style:TextStyle(
                            fontWeight:FontWeight.w700,
                            color:colors.black,
                            fontSize:19
                          )
                        ),
                      ),                  
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: CustomTextfield(
                          labelText:"Name",
                          enabled:false,
                          controller:TextEditingController(text:"John Doe"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: CustomTextfield(
                          labelText:"Email address",
                          enabled:false,
                          controller:TextEditingController(text:"johndoe@gmail.com"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: CustomTextfield(
                          labelText:"Phone number",
                          controller:phoneController,
                          errorText:errorText,
                          textInputType:TextInputType.phone,
                          hint:"+91XXXXXXXXXX"
                        ),
                      ),    
                      const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          "This number will be verified in the next step with an OTP",
                          style:TextStyle(color:colors.darkGrey,fontSize:12)
                        ),
                      ),    
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom:0,
                child: Container(
                  width:MediaQuery.of(context).size.width,
                  decoration:const BoxDecoration(
                    color:Colors.white,
                    boxShadow:[
                      BoxShadow(
                        offset:Offset(0,-2),
                        blurRadius:8,
                        color:Color(0xffABADAE)
                      )
                    ]
                  ),
                  child:Padding(
                    padding:const EdgeInsets.all(12),
                    child:PrimaryButton(
                      onPressed:proceed,
                      child:const Text("Confirm and proceed"),
                    ),
                  )
                ),
              ),          
            ],
          ),
        )
      ),
    );
  }
}

class VerifyOTP extends StatefulWidget {
  final CustomUser? user;
  const VerifyOTP({ 
    Key? key,
    this.user
  }) : super(key: key);

  @override
  _VerifyOTPState createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {

  final OtpFieldController _controller = OtpFieldController();
  bool failed = true,codeSent = false,loading = false;
  String? errorText;
  String verificationId="";
  @override
  void initState(){
    verify();
    super.initState();
  }

  verify() async {
    final auth = FirebaseAuth.instanceFor(app:Firebase.app());
    final fstore = FirebaseFirestore.instanceFor(app:Firebase.app());
    auth.verifyPhoneNumber(
      phoneNumber:widget.user!.phone.toString(), 
      verificationCompleted:(credential) async {
        final res = await auth.signInWithCredential(credential);
        final user = await fstore.collection(CustomUser.tablename).doc(res.user!.uid).get();
        if(user.exists){
          Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => MyHomePage(user:CustomUser.fromJson(user.data())),
            transitionsBuilder: (context, animation, secondaryAnimation,child) =>
              SlideTransition(
                position:animation.drive(Tween(begin:const Offset(1, 0), end: Offset.zero)),
                child: child
              )
          ));
        }else{
          fstore.collection(CustomUser.tablename).doc(res.user!.uid).set(widget.user!.toJson());
          Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => MyHomePage(user:widget.user),
            transitionsBuilder: (context, animation, secondaryAnimation,child) =>
              SlideTransition(
                position:animation.drive(Tween(begin:const Offset(1, 0), end: Offset.zero)),
                child: child
              )
          ));
        }
      }, 
      verificationFailed: (e){
        if(e.code == 'invalid-phone-number'){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor:Colors.transparent,
              content:Padding(
                padding:const EdgeInsets.all(12),
                child:Container(
                  decoration:BoxDecoration(
                    color:colors.black,
                    borderRadius:BorderRadius.circular(10)
                  ),
                  child: const Padding(
                    padding:EdgeInsets.all(12),
                    child:Text("Invalid phone number",style:TextStyle(color:colors.lightGrey))
                  ),
                )
              ),
            )
          );
        }else{
          setState(() {
            failed = true;
          });
        }
      }, 
      codeSent:(vid,resendToken){
        setState(() {
          codeSent = true;
          verificationId = vid;
        });
      }, 
      codeAutoRetrievalTimeout: (val){}
    );
  }

  verifyManually(String otp) async {
    final auth = FirebaseAuth.instanceFor(app:Firebase.app());
    final fstore = FirebaseFirestore.instanceFor(app:Firebase.app());

    final credential = PhoneAuthProvider.credential(
      verificationId:verificationId, 
      smsCode: otp
    );

    final res = await auth.signInWithCredential(credential);
    final user = await fstore.collection(CustomUser.tablename).doc(res.user!.uid).get();
    if(user.exists){
      Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => MyHomePage(user:CustomUser.fromJson(user.data())),
        transitionsBuilder: (context, animation, secondaryAnimation,child) =>
          SlideTransition(
            position:animation.drive(Tween(begin:const Offset(1, 0), end: Offset.zero)),
            child: child
          )
      ));
    }else{
      fstore.collection(CustomUser.tablename).doc(res.user!.uid).set(widget.user!.toJson());
      Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => MyHomePage(user:widget.user),
        transitionsBuilder: (context, animation, secondaryAnimation,child) =>
          SlideTransition(
            position:animation.drive(Tween(begin:const Offset(1, 0), end: Offset.zero)),
            child: child
          )
      ));
    }
  }

  onComplete(String otp){
    setState(() {
      loading = true;
    });
    verifyManually(otp);   
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:Container(
          color:Colors.white,
          height:MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child:Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment:CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment:Alignment.centerLeft,
                    child:IconButton(
                      onPressed:(){
                        if(Navigator.of(context).canPop()){
                          Navigator.of(context).pop();
                        }
                      },
                      icon:const Icon(Icons.arrow_back_rounded,color:colors.darkGrey),
                    )
                  ),
                  Padding(
                    padding:const EdgeInsets.all(14),
                    child:Text(
                      "Please enter the One Time Password sent on ${widget.user!.phone}",
                      style:const TextStyle(
                        fontWeight:FontWeight.w700,
                        color:colors.black,
                        fontSize:19
                      )
                    ),
                  ),                  
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical:30),
                    child: Center(
                      child: OTPTextField(
                        controller:_controller,
                        length:6,
                        outlineBorderRadius:0,
                        width:300,
                        style:const TextStyle(
                          fontSize: 17
                        ),
                        textFieldAlignment: MainAxisAlignment.spaceEvenly,
                        fieldWidth:40,
                        fieldStyle: FieldStyle.box,   
                        onChanged:(val)=>{},
                        onCompleted:onComplete,
                        margin:const EdgeInsets.symmetric(horizontal:2), 
                        obscureText:true                                                
                      ),
                    ),
                  ),
                  Padding(
                    padding:const EdgeInsets.all(8),
                    child:Center(
                      child: GestureDetector(
                        onTap:()=>{},
                        child:const Text(
                          "Resend OTP",
                          style:TextStyle(
                            color:colors.primary,
                            fontWeight:FontWeight.w500
                          ),
                        ),
                      ),
                    ),
                  )                                                     
                ],
              ),
            ),
          )
        )
      ),
    );
  }
}