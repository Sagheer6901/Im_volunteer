import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_am_volunteer/controllers/event_detail_controller.dart';
import 'package:i_am_volunteer/controllers/home_controller.dart';
import 'package:i_am_volunteer/ui/admin/manageVolunteers/manage_volunteers.dart';
import 'package:i_am_volunteer/utils/app_colors.dart';
import 'package:i_am_volunteer/widgets/custom_button.dart';
import 'package:i_am_volunteer/widgets/custom_scaffold.dart';
import 'package:i_am_volunteer/widgets/custom_text.dart';
import 'package:intl/intl.dart';

import '../../models/comment_model.dart';
import '../../models/event_model.dart';
import '../../utils/ui_utils.dart';
import '../../widgets/event.dart';
import '../../widgets/input_field.dart';

class EventDetails extends StatefulWidget {
  final EventModel event;

  const EventDetails({
    super.key,
    required this.event,
  });

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails>
    with SingleTickerProviderStateMixin {
  final controller = Get.put(EventDetailsScreenController());
  final homeController = Get.find<HomeScreenController>();
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    controller.listenToComments(widget.event.eventId!);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 600,
      ),
    );
    _animation = Tween<double>(
      begin: Get.height * 0.48,
      end: Get.height - 130,
    ).animate(
      _animationController,
    );
  }

  @override
  Widget build(BuildContext context) {
    log('VALUE: ${_animationController.value}');
    return CustomScaffold(
      body: _getBody(),
      showBottomNavigation: false,
      onWillPop: controller.onBack,
      scaffoldKey: controller.scaffoldKey,
      screenName: 'Event Details',
    );
  }

  Widget _getBody() {
    return Stack(
      children: [
        Column(
          children: [
            _postWidget(),
            (FirebaseAuth.instance.currentUser!.email!.contains("admin"))?CustomButton(label: "Manage Volunteers", fontWeight: FontWeight.w500, textSize: 18, textColor: AppColors.primary, onTap: (){
              Get.to(()=>ManageVolunteers( eventId:widget.event.eventId));
            }):SizedBox()
          ],
        ),
        Positioned(
          bottom: 0,
          child: _comments(),
        ),
      ],
    );
  }

  Widget _comments() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return InkWell(
          onTap: () {
            if (isExpanded) {
              _animationController.reverse();
            } else {
              _animationController.forward();
            }
            isExpanded = !isExpanded;
          },
          child: Container(
            width: Get.width,
            height: _animation.value,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: kElevationToShadow[6],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                UiUtils.vertSpace10,
                CustomText(
                  text: isExpanded ? 'Tap to collapse!' : 'Tap to expand!',
                ),
                InkWell(
                  onTap: () {
                    _openCommentDialog();
                  },
                  child: Row(
                    children: [
                      Expanded(
                        flex: 9,
                        child: IgnorePointer(
                          child: InputField(
                            controller: controller.commentController,
                            prefixIcon: Icons.comment,
                            hint: 'Add a comment',
                          ),
                        ),
                      ),
                      Obx(
                        () => controller.isLoading.value
                            ? CircularProgressIndicator.adaptive(
                                valueColor: AlwaysStoppedAnimation(
                                  AppColors.primary,
                                ),
                              )
                            : IconButton(
                                icon: Icon(
                                  Icons.send,
                                  color: AppColors.primary,
                                ),
                                onPressed: () {},
                              ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Obx(
                    () => controller.comments.value.isEmpty
                        ? CustomText(
                            text: 'No comments yet!',
                            color: AppColors.secondary,
                          )
                        : ListView.builder(
                            itemCount: controller.comments.value.length,
                            itemBuilder: (context, index) {
                              final comment = controller.comments.value[index];
                              return _singleComment(comment);
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _singleComment(CommentModel comment) {
    final dateFormat = DateFormat('MMM dd, yyyy hh:mm a');
    final currentUid = FirebaseAuth.instance.currentUser;
    RxBool isLiked = comment.likes!.contains(currentUid!.uid).obs;
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: comment.commentBy!.name!,
                weight: FontWeight.bold,
                color: AppColors.primary,
              ),
              Obx(
                () => InkWell(
                  onTap: () async {
                    if (isLiked.value) {
                      await controller.unlikeComment(
                        widget.event.eventId!,
                        comment.commentId!,
                      );
                    } else {
                      await controller.likeComment(
                        widget.event.eventId!,
                        comment.commentId!,
                      );
                    }
                    isLiked.value = !isLiked.value;
                  },
                  child: Icon(
                    isLiked.value
                        ? CupertinoIcons.heart_fill
                        : CupertinoIcons.heart,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
          CustomText(
            text: comment.comment ?? 'Unknown',
            weight: FontWeight.bold,
          ),
          UiUtils.vertSpace5,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: dateFormat.format(
                  comment.time ?? DateTime.now(),
                ),
              ),
              if (comment.likes!.isNotEmpty)
                CustomText(
                  text: comment.likes!.length == 1
                      ? '1 like'
                      : '${comment.likes!.length} likes',
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _openCommentDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          insetPadding: EdgeInsets.zero,
          title: CustomText(
            text: 'Add a comment!',
            color: AppColors.primary,
            weight: FontWeight.bold,
          ),
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: Get.width,
            child: InputField(
              autoFocus: true,
              controller: controller.commentController,
              prefixIcon: Icons.comment,
              hint: 'Add a comment',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const CustomText(
                text: 'Cancel',
                color: Colors.red,
              ),
            ),
            TextButton(
              onPressed: () => controller.addComment(
                context,
                widget.event.eventId!,
              ),
              child: CustomText(
                text: 'Comment',
                color: AppColors.primary,
                weight: FontWeight.bold,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _postWidget() {
    return EventWidget(
      event: widget.event,
      showBottomWidgets: false,
    );
  }

  Widget _adminProfiles() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where("role", isEqualTo: "admin")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        if (snapshot.data!.size == 0) {
          return const Center(
            child: Text(
              "There is no Lead",
            ),
          );
        }
        return SizedBox(
          height: 120,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            // itemCount: snapshot.data!.docs.length,
            // itemBuilder: ((context, index) {
            children: snapshot.data!.docs.map(
              (document) {
                final data = document.data();
                return statusWidget(
                  image: data['profile'],
                  text: '${data['name']}',
                );
              },
            ).toList(),
          ),
        );
      },
    );
  }

  Widget statusWidget({required String image, required String text}) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: AppColors.primary.withOpacity(0.4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: Image.network(
                image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 7,
          ),
          CustomText(text: text),
        ],
      ),
    );
  }
}
