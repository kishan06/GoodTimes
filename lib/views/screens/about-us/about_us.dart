import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:good_times/data/repository/response_data.dart';
import 'package:good_times/utils/constant.dart';
import '../../../data/models/orgnisations_model.dart';
import '../../../data/repository/services/orgnisation.dart';
import '../../widgets/common/parent_widget.dart';
import '../../widgets/common/skeleton.dart';

class AboutUs extends StatefulWidget {
  static const String routeName = 'aboutUs';
  const AboutUs({super.key});
  
  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('About Us', style: headingStyle),
                const SizedBox(height: 40),
                FutureBuilder<ResponseModel>(
                  future: OrgnisataionsServices().orgnisataionsServices(context),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      CMSModel data = snapshot.data!.data;
                      log('data of CMS ${data.aboutUs}');
                      return Html(
                        data: data.aboutUs,
                        style: {
                          "body": Style(
                            fontSize: FontSize(18.0),
                            fontWeight: FontWeight.bold,
                            color: kTextWhite,
                          ),
                        },
                      );
                    }
                     return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                       scrollDirection: Axis.vertical,
                       shrinkWrap: true,
                       itemCount: 30,
                       itemBuilder: (context, index) => Container(
                         margin: const EdgeInsets.only(bottom: 20),
                         child:ReusableSkeletonAvatar(
                              height: 20,
                              width: MediaQuery.of(context).size.width,
                              borderRadius: BorderRadius.circular(10),
                            ),
                       ),
                     );
      
                  //   for (int i = 0; i < 4; i++)
                  // Column(
                  //   children: const [
                  //     SizedBox(height: 8),
                  //     ShimmerSkeletonBase(
                  //       width: double.infinity,
                  //       height: 42,
                  //       radius: 8,
                  //     ),
                  //   ],
                  // ),
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
