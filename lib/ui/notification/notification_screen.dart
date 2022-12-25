import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_am_volunteer/models/event_model.dart';
import 'package:i_am_volunteer/routes/app_routes.dart';
import 'package:i_am_volunteer/utils/app_assets.dart';
import 'package:i_am_volunteer/utils/app_colors.dart';
import 'package:i_am_volunteer/widgets/custom_text.dart';
import 'package:i_am_volunteer/widgets/event.dart';
import '../../controllers/notification_screen_controller.dart';
import '../../widgets/custom_scaffold.dart';

class NotificationScreen extends StatelessWidget {
  final controller = Get.find<NotificationScreenController>();
  NotificationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: _getBody(),
      onWillPop: controller.onWillPop,
      scaffoldKey: controller.scaffoldKey,
      screenName: 'Notification Screen',
    );
  }
  Widget _vgetBody() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream:
            FirebaseFirestore.instance.collection('events').snapshots(),
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
              return Expanded(
                child: ListView(
                  shrinkWrap: true,
                  // scrollDirection: Axis.horizontal,
                  // itemCount: snapshot.data!.docs.length,
                  // itemBuilder: ((context, index) {
                  children: snapshot.data!.docs.map(
                        (DocumentSnapshot document) {
                      Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                      return InkWell(
                          onTap: () {
                            Get.toNamed(AppRoutes.homeScreen);
                          },
                          child: notificationContainer(
                              image: data['adminImage'],
                              notificationDescription:
                              '${data['adminName']} added a event'));
                    },
                  ).toList(),
                ),
              );
              //     return Text('nodata');
              //   },),
              // );
            },
          ),

        ],
      ),
    );
  }

  Widget _getBody() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          notificationSearchWidget(),
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
                      return InkWell(
                          onTap: () {
                            // FirebaseFirestore.instance.collection("events").doc(data['eventId']).update(
                            //     {
                            //       "openEvent": false
                            //     });
                            // Get.toNamed(AppRoutes.homeScreen);
                            Get.toNamed(
                              AppRoutes.eventDetails,
                              arguments: {
                                'event': event,
                              },
                            );
                          },
                          child: notificationContainer(
                              image: data['adminImage'],
                              notificationDescription:
                              '${data['adminName']} added a event'));                    },
                  ).toList(),
                ),
              );
              //     return Text('nodata');
              //   }),
              // );
            },
          ),


          //     Map<String, dynamic> data =
          //     document.data()! as Map<String, dynamic>;
          //
          // // final data = document.data();
          // final event = EventModel.fromJson(data);
          // return data['openEvent']==true?InkWell(
          //     onTap: () {
          //       FirebaseFirestore.instance.collection("events").doc(data['eventId']).update(
          //           {
          //             "openEvent": false
          //           });
          //       // Get.toNamed(AppRoutes.homeScreen);
          //       Get.toNamed(
          //         AppRoutes.eventDetails,
          //         arguments: {
          //           'event': event,
          //         },
          //       );
          //     },
          //     child: notificationContainer(
          //         image: data['adminImage'],
          //         notificationDescription:
          //         '${data['adminName']} added a event')):SizedBox();

          // notificationContainer(image: AppAssets.personImage2, notificationDescription: 'Dr ABC added a event'),
          // notificationContainer(image: AppAssets.personImage1, notificationDescription: 'Dr ABCDE added a event'),
          // notificationContainer(image: AppAssets.personImage3, notificationDescription: 'Dr IJKL added a event'),
        ],
      ),
    );
  }

  Widget notificationContainer(
      {required String image, required String notificationDescription}) {
    return Container(
      width: Get.width,
      height: 100,
      decoration: BoxDecoration(
          border:
          Border(bottom: BorderSide(color: AppColors.secondary, width: 2))),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.primary.withOpacity(0.4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
              child: CustomText(
                text: notificationDescription,
                weight: FontWeight.w500,
              )),
          Icon(
            Icons.more_horiz,
            color: AppColors.primary,
          )
        ],
      ),
    );
  }

  Widget notificationSearchWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: 'Notification',
            fontSize: 30,
            color: AppColors.primary,
            weight: FontWeight.w700,
          ),
          // const Icon(
          //   Icons.search,
          // ),
        ],
      ),
    );
  }
}
