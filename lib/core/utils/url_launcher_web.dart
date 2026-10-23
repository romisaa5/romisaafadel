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

  /// Launches an email composition window via standard mailto URI.
  ///
  /// Uses direct browser navigation to the mailto protocol so the user's
  /// operating system or default email client (Outlook, Mail, Gmail) opens
  /// with the recipient already populated.
  static Future<bool> sendEmail(String email, {String? subject}) async {
    try {
      if (email.isEmpty) return false;

      final trimmedEmail = email.trim();
      final String mailtoUri;
      if (subject != null && subject.trim().isNotEmpty) {
        final encodedSubject = Uri.encodeComponent(subject.trim());
        mailtoUri = 'mailto:$trimmedEmail?subject=$encodedSubject';
      } else {
        mailtoUri = 'mailto:$trimmedEmail';
      }

      // Direct assignment to window.location triggers the browser's registered
      // mailto protocol handler reliably without navigating away from the page.
      web.window.location.href = mailtoUri;

      // Secondary fallback via anchor element for additional browser compatibility
      final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
      anchor.href = mailtoUri;
      anchor.target = '_self';
      web.document.body?.appendChild(anchor);
      anchor.click();
      anchor.remove();

      return true;
    } catch (_) {
      return false;
    }
  }

  /// Launches phone dialer / tel link.
  static Future<bool> dialPhone(String phoneNumber) async {
    try {
      if (phoneNumber.isEmpty) return false;
      final telUri = 'tel:${phoneNumber.trim()}';
      web.window.location.href = telUri;
      return true;
    } catch (_) {
      return false;
    }
  }
}
