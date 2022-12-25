import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_am_volunteer/controllers/custom_navigation_drawer_controller.dart';
import 'package:i_am_volunteer/services/locator.dart';
import 'package:i_am_volunteer/utils/app_assets.dart';
import 'package:i_am_volunteer/utils/app_colors.dart';
import 'package:i_am_volunteer/widgets/custom_text.dart';

import '../services/auth_service.dart';

class CustomNavigationDrawer extends StatelessWidget {
  final controller = Get.find<CustomNavigationDrawerController>();
  // final authService = locator.get<AuthService>();

  CustomNavigationDrawer({super.key});
  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: Get.width / 1.5,
      child: Drawer(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
            return ListView(
                shrinkWrap: true,
                // itemCount: snapshot.data!.docs.length,
                // itemBuilder: ((context, index) {
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;

                  return         Column(
                    children: [


                      Container(
                        color: AppColors.primary.withOpacity(0.07),
                        height: 180,
                        child: SafeArea(
                          child: Center(
                            child: Column(
                              children: [

                                data['image']==null?
                                CircleAvatar(
                                  radius: 40,
                                  backgroundImage: AssetImage(AppAssets.personImage2),
                                ):
                                CircleAvatar(
                                  radius: 35,
                                  backgroundColor: AppColors.primary.withOpacity(0.4),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(35),
                                      child: Image.network(data['image'].toString(), fit: BoxFit.cover)
                                  ),
                                ),
                                // const CircleAvatar(
                                //   radius: 40,
                                //   backgroundImage: AssetImage(
                                //     AppAssets.personImage2,
                                //   ),
                                // ),
                                const SizedBox(
                                  height: 5,
                                ),
                                CustomText(
                                  textAlign: TextAlign.center,
                                  text: data['name'],
                                  color: AppColors.primary,
                                  weight: FontWeight.w700,
                                ),
                                Expanded(
                                  child: CustomText(
                                    textAlign: TextAlign.center,
                                    text: data['email'],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // drawerWidget(
                      //   Icons.person,
                      //   'Admin Login/Profile',
                      // ),
                      // StreamBuilder<QuerySnapshot>(
                      //   stream: FirebaseFirestore.instance
                      //       .collection("Users")
                      //       .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email) // or uid
                      //       .snapshots(),
                      //   builder: (context, snapshot) {
                      //
                      //     if (snapshot.hasData) {
                      //
                      //       if (snapshot.data!.docs[0]["role"] =='admin' ) {
                      //         Column(
                      //           children: [
                      //             drawerWidget(
                      //               Icons.mail_outline,
                      //               'Chat Box',
                      //             ),
                      //
                      //             drawerWidget(
                      //               Icons.logout,
                      //               'Log Out',
                      //             ),
                      //           ],
                      //         );
                      //       }
                      //       else
                      //     }
                      //     else {
                      //       return Center(
                      //         child: CircularProgressIndicator(),
                      //       );
                      //     }
                      //     return Center(child: CircularProgressIndicator());
                      //   },
                      // )
                      data['email'].contains("admin")?
                      Column(
                        children: [
                          drawerWidget(
                            Icons.group,
                            'Manage Volunteer',
                          ),
                          drawerWidget(
                            Icons.mail_outline,
                            'Chat Box',
                          ),
                          drawerWidget(
                            Icons.logout,
                            'Log Out',
                          ),
                        ],
                      ):Column(
                        children: [
                          drawerWidget(
                            Icons.mail_outline,
                            'Manage Events',
                          ),
                          drawerWidget(
                            Icons.mail_outline,
                            'Chat Box',
                          ),

                          drawerWidget(
                            Icons.logout,
                            'Log Out',
                          ),
                        ],
                      )
                    ],
                  );
                }).toList());
          },
        ),

        // Column(
        //   children: [
        //
        //
        //     Container(
        //       color: AppColors.primary.withOpacity(0.07),
        //       height: 180,
        //       child: SafeArea(
        //         child: Center(
        //           child: Column(
        //             children: [
        //
        //           authService.user!.image==null?
        //               CircleAvatar(
        //                 radius: 40,
        //                 backgroundImage: AssetImage(AppAssets.personImage2),
        //               ):
        //               CircleAvatar(
        //                 radius: 35,
        //                 backgroundColor: AppColors.primary.withOpacity(0.4),
        //                 child: ClipRRect(
        //                     borderRadius: BorderRadius.circular(35),
        //                     child: Image.network(authService.user!.image.toString(), fit: BoxFit.cover)
        //                 ),
        //               ),
        //               // const CircleAvatar(
        //               //   radius: 40,
        //               //   backgroundImage: AssetImage(
        //               //     AppAssets.personImage2,
        //               //   ),
        //               // ),
        //               const SizedBox(
        //                 height: 5,
        //               ),
        //               CustomText(
        //                 textAlign: TextAlign.center,
        //                 text: controller.authService.user!.name!,
        //                 color: AppColors.primary,
        //                 weight: FontWeight.w700,
        //               ),
        //               Expanded(
        //                 child: CustomText(
        //                   textAlign: TextAlign.center,
        //                   text: controller.authService.user!.email!,
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //     const SizedBox(
        //       height: 10,
        //     ),
        //     // drawerWidget(
        //     //   Icons.person,
        //     //   'Admin Login/Profile',
        //     // ),
        //     // StreamBuilder<QuerySnapshot>(
        //     //   stream: FirebaseFirestore.instance
        //     //       .collection("Users")
        //     //       .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email) // or uid
        //     //       .snapshots(),
        //     //   builder: (context, snapshot) {
        //     //
        //     //     if (snapshot.hasData) {
        //     //
        //     //       if (snapshot.data!.docs[0]["role"] =='admin' ) {
        //     //         Column(
        //     //           children: [
        //     //             drawerWidget(
        //     //               Icons.mail_outline,
        //     //               'Chat Box',
        //     //             ),
        //     //
        //     //             drawerWidget(
        //     //               Icons.logout,
        //     //               'Log Out',
        //     //             ),
        //     //           ],
        //     //         );
        //     //       }
        //     //       else
        //     //     }
        //     //     else {
        //     //       return Center(
        //     //         child: CircularProgressIndicator(),
        //     //       );
        //     //     }
        //     //     return Center(child: CircularProgressIndicator());
        //     //   },
        //     // )
        //     controller.authService.user!.email!.contains("admin")?
        //     Column(
        //       children: [
        //         drawerWidget(
        //           Icons.group,
        //           'Manage Volunteer',
        //         ),
        //         drawerWidget(
        //           Icons.mail_outline,
        //           'Chat Box',
        //         ),
        //         drawerWidget(
        //           Icons.logout,
        //           'Log Out',
        //         ),
        //       ],
        //     ):Column(
        //       children: [
        //         drawerWidget(
        //           Icons.mail_outline,
        //           'Manage Events',
        //         ),
        //         drawerWidget(
        //           Icons.mail_outline,
        //           'Chat Box',
        //         ),
        //
        //         drawerWidget(
        //           Icons.logout,
        //           'Log Out',
        //         ),
        //       ],
        //     )
        //   ],
        // ),
      ),
    );
  }

  Widget drawerWidget(IconData icon, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: GestureDetector(
        onTap: () {
          controller.onDrawerItemTap(screenName: name);
        },
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppColors.primary),
                const SizedBox(
                  width: 3,
                ),
                CustomText(text: name),
              ],
            ),
            const SizedBox(
              height: 3,
            ),
            Divider(
              color: AppColors.primary.withOpacity(0.07),
              thickness: 2,
            )
          ],
        ),
      ),
    );
  }
}
