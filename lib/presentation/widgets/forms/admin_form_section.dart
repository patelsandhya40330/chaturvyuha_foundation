import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

class AdminFormSection extends StatelessWidget {
  final String title; final String? subtitle; final Widget child;
  const AdminFormSection({super.key,required this.title,required this.child,this.subtitle});
  @override Widget build(BuildContext context)=>Container(width:double.infinity,padding:const EdgeInsets.all(18),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(10),border:Border.all(color:AppConstants.border)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,style:const TextStyle(fontSize:15,fontWeight:FontWeight.w800)),if(subtitle!=null)...[const SizedBox(height:4),Text(subtitle!,style:const TextStyle(color:AppConstants.textSecondary,fontSize:12))],const SizedBox(height:16),child]));
}

class AdminTextField extends StatelessWidget {
  final String label,hint; final int maxLines; final TextInputType? keyboardType; final Widget? suffixIcon;
  const AdminTextField({super.key,required this.label,required this.hint,this.maxLines=1,this.keyboardType,this.suffixIcon});
  @override Widget build(BuildContext context)=>TextFormField(maxLines:maxLines,keyboardType:keyboardType,decoration:InputDecoration(labelText:label,hintText:hint,suffixIcon:suffixIcon));
}

class AdminDropdown extends StatelessWidget {
  final String label,value; final List<String> items; final ValueChanged<String?>? onChanged;
  const AdminDropdown({super.key,required this.label,required this.value,required this.items,this.onChanged});
  @override Widget build(BuildContext context)=>DropdownButtonFormField<String>(value:value,decoration:InputDecoration(labelText:label),items:items.map((e)=>DropdownMenuItem(value:e,child:Text(e))).toList(),onChanged:onChanged);
}
