import 'package:flutter/material.dart';
import 'size_config.dart';

const kPrimaryColor = Color(0xffD1AA58);
const kPrimaryColorLight = Color(0xffF0D49D);
const kPrimaryColorlight = Color(0xffF1D6A0);
const kTextWhite = Color(0xffffffff);
const kTextBlack = Color(0xFF000000);
const kTextgrey = Color(0xFF999999);
const kTextgreyLight = Color(0xFFEDEDED);
const kTextSuccess = Color(0xFF22BB33);
const kTextError = Color(0xFFF53B39);
 const kTextgreyDark = Color(0xff434343);


const String eventUser = "Event Visitor";
const String eventManager = "Event Manager";

const headingStyle = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.w600,
  fontFamily: 'Poppins',
  color: kTextWhite,
  height: 1.5,
);
const appbarheadingStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
  fontFamily: 'Poppins',
  color: kTextWhite,
  height: 1.5,
);

const labelStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w400,
  fontFamily: 'Poppins',
  color: kTextWhite,
  height: 1.5,
);
const paragraphStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  fontFamily: 'Poppins',
  color: kTextWhite,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

const double scaffoldPadding = 15.0;

// Form Error
final RegExp emailValidatorRegExp = RegExp(r"^[a-zA-Z0-9_.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Enter your email";
const String kInvalidEmailError = "Enter valid email";
const String kPassNullError = "Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords doesn't match";
const String kNamefNullError = "Enter your first name";
const String kNamelNullError = " Enter your last name";
const String kPhoneNumberNullError = "Enter your phone number";
const String kPhoneNumberValidateError = "Length between 10-12 digits";
final RegExp aadhaarRegex = RegExp(r"^\d{4}\s\d{4}\s\d{4}$");
final RegExp denyEmojis = RegExp(r'[\p{Emoticons}\p{Extended_Pictographic}]+');
final RegExp acceptTxtNNumb = RegExp(r'[a-zA-Z0-9\s]');
final RegExp textNmbSpclCha = RegExp(r'^[a-zA-Z0-9!@#\$%^&*(),.?":{}|<>_-]+$');
final RegExp phoneValidation = RegExp(r'^[0-9]+$');
final RegExp textValidation = RegExp(r'^[a-zA-Z]+$');



final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: const BorderSide(color: kTextBlack),
  );
}

MaterialStateProperty<Color?> kPrimaryColorMaterial = MaterialStateProperty.all<Color?>(
  kPrimaryColor,
);

MaterialColor primarySwatch = const MaterialColor(
  0xffD1AA58,
  <int, Color>{
    50: Color(0xfffff8e1),
    100: Color(0xffffecb3),
    200: Color(0xffffe082),
    300: Color(0xffffd54f),
    400: Color(0xffffca28),
    500: Color(0xffD1AA58), // Your primary color
    600: Color(0xffffb300),
    700: Color(0xffffa000),
    800: Color(0xffff8f00),
    900: Color(0xffff6f00),
  },
);

  List<String> sortingtext = [
    'Within 10km',
    'Arts & Entertainment',
    'Business & Economic',
    'Health & Wellness',
    'Leisure & Hobbies',
    'Cultural & Social',
    'Education & Technology',
    'Outdoor Activities',
    'Recreation & Sports',
    'Family',
    'Shopping Sale',
    'Tags',
  ];

const String connectionTime = "It appears there's a connection timeout or network error. Please check your internet connection or try again later.";
