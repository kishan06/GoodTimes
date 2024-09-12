import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

import 'package:path_provider/path_provider.dart';

// Share image with content URI
Future<void> shareImage(String imagePath) async {
  try {
    final Uri contentUri = await getUriFromFile(imagePath);
    print("///");
    // Use Share package to share image with the URI
    Share.shareFiles([contentUri.toString()]);
  } catch (e) {
    print("Error sharing image: $e");
  }
}

Future<Uri> getUriFromFile(String filePath) async {
  // Get the context of the FileProvider
  final context = (await getApplicationDocumentsDirectory()).path;
  // Create file object from path
  final file = File(filePath);

  // Generate the content URI using FileProvider
  final uri = Uri.file(file.path);
  return uri;
}
