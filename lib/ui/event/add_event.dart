import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:i_am_volunteer/controllers/add_event_controller.dart';
import 'package:i_am_volunteer/utils/app_colors.dart';
import 'package:i_am_volunteer/widgets/custom_button.dart';
import 'package:i_am_volunteer/widgets/custom_scaffold.dart';
import 'package:i_am_volunteer/widgets/input_field.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddEvent extends StatelessWidget {
  final controller = Get.put(AddEventController());
  AddEvent({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      // bottomSheet: Text("dfsdfsdf"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              InputField(
                controller: controller.titleController,
                hint: 'title',
                suffixIcon: Icons.edit,
                validator: (ct) {
                  if (controller.titleController.text.length <= 6) {
                    return "title must be 6 character long";
                  }
                },
              ),
              InputField(
                controller: controller.descriptionController,
                hint: 'description',
                suffixIcon: Icons.edit,
                validator: (ct) {
                  if (controller.descriptionController.text.length <= 10) {
                    return "name must be 10 character long";
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text("Event Date:", textScaleFactor: 1),
                        SizedBox(
                          width: 5,
                        ),
                        Obx(
                          () => Text(
                              '${controller.eventDate.value.day} / ${controller.eventDate.value.month} / ${controller.eventDate.value.year}'),
                        ),
                        IconButton(
                          onPressed: controller.eventDatePicker,
                          icon: Icon(Icons.calendar_today_sharp),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text("Last Date for Registration:", textScaleFactor: 1),
                        SizedBox(
                          width: 5,
                        ),
                        Obx(
                          () => Text(
                              '${controller.lastDateForReg.value.day} / ${controller.lastDateForReg.value.month} / ${controller.lastDateForReg.value.year}'),
                        ),
                        IconButton(
                          onPressed: controller.lastDatePicker,
                          icon: Icon(Icons.calendar_today_sharp),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Obx(
                () => Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    height: 200,
                    width: double.infinity,
                    child: controller.len.value == 1
                        ? IconButton(
                            onPressed: () {
                              controller.pick();
                            },
                            icon: Icon(
                              Icons.cloud_upload_outlined,
                              color: AppColors.primary,
                              size: 50,
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              controller.pick();
                            },
                            child: Center(
                              child: Image.memory(controller.webImage.value!),
                            //     child: Text(
                            //   "Image Selected",
                            //   style: TextStyle(
                            //       color: AppColors.primary,
                            //       fontWeight: FontWeight.w800,
                            //       fontSize: 18),
                            // )
                            )
                    )),
              ),
              Container(
                  height: 40,
                  margin: EdgeInsets.only(bottom: 50, top: 10),
                  child: CustomButton(
                      label: "Post Event",
                      color: AppColors.secondary,
                      textColor: AppColors.primary,
                      onTap: () {
                        if (controller.len > 1 &&
                            controller.titleController.text.length >= 6 &&
                            controller.descriptionController.text.length >= 10 &&
                            controller.eventDate.value != DateTime.now() &&
                            controller.lastDateForReg.value != DateTime.now()) {
                          controller.uploads();

                          controller.onBack();
                        } else {
                          print("hello");
                          Get.snackbar(
                              "Incomplete Info", "Please complete all fields",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppColors.secondary,
                              colorText: AppColors.primary);
                        }
                      }))
            ],
          ),
        ),
      ),
      // body: _getBody(),
      onWillPop: controller.onBack,
      scaffoldKey: controller.scaffoldKey,
      screenName: 'AddEvent Screen',
    );
  }
}
