import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_app/Components/Button.dart';
import 'package:donation_app/Screens/NGOLoginFlow.dart';
import 'package:donation_app/Screens/UserLoginFlow.dart';
import 'package:donation_app/Service/CustomUser.dart';
import 'package:donation_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:donation_app/globals/colors.dart' as colors;
import 'package:donation_app/globals/appInfo.dart' as appInfo;
import 'package:google_sign_in/google_sign_in.dart';

class Landing extends StatefulWidget {
  const Landing({ Key? key }) : super(key: key);

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {

  @override
  void initState(){
    Firebase.initializeApp();
    super.initState();
  }

  signinWithGoogle() async {
    final googleSignIn = await GoogleSignIn().signIn();
    if(googleSignIn!=null){
      final googleAuth = await googleSignIn.authentication;
      final cred = GoogleAuthProvider.credential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      final firebaseUser = (await FirebaseAuth.instanceFor(app: Firebase.app()).signInWithCredential(cred)).user;
      if (firebaseUser != null) {
        final res = await FirebaseFirestore.instanceFor(app:Firebase.app()).collection(CustomUser.tablename).where('email',isEqualTo:firebaseUser.email).get();
        if(res.docs.isNotEmpty){
          Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => MyHomePage(user:CustomUser.fromJson(res.docs.first.data())),
            transitionsBuilder: (context, animation, secondaryAnimation,child) =>
              SlideTransition(
                position:animation.drive(Tween(begin:const Offset(1, 0), end: Offset.zero)),
                child: child
              )
            )
          );
        }else{
          CustomUser user = CustomUser(
            uid:firebaseUser.uid,
            displayName:firebaseUser.displayName,
            email:firebaseUser.email,      
          );        
          Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => UserDetailsFill(user:user),
            transitionsBuilder: (context, animation, secondaryAnimation,child) =>
              SlideTransition(
                position:animation.drive(Tween(begin:const Offset(1, 0), end: Offset.zero)),
                child: child
              )
            )
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child:Container(color:colors.primary)),
          Container(
            color:Colors.white,
            child:Padding(
              padding: const EdgeInsets.all(21),
              child: Column(
                children: [
                  const Text(
                    "${appInfo.appName} provides you a way to help out in your local community and improve the lives of those around you",
                    style:TextStyle(color:colors.darkGrey)
                  ),
                  const SizedBox(height:30),
                  PrimaryButton(
                    onPressed:signinWithGoogle,
                    child:const Center(
                      child:Text(
                        "Sign-in using Google",
                        style:TextStyle(
                          fontWeight:FontWeight.bold,
                          fontSize:14
                        )
                      )
                    ),
                  ),
                  const SizedBox(height:10),
                  SecondaryButton(
                    onPressed:()=>Navigator.of(context).push( 
                      MaterialPageRoute(
                        builder: (context) => const RegistrationID()
                      )
                    ),
                    child:const Center(
                      child:Text(
                        "I represent an NGO",
                        style:TextStyle(
                          fontWeight:FontWeight.bold,
                          fontSize:14
                        )
                      )
                    ),
                  ),
                ],
              ),
            )
          )
        ],
      ),
    );
  }
}

