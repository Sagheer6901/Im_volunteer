import 'package:get/get.dart';
import 'package:i_am_volunteer/models/event_model.dart';
import 'package:i_am_volunteer/models/volunteer_model.dart';
import 'package:i_am_volunteer/ui/account/user_profile_screen.dart';
import 'package:i_am_volunteer/ui/account/volunteer_profile_screen.dart';
import 'package:i_am_volunteer/ui/admin/manageVolunteers/manage_volunteers.dart';
import 'package:i_am_volunteer/ui/calender/calender_screen.dart';
import 'package:i_am_volunteer/ui/chat/chat_screen.dart';
import 'package:i_am_volunteer/ui/event/add_event.dart';
import 'package:i_am_volunteer/ui/home/event_details.dart';
import 'package:i_am_volunteer/ui/home/home_screen.dart';
import 'package:i_am_volunteer/ui/home/volunteer_registration_screen.dart';
import 'package:i_am_volunteer/ui/notification/notification_screen.dart';
import 'package:i_am_volunteer/ui/paidVolunteer/paid_volunteer_screen.dart';
import 'package:i_am_volunteer/ui/volunteer/volunteer_detail.dart';

import '../bindings/chat_bindings.dart';
import '../bindings/event_binding.dart';
import '../bindings/screen_binding.dart';
import '../ui/auth/auth_dashboard.dart';
import '../ui/auth/login.dart';
import '../ui/auth/register.dart';
import '../ui/auth/splash.dart';
import '../ui/chat/user_list.dart';

class AppRoutes {
  static String splash = '/';
  static String login = '/login';
  static String register = '/register';
  static String authDashboard = '/auth';
  static String homeScreen = '/home_screen';
  static String calenderScreen = '/calender_screen';
  static String paidVolunteerScreen = '/paid_volunteer';
  static String notificationScreen = '/notification_screen';
  static String accountScreen = '/account_screen';
  static String volunteerRegistrationScreen = '/volunteer_registration_screen';
  static String userProfileScreen = '/user_profile_screen';
  static String volunteerProfileScreen = '/volunteer_profile_screen';
  static String chatScreen = '/chat_screen';
  static String userList = '/user_list';
  static String kBottomNavigationController = "/BOTTOM_NAVBAR_Controller";
  static String eventDetails = '/event_details';
  static String volunteerDetails = "/volunteer_details";
  static String manageVolunteers = "/manageVolunteers";
  static String addEvent = '/addEvent';

  static List<GetPage> pages = [
    GetPage(
      name: splash,
      page: () => Splash(),
      binding: ScreenBinding(),
    ),
    GetPage(
      name: login,
      page: () => Login(),
      binding: ScreenBinding(),
    ),
    GetPage(
      name: register,
      page: () => Register(),
      binding: ScreenBinding(),
    ),
    GetPage(
      name: authDashboard,
      page: () => AuthDashboard(),
      binding: ScreenBinding(),
    ),
    GetPage(
      name: homeScreen,
      page: () => HomeScreen(),
      bindings: [
        ChatBindings(),

        ScreenBinding(),
      ],
    ),
    GetPage(
      name: eventDetails,
      page: () {
        final args = Get.arguments;
        final event = args['event'] as EventModel;
        return EventDetails(
          event: event,
        );
      },
      binding: EventBinding(),
    ),
    GetPage(
      name: volunteerDetails,
      page: () {
        final args = Get.arguments;
        final volunteer = args['volunteer'] as VolunteerModel;
        return VolunteerDetails(
          volunteer: volunteer,
        );
      },
      binding: EventBinding(),
    ),
    GetPage(
      name: calenderScreen,
      page: () => CalenderScreen(),
      binding: ScreenBinding(),
    ),
    GetPage(
      name: notificationScreen,
      page: () => NotificationScreen(),
      binding: ScreenBinding(),
    ),
    GetPage(
      name: paidVolunteerScreen,
      page: () => PaidVolunteerScreen(),
      binding: ScreenBinding(),
    ),
    GetPage(
      name: accountScreen,
      page: () => UserProfileScreen(),
      binding: ScreenBinding(),
    ),
    GetPage(
      name: volunteerRegistrationScreen,
      page: () => VolunteerRegistrationScreen(),
      binding: ScreenBinding(),
    ),
  GetPage(
  name: manageVolunteers,
  page: () => ManageVolunteers(),
    binding: ScreenBinding(),

  ),
    GetPage(name: addEvent, page: ()=>AddEvent(),      binding: ScreenBinding(),
    ),
  GetPage(
      name: userProfileScreen,
      page: () => UserProfileScreen(),
      binding: ScreenBinding(),
    ),
    GetPage(
      name: volunteerProfileScreen,
      page: () => VolunteerProfileScreen(),
      binding: ScreenBinding(),
    ),
    GetPage(
      name: chatScreen,
      page: () => const ChatScreen(),
    ),
    GetPage(
      name: userList,
      page: () => UserList(),
    ),
  ];
}
