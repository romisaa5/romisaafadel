import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';
// ignore: avoid_web_libraries_in_flutter
import 'package:web/web.dart' as web;

/// Triggers a browser download of the supplied file [bytes] as a Blob object URL.
///
/// Using a Blob object URL with the HTML5 `<a download="...">` attribute guarantees
/// that the browser triggers an actual file download with [downloadFilename], rather
/// than simply navigating to or opening the document in a new tab.
Future<bool> downloadBytes({
  required Uint8List bytes,
  required String downloadFilename,
  String mimeType = 'application/pdf',
}) async {
  try {
    final jsArray = bytes.toJS;
    final blob = web.Blob(
      [jsArray].toJS,
      web.BlobPropertyBag(type: mimeType),
    );
    final blobUrl = web.URL.createObjectURL(blob);

    final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
    anchor.href = blobUrl;
    anchor.download = downloadFilename;
    anchor.style.display = 'none';
    web.document.body?.appendChild(anchor);
    anchor.click();

    // Small delay before cleanup so the browser registers the download trigger.
    await Future<void>.delayed(const Duration(milliseconds: 250));
    anchor.remove();
    web.URL.revokeObjectURL(blobUrl);
    return true;
  } catch (e) {
    return false;
  }
}

/// Fallback method using direct asset path URL.
Future<bool> downloadAsset({
  required String assetPath,
  required String downloadFilename,
}) async {
  try {
    final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
    anchor.href = assetPath;
    anchor.download = downloadFilename;
    anchor.style.display = 'none';
    web.document.body?.appendChild(anchor);
    anchor.click();
    await Future<void>.delayed(const Duration(milliseconds: 150));
    anchor.remove();
    return true;
  } catch (e) {
    return false;
  }
}
