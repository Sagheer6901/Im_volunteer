import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class ManageEventController extends GetxController{
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ReceivePort _port = ReceivePort();

  @override
  void onInit() {
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      // setState((){ });
    });

    FlutterDownloader.registerCallback(downloadCallback);    super.onInit();
  }


  @override
  void onClose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    var send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  download(url) async {
    final temp = await getApplicationDocumentsDirectory();

    final taskId = await FlutterDownloader.enqueue(
      url: '$url',
      headers: {}, // optional: header send with url (auth token etc)
      savedDir: temp.path,
      showNotification: true, // show download progress in status bar (for Android)
      openFileFromNotification: true, // click on notification to open downloaded file (for Android)
    );
    FlutterDownloader.open(taskId: taskId!);
  }
}