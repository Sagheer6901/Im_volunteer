import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_am_volunteer/widgets/custom_scaffold.dart';

import '../../controllers/chat_screen_controller.dart';
import '../../models/chat_list.dart';
import '../../models/user_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/ui_utils.dart';
import '../../widgets/custom_text.dart';

class UserList extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final controller = Get.find<ChatScreenController>();
  UserList({super.key});

  @override
  Widget build(BuildContext context) {
    final isUserAdmin = controller.authService.user!.isAdmin();
    return CustomScaffold(
      showBottomNavigation: false,
      onWillPop: () {
        Navigator.of(context).pop();
      },
      screenName: 'Users List',
      body: Column(
        children: [
          if (!isUserAdmin) _adminChat(),
          if (!isUserAdmin) const Divider(),
          Expanded(
            child: StreamBuilder<List<ChatList>>(
              stream: isUserAdmin
                  ? controller.chatService.getAdminChatList()
                  : controller.chatService.getChatList(),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return UiUtils.loader;
                } else if (snap.hasData) {
                  if (snap.data!.isEmpty) {
                    return const Center(
                      child: Text('No chats!'),
                    );
                  }
                  final chats = snap.data!;
                  return ListView.separated(
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final chat = chats[index];
                      final isAdminChat = chat.isAdminChat!;
                      if (isAdminChat && isUserAdmin) {
                        final user = chat.participantsData!.where((e) {
                          return e.role == Role.user.name;
                        }).first;
                        return _chatItem(user);
                      } else {
                        final currentUid = controller.authService.user!.uid;
                        final user = chat.participantsData!.where((e) {
                          return e.uid != currentUid;
                        }).first;
                        return _chatItem(user);
                      }
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                  );
                } else {
                  return const Center(
                    child: Text('Something went wrong!'),
                  );
                }
              },
            ),
          ),
        ],
      ),
      scaffoldKey: scaffoldKey,
    );
  }

  Widget _chatItem(ParticipantsData user) {
    return InkWell(
      onTap: () async {
        if (controller.authService.user!.isAdmin()) {
          controller.getChatWithUser(user.uid!,user.name);
        } else {
          await controller.createChat();
        }
      },
      child: SizedBox(
        height: Get.height * 0.08,
        // decoration: BoxDecoration(
        //   border: Border(
        //     top: BorderSide(
        //       color: AppColors.primary,
        //     ),
        //     bottom: BorderSide(
        //       color: AppColors.primary,
        //     ),
        //   ),
        // ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.primary,
                child: Icon(
                  Icons.person,
                  size: 30,
                  color: AppColors.white,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: user.name!,
                    color: AppColors.primary,
                    fontSize: 20,
                    weight: FontWeight.bold,
                  ),
                  CustomText(
                    text: user.email!,
                    fontSize: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _adminChat() {
    return InkWell(
      onTap: () async {
        await controller.createChatWithAdmin();
      },
      child: Container(
        width: Get.width,
        height: Get.height * 0.08,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.3),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Icon(
                Icons.chat,
                color: AppColors.white,
              ),
            ),
            Expanded(
              flex: 6,
              child: CustomText(
                text: 'Chat with Admin',
                color: AppColors.white,
                weight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Expanded(
              flex: 2,
              child: Obx(
                () => controller.chatLoading.value
                    ? UiUtils.loader
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
