import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../data/common/scaffold_snackbar.dart';
import '../utils/constant.dart';
class DownloadBarcode {
  // save qr code in gallery functions
  Future<void> saveQRCode(context,String qrText) async {
    try {
      ByteData? qrImageData = await QrPainter(
        emptyColor:kPrimaryColor,
        data: qrText,
        version: QrVersions.auto,
        gapless: true,
      ).toImageData(200.0);

      Uint8List bytes = Uint8List.view(qrImageData!.buffer);
      // Save the image to the device's gallery
      await ImageGallerySaver.saveImage(bytes, name: 'qr_code');
      snackBarSuccess(context, message: "QR Code saved to gallery");
    } catch (e) {
      snackBarError(context, message: "Failed to save QR Code");
    }
  }
}