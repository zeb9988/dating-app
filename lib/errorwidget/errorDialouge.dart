import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;



Future<Future> showErrorDialog(
    {
  required BuildContext context,
  required String title,
  required String error,

}) async {
  if(kIsWeb){
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(error),
        actions: <Widget>[

          TextButton(
            child:  const Text('ok'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }

  if (Platform.isAndroid) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(error),
        actions: <Widget>[

          TextButton(
            child:  const Text('ok'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }

  return showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(error),
      actions: <Widget>[
        CupertinoDialogAction(
          child:  const Text('ok'),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );
}