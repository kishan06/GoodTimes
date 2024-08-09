import 'package:flutter/material.dart';
import 'package:good_times/views/screens/about-us/about_us.dart';
import 'package:good_times/views/screens/auth/forgot-password/create_new_password.dart';
import 'package:good_times/views/screens/auth/forgot-password/forgot_password.dart';
import 'package:good_times/views/screens/auth/forgot-password/otp_screen.dart';
import 'package:good_times/views/screens/contact-us/contact_us.dart';
import 'package:good_times/views/screens/event/event_preview.dart';
import 'package:good_times/views/screens/event_manager/create-event/create_event.dart';
import 'package:good_times/views/screens/event_manager/create-event/event_preivew.dart';
import 'package:good_times/views/screens/event_manager/create-event/event_title.dart';
import 'package:good_times/views/screens/event_manager/create-event/select_date.dart';
import 'package:good_times/views/screens/event_manager/refer_friend.dart';
import 'package:good_times/views/screens/event_manager/venue/venue_preview.dart';
import 'package:good_times/views/screens/faq/faq.dart';
import 'package:good_times/views/screens/favorites/favorites.dart';
import 'package:good_times/views/screens/home/main_home.dart';
import 'package:good_times/views/screens/notification/notification.dart';
import 'package:good_times/views/screens/profile/profile.dart';
import 'package:good_times/views/screens/refferal/refer.dart';
import 'package:good_times/views/screens/settings/feedback.dart';
import 'package:good_times/views/screens/settings/settings.dart';
import 'package:good_times/views/screens/termCondition-privacyPolicy/privacy_and_polcy.dart';
import 'package:good_times/views/screens/termCondition-privacyPolicy/term_condition.dart';
import 'package:good_times/views/widgets/common/change_password_modal.dart';

import '../../views/screens/auth/login/login.dart';
import '../../views/screens/auth/registration/email_verify.dart';
import '../../views/screens/auth/registration/otp_verify.dart';
import '../../views/screens/auth/registration/welcome_screen.dart';
import '../../views/screens/auth/registration/select_user_type.dart';
import '../../views/screens/auth/registration/referral.dart';
import '../../views/screens/auth/registration/complete_profile.dart';
import '../../views/screens/auth/registration/select_preference.dart';
import '../../views/screens/event_manager/venue/create_venue.dart';
import '../../views/screens/event_manager/venue/custome_address_venue.dart';
import '../../views/screens/event_manager/venue/venue.dart';
import '../../views/screens/intro_slider/intro_slider.dart';
import '../../views/screens/profile/add_bank_details.dart';
import '../../views/screens/profile/edit_preferences.dart';
import '../../views/screens/profile/edit_profile.dart';
import '../../views/screens/settings/notification_setting.dart';
import '../../views/screens/subscription/subscription_plan.dart';
import '../../views/screens/event_manager/syncfusion_calendar.dart';

final Map<String, WidgetBuilder> routes = {
  IntroSlider.routeName: (context) => const IntroSlider(),
  WelcomeScreen.routeName: (context) =>  WelcomeScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  SelectUserType.routeName: (context) => const SelectUserType(),
  EmialVerify.routeName: (context) => const EmialVerify(),
  PreVerifyOTP.routeName: (context) => const PreVerifyOTP(),
  CompleteDetails.routeName: (context) => const CompleteDetails(),
  ReferralScreen.routeName: (context) => const ReferralScreen(),
  SelectPrefrence.routeName: (context) => const SelectPrefrence(),
  SubScription.routeName: (context) => const SubScription(),
  HomeMain.routeName: (context) => const HomeMain(),
  // EventFilter.routeName: (context) => const EventFilter(),
  EventPreview.routeName: (context) => const EventPreview(),
  Favorites.routeName: (context) => const Favorites(),
  Notifications.routeName: (context) => const Notifications(),
  Settings.routeName: (context) => const Settings(),
  Reffer.routeName: (context) => const Reffer(),
  ContactUS.routeName: (context) => const ContactUS(),
  FAQs.routeName: (context) => const FAQs(),
  PrivacyAndPolicy.routeName: (context) => const PrivacyAndPolicy(),
  TermAndConditions.routeName: (context) => const TermAndConditions(),
  AboutUs.routeName: (context) => const AboutUs(),
  ForgotPassword.routeName: (context) => const ForgotPassword(),
  VerifyOTP.routeName: (context) => const VerifyOTP(),
  CreatePassword.routeName: (context) => const CreatePassword(),




  // event manager routes
  ReferFriend.routeName: (context) => const ReferFriend(),
  CreateVenue.routeName: (context) => const CreateVenue(),
  VenuePreview.routeName: (context) => const VenuePreview(),
  Venue.routeName: (context) => const Venue(),
  EventTitile.routeName: (context) => const EventTitile(),
  // EventDescription.routeName: (context) => const EventDescription(),
  CreateEvent.routeName: (context) => const CreateEvent(),
  SelectEventDate.routeName: (context) => const SelectEventDate(),
  CreatedEventPreview.routeName: (context) => const CreatedEventPreview(),
  NotificationSetting.routeName: (context) => const NotificationSetting(),
  FeedBack.routeName: (context) => const FeedBack(),
  SyncFusioCalendar.routeName: (context) => const SyncFusioCalendar(),



  // Profile routes
  Profile.routeName: (context) => const Profile(),
  EditProfile.routeName: (context) => const EditProfile(),
  // EditedEventPreview.routeName: (context) => const EditedEventPreview(),
  VenueCustomAddress.routeName: (context) => const VenueCustomAddress(),
  EditPrefrence.routeName: (context) => const EditPrefrence(),
  AddBankDetails.routeName: (context) => const AddBankDetails(),
  AccountTransfer.routeName: (context) => const AccountTransfer(),
};