import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_am_volunteer/controllers/custom_bottom_navbar_controller.dart';
import 'package:i_am_volunteer/controllers/manage_event_controller.dart';
import 'package:i_am_volunteer/routes/app_routes.dart';
import 'package:i_am_volunteer/ui/volunteer/volunteer_detail.dart';
import 'package:i_am_volunteer/utils/app_assets.dart';
import 'package:i_am_volunteer/widgets/custom_button.dart';
import 'package:i_am_volunteer/widgets/custom_scaffold.dart';
import 'package:i_am_volunteer/widgets/custom_text.dart';

import '../../utils/app_colors.dart';

class Volunteers extends StatelessWidget {
  final controller = Get.put(ManageEventController());
  CustomBottomNavBarController bottomNavigationController = Get.find(tag: AppRoutes.kBottomNavigationController);

  Volunteers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      showBottomNavigation: false,
      scaffoldKey: controller.scaffoldKey,
      onWillPop: (){
        bottomNavigationController.selectedNav.value = 2;
        Get.back();

        return Future.value(false);
      },
      body:                   StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where("volunteer", isEqualTo: true)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          return Wrap(
              alignment: WrapAlignment.center,
              // shrinkWrap: true,
              // itemCount: snapshot.data!.docs.length,
              // itemBuilder: ((context, index) {
              children: snapshot.data!.docs
                  .map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
                // return Text("data ${data['email']}");
                return InkWell(
                    onTap: (){
                      Get.to(
                        // AppRoutes.volunteerDetails,
                        // arguments: {
                        //   'volunteer': data,
                        // },
                              ()=> VolunteerDetails(volunteer: data,)
                      );
                    },
                    child: _getBody(data, context));
              }).toList());
        },
      ),
      screenName: 'Manage Events',
    );
  }

  Widget _getBody(data, context) {
    return Container(
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Column(
        children: [
          data['image'] == null
              ? CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(AppAssets.personImage2),
          )
              : CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primary.withOpacity(0.4),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.network(data['image'], fit: BoxFit.cover)),
          ),
          SizedBox(
            height: 10,
          ),
          FittedBox(
              child: CustomText(
                  text: data['name'], fontSize: 16, weight: FontWeight.w600)),
          SizedBox(
            height: 5,
          ),
          FittedBox(
              child: CustomText(
                  text: data['email'], fontSize: 16, weight: FontWeight.w600)),
          SizedBox(
            height: 5,
          ),
          FittedBox(
              child: CustomText(
                  text: "${data['dept']}",
                  fontSize: 16,
                  weight: FontWeight.w600)),
          SizedBox(
            height: 5,
          ),
          CustomText(
            text: "2018",
            fontSize: 16,
            weight: FontWeight.w600,
          ),
          SizedBox(
            height: 5,
          ),
          data['volunteer'] == true
              ? CustomButton(
            onTap: () {
              // controller.pdfCreation("${data['email']}", data['vid'], eventId, controllerAuth.authService.user!.uid);
            },
            label: "Selected",
            color: AppColors.secondary,
            fontWeight: FontWeight.w500,
            textSize: 16,
            height: 40,
            textColor: Colors.red,
          )
              : CustomButton(
              label: "Accept",
              color: AppColors.secondary,
              fontWeight: FontWeight.w500,
              textSize: 16,
              height: 40,
              textColor: AppColors.primary,
              onTap: () {
                // FirebaseFirestore.instance.collection('volunteers').doc(data!['uid']).update(
                //     {
                //       "volunteer":true
                //     });

                // FirebaseFirestore.instance.collection('events').doc(docId).collection("volunteers").doc("g9y0xFXEXUusRP4saXX3").update(
                //     {
                //       "volunteer":true
                //     });
                // controller.pdfCreation("${data['email']}", data['vid'], eventId, data['uid']);
              })
        ],
      ),
    );
  }

}
