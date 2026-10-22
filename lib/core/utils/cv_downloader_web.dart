import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'package:web/web.dart' as web;

/// Triggers a browser download of the given [assetPath] (a Flutter web asset URL)
/// using the supplied [downloadFilename].
///
/// This uses the `<a download>` trick which is the most reliable, dependency-free
/// way to download a static asset in a Flutter Web app.
///
/// Returns `true` on success, `false` if anything goes wrong.
Future<bool> downloadAsset({
  required String assetPath,
  required String downloadFilename,
}) async {
  try {
    final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
    anchor.href = assetPath;
    anchor.download = downloadFilename;
    anchor.style.display = 'none';
    web.document.body!.appendChild(anchor);
    anchor.click();
    // Small delay before removal so the browser can register the click.
    await Future<void>.delayed(const Duration(milliseconds: 100));
    web.document.body!.removeChild(anchor);
    return true;
  } catch (e) {
    return false;
  }
}
