import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:donation_app/Components/Button.dart';
import 'package:donation_app/Components/TextField.dart';
import 'package:donation_app/Service/NGO.dart';
import 'package:donation_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:donation_app/globals/colors.dart' as colors;
import 'package:flutter/services.dart';

class RegistrationID extends StatefulWidget {
  const RegistrationID({ Key? key }) : super(key: key);

  @override
  _RegistrationIDState createState() => _RegistrationIDState();
}

class _RegistrationIDState extends State<RegistrationID> {

  final TextEditingController _controller = TextEditingController();
  bool loading = false;
  String? errorText;

  proceed() async {
    setState(() {
      loading = true;
    });
    if(_controller.value.text.trim().isEmpty){
      setState(() {
        errorText = "Please enter government issued registration number";
      });
      return;
    }
    final res = await FirebaseFirestore.instanceFor(app:Firebase.app())
      .collection('goidb')
      .where('registrationNumber',isEqualTo:_controller.value.text.toString())
      .get();
    if(res.docs.isEmpty){
      setState(() {
        errorText = "No records found";
        loading = false;
      });
      return;
    }
    Navigator.of(context).push( 
      MaterialPageRoute(
        builder: (context) => NGODetailsFill(
          ngo:NGO(
            name:res.docs.first['name'],
            email:res.docs.first['email'],
            registrationNumber:res.docs.first['registrationNumber'],
            address:res.docs.first['address'],
          )
        )
      )
    );
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
                      "Please enter your NGO’s official registration ID",
                      style:TextStyle(
                        fontWeight:FontWeight.w700,
                        color:colors.black,
                        fontSize:19
                      )
                    ),
                  ),
                  Padding(
                    padding:const EdgeInsets.symmetric(vertical:35,horizontal:8),
                    child: CustomTextfield(
                      hint:"Registration ID",
                      controller:_controller,
                      errorText:errorText,
                      textInputAction:TextInputAction.done,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical:14,horizontal:8),
                    child: RichText(
                      text: TextSpan(
                        style:const TextStyle(color:colors.darkGrey),
                        text: 'Ensure that no one else from your NGO has registered on appName previously. If already done,', 
                        children: [
                        TextSpan(
                          text: ' login here',
                          style:const TextStyle(color:colors.primary),
                          recognizer: TapGestureRecognizer()..onTap = () => Navigator.of(context).push( 
                            MaterialPageRoute(
                              builder: (context) => const NGOLogin()
                            )
                          ),
                        )
                      ]),
                    ),
                  ),
                  Padding(
                    padding:const EdgeInsets.symmetric(vertical:30),
                    child:PrimaryButton(
                      onPressed:proceed,
                      child:const Center(
                        child:Text(
                          "Confirm and proceed",
                          style:TextStyle(
                            fontWeight:FontWeight.bold,
                            fontSize:14
                          )
                        )
                      ),
                    ),
                  ),
                  Visibility(
                    visible:loading,
                    child:const Padding(
                    padding: EdgeInsets.symmetric(vertical:50),
                    child:Center(
                      child:CircularProgressIndicator(
                        valueColor:AlwaysStoppedAnimation(colors.primary),
                      )
                    )
                  )
                  )
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}

class NGODetailsFill extends StatefulWidget {
  final NGO ngo;
  const NGODetailsFill({ Key? key,required this.ngo }) : super(key: key);

  @override
  _NGODetailsFillState createState() => _NGODetailsFillState();
}

class _NGODetailsFillState extends State<NGODetailsFill> {
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
                          "Please confirm your details and proceed",
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
                          controller:TextEditingController(text:widget.ngo.name),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: CustomTextfield(
                          labelText:"Email address",
                          enabled:false,
                          controller:TextEditingController(text:widget.ngo.email),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: CustomTextfield(
                          labelText:"Registration No as per GOI",
                          enabled:false,
                          controller:TextEditingController(text:widget.ngo.registrationNumber),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: CustomTextfield(
                          labelText:"Registered address as per GOI",
                          enabled:false,
                          controller:TextEditingController(text:widget.ngo.address),
                          minLines:2,
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
                      onPressed:()=>Navigator.of(context).push( 
                        MaterialPageRoute(
                          builder: (context) => NGOBankDetailsFill(
                            ngo:widget.ngo
                          )
                        )
                      ),
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

class NGOBankDetailsFill extends StatefulWidget {
  final NGO ngo;
  const NGOBankDetailsFill({ Key? key,required this.ngo }) : super(key: key);

  @override
  _NGOBankDetailsFillState createState() => _NGOBankDetailsFillState();
}

class _NGOBankDetailsFillState extends State<NGOBankDetailsFill> {

  final TextEditingController acno = TextEditingController(),bankname = TextEditingController(),ifscCode = TextEditingController(),branch = TextEditingController();

  String? acnoError,banknameError,ifscCodeError,branchError ;

  proceed() async {
    if(acno.value.text.trim().isEmpty){
      setState(() {
        acnoError = "Please enter an Account No.";
      });
      return;
    }
    if(bankname.value.text.trim().isEmpty){
      setState(() {
        banknameError = "Please enter bank name";
      });
      return;
    }
    if(ifscCode.value.text.trim().isEmpty){
      setState(() {
        ifscCodeError = "Please enter valid IFSC code";
      });
      return;
    }
    if(branch.value.text.trim().isEmpty){
      setState(() {
        branchError = "Please enter your home branch";
      });
      return;
    }
    setState(() {
      widget.ngo.setBankDetails(branch.value.text.trim(), acno.value.text.trim(), bankname.value.text.trim(), ifscCode.value.text.trim());
    });
    Navigator.of(context).push( 
      MaterialPageRoute(
        builder: (context) => NGOPassword(
          ngo:widget.ngo
        )
      )
    );
    
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
                          "Please enter your bank details and proceed",
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
                          labelText:"Account Number",                      
                          controller:acno,
                          errorText:acnoError,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: CustomTextfield(
                          labelText:"Bank Name",                      
                          controller:bankname,
                          errorText:banknameError,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: CustomTextfield(
                          labelText:"IFSC Code",                      
                          controller:ifscCode,
                          errorText:ifscCodeError,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: CustomTextfield(
                          labelText:"Branch",                      
                          controller:branch,
                          errorText:branchError,
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

class NGOPassword extends StatefulWidget {
  final NGO ngo;
  const NGOPassword({ Key? key,required this.ngo }) : super(key: key);

  @override
  _NGOPasswordState createState() => _NGOPasswordState();
}

class _NGOPasswordState extends State<NGOPassword> {

  final password = TextEditingController();
  String? errorText;

  proceed() async {
    if(password.value.text.trim().length<6){
      setState(() {
        errorText = "Password must be atleast 6 characters long";
      });
      return;
    }
    try{
      final userCredential = await FirebaseAuth.instanceFor(app:Firebase.app())
        .createUserWithEmailAndPassword(
          email:widget.ngo.email.toString(), 
          password:password.value.text.trim()
        );
      if(userCredential.user!=null){
        setState(() {
          widget.ngo.ngoId = userCredential.user!.uid;
        });
        FirebaseFirestore.instanceFor(app:Firebase.app())
          .collection(NGO.tablename)
          .doc(widget.ngo.ngoId).set(widget.ngo.toJson());
        Navigator.of(context).push( 
          MaterialPageRoute(
            builder: (context) => MyHomePage(ngo:widget.ngo)
          )
        );        
      }
    } on Exception catch(e){
      switch (e.toString()) {
        case 'email-already-in-use':
          setState(() {
            errorText = "This email is already registered with us";
          });
          break;
        default:
          setState(() {
            errorText = "Unknown error occured. Please try again later.";
          });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:Container(
          color:Colors.white,
          height:MediaQuery.of(context).size.height,
          child:SingleChildScrollView(
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
                      "Please choose a strong password",
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
                      obscureText:true,
                      controller:password,
                      errorText:errorText,
                    ),
                  ),    
                  const Padding(
                    padding:EdgeInsets.symmetric(horizontal:14,vertical:30),
                    child:Text(
                      "Ensure that your password consists of capital and small alphabets, numbers and special characters",
                      style:TextStyle(
                        color:colors.darkGrey
                      )
                    )
                  ),
                  const SizedBox(height:50),
                  SizedBox(
                    width:MediaQuery.of(context).size.width,
                    child: PrimaryButton(
                      onPressed:proceed,
                      child:const Text("Create Account"),
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

class NGOLogin extends StatefulWidget {
  const NGOLogin({ Key? key }) : super(key: key);

  @override
  _NGOLoginState createState() => _NGOLoginState();
}

class _NGOLoginState extends State<NGOLogin> {

  final email = TextEditingController(), password = TextEditingController();
  String? emailError,passwordError;
  bool loading = false;
  proceed() async {
    if(email.value.text.trim().isEmpty){
      setState(() {
        emailError = "Please enter registered email";
      });
      return;
    }
    if(password.value.text.trim().isEmpty){
      setState(() {
        passwordError = "Please enter password";
      });
      return;
    }
    if(password.value.text.trim().length<6){
      setState(() {
        passwordError = "Incorrect password";
      });
      return;
    }
    setState(() {
      loading = true;
    });

    try{
      final userCredential = await FirebaseAuth.instanceFor(app:Firebase.app())
        .signInWithEmailAndPassword(
          email:email.value.text.trim(), 
          password:password.value.text.trim()
        );
      if(userCredential.user!=null){
        final res = await FirebaseFirestore.instanceFor(app:Firebase.app()).collection(NGO.tablename).doc(userCredential.user!.uid).get();
        setState(() {
          loading = false;
        });
        Navigator.of(context).push( 
          MaterialPageRoute(
            builder: (context) => MyHomePage(ngo:NGO.fromJson(res.data()))
          )
        );
      }
    } on FirebaseAuthException catch(e){
      switch (e.code) {
        case 'user-not-found':
          setState(() {
            emailError = "No user found. Please register first.";
          });
          break;
        case 'wrong-password':
          setState(() {
            passwordError = "Incorrect Password";
          });
          break;
        default:
          setState(() {
            passwordError = "Unknown error occured. Please try again later.";
          });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:Container(
          color:Colors.white,
          height:MediaQuery.of(context).size.height,
          child:SingleChildScrollView(
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
                      "Please sign in with registered email and password.",
                      style:TextStyle(
                        fontWeight:FontWeight.w700,
                        color:colors.black,
                        fontSize:19
                      )
                    ),
                  ),        
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:8),
                    child: CustomTextfield(
                      controller:email,
                      obscureText:false,
                      labelText:"Email",
                      hint:"email@example.com",
                      errorText:emailError,
                      textInputType:TextInputType.emailAddress,
                    ),
                  ),                                
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:8),
                    child: CustomTextfield(
                      obscureText:true,
                      controller:password,
                      labelText:"Password",
                      hint:"••••••",
                      errorText:passwordError,
                    ),
                  ),                      
                  const SizedBox(height:50),
                  SizedBox(
                    width:MediaQuery.of(context).size.width,
                    child: PrimaryButton(
                      onPressed:proceed,
                      child:const Text("Login"),
                    ),
                  ),
                  Visibility(
                    visible:loading,
                    child:const Padding(
                    padding: EdgeInsets.symmetric(vertical:50),
                      child:Center(
                        child:CircularProgressIndicator(
                          valueColor:AlwaysStoppedAnimation(colors.primary),
                        )
                      )
                    )
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