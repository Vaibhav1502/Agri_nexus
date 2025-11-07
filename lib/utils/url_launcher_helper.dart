// app/utils/url_launcher_helper.dart

import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherHelper {
  // This function will try to launch a URL.
  // It handles potential errors gracefully.
  static Future<void> launch(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // Show an error message if the URL can't be launched.
      Get.snackbar(
        "Could Not Launch URL",
        "The link could not be opened. Please try again later.",
      );
    }
  }
}