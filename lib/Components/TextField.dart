import 'package:flutter/material.dart';
import 'package:donation_app/globals/colors.dart' as colors;
import 'package:flutter/services.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint,errorText,labelText;
  final FocusNode? focusNode;
  final bool enabled,obscureText;
  final int? maxLines,minLines;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  const CustomTextfield({ 
    Key? key,
    this.labelText,
    this.controller,
    this.hint,
    this.errorText,
    this.focusNode,
    this.enabled = true,
    this.maxLines,
    this.minLines,
    this.obscureText = false,
    this.textInputType,
    this.textInputAction
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            labelText!=null?labelText.toString():"",
            style:const TextStyle(
              color:colors.darkGrey,
            )
          ),
        ),
        TextField(          
          keyboardType:textInputType,
          textInputAction:textInputAction,
          controller:controller,
          focusNode:focusNode,
          cursorColor:colors.mediumGrey,
          enabled:enabled,      
          maxLines:obscureText ? 1 : maxLines,
          minLines:obscureText ? 1 : minLines,
          obscureText:obscureText,          
          style:TextStyle(
            color:enabled ? colors.darkGrey : colors.darkGrey.withOpacity(0.5),
            fontSize:17
          ),    
          decoration:InputDecoration(            
            fillColor:colors.mediumGrey.withOpacity(0.12),
            filled:!enabled,
            hintText:hint,
            hintStyle:const TextStyle(
              color:colors.mediumGrey
            ),
            contentPadding:
              minLines==1?
              const EdgeInsets.symmetric(vertical:5,horizontal:17)
              : const EdgeInsets.symmetric(vertical:14,horizontal:12),
            border:OutlineInputBorder(
              borderRadius:BorderRadius.circular(5),
              borderSide:const BorderSide(color:colors.mediumGrey)
            )
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            errorText!=null?errorText.toString():"",
            style:const TextStyle(
              color:Colors.red,
            )
          ),
        ),
      ],
    );
  }
}
