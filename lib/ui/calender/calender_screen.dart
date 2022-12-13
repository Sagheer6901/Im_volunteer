
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_am_volunteer/controllers/calender_screen_controller.dart';
import 'package:i_am_volunteer/ui/calender/day_events.dart';
import 'package:i_am_volunteer/utils/app_colors.dart';
import 'package:i_am_volunteer/widgets/custom_text.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../widgets/custom_scaffold.dart';


class CalenderScreen extends StatelessWidget{
  final controller = Get.find<CalenderScreenController>();

  CalenderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: _getBody(controller.toHighlight),
      onWillPop: controller.onWillPop,
      scaffoldKey: controller.scaffoldKey,
      screenName: 'Calender Screen',);
  }
  Widget _getBody(List<DateTime> toHighlight){
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            Container(
              height: 60,
              decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(child: CustomText(text: 'Event Calender',fontSize: 20,color: AppColors.white,weight: FontWeight.w800,),),
            ),
            Obx(
              ()=> TableCalendar(
                firstDay: controller.kFirstDay,
                lastDay: controller.kLastDay,
                focusedDay: controller.focusedDay.value,
                calendarFormat: controller.calendarFormat.value,
                headerStyle: HeaderStyle(
                  formatButtonDecoration: BoxDecoration(color: AppColors.white,borderRadius: BorderRadius.circular(14),border: Border.all(color: AppColors.primary))
                ),
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(color: AppColors.primary,shape: BoxShape.circle)
                ),
                selectedDayPredicate: (day) {
                  return isSameDay(controller.selectedDay.value, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(controller.selectedDay.value, selectedDay)) {
                      controller.selectedDay.value = selectedDay;
                      controller.focusedDay.value = focusedDay;
                  }
                },

                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    for (DateTime d in toHighlight) {

                      int selectedDT=d.millisecondsSinceEpoch;
                      if (day.day == d.day &&
                          day.month == d.month &&
                          day.year == d.year) {
                        return InkWell(
                          onTap: (){
                            // var event = FirebaseFirestore.instance
                            //     .collection('users')
                            //     .where("role", isEqualTo: "admin").snapshots();
                            // print(event.first);
                            Get.to(()=>DayEvents(),arguments: selectedDT);
                            // Get.bottomSheet(Text("hello"));/
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.lightGreen,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '${day.day}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      }
                    }
                    return null;
                  },
                ),
                /*onFormatChanged: (format) {
                  if (controller.calendarFormat.value != format) {
                      controller.calendarFormat.value = format;
                  }
                },*/
                onPageChanged: (focusedDay) {
                  controller.focusedDay.value = focusedDay;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


