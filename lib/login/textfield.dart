
import 'package:flutter/material.dart';

Widget MyTextField (BuildContext context,TextEditingController  Controller,final validate,double screenHeight , double screenWidth){
  return TextFormField(
        controller: Controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black, width: 5.0),
            borderRadius: BorderRadius.circular(50.0),
          ),
        ),
        validator: validate,
  );
}