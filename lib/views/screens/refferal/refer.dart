import 'package:flutter/material.dart';
import 'package:good_times/utils/constant.dart';
import 'package:good_times/views/widgets/common/button.dart';

import '../../../data/repository/services/profile.dart';
import '../../../view-models/copy_clipboard.dart';
import '../../../view-models/deep_link_model.dart';
import '../../widgets/common/parent_widget.dart';

class Reffer extends StatefulWidget {
  static const String routeName = 'reffer';
  const Reffer({super.key});

  @override
  State<Reffer> createState() => _RefferState();
}

class _RefferState extends State<Reffer> {
  @override
  Widget build(BuildContext context) {
    return parentWidgetWithConnectivtyChecker(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: kPrimaryColor),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/reffer_img.jpeg'),
                    fit: BoxFit.cover)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: scaffoldPadding),
              child: FutureBuilder(
                future: ProfileService().getUserReferral(context), 
                builder: (context,snapshot) {
                  if(snapshot.hasData){
                    String referralCode = snapshot.data;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      const Text('Refer to earn G-tokens', style: headingStyle),
                      const SizedBox(height: 30),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 11, vertical: 23),
                        decoration: BoxDecoration(
                            color: kTextBlack.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          children: [
                            Image.asset('assets/images/logo.png',
                                width: 52, height: 52),
                            const SizedBox(width: 18),
                            Expanded(
                              child: Text(
                                "Use my referral code to install Good Times app ",
                                style: paragraphStyle.copyWith(fontSize: 14),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      Text('Your referral code',
                          style: headingStyle.copyWith(fontSize: 24)),
                      const SizedBox(height: 6),
                      Text('Share this unique code with your friends',
                          style: paragraphStyle.copyWith(fontSize: 14)),
                      const SizedBox(height: 15),
                      Container(
                        height: 65,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: kTextBlack.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child:  Center(
                            child: Text(
                          referralCode,
                          style: headingStyle,
                        )),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: MyElevatedButton(
                                onPressed: () {
                                  initDeepLinkData(referralCode, 'referral_code');
                                  generateLink(context).then((value) {
                                    CopyClipboardAndSahreController()
                                        .shareLink(data:value,message: "Hi! I\'m sharing an exclusive invite to Good times with you");
                                  });
                                },
                                text: 'Share'),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: myElevatedButtonOutline(
                                onPressed: () {
                                  CopyClipboardAndSahreController().copyToClipboard(context, referralCode);
                                },
                                text: 'Copy'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 45),
                      Text(
                        'How it works',
                        style: headingStyle.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Text(
                            "You can earn G-Token by referring Good Times to others. Whenever a new user either registers using your referral code or renews his subscription, cha-ching, you earn G-Token. This provides you with a consistent stream of income!",
                            style: paragraphStyle.copyWith(fontSize: 14),
                          )),
                        ],
                      ),
                      const SizedBox(height: 22),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.circular(100)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Text(
                            "You can earn real money by redeeming your G-Tokens. To redeem, click on the in Wallet tab and Sell G-Token button. The money will be credited directly to your bank account if your account is verified.",
                            style: paragraphStyle.copyWith(fontSize: 14),
                          )),
                        ],
                      ),
                    ],
                  );
                  }
                  return const Center(child: CircularProgressIndicator());
                }
              ),
            ),
          ),
        ),
      ),
    );
  }
}
