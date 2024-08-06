import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:good_times/utils/constant.dart';
import 'package:good_times/views/widgets/common/button.dart';

// import '../../../../data/models/test_moddedl.dart';
// import '../../../../data/resources/services/faq.dart';
import '../../../../view-models/Preferences/Preferences_Controller.dart';
import '../../../widgets/common/parent_widget.dart';
import '../login/login.dart';
import 'select_user_type.dart';

class WelcomeScreen extends StatelessWidget {
  static const String routeName = '/welcome-screen';
   WelcomeScreen({super.key});
  PreferenceController preferenceController =
      Get.put(PreferenceController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    return parentWidgetWithConnectivtyChecker(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          iconTheme: const IconThemeData(color: kPrimaryColor),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: scaffoldPadding),
          child: Column(
            children: [
              // FutureBuilder(
              //   future: FaqService().callApi(context),
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.done &&
              //         snapshot.hasData) {
              //       log('snapshot response of data ${snapshot.data}');
              //       List<TestModel> data =   snapshot.data;
              //       return Text(data[3].title,style: headingStyle,);
              //     }

              //      if (snapshot.connectionState == ConnectionState.none &&
              //         snapshot.hasData) {
              //       return const Text('Denied the data');
              //     }
              //     return const CircularProgressIndicator();
              //   },
              // ),

              const SizedBox(height: 65),
              Image.asset(
                'assets/images/logo.png',
                width: 100,
              ),
              const SizedBox(height: 40),
              Text(
                'Welcome to Good Times LTD. We’re excited you are here',
                style: headingStyle.copyWith(fontSize: 22),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Text(
              //   'Select to continue as',
              //   style: paragraphStyle.copyWith(
              //     color: const Color(0xffBABABA),
              //   ),
              // ),
              const SizedBox(height: 25),
              MyElevatedButton(
                  onPressed: () {
                    preferenceController.selectedpreference.value=[];
                    Navigator.pushNamed(context, SelectUserType.routeName);
                  },
                  text: 'Join Good Times'),
              const SizedBox(height: 25),
              myElevatedButtonOutline(
                onPressed: () {
                  preferenceController.selectedpreference.value=[];
                  Navigator.pushNamed(context, LoginScreen.routeName);
                },
                text: 'Login',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
