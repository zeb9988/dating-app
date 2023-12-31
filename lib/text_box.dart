import 'package:flutter/material.dart';


class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;

  const MyTextBox ({
    super.key,
  required this.text,
  required this.sectionName,
  required this.onPressed,
  });

  @override
    Widget build(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(8),
    ),
    padding:const EdgeInsets.only(
      left: 10,
      bottom: 20,
    ),
    margin: const EdgeInsets.only(
      left: 10,
      right: 20,
      top: 20,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //section name


        //text
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //sections name
            Text(sectionName,style: TextStyle(color: Colors.grey[500]),),
            Text(text),

            //edit bottun
            IconButton(onPressed: (

                ){},
                icon: Icon(
                  Icons.settings,
                  color: Colors.grey[400],
                )),
          ],
        ),



      ],
    ),
  );
  }
}
