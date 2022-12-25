import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:i_am_volunteer/controllers/custom_bottom_navbar_controller.dart';
import 'package:i_am_volunteer/routes/app_routes.dart';
import 'package:path_provider/path_provider.dart';

class ManageEventController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ReceivePort _port = ReceivePort();
  CustomBottomNavBarController bottomNavigationController = Get.find(tag: AppRoutes.kBottomNavigationController);
  Future<bool> onWillPop() {
    bottomNavigationController.selectedNav.value = 2;
    Get.back();

    return Future.value(false);
  }
  @override
  void onInit() {
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      // setState((){ });
    });

    FlutterDownloader.registerCallback(downloadCallback);
    super.onInit();
  }

  @override
  void onClose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    var send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  download(url) async {
    await FlutterDownloader.cancelAll();
    final temp = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    final random = Random();
    final taskId = await FlutterDownloader.enqueue(
      url: '$url',
      // headers: {}, // optional: header send with url (auth token etc)
      savedDir: temp!.path,
      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
      fileName: 'volunteer_card_${random.nextInt(1000)}.pdf',
    );
    FlutterDownloader.open(taskId: taskId!);
  }
}
