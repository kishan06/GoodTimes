// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:qr_flutter/qr_flutter.dart';

import '../../../data/repository/services/profile.dart';
import '../../../utils/constant.dart';
import '../../../view-models/deep_link_model.dart';
import '../../../views/widgets/common/button.dart';
import '../../../view-models/copy_clipboard.dart';
import '../../../view-models/download_barcode.dart';
import '../../widgets/common/parent_widget.dart';
import '../../widgets/common/skeleton.dart';

class ReferFriend extends StatefulWidget {
  static const String routeName = "referFriend";
  const ReferFriend({super.key});

  @override
  State<ReferFriend> createState() => _ReferFriendState();
}

class _ReferFriendState extends State<ReferFriend> {
  String referralCode = "";
  String generatedCode = "";

  _generateDeepLinkForReferral(String generatedCodeFromAPI) async {
    generatedCode = generatedCodeFromAPI;
    initDeepLinkData(generatedCode, 'referral_registration');
    await generateLink(context).then((value) {
      // setState(() {
      referralCode = value;
      //   });
    });
    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return parentWidgetWithConnectivtyChecker(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: kPrimaryColor),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: scaffoldPadding),
            child: FutureBuilder(
                future: ProfileService()
                    .getUserReferral(context)
                    .then((value) => _generateDeepLinkForReferral(value)),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Refer to earn G-tokens',
                            style: headingStyle),
                        const SizedBox(height: 8),
                        Text(
                          'Refer a friend to get exciting rewards.',
                          style: paragraphStyle.copyWith(
                              color: const Color(0xffC8C8C8)),
                        ),
                        const SizedBox(height: 50),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          decoration: BoxDecoration(
                              color: kTextWhite.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              QrImageView(
                                backgroundColor: kPrimaryColor,
                                data: referralCode,
                                version: QrVersions.auto,
                                size: 200.0,
                                padding: const EdgeInsets.all(0),
                              ),
                              const SizedBox(height: 20),
                              InkWell(
                                onTap: () {
                                  DownloadBarcode().saveQRCode(context, referralCode);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.file_download_outlined,
                                        color: kPrimaryColor),
                                    const SizedBox(width: 5),
                                    Text(
                                      'Download',
                                      style: paragraphStyle.copyWith(
                                          color: const Color(0xffC8C8C8)),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 50),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          decoration: BoxDecoration(
                              color: kTextWhite.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text('Your referral code',
                                  style: paragraphStyle),
                              const SizedBox(height: 10),
                              Text(generatedCode,
                                  style: labelStyle.copyWith(fontSize: 22)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        Row(
                          children: [
                            Expanded(
                              child: MyElevatedButton(
                                  onPressed: () {
                                    initDeepLinkData(
                                        generatedCode, 'referral_code');
                                    generateLink(context).then((value) {
                                      CopyClipboardAndSahreController()
                                          .shareLink(data:value,message: "Hi! I\'m sharing an exclusive invite to Good times with you.");
                                    });
                                  },
                                  text: 'Share'),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: myElevatedButtonOutline(
                                  onPressed: () {
                                    CopyClipboardAndSahreController()
                                        .copyToClipboard(
                                            context, generatedCode);
                                  },
                                  text: 'Copy'),
                            )
                          ],
                        )
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  }
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        ReusableSkeletonParaGraph(
                          height: 18,
                          width: MediaQuery.of(context).size.width,
                          borderRadius: BorderRadius.circular(10),
                          lines: 3,
                        ),
                        const SizedBox(height: 50),
                        ReusableSkeletonAvatar(
                          height: 340,
                          width: MediaQuery.of(context).size.width,
                          borderRadius: BorderRadius.circular(0),
                        ),
                        const SizedBox(height: 20),
                        ListView.separated(
                          shrinkWrap: true,
                          itemCount: 20,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 20),
                          itemBuilder: (context, index) {
                            return ReusableSkeletonAvatar(
                              height: 25,
                              width: MediaQuery.of(context).size.width,
                              borderRadius: BorderRadius.circular(10),
                            );
                          },
                        )
                      ],
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
