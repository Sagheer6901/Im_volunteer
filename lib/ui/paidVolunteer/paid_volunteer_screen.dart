
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/paid_volunteer_screen_controller.dart';
import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/custom_text.dart';

class PaidVolunteerScreen extends StatelessWidget{
  final controller = Get.find<PaidVolunteerScreenController>();
  PaidVolunteerScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: _getBody(),
      onWillPop: controller.onWillPop,
      scaffoldKey: controller.scaffoldKey,
      screenName: 'Paid Volunteer Screen',);
  }
  Widget _getBody(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 60),
      child: Column(
        children: [
          // Center(
          //   child: StreamBuilder<QuerySnapshot>(
          //       stream: FirebaseFirestore.instance
          //           .collection('paidVolunteers')
          //           .snapshots(),
          //       builder: (BuildContext context,
          //           AsyncSnapshot<QuerySnapshot> snapshot) {
          //         if (snapshot.hasError) {
          //           return Text('Something went wrong');
          //         }
          //
          //         if (snapshot.connectionState == ConnectionState.waiting) {
          //           return Text("Loading");
          //         }
          //         if (snapshot.data!.size == 0) {
          //           return Center(child: Text("There is no Lead"));
          //         }
          //         return SizedBox(
          //           height: 120,
          //           child: ListView(
          //               shrinkWrap: true,
          //               scrollDirection: Axis.horizontal,
          //               // itemCount: snapshot.data!.docs.length,
          //               // itemBuilder: ((context, index) {
          //               children: snapshot.data!.docs
          //                   .map((DocumentSnapshot document) {
          //                 Map<String, dynamic> data =
          //                 document.data()! as Map<String, dynamic>;
          //                 return statusWidget(
          //                     image: data['image'], text: '${data['name']}');
          //               }).toList()),
          //         );
          //         //     return Text('nodata');
          //         //   }),
          //         // );
          //       }),
          // ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('paidVolunteers')
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
                  // height: 120,
                  child: ListView(
                      shrinkWrap: true,
                      // physics: ,
                      // scrollDirection: Axis.vertical,
                      // itemCount: snapshot.data!.docs.length,
                      // itemBuilder: ((context, index) {
                      children: snapshot.data!.docs
                          .map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                        return  informationCard(profileImage: data['image'].toString(), name: data['name'].toString(), profession: data['profession'].toString(), experience: '${data['experience']} Years', contactNum: '+${data['contactNo']}',price: data['price'].toString(), fbUrl: data['fbUrl'] , instaUrl: data['instaUrl'] );
                      }).toList()),
                );
                //     return Text('nodata');
                //   }),
                // );
              }),

          // informationCard(profileImage: AppAssets.personImage2, name: 'Dr.cde', profession: 'Musician', experience: '3 Years', contactNum: '+92 1234567890',price: '2000'),
          // informationCard(profileImage: AppAssets.personImage3, name: 'Dr.abd', profession: 'Software Engineer', experience: '4 Years', contactNum: '+92 1234566590',price: '3000'),
          // informationCard(profileImage: AppAssets.personImage1, name: 'Dr.akl', profession: 'Singer', experience: '1 Years', contactNum: '+92 321566590',price: '40000'),
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

  Widget informationCard({required String profileImage, required String name,required String profession,required String experience,required String contactNum,required String price, instaUrl, fbUrl}){
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: AppColors.primary.withOpacity(0.07),blurRadius: 3),
            ]
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            profileImageWidget(image: profileImage),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  textAlign: TextAlign.center,
                  text: name,color: AppColors.primary,weight: FontWeight.w700,fontSize: 20),
                const SizedBox(width: 10,),
                IconButton(
                    onPressed: (){
                      _launchUrl(fbUrl);
                    },
                    icon: Icon(Icons.facebook,size: 20,color: AppColors.heading.withOpacity(0.3),)),
                SizedBox(width: 10,),

                InkWell(
                    onTap: (){
                      _launchUrl(instaUrl);
                    },
                    child: Image.asset(AppAssets.instaIcon,height: 20,color: AppColors.heading.withOpacity(0.3),))
              ],
            ),
            profileInformation(profession: profession, experience: experience, contactNum: contactNum),
            CustomButton(
              fontWeight: FontWeight.w500,
              textSize: 16,
              width: Get.width,
              height: 40,
              label: 'One Event Price is: $price',
              onTap: ()=>null,color: AppColors.primary.withOpacity(0.07),
              textColor: AppColors.heading,
              isShadow: false,),
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
  Future<void> _launchUrl(url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }
  Widget profileInformation(
      {required String profession, required String experience, required String contactNum}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customText(name: 'Profession'),
              const SizedBox(height: 10,),
              customText(name: 'Contact No:'),
              const SizedBox(height: 10,),
              customText(name: 'Experience'),
            ],
          ),
          Container(color: AppColors.primary,width: 3,height: 70),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customText(value: profession),
              const SizedBox(height: 10,),
              customText(value: contactNum),
              const SizedBox(height: 10,),
              customText(value: experience),
            ],
          ),
        ],
      ),
    );

  }


  Widget customText({String value='', String name=''}){
    return  CustomText(text: value!=''?value:name,color: value!=''?AppColors.primary:AppColors.heading,fontSize: 15,weight: FontWeight.w600,);
  }

}