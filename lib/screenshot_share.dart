import 'dart:io';
import 'dart:typed_data';
import "dart:ui" as dart_ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

void _saveTempFileShare(Uint8List bytes) async {
  final tempDir = await getTemporaryDirectory();
  final file = File('${tempDir.path}/sharedImage.png');
  await file.writeAsBytes(bytes);

  Share.shareFiles([file.path], mimeTypes: ["image/png"]);
}

void screenshotShare(GlobalKey previewContainerKey) async {
  final currentContext = previewContainerKey.currentContext;
  if (currentContext == null) {
    return;
  }
  RenderRepaintBoundary boundary = currentContext.findRenderObject() as RenderRepaintBoundary;
  dart_ui.Image image = await boundary.toImage(pixelRatio: 2.5);
  ByteData? byteData = await (image.toByteData(format: dart_ui.ImageByteFormat.png));
  Uint8List pngBytes = byteData!.buffer.asUint8List();
  try {
    _saveTempFileShare(pngBytes);
  } catch (e) {
    throw "Error while sharing: $e";
  }
}