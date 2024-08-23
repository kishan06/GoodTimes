import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

// This function is triggered when the copy icon is pressed
  

class CopyClipboardAndSahreController{

  Future<void> copyToClipboard(context,inviteCode) async {
    await Clipboard.setData(ClipboardData(text: inviteCode));

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Copied to clipboard'),
    ));
  }

  shareLink({data,message}){
   Share.share('$message $data');
  }


}