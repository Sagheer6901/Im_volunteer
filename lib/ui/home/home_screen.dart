import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_am_volunteer/controllers/custom_navigation_drawer_controller.dart';
import 'package:i_am_volunteer/controllers/home_controller.dart';
import 'package:i_am_volunteer/main.dart';
import 'package:i_am_volunteer/models/user_model.dart';
import 'package:i_am_volunteer/ui/event/add_event.dart';
import 'package:i_am_volunteer/widgets/custom_button.dart';
import 'package:i_am_volunteer/widgets/custom_text.dart';

import '../../controllers/chat_screen_controller.dart';
import '../../models/event_model.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_colors.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/event.dart';

class HomeScreen extends StatelessWidget {
  final controller = Get.find<HomeScreenController>();
  final chatController = Get.find<ChatScreenController>();
  final controllerAuth = Get.find<CustomNavigationDrawerController>();

  HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: _getBody(),
      scaffoldKey: controller.scaffoldKey,
      screenName: 'Home Screen',
    );
  }

  Widget _getBody() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   physics: const BouncingScrollPhysics(),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       statusWidget(image: AppAssets.personImage1, text: 'Dr. ABCD'),
          //       statusWidget(image: AppAssets.personImage2, text: 'Dr. CDEF'),
          //       statusWidget(image: AppAssets.personImage3, text: 'Dr. IJKL'),
          //       statusWidget(image: AppAssets.personImage1, text: 'Dr. ABCDEF'),
          //       statusWidget(image: AppAssets.personImage2, text: 'Dr. CDEFGHI'),
          //       statusWidget(image: AppAssets.personImage3, text: 'Dr. IJKLMNO'),
          //
          //     ],
          //   ),
          // ),
          StreamBuilder<QuerySnapshot>(
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
                return const Center(child: Text("There is no Lead"));
              }
              return SizedBox(
                height: 120,
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  // itemCount: snapshot.data!.docs.length,
                  // itemBuilder: ((context, index) {
                  children: snapshot.data!.docs.map(
                    (DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return statusWidget(
                          image: data['profile'], text: '${data['name']}');
                    },
                  ).toList(),
                ),
              );
              //     return Text('nodata');
              //   },),
              // );
            },
          ),

          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('events').snapshots(),
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
                    "There are no events!!",
                  ),
                );
              }
              return Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: snapshot.data!.docs.map(
                    (document) {
                      final data = document.data();
                      final event = EventModel.fromJson(data);
                      return EventWidget(
                        event: event,
                        onApplyForVolunteer: () {
                          controller.onApplyVolunteer(data['eventId']);
                        },
                        onPostTapped: () {
                          Get.toNamed(
                            AppRoutes.eventDetails,
                            arguments: {
                              'event': event,
                            },
                          );
                        },
                      );
                    },
                  ).toList(),
                ),
              );
              //     return Text('nodata');
              //   }),
              // );
            },
          ),
          controllerAuth.authService.user!.role ==Role.admin?Container(
              height: 40,
              margin: EdgeInsets.only(bottom: 50,top: 10),
              child: CustomButton(label: "Add Event",color: AppColors.secondary,textColor: AppColors.primary, onTap: (){
                Get.to(()=> AddEvent());
              })):SizedBox()
       ],
      ),
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
                child: Image.network(image, fit: BoxFit.cover)),
          ),
          const SizedBox(
            height: 7,
          ),
          CustomText(text: text),
        ],
      ),
    );
  }

  Widget postWidget(
      {required String title,
      required String image,
      required String name,
      required String profileImage,
      required bool openEvent}) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: AppColors.primary.withOpacity(0.07), blurRadius: 3),
            ]),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                profileImageWidget(image: profileImage),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: name,
                      color: AppColors.primary,
                      weight: FontWeight.w600,
                    ),
                    CustomText(text: title)
                  ],
                )),
                const Icon(Icons.more_vert),
              ],
            ),
            const SizedBox(
              height: 14,
            ),
            postImage(image),
            const SizedBox(height: 7),
            bottomWidgetOfPost(openEvent)
          ],
        ),
      ),
    );
  }

  Widget profileImageWidget({required String image}) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: AppColors.primary.withOpacity(0.4),
      // child: CircleAvatar(
      //   radius: 20,
      //   child: Image.network(image),
      // ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.network(image, fit: BoxFit.cover)),
    );
  }

  Widget postImage(String image) {
    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.eventDetails);
      },
      child: Container(
        height: 200,
        width: Get.width,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(image, fit: BoxFit.cover)),
      ),
    );
  }

  Widget bottomWidgetOfPost(bool isEventOpen) {
    return Row(
      children: [
        const Icon(Icons.favorite_border),
        const SizedBox(width: 13),
        const Icon(Icons.chat_bubble_outline),
        const Spacer(),
        isEventOpen
            ? (controller.indicator?CircularProgressIndicator(color: AppColors.secondary,):GestureDetector(
          onTap: () {
            // controller.onApplyVolunteer(data['eventId']);

          },
          child: Container(
            height: 40,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: AppColors.primary.withOpacity(0.4), width: 2)),
            child: const CustomText(
              text: 'Apply For Volunteer',
              weight: FontWeight.w600,
            ),
          ),
        ))
            : const SizedBox()
      ],
    );
  }
}
