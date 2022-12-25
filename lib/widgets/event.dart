import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_am_volunteer/controllers/auth_controller.dart';
import 'package:i_am_volunteer/controllers/custom_navigation_drawer_controller.dart';
import 'package:i_am_volunteer/controllers/event_controller.dart';
import 'package:i_am_volunteer/models/event_model.dart';
import 'package:i_am_volunteer/models/user_model.dart';
import 'package:i_am_volunteer/services/auth_service.dart';
import 'package:i_am_volunteer/services/locator.dart';

import '../routes/app_routes.dart';
import '../utils/app_colors.dart';
import 'custom_text.dart';

class EventWidget extends StatelessWidget {
  final controller = Get.put(EventController());
  final controllerUser = Get.find<CustomNavigationDrawerController>();
  final authService = locator.get<AuthService>();

  final EventModel event;
  final Function()? onApplyForVolunteer;
  final Function()? onPostTapped;
  final bool showBottomWidgets;

  EventWidget({
    Key? key,
    required this.event,
    this.onApplyForVolunteer,
    this.onPostTapped,
    this.showBottomWidgets = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser;
    RxBool isLiked = event.likes!.contains(currentUid!.uid).obs;
    RxBool isApplied = event.applied!.contains(currentUid.uid).obs;

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.07),
              blurRadius: 3,
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                _profileImageWidget(
                  image: event.adminImage!,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: event.adminName!,
                        color: AppColors.primary,
                        weight: FontWeight.w600,
                      ),
                      CustomText(
                        text: event.title!,
                      )
                    ],
                  ),
                ),
                authService.user!.role == Role.admin?IconButton(
                  onPressed: (){
    Get.defaultDialog(
      textCancel:"No" ,
    textConfirm:  "Yes",
    onCancel: (){
        Get.back();
    },
        onConfirm: (){
          FirebaseFirestore.instance.collection("events").doc(event.eventId).delete();
          Get.back();

        },
    content: Text("Do you want to Delete Event?"));

                    // FirebaseFirestore.instance.collection("events").doc(event.eventId).delete();
                  },
                  icon: const Icon(
                    Icons.more_vert,
                  ),
                ):SizedBox(),
              ],
            ),
            const SizedBox(
              height: 14,
            ),
            _postImage(
              event.image!,
            ),
            const SizedBox(height: 7),
            if (showBottomWidgets)
              _bottomWidgetOfPost(
                  event.openEvent ?? true, isLiked, event, isApplied),
          ],
        ),
      ),
    );
  }

  Widget _profileImageWidget({required String image}) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: AppColors.primary.withOpacity(0.4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Image.network(
          image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _postImage(String image) {
    return InkWell(
      onTap: onPostTapped,
      child: Container(
        height: 200,
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _bottomWidgetOfPost(bool isEventOpen, isLiked, event, isApplied) {
    return Row(
      children: [
        Obx(
          () => InkWell(
            onTap: () async {
              if (isLiked.value) {
                await controller.unlikeEvent(
                  event.eventId!,
                );
              } else {
                await controller.likeEvent(
                  event.eventId!,
                );
              }
              isLiked.value = !isLiked.value;
            },
            child: Icon(
              isLiked.value ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
              color: Colors.red,
            ),
          ),
        ),
        const SizedBox(
          width: 13,
        ),
        IconButton(
          onPressed: onPostTapped,
          icon: Icon(Icons.messenger_outline_sharp),
          color: AppColors.primary,
        ),
        const Spacer(),
         (
            controllerUser.authService.user!.email!.contains("admin")?SizedBox():(!isApplied.value
                ? GestureDetector(
                    onTap: onApplyForVolunteer,
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.4),
                          width: 2,
                        ),
                      ),
                      child: const CustomText(
                        text: 'Apply For Volunteer',
                        weight: FontWeight.w600,
                      ),
                    ),
                  )
                : GestureDetector(
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.4),
                          width: 2,
                        ),
                      ),
                      child: const CustomText(
                        text: 'Applied',
                        weight: FontWeight.w600,
                      ),
                    ),
                  )))

      ],
    );
  }
}



//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:i_am_volunteer/controllers/custom_navigation_drawer_controller.dart';
// import 'package:i_am_volunteer/controllers/event_controller.dart';
// import 'package:i_am_volunteer/models/event_model.dart';
//
// import '../routes/app_routes.dart';
// import '../utils/app_colors.dart';
// import 'custom_text.dart';
//
// class EventWidget extends StatelessWidget {
//   final controller = Get.put(EventController());
//   final controllerUser = Get.find<CustomNavigationDrawerController>();
//
//   final EventModel event;
//   final Function()? onApplyForVolunteer;
//   final Function()? onPostTapped;
//   final bool showBottomWidgets;
//
//   EventWidget({
//     Key? key,
//     required this.event,
//     this.onApplyForVolunteer,
//     this.onPostTapped,
//     this.showBottomWidgets = true,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final currentUid = FirebaseAuth.instance.currentUser;
//     RxBool isLiked = event.likes!.contains(currentUid!.uid).obs;
//     RxBool isApplied = event.applied!.contains(currentUid.uid).obs;
//
//     return Padding(
//       padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
//       child: Container(
//         decoration: BoxDecoration(
//           color: AppColors.white,
//           borderRadius: BorderRadius.circular(10),
//           boxShadow: [
//             BoxShadow(
//               color: AppColors.primary.withOpacity(0.07),
//               blurRadius: 3,
//             ),
//           ],
//         ),
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 _profileImageWidget(
//                   image: event.adminImage!,
//                 ),
//                 const SizedBox(
//                   width: 10,
//                 ),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       CustomText(
//                         text: event.adminName!,
//                         color: AppColors.primary,
//                         weight: FontWeight.w600,
//                       ),
//                       CustomText(
//                         text: event.title!,
//                       )
//                     ],
//                   ),
//                 ),
//                 const Icon(
//                   Icons.more_vert,
//                 ),
//               ],
//             ),
//             const SizedBox(
//               height: 14,
//             ),
//             _postImage(
//               event.image!,
//             ),
//             const SizedBox(height: 7),
//             if (showBottomWidgets)
//               _bottomWidgetOfPost(
//                   event.openEvent ?? true, isLiked, event, isApplied),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _profileImageWidget({required String image}) {
//     return CircleAvatar(
//       radius: 22,
//       backgroundColor: AppColors.primary.withOpacity(0.4),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(30),
//         child: Image.network(
//           image,
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }
//
//   Widget _postImage(String image) {
//     return InkWell(
//       onTap: onPostTapped,
//       child: Container(
//         height: 200,
//         width: Get.width,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(10),
//           child: Image.network(
//             image,
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _bottomWidgetOfPost(bool isEventOpen, isLiked, event, isApplied) {
//     return Row(
//       children: [
//         Obx(
//               () => InkWell(
//             onTap: () async {
//               if (isLiked.value) {
//                 await controller.unlikeEvent(
//                   event.eventId!,
//                 );
//               } else {
//                 await controller.likeEvent(
//                   event.eventId!,
//                 );
//               }
//               isLiked.value = !isLiked.value;
//             },
//             child: Icon(
//               isLiked.value ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
//               color: Colors.red,
//             ),
//           ),
//         ),
//         const SizedBox(
//           width: 13,
//         ),
//         IconButton(
//           onPressed: onPostTapped,
//           icon: Icon(Icons.messenger_outline_sharp),
//           color: AppColors.primary,
//         ),
//         const Spacer(),
//         isEventOpen
//             ? (
//             controllerUser.authService.user!.email!.contains("admin")?SizedBox():(!isApplied.value
//                 ? GestureDetector(
//               onTap: onApplyForVolunteer,
//               child: Container(
//                 height: 40,
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(
//                     color: AppColors.primary.withOpacity(0.4),
//                     width: 2,
//                   ),
//                 ),
//                 child: const CustomText(
//                   text: 'Apply For Volunteer',
//                   weight: FontWeight.w600,
//                 ),
//               ),
//             )
//                 : GestureDetector(
//               child: Container(
//                 height: 40,
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(
//                     color: AppColors.primary.withOpacity(0.4),
//                     width: 2,
//                   ),
//                 ),
//                 child: const CustomText(
//                   text: 'Applied',
//                   weight: FontWeight.w600,
//                 ),
//               ),
//             )))
//             : const SizedBox()
//       ],
//     );
//   }
// }
