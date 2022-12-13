import 'package:get/get.dart';
import 'package:i_am_volunteer/ui/event/add_event.dart';

import '../controllers/event_controller.dart';
import '../ui/admin/manageVolunteers/manage_volunteers.dart';

class EventBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => EventController(),
    );
    Get.lazyPut(() => ManageVolunteers());
    Get.lazyPut(() => AddEvent());
  }
}
