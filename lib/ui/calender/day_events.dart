import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_am_volunteer/controllers/home_controller.dart';
import 'package:i_am_volunteer/utils/app_colors.dart';
import 'package:i_am_volunteer/widgets/custom_text.dart';

import '../../controllers/calender_screen_controller.dart';

class DayEvents extends StatelessWidget {
  final controller = Get.find<CalenderScreenController>();
  final homeController = Get.find<HomeScreenController>();

  DayEvents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(),
    );
  }

  Widget _getBody() {
    var data = Get.arguments;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, top: 20),
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('events')
                  .where('eventDate', isEqualTo: data)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }
                if (snapshot.data!.size == 0) {
                  return Center(child: Text("There is no Lead"));
                }
                return Expanded(
                    child: ListView(
                        shrinkWrap: true,
                        // itemCount: snapshot.data!.docs.length,
                        // itemBuilder: ((context, index) {
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          return postWidget(
                              title: data['title'],
                              image: data['image'],
                              name: data['adminName'],
                              profileImage: data['adminImage'],
                              openEvent: data['openEvent']);
                        }).toList()));
                //     return Text('nodata');
                //   }),
                // );
              }),

          // postWidget(image: AppAssets.eventPhoto, name: 'Dr. IJKL', profileImage: AppAssets.personImage3,openEvent: false),
          // postWidget(image: AppAssets.eventPhoto2, name: 'Dr. CDEF', profileImage: AppAssets.personImage2,openEvent: true)
        ],
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
    return Container(
      height: 200,
      width: Get.width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(image, fit: BoxFit.cover)),
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
            ? GestureDetector(
                onTap: () {
                  // homeController.onApplyVolunteer();
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
              )
            : const SizedBox()
      ],
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
}
