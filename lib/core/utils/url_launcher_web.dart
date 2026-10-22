import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'package:web/web.dart' as web;

/// Cross-platform web URL and communication launcher using native browser APIs.
class WebUrlLauncher {
  WebUrlLauncher._();

  /// Opens an external URL (such as GitHub, LinkedIn, or App Stores) in a new browser tab.
  static Future<bool> openUrl(String url) async {
    try {
      if (url.isEmpty) return false;
      web.window.open(url, '_blank');
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Launches an email draft via mailto link.
  static Future<bool> sendEmail(String email, {String? subject}) async {
    try {
      final uri = Uri(
        scheme: 'mailto',
        path: email,
        query: subject != null ? 'subject=${Uri.encodeComponent(subject)}' : null,
      );
      final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
      anchor.href = uri.toString();
      web.document.body!.appendChild(anchor);
      anchor.click();
      await Future<void>.delayed(const Duration(milliseconds: 100));
      web.document.body!.removeChild(anchor);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Launches phone dialer / tel link.
  static Future<bool> dialPhone(String phoneNumber) async {
    try {
      final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
      anchor.href = 'tel:$phoneNumber';
      web.document.body!.appendChild(anchor);
      anchor.click();
      await Future<void>.delayed(const Duration(milliseconds: 100));
      web.document.body!.removeChild(anchor);
      return true;
    } catch (_) {
      return false;
    }
  }
}
