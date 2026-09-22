import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
class ImageUploadBox extends StatelessWidget {
 final String title,subtitle; final double height; final VoidCallback? onTap;
 const ImageUploadBox({super.key,this.title='Click to upload or drag and drop',this.subtitle='PNG, JPG or WEBP',this.height=170,this.onTap});
 @override Widget build(BuildContext context)=>InkWell(onTap:onTap,borderRadius:BorderRadius.circular(10),child:Container(height:height,width:double.infinity,decoration:BoxDecoration(color:const Color(0xFFFCFCFD),borderRadius:BorderRadius.circular(10),border:Border.all(color:AppConstants.border)),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Container(width:48,height:48,decoration:BoxDecoration(color:AppConstants.softRed,borderRadius:BorderRadius.circular(12)),child:const Icon(Icons.cloud_upload_outlined,color:AppConstants.primaryRed)),const SizedBox(height:12),Text(title,textAlign:TextAlign.center,style:const TextStyle(fontSize:12,fontWeight:FontWeight.w700)),const SizedBox(height:5),Text(subtitle,style:const TextStyle(color:AppConstants.textSecondary,fontSize:10))])));
}
