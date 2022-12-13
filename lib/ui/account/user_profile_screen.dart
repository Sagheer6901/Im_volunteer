import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:i_am_volunteer/controllers/user_profile_screen_controller.dart';
import 'package:i_am_volunteer/widgets/custom_button.dart';
import 'package:i_am_volunteer/widgets/input_field.dart';

import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/custom_text.dart';

class UserProfileScreen extends StatelessWidget {
  final controller = Get.find<UserProfileScreenController>();
  final controllerAuth = Get.find<UserProfileScreenController>();

  UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: StreamBuilder(
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

                return _getBody(data);
              }).toList());
        },
      ),
      // body: _getBody(),
      onWillPop: controller.onBack,
      scaffoldKey: controller.scaffoldKey,
      screenName: 'User Profile Screen',
    );
  }

  Widget _getBody(data) {
    return Column(
      children: [
        // Container(
        //   height: 100,
        //   width: Get.width,
        //   decoration: BoxDecoration(
        //       color: AppColors.primary.withOpacity(0.07),
        //       borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35),bottomRight: Radius.circular(35))
        //   ),
        //   padding: const EdgeInsets.only(top: 30, left: 20),
        //   child: CustomText(
        //     text: 'Profile',
        //     fontSize: 30,
        //     color: AppColors.primary,
        //     weight: FontWeight.w700,
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  controller.pick(1);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    data['image'] == null
                        ? Obx(() => (controller.webImage.value!.length > 8
                            ? Container(
                                height: 65,
                                width: 65,
                                child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                    child: Image.memory(
                                        controller.webImage.value!)),
                              )
                            : CircleAvatar(
                                radius: 40,
                                backgroundImage:
                                    AssetImage(AppAssets.personImage2),
                              )))
                        : CircleAvatar(
                            radius: 35,
                            backgroundColor: AppColors.primary.withOpacity(0.4),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(35),
                                child: Image.network(data['image'],
                                    fit: BoxFit.cover)),
                          ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  if (controller.webImage.value!.length > 8) {
                    controller.uploads(1);
                  } else {
                    Get.defaultDialog(
                        content: Text("Please select photo to update"));
                  }
                },
                child: CustomText(
                  fontSize: 16,
                  color: AppColors.primary,
                  text: 'Update Photo',
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // CustomText(
              //   text: '${data['name']}',
              //   color: AppColors.primary,
              //   weight: FontWeight.w700,
              // ),
              // CustomText(
              //   text: '${data['email']}',
              //   color: AppColors.heading,
              //   weight: FontWeight.w500,
              // ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    fontSize: 18,
                    text: data['name'] == null ? "Add Name" : '${data['name']}',
                    color: AppColors.heading,
                    weight: FontWeight.w400,
                  ),
                  IconButton(
                      onPressed: () {
                        Get.defaultDialog(
                          title: "Update Name",
                          content: Column(
                            children: [
                              InputField(
                                paddingHorizontal: 15,
                                paddingVertical: 0,
                                controller: controller.nameController,
                                hint: 'AbcName',
                                suffixIcon: Icons.edit,
                                validator: (ct) {
                                  if (controller.nameController.text.length >=
                                      6) {
                                    return "name must be 6 character long";
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomButton(
                                height: 48,
                                label: 'Update',
                                onTap: () async {
                                  if (controller.nameController.text.length >=
                                      6)
                                    await FirebaseFirestore.instance
                                        .collection("users")
                                        .doc("${FirebaseAuth.instance.currentUser!.uid}")
                                        .update({
                                      "name": controller.nameController.text
                                    }).then((value) => Get.back());
                                },
                                color: AppColors.primary.withOpacity(0.07),
                                textColor: AppColors.primary,
                                isShadow: false,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        );
                      },
                      icon: Icon(Icons.edit))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    fontSize: 18,
                    text: data['email'] == null
                        ? "Add Email"
                        : '${data['email']}',
                    color: AppColors.heading,
                    weight: FontWeight.w400,
                  ),
                  // IconButton(onPressed: (){
                  //   Get.defaultDialog(
                  //     title: "Update Email",
                  //     content: Column(
                  //       children: [
                  //         InputField(
                  //           paddingHorizontal: 15,
                  //           paddingVertical: 0,
                  //           controller: controller.emailController,
                  //           hint: 'AbcEmail',
                  //           suffixIcon: Icons.edit,
                  //           validator: emailValidator
                  //         ),
                  //         const SizedBox(
                  //           height: 20,
                  //         ),
                  //         CustomButton(
                  //           height: 48,
                  //           label: 'Update',
                  //           onTap: () async{
                  //             // controller.resetEmail(controller.emailController.text.trim());
                  //             // if(controller.emailController.text.length>=6)
                  //             //   await FirebaseFirestore.instance
                  //             //       .collection("users")
                  //             //       .doc("Y3feimlhlSOu4iDotiSK9nIM5ZC2")
                  //             //       .update({"email": controller.emailController.text}).then((value) => Get.back());
                  //           },
                  //           color: AppColors.primary.withOpacity(0.07),
                  //           textColor: AppColors.primary,
                  //           isShadow: false,
                  //         ),
                  //         const SizedBox(
                  //           height: 20,
                  //         ),
                  //       ],
                  //     ),
                  //   );
                  // }, icon: Icon(Icons.edit))
                  SizedBox()
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    fontSize: 18,
                    text: data['phoneNumber'] == null
                        ? "Add Phone No (92***)"
                        : '${data['phoneNumber']}',
                    color: AppColors.heading,
                    weight: FontWeight.w400,
                  ),
                  IconButton(
                      onPressed: () {
                        Get.defaultDialog(
                          title: "Update Phone No",
                          content: Column(
                            children: [
                              InputField(
                                paddingHorizontal: 15,
                                paddingVertical: 0,
                                controller: controller.phoneNumberController,
                                hint: '923033333311',
                                suffixIcon: Icons.edit,
                                validator: (ct) {
                                  if (controller
                                          .phoneNumberController.text.length <=
                                      12) {
                                    return "enter valid number";
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomButton(
                                height: 48,
                                label: 'Update',
                                onTap: () async {
                                  if (controller
                                          .phoneNumberController.text.length <=
                                      12)
                                    await FirebaseFirestore.instance
                                        .collection("users")
                                        .doc("${FirebaseAuth.instance.currentUser!.uid}")
                                        .update({
                                      "phoneNumber":
                                          controller.phoneNumberController.text
                                    }).then((value) => Get.back());
                                },
                                color: AppColors.primary.withOpacity(0.07),
                                textColor: AppColors.primary,
                                isShadow: false,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        );
                      },
                      icon: Icon(Icons.edit))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    fontSize: 18,
                    text: data['dept'] == null ? "Add Dept" : '${data['dept']}',
                    color: AppColors.heading,
                    weight: FontWeight.w400,
                  ),
                  IconButton(
                      onPressed: () {
                        Get.defaultDialog(
                          title: "Update Dept",
                          content: Column(
                            children: [
                              InputField(
                                paddingHorizontal: 15,
                                paddingVertical: 0,
                                controller: controller.deptController,
                                hint: 'AbcDept',
                                suffixIcon: Icons.edit,
                                validator: (ct) {
                                  if (controller.deptController.text.length >=
                                      6) {
                                    return "Dept name must be 6 character long";
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              CustomButton(
                                height: 48,
                                label: 'Update',
                                onTap: () async {
                                  if (controller.deptController.text.length >=
                                      6)
                                    await FirebaseFirestore.instance
                                        .collection("users")
                                        .doc("${FirebaseAuth.instance.currentUser!.uid}")
                                        .update({
                                      "dept": controller.deptController.text
                                    }).then((value) => Get.back());
                                },
                                color: AppColors.primary.withOpacity(0.07),
                                textColor: AppColors.primary,
                                isShadow: false,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        );
                      },
                      icon: Icon(Icons.edit))
                ],
              ),

              controller.authService.user!.email!.contains("admin")
                  ? SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          fontSize: 18,
                          text: data['rollNo'] == null
                              ? "Add Roll No"
                              : '${data['rollNo']}',
                          color: AppColors.heading,
                          weight: FontWeight.w400,
                        ),
                        IconButton(
                            onPressed: () {
                              Get.defaultDialog(
                                title: "Update Roll No",
                                content: Column(
                                  children: [
                                    InputField(
                                      paddingHorizontal: 15,
                                      paddingVertical: 0,
                                      controller: controller.rollNoController,
                                      hint: 'Roll No',
                                      suffixIcon: Icons.edit,
                                      validator: (ct) {
                                        if (controller
                                                .rollNoController.text.length <=
                                            6) {
                                          return "RollNo name must be 2 character long";
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CustomButton(
                                      height: 48,
                                      label: 'Update',
                                      onTap: () async {
                                        if (controller
                                                .rollNoController.text.length >=
                                            2)
                                          await FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(
                                                  "${FirebaseAuth.instance.currentUser!.uid}")
                                              .update({
                                            "rollNo":
                                                controller.rollNoController.text
                                          }).then((value) => Get.back());
                                      },
                                      color:
                                          AppColors.primary.withOpacity(0.07),
                                      textColor: AppColors.primary,
                                      isShadow: false,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: Icon(Icons.edit))
                      ],
                    ),
              controller.authService.user!.email!.contains("admin")
                  ? SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          fontSize: 18,
                          text: data['batch'] == null
                              ? "Add Batch"
                              : '${data['batch']}',
                          color: AppColors.heading,
                          weight: FontWeight.w400,
                        ),
                        IconButton(
                            onPressed: () {
                              Get.defaultDialog(
                                title: "Update batch",
                                content: Column(
                                  children: [
                                    InputField(
                                      paddingHorizontal: 15,
                                      paddingVertical: 0,
                                      controller: controller.batchController,
                                      hint: 'batch',
                                      suffixIcon: Icons.edit,
                                      validator: (ct) {
                                        if (controller
                                                .batchController.text.length <=
                                            4) {
                                          return "Batch (20**) name must be 4 character long";
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    CustomButton(
                                      height: 48,
                                      label: 'Update',
                                      onTap: () async {
                                        if (controller
                                                .batchController.text.length >=
                                            4)
                                          await FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(
                                                  "${FirebaseAuth.instance.currentUser!.uid}")
                                              .update({
                                            "batch":
                                                controller.batchController.text
                                          }).then((value) => Get.back());
                                      },
                                      color:
                                          AppColors.primary.withOpacity(0.07),
                                      textColor: AppColors.primary,
                                      isShadow: false,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: Icon(Icons.edit))
                      ],
                    ),

              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),

        controller.authService.user!.email!.contains("admin")
            ? SizedBox()
            : Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    height: 200,
                    width: double.infinity,
                    child: data['cardImage'] == null
                        ? Obx(() => Center(
                            child: controller.webImage1.value!.length <= 8
                                ? IconButton(
                                    onPressed: () {
                                      controller.pick(2);
                                    },
                                    icon: Icon(
                                      Icons.cloud_upload_outlined,
                                      color: AppColors.primary,
                                      size: 50,
                                    ),
                                  )
                                : Container(
                                    height: 200,
                                    width: double.infinity,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                        child: Image.memory(
                                            controller.webImage1.value!)),
                                  )))
                        : Image.network(
                            data['cardImage'],
                            fit: BoxFit.fill,
                          ),
                  ),
                  data['cardImage'] == null
                      ? InkWell(
                          onTap: () {
                            if (controller.webImage1.value!.length > 8) {
                              controller.uploads(2);
                            } else {
                              Get.defaultDialog(
                                  content:
                                      Text("Please select photo to update"));
                            }
                          },
                          child: CustomText(
                            fontSize: 18,
                            color: AppColors.primary,
                            text: 'Update Card',
                          ),
                        )
                      : SizedBox()
                ],
              ),
      ],
    );
  }
}
