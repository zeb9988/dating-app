import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;


Future<Future> showErrorDialogWithCancelTakesAFunction(
    {
      required BuildContext context,
      required String title,
      required String error,
      required Function function,

    }) async {
  if(kIsWeb){
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(error),
        actions: <Widget>[

          TextButton(
            child:  const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
          TextButton(
              child:  const Text('Ok'),
              onPressed: () {
                function();
                Navigator.pop(context);
              }
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
            child:  const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
          TextButton(
              child:  const Text('Ok'),
              onPressed: () {
                function();
                Navigator.pop(context);
              }
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
          child:  TextButton(
            child:  const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
          onPressed: () => Navigator.of(context).pop(true),
        ),
        TextButton(
            child:  const Text('Ok'),
            onPressed: () {
              function();
              Navigator.pop(context);
            }
        ),
      ],
    ),
  );
}