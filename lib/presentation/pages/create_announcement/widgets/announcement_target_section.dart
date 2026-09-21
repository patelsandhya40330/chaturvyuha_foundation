import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../widgets/forms/admin_form_section.dart';
class AnnouncementTargetSection extends StatefulWidget{const AnnouncementTargetSection({super.key});@override State<AnnouncementTargetSection> createState()=>_AnnouncementTargetSectionState();}
class _AnnouncementTargetSectionState extends State<AnnouncementTargetSection>{final selected=<String>{'All visitors'};@override Widget build(BuildContext c){const targets=['All visitors','Registered users','Program participants','Staff members'];return AdminFormSection(title:'Audience',subtitle:'Choose who should see this announcement.',child:Column(children:[for(final target in targets)CheckboxListTile(contentPadding:EdgeInsets.zero,value:selected.contains(target),activeColor:AppConstants.primaryRed,title:Text(target,style:const TextStyle(fontSize:12)),onChanged:(v)=>setState(()=>v==true?selected.add(target):selected.remove(target))) ]));}}
