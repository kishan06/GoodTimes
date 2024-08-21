import 'dart:developer';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:good_times/data/common/scaffold_snackbar.dart';
import 'package:good_times/data/repository/endpoints.dart';
import 'package:good_times/data/repository/response_data.dart';
import 'package:good_times/view-models/global_controller.dart';
import 'package:good_times/views/widgets/common/button.dart';
import 'package:good_times/views/widgets/common/textformfield.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../data/models/wallet_model.dart';
import '../../../data/models/withdrawal_transaction_model.dart';
import '../../../data/repository/services/check_account_details.dart';
import '../../../data/repository/services/profile.dart';
import '../../../data/repository/services/wallet.dart';
import '../../../utils/constant.dart';
import '../../../utils/helper.dart';
import '../../../utils/loading.dart';
import '../../widgets/common/bottom_navigation.dart';
import '../../widgets/common/parent_widget.dart';
import '../../widgets/common/skeleton.dart';
import '../../widgets/subscriptionmodule.dart';
import '../profile/add_bank_details.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> with TickerProviderStateMixin {
  late TabController _tabController;
  final GlobalController globalController = Get.find();
  bool bankDetailsValue = false;
  bool waiting = false;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    ProfileService().getProfileDetails(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Future checkBankDetails() async {
    bankDetailsValue = await CheckBankDetails().getLikesEvents(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: parentWidgetWithConnectivtyChecker(
        child: Scaffold(
          appBar: AppBar(
            leading: const SizedBox(),
            leadingWidth: 0,
            title: const Text(
              'Wallet',
              style: headingStyle,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: scaffoldPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                FutureBuilder(
                  future: WallerService().walletService(context),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      var data = snapshot.data;
                      return _walletArea(coins: data, totalConis: data);
                    }
                    return ReusableSkeletonAvatar(
                      height: 243,
                      width: MediaQuery.of(context).size.width,
                      borderRadius: BorderRadius.circular(0),
                    );
                  },
                ),
                const SizedBox(height: 28),
                const Text('Wallet Transaction', style: headingStyle),
                const SizedBox(height: 28),
                TabBar(
                  padding: const EdgeInsets.all(0),
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorPadding: EdgeInsets.zero,
                  tabAlignment: TabAlignment.center,
                  labelColor: kTextWhite,
                  unselectedLabelColor: kTextWhite.withOpacity(0.6),
                  labelStyle:
                      paragraphStyle.copyWith(fontWeight: FontWeight.w500),
                  controller: _tabController,
                  indicatorColor: kPrimaryColor,
                  tabs: const <Widget>[
                    Tab(
                      text: 'All',
                    ),
                    Tab(
                      text: 'My Subscriptions',
                    ),
                    Tab(
                      text: 'Referrals',
                    ),
                    Tab(
                      text: 'Sell G-Tokens',
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: TabBarView(controller: _tabController, children: [
                    FutureBuilder(
                      future:
                          WallerService().walletTransactionsService(context),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List data = snapshot.data;
                          log("wallet transactiosn in ui screens $data");
                          return data.isEmpty
                              ? const Center(
                                  child: Text(
                                  "No Data Found",
                                  style: paragraphStyle,
                                ))
                              : _allTranscations(data);
                        }
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: 5,
                          itemBuilder: (context, index) => Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              children: [
                                ReusableSkeletonAvatar(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                // const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    FutureBuilder(
                      future:
                          WallerService().walletTransactionsService(context),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<WalletTransactionsModel> data = snapshot.data;
                          List newData = data
                              .where((element) => (element.transactionType
                                      .contains("payment") ||
                                  element.transactionType.contains("deposit")))
                              .toList();
                          return newData.isEmpty
                              ? const Center(
                                  child: Text(
                                  "No Data Found",
                                  style: paragraphStyle,
                                ))
                              : _allTranscations(newData);
                        }
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: 5,
                          itemBuilder: (context, index) => Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              children: [
                                ReusableSkeletonAvatar(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                // const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    FutureBuilder(
                      future:
                          WallerService().walletTransactionsService(context),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<WalletTransactionsModel> data = snapshot.data;
                          log("wallet transactiosn in ui screens $data");
                          List newData = data
                              .where((element) =>
                                  element.transactionType.contains("credit"))
                              .toList();
                          return newData.isEmpty
                              ? const Center(
                                  child: Text(
                                  "No Data Found",
                                  style: paragraphStyle,
                                ))
                              : _allTranscations(newData);
                        }
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: 5,
                          itemBuilder: (context, index) => Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              children: [
                                ReusableSkeletonAvatar(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                // const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    FutureBuilder(
                      future: WallerService().withdrawalTransactions(context),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<WithdrawalTransactionsModel> data =
                              snapshot.data;
                          // log("wallet transactiosn in ui screens $data");
                          return data.isEmpty
                              ? const Center(
                                  child: Text(
                                  "No Data Found",
                                  style: paragraphStyle,
                                ))
                              : ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return const Divider();
                                  },
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 4,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "Sold",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: kTextWhite),
                                                  ),
                                                  Text(
                                                    data[index]
                                                        .status!
                                                        .capitalizeFirst
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: kPrimaryColor),
                                                  ),
                                                  (data[index].reply == null)
                                                      ? const SizedBox()
                                                      : replyModelsheet(context,
                                                          replyData:
                                                              data[index].reply)
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "Token: ",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: kTextWhite,
                                                        ),
                                                      ),
                                                      Text(
                                                        data[index]
                                                            .coins
                                                            .toString(),
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          color: kPrimaryColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 5),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "amount: ",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: kTextWhite,
                                                        ),
                                                      ),
                                                      Text(
                                                        data[index].amount,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          color: kPrimaryColor,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    );
                                  },
                                );
                        }
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: 5,
                          itemBuilder: (context, index) => Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              children: [
                                ReusableSkeletonAvatar(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                // const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ]),
                ),
              ],
            ),
          ),
          bottomNavigationBar: const BottomNavigationBars(),
        ),
      ),
    );
  }

  InkWell replyModelsheet(BuildContext context, {replyData}) {
    return InkWell(
      onTap: () {
        showBarModalBottomSheet(
          // expand: false,
          context: context,
          // isDismissible:isDismissible,
          // enableDrag:enableDrag,
          barrierColor: const Color(0xff000000).withOpacity(0.8),
          backgroundColor: kTextBlack.withOpacity(0.55),
          builder: (context) => ConstrainedBox(
            // height: Get.size.height * 0.6,
            constraints: BoxConstraints(
              minHeight: Get.size.height * 0.3,
            ),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          "Reply",
                          style: headingStyle.copyWith(fontSize: 25),
                        ),
                      ),
                      IconButton(
                          icon: const Icon(Icons.close, color: kPrimaryColor),
                          onPressed: () => Get.back()),
                    ],
                  ),
                ),
                const Divider(),
                const SizedBox(height: 10),
                Text(
                  replyData,
                  style: const TextStyle(fontSize: 20, color: kTextWhite),
                )
                // Padding(
                //   padding: EdgeInsets.all(scaffoldPadding),
                //   child: child,
                // ),
              ],
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
        );
      },
      child: const Text(
        'View Reply',
        style: TextStyle(fontSize: 12, color: kPrimaryColor),
      ),
    );
  }

  Container _walletArea({coins, totalConis}) {
    return Container(
      decoration: BoxDecoration(
        color: kTextWhite.withOpacity(0.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'You’ve earned G-Tokens',
                  style: labelStyle.copyWith(fontWeight: FontWeight.w500),
                ),
                Text(
                  '$coins',
                  style: headingStyle.copyWith(fontSize: 35),
                ),
              ],
            ),
            const SizedBox(height: 15),
            MyElevatedButton(
              onPressed: () {
                globalController.logger
                    .e("check bank details added or not $bankDetailsValue");
                globalController.hasActiveSubscription.value ||
                        globalController.hasActiveGracePeriod.value
                    ? EasyDebounce.debounce(
                        'my-debouncer', const Duration(milliseconds: 200), () {
                        checkBankDetails().then((value) {
                          bankDetailsValue
                              ? withdrawalRequest()
                              : Navigator.pushNamed(
                                  context, AddBankDetails.routeName);
                        });
                      })
                    : Subscriptionmodule(context, "event_user");
              },
              text: 'Sell G-Token',
            ),
            const SizedBox(height: 25),
            const Divider(),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('All-time total', style: labelStyle),
                Text(
                  '$totalConis',
                  style: labelStyle.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _allTranscations(filterTransactionData) {
    List<WalletTransactionsModel> data = filterTransactionData;
    // Logger().e("all trasaction type data ${data[2].transactionType}");
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: _transactionRow(
              text: data[index].transactionTypeDisplay,
              rupee: (data[index].transactionType == "credit")
                  ? data[index].coins
                  : data[index].amount,
              transactionStatus: data[index].transactionStatus,
              transactionType: data[index].transactionType,
            ),
          );
        },
        separatorBuilder: (context, index) => const Divider(
              color: Color(0xff4A4A4A),
            ),
        itemCount: data.length);
  }

  _transactionRow({text, rupee, transactionStatus, transactionType}) {
    return Row(
      children: [
        (transactionStatus == 'fail')
            ? const Icon(Icons.error, color: kTextError, size: 20)
            : SvgPicture.asset('assets/svg/arrow-down-left.svg'),
        const SizedBox(width: 5),
        Text(text, style: paragraphStyle),
        const Spacer(),
        Text(
          '${(transactionType == "credit") ? 'Token ' : "£ "}$rupee',
          style: labelStyle,
        )
      ],
    );
  }

  withdrawalRequest() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: kTextBlack,
          // title: const Text("My title"),
          content: FutureBuilder(
            future: WallerService().reffralRecords(context),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<ReffralRecordsModel> data = snapshot.data;
                return data.isNotEmpty
                    ? SizedBox(
                        // height: MediaQuery.of(context).size.height*0.8,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text("G-Token : ${data[index].coins}",
                                      style: paragraphStyle),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      WallerService().reffralRedeem(context,
                                          uniqueToken: data[index].uniqueToken);
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        width: 1,
                                        color: kPrimaryColor.withOpacity(0.7),
                                      ),
                                    ),
                                    child: const Text("Sell",
                                        style: paragraphStyle),
                                  ),
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (context, index) =>
                              Divider(color: kPrimaryColor.withOpacity(0.4)),
                        ),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 50),
                          Center(
                            child: Text("No Data found", style: paragraphStyle),
                          ),
                        ],
                      );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),

          actions: [
            TextButton(
              child: const Text(
                "Withdraw manually",
                style: TextStyle(color: kPrimaryColor),
              ),
              onPressed: () {
                // Get.back();
                manuallyWithdrawalRequest();
              },
            ),
            TextButton(
              child: const Text(
                "Cancel",
                style: TextStyle(color: kPrimaryColor),
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }

  manuallyWithdrawalRequest() {
    final _key = GlobalKey<FormState>();
    final _coinWithdraw = TextEditingController();
    AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: kTextBlack,
          // title: const Text("My title"),
          content: Form(
            key: _key,
            autovalidateMode: _autovalidateMode,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Withdraw Manually",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                textFormField(
                  controller: _coinWithdraw,
                  autofocus: true,
                  hintTxt: "Enter coins",
                  validationFunction: (values) {
                    var value = values.trim();
                    if (value == null || value.isEmpty) {
                      return "Please enter valid coin";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),

          actions: [
            Row(
              children: [
                Expanded(
                  child: myElevatedButtonOutline(
                    onPressed: () {
                      setState(() {
                        _autovalidateMode = AutovalidateMode.always;
                      });
                      unfoucsKeyboard(context);
                      // _key.currentState!.validate();
                      if (_key.currentState!.validate()) {
                        showWaitingDialoge(context: context, loading: waiting);
                        setState(() {
                          waiting = true;
                        });
                        WallerService()
                            .referralTokenManullySell(context,
                                tokenCout: _coinWithdraw.text)
                            .then((value) {
                          logger.f(
                              "value in data change ${value.responseStatus}");
                          logger.f("value in data change ${value.data}");
                          if (value.responseStatus == ResponseStatus.success) {
                            logger.e("checked error message $waiting");
                            setState(() {
                              waiting = false;
                            });
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            snackBarSuccess(context,
                                message: "Selected tokens sold successfully");
                            logger.e("checked error message $waiting");
                          }

                          if (value.responseStatus == ResponseStatus.failed) {
                            setState(() {
                              waiting = false;
                            });
                            Navigator.pop(context);
                          }
                        });
                      }
                    },
                    text: 'Continue',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: MyElevatedButton(
                    text: "Cancel",
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
