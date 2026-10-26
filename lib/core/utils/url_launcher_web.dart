import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'package:web/web.dart' as web;

/// Cross-platform web URL and communication launcher using native browser APIs.
class WebUrlLauncher {
  WebUrlLauncher._();

  /// Direct Gmail compose URL with exact recipient romisaafadel982@gmail.com.
  static const String defaultEmail = 'romisaafadel982@gmail.com';
  static const String defaultGmailComposeUrl =
      'https://mail.google.com/mail/?view=cm&fs=1&to=romisaafadel982%40gmail.com';

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

  /// Opens Gmail's Web compose interface directly in a new browser tab.
  ///
  /// Uses the exact URL:
  /// `https://mail.google.com/mail/?view=cm&fs=1&to=romisaafadel982%40gmail.com`
  ///
  /// Executed synchronously in response to the user's click gesture to prevent
  /// browser popup restrictions from blocking the new tab.
  static bool openGmailCompose({String? email}) {
    try {
      final recipient = (email != null && email.trim().isNotEmpty)
          ? email.trim()
          : defaultEmail;

      final url = recipient == defaultEmail
          ? defaultGmailComposeUrl
          : 'https://mail.google.com/mail/?view=cm&fs=1&to=${Uri.encodeComponent(recipient)}';

      final newWindow = web.window.open(url, '_blank');
      return newWindow != null;
    } catch (_) {
      return false;
    }
  }

  /// Primary email handler: opens Gmail Web compose directly in a new tab.
  static Future<bool> sendEmail(String email, {String? subject}) async {
    return openGmailCompose(email: email);
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
