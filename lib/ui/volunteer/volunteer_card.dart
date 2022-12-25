import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_am_volunteer/controllers/manage_event_controller.dart';
import 'package:i_am_volunteer/widgets/custom_scaffold.dart';
import 'package:i_am_volunteer/widgets/custom_text.dart';

import '../../utils/app_colors.dart';

class VolunteerCards extends StatelessWidget {
  final controller = Get.put(ManageEventController());

  VolunteerCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      showBottomNavigation: false,
      scaffoldKey: controller.scaffoldKey,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc("Y3feimlhlSOu4iDotiSK9nIM5ZC2")
            .collection("eventCards")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          return Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            children: snapshot.data!.docs.map(
              (DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: 'Cards For Volunteers',
                            fontSize: 30,
                            color: AppColors.primary,
                            weight: FontWeight.w700,
                          ),
                          // const Icon(
                          //   Icons.search,
                          // ),
                        ],
                      ),
                    ),
                    FittedBox(child: Text("Click Event Button to Download your Card",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),)),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.primary,
                          ),
                          borderRadius: BorderRadius.circular(
                            20,
                          ),
                        ),
                        child: InkWell(
                          onTap: () {
                            controller.download(data['volunteerCard']);
                          },
                          child: FittedBox(
                            child: Text(
                              data['eventName'],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ).toList(),
          );
        },
      ),
      screenName: 'Manage Events',
    );
  }
}
