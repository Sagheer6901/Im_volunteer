import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_am_volunteer/models/user_model.dart';
import 'package:i_am_volunteer/services/chat_service.dart';
import 'package:i_am_volunteer/services/firestore_service.dart';
import 'package:i_am_volunteer/services/locator.dart';

import '../models/chat_item.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';

class ChatScreenController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  RxBool chatLoading = false.obs;
  RxBool loading = false.obs;
  TextEditingController messageText = TextEditingController();
  FocusNode messageTextFocus = FocusNode();
  ScrollController scrollController = ScrollController();
  final chatService = locator.get<ChatService>();
  final authService = locator.get<AuthService>();
  final fireService = locator.get<FirestoreService>();
  Rx<List<ChatItem>> messages = Rx<List<ChatItem>>([]);




  Future<void> subscribeForMessages(String? chatID) async {
    await chatService.chatStreams(chatID).listen((event) {
      if (event.isNotEmpty) {
        const equality = ListEquality();
        if (!equality.equals(event, messages.value)) {
          messages.value = event;
        }
      }
    });
  }

  Future<void> createChat() async {
    chatLoading.value = true;
    if (await chatService.chatExists()) {
      log('Chat exists');
    } else {
      log('chat does not exist!');
      await chatService.createChat();
    }
    chatLoading.value = false;
  }

  Future<void> getChatWithUser(String userUid, name) async {
    loading.value = true;
    final chatID = await chatService.getAdminChatWithUser(userUid);
    loading.value = false;
    Get.toNamed(
      AppRoutes.chatScreen,
      arguments: {
        'chatID': chatID,
        'name': name,
      },
    );
  }

  Future<void> createChatWithAdmin() async {
    chatLoading.value = true;
    if (await chatService.adminChatExists()) {
      final chatID = await chatService.getUserChatWithAdminID();
      chatLoading.value = false;
      Get.toNamed(
        AppRoutes.chatScreen,
        arguments: {
          'chatID': chatID,

        },
      );
    } else {
      log('chat does not exist!');
      // final chatID = await chatService.createUserChatWithAdmin();
      // chatLoading.value = false;
      Get.toNamed(
        AppRoutes.chatScreen,
        arguments: {
          'chatID': null,
        },
      );
    }
  }


  void removeFocus() {
    if (messageTextFocus.hasFocus) {
      messageTextFocus.unfocus();
    }
  }

  void scrollToBottom() {
    // Future.delayed(const Duration(milliseconds: 100), () {
    //   scrollController.animateTo(scrollController.position.maxScrollExtent,
    //       duration: const Duration(milliseconds: 1),
    //       curve: Curves.fastOutSlowIn);
    // });
  }

  Future<bool> onBack() async {
    removeFocus();
    if (!messageTextFocus.hasFocus) {
      Get.back();
    }
    return Future.value(false);
  }

  final chatI = "".obs;


  Future<void> sendText(String? chatID,userRole) async {
    String text = messageText.text.trim();
    if(userRole != Role.admin){
      if(chatI.value.toString() == "" && chatID ==null){
        chatI.value = await chatService.createUserChatWithAdmin();
        if (text.isNotEmpty) {
          messageText.clear();
          await chatService.sendChat(text, chatI.value);
          // subscribeForMessages(chatI.value);
        }
      }
      else{
        final chat = await chatService.getUserChatWithAdminID();
        if (text.isNotEmpty) {
          messageText.clear();
          await chatService.sendChat(text, chat);
        }
      }
    }
    else{
      if (text.isNotEmpty) {
        messageText.clear();
        await chatService.sendChat(text, chatID);
      }
    }

  }

  @override
  void dispose() {
    messageText.dispose();
    scrollController.dispose();
    chatI.value == "";
    super.dispose();
  }

}
