import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_am_volunteer/controllers/manage_volunteers_controller.dart';
import 'package:i_am_volunteer/utils/app_assets.dart';
import 'package:i_am_volunteer/utils/app_colors.dart';
import 'package:i_am_volunteer/widgets/custom_button.dart';
import 'package:i_am_volunteer/widgets/custom_scaffold.dart';
import 'package:i_am_volunteer/widgets/custom_text.dart';

class ManageVolunteers extends StatelessWidget {
  final controller = Get.put(ManageVolunteersController());
  var docId = "fLf0XG2qfM28FfqzbtDW";
  final eventId;
  ManageVolunteers({super.key, this.eventId});

  @override
  Widget build(BuildContext context) {
print("ss ${eventId}");

    print(docId);
    return CustomScaffold(
      showBottomNavigation: false,
      body:           Column(
        children: [
          TabBar(
              controller: controller.tabController,
              unselectedLabelColor: AppColors.primary,
              labelColor: AppColors.primary,
              indicatorWeight: 5,
              indicatorColor: AppColors.primary.withOpacity(0.8),
              tabs: <Widget>[
                Tab(
                  child: Text(
                    "REQUESTS",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Tab(
                  child: Text(
                    "SELECTED",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ]),
          Expanded(
            child: TabBarView(
                controller: controller.tabController, children: <Widget>[
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('events').doc(eventId).collection("volunteers")
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
                      children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;

                        return _getBody(data,context);
                      }).toList());
                },
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('events').doc(docId).collection("volunteers").snapshots(),
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
                      children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                        // return Text("data ${data['email']}");
                        return _getBody(data,context);
                      }).toList());
                },
              ),

            ]),
          ),
        ],
      ),
      // body: _getBody(),
      onWillPop: controller.onBack,
      scaffoldKey: controller.scaffoldKey,
      screenName: 'Volunteers Screen',
    );
  }

  Widget _getBody(data,context) {
    return
          Container(
            margin: EdgeInsets.all(15),
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width*0.4,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary),
              borderRadius: BorderRadius.all(Radius.circular(5))
            ),
            child: Column(
              children: [

                data['image']==null?
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(AppAssets.personImage2),
                ):
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primary.withOpacity(0.4),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.network(data['image'], fit: BoxFit.cover)
                  ),
                ),
                SizedBox(height: 10,),
                // FittedBox(child: CustomText(text:data['name'],fontSize: 16,weight: FontWeight.w600)),
                SizedBox(height: 5,),
                FittedBox(child: CustomText(text:data['email'],fontSize: 16,weight: FontWeight.w600)),
                SizedBox(height: 5,),
                // FittedBox(child: CustomText(text:"${data['dept']}",fontSize: 16,weight: FontWeight.w600)),
                SizedBox(height: 5,),
                CustomText(text:"2018",fontSize: 16, weight: FontWeight.w600,),
                SizedBox(height: 5,),

                data['volunteer']==true?CustomButton(onTap: (){
                  controller.pdfCreation("${data['email']}");

                },label: "Selected",color: AppColors.secondary,fontWeight: FontWeight.w500,textSize: 16,height: 40,textColor: Colors.red,):CustomButton(label: "Accept",color: AppColors.secondary,fontWeight: FontWeight.w500,textSize: 16,height: 40,textColor: AppColors.primary, onTap: (){
                  // FirebaseFirestore.instance.collection('volunteers').doc(data!['uid']).update(
                  //     {
                  //       "volunteer":true
                  //     });

                  // FirebaseFirestore.instance.collection('events').doc(docId).collection("volunteers").doc("g9y0xFXEXUusRP4saXX3").update(
                  //     {
                  //       "volunteer":true
                  //     });
                  controller.pdfCreation("${data['email']}");
                })

              ],
            ),
          );

  }
}



