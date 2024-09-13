/* class SocialShare {
  Android android = Android();
   // IOS iOS = IOS();

  /* Future<Map<String, bool>> getInstalledApps() async {
    return AppinioSocialSharePlatform.instance.getInstalledApps();
  }
 */
  Future<void> shareToFacebook({String? text, String? filePath}) async {
    if (android.isAvailable()) {
      return android.shareToFacebook(text: text, filePath: filePath);
    }
    // else if (iOS.isAvailable()) {
    //   return iOS.shareToFacebook(text: text, filePath: filePath);
    // }
    throw UnsupportedError(
        'Facebook sharing is not supported on this platform.');
  }

  Future<void> shareToTwitter({String? text, String? filePath}) async {
    if (android.isAvailable()) {
      return android.shareToTwitter(text: text, filePath: filePath);
    }
    // else if (iOS.isAvailable()) {
    //   return iOS.shareToTwitter(text: text, filePath: filePath);
    // }
    throw UnsupportedError(
        'Twitter sharing is not supported on this platform.');
  }

  Future<void> shareToInstagram({String? text, String? filePath}) async {
    if (android.isAvailable()) {
      return android.shareToInstagram(text: text, filePath: filePath);
    }
    // else if (iOS.isAvailable()) {
    //   return iOS.shareToTwitter(text: text, filePath: filePath);
    // }
    throw UnsupportedError(
        'Twitter sharing is not supported on this platform.');
  }
}

class Android {
  static const MethodChannel _channel = MethodChannel('appinio_social_share');

  bool isAvailable() {
    // Check if the Android platform is available
    return true;
  }

  Future<void> shareToFacebook({String? text, String? filePath}) async {
    try {
      Map<String, dynamic> arguments = {
        'platform': 'facebook',
        'text': text ?? '',
        'filePath': filePath ?? ''
      };

      await _channel.invokeMethod('shareToFacebook', arguments);
    } on PlatformException catch (e) {
      print("Failed to share on Facebook: '${e.message}'.");
    }
  }

  Future<void> shareToTwitter({String? text, String? filePath}) async {
    try {
      Map<String, dynamic> arguments = {
        'platform': 'twitter',
        'text': text ?? '',
        'filePath': filePath ?? ''
      };

      await _channel.invokeMethod('shareToTwitter', arguments);
    } on PlatformException catch (e) {
      print("Failed to share on Twitter: '${e.message}'.");
    }
  }

  Future<void> shareToInstagram({String? text, String? filePath}) async {
    try {
      Map<String, dynamic> arguments = {
        'platform': 'instagram',
        'text': text ?? '',
        'filePath': filePath ?? ''
      };

      await _channel.invokeMethod('shareToInstagram', arguments);
    } on PlatformException catch (e) {
      print("Failed to share on Instagram: '${e.message}'.");
    }
  }
}

 */