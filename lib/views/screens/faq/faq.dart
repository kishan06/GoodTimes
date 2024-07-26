import 'package:flutter/material.dart';
import 'package:good_times/utils/constant.dart';

import '../../../data/models/faq_model.dart';
import '../../../data/repository/services/faq.dart';
import '../../widgets/common/parent_widget.dart';
import '../../widgets/common/skeleton.dart';

class FAQs extends StatefulWidget {
  static const String routeName = "fAQs";
  const FAQs({super.key});

  @override
  State<FAQs> createState() => _FAQsState();
}

class _FAQsState extends State<FAQs> {
  @override
  Widget build(BuildContext context) {
    // FaqService().faq(context);
    return parentWidgetWithConnectivtyChecker(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: kPrimaryColor),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: scaffoldPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('FAQ', style: headingStyle),
              const SizedBox(height: 20),
              Expanded(
                  child: FutureBuilder(
                future: FaqService().faq(context),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<FaqModel> data = snapshot.data!.data;
                    return data.isEmpty
                        ? const Center(
                            child: Text(
                            'No data found 😞',
                            style: headingStyle,
                          ))
                        : ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return expansionList(
                                  question: data[index].question,
                                  answer: data[index].answer);
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 20),
                            itemCount: data.length);
                  }
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: 15,
                    itemBuilder: (context, index) => Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: ReusableSkeletonAvatar(
                        height: 58,
                        width: MediaQuery.of(context).size.width,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
              )),
            ],
          ),
        ),
      ),
    );
  }

  Container expansionList({question, answer}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff212121),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(bottom: 8),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          iconColor: kTextWhite,
          collapsedIconColor: kTextWhite,
          title: Text(
            question,
            style: labelStyle.copyWith(fontWeight: FontWeight.w500),
          ),
          children: <Widget>[
            Container(
              height: 2,
              width: double.infinity,
              color: kTextWhite.withOpacity(0.4),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  answer,
                  style:
                      paragraphStyle.copyWith(color: const Color(0xffC8C8C8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
