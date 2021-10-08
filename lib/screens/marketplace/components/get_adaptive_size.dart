import 'package:flutter/material.dart';

double getAdaptiveSize(double value, BuildContext context){
  if(MediaQuery.of(context).size.width > 720)
    return value * 2;
  else if(MediaQuery.of(context).size.width < 400)
   return value / 1.1;
   else return value;
}