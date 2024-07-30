// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:logger/logger.dart';

var logger = Logger();

class Endpoints {
  // base point urls
  //!local urls of bobby server
  /* static const domain = "http://192.168.50.92:8000/";
  static const _base = "http://192.168.50.92:8000/api/";
  static const chatDomain = "ws://chat.goodtimes.betadelivery.com/ws/chat/"; */

  // base point urls
  //!stagging urls our server
  // static const domain = "https://goodtimes.betadelivery.com";
  // static const _base = "https://goodtimes.betadelivery.com/api/";
  // static const chatDomain= "ws://chat.goodtimes.betadelivery.com/ws/chat/";

  //!stagging urls of client
  static const domain = "https://staging.goodtimesltd.co.uk";
  static const _base = "https://staging.goodtimesltd.co.uk/api/";
  static const chatDomain= "ws://chat.staging.goodtimesltd.co.uk/ws/chat/";

  //!production urls of client
 /*  static const domain = "https://admin.goodtimesltd.co.uk";
  static const _base = "https://admin.goodtimesltd.co.uk/api/";
  static const chatDomain = "ws://chat.admin.goodtimesltd.co.uk/ws/chat/";  */

  // websocket url
  //Production on clinet server base websocketurl

  // authentication api urls
  static const registrations = _base + 'account/signup/phone/'; //complete
  static const preRegisterOtpVerify = _base + 'account/verify-otp/'; //complete
  static const completeProfile = _base + 'account/signup/details/'; //complete
  static const requestOtp = _base + 'account/request-otp/'; //complete
  static const logIn = _base + 'account/login/'; //complete
  static const resetPassword = _base + 'account/signup/password/'; //complete

  // get current location api
  static const sendCurrentLocation = _base + 'events/add-location/'; //complete

  // google login token urls
  static const googleLogin = _base + 'account/google-login/'; //complete

  // cms urls
  static const faq = _base + "cms/faq-mobile/"; //complete
  static const orgnisataions = _base + "cms/organization-mobile/"; //complete

  // profile urls
  static const profile = _base + "account/profile/view/"; //complete
  static const editProfile = _base + "account/profile/edit/"; //complete

  // get venue urls
  static const getVenue = _base + "events/get-venue/"; //complete
  static const deleteVenue = _base + "events/venue/delete/"; //complete

  //venue apis
  static const addVenu = _base + "events/add-venue/";

  // event categories api urls
  static const getEventCategories = _base + "events/event-categories/";
  static const getAgeGroup = _base + "events/age-groups";
  static const postEventCategories =
      _base + "events/add-principal-preferences/";
  static const getPreferences = _base + "events/principal-preferences/";

  // stripe payment url
  static const stripePaymentUrl = _base + "subscriptions/buy-subscription/";
  static const addBankDetails =
      _base + "wallet/add-bank-details/"; //verfiy bank accounts
  static const checkBankDetails =
      _base + "wallet/check-bank-accounts/"; //check bank accounts

  //event data api urls
  static const createEvent = _base + "events/add-event/";
  static const getEventFilter = _base + "events/get-events/";
  static const getAdvanceEventFilter = _base + "events/events/";
  static const getEventFilterTags = _base + "events/tags/";
  static const getEventFilterWithin10km = _base +
      "events/events/filter-by-location/"; //events filter by within 10 km
  static const getEventFilterDateRage =
      _base + "events/events/date-range/"; //events filter by date range
  static const getEventDetailsWithId = _base + "events/event/";
  static const eventIntrestedAndGoing = _base + "events/event-status/";
  static const eventLike = _base + "events/toggle-favorite/";
  static const eventLikesList = _base + "events/favorites/events/";
  static const eventRatings = _base + "events/event-reviews/";

  // edit events
  static const editevents = _base + "events/edit-event/";

  //get wallets api
  static const getWallet = _base + "wallet/get-wallet/";
  static const getWalletTransactions = _base + "wallet/get-transaction/";

  //Event manager apis
  static const eventManager = _base + "events/my-events/";

  //contact us apis
  static const contactUs = _base + "communications/contact-us/";
  static const feedBack = _base + "communications/feedback/";

  // chat apis
  static const chatHistory = _base + "chat/chat_messages/";
  static const createChatEvent = _base + "chat/chat_group/";

  // check preference
  static const checkPreference = _base + "events/check_principal_preference/";

  // referral code
  static const referralCode = _base + "referrals/referral-code/";
  static const referralTokenManullySell =
      _base + "referrals/redeem-selected-rewards/";

  // send player id
  static const sendPlayerId = _base + "account/player-id/add/";

  // get notication category
  static const notificationCategory =
      _base + "notifications/user-notifications/";
  static const notificationCategoryEnableDisable =
      _base + "notifications/toggle-notification-setting/";
  static const notificationList = _base + "notifications/in-app-notifications/";

  static const walletRequests = _base + "wallet/create-withdrawal-request/";
  static const withdrawalTransactions =
      _base + "wallet/view-withdrawal-request/";
  static const refferalRecords = _base + "referrals/referral-record-rewards/";
  static const reffralRedeem = _base + "referrals/redeem-reward/";
  static const accoutDelete = _base + "account/delete-account/";
  static const appVersion = _base + "account/version-check/";
  static const deletePlayerId = _base + "notifications/delete-player-id/";
  static const createGroup = _base + "chat/chat_group/";

  //report count
  static const eventReportCount = _base + "events/event/";
  static const eventShareReportCount = _base + "events/event/";

  // account transfer urls
  static const accountTransfer = _base + "account/transfer-check/";
  static const accountTransferDone = _base + "account/transfer-check/";
  static const eventCategoryDrawar = _base + "events/preferences/";
}
