import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:get_storage/get_storage.dart';

import '../../common/scaffold_snackbar.dart';
import '../../models/wallet_model.dart';
import '../../models/withdrawal_transaction_model.dart';
import '../api_services.dart';
import '../endpoints.dart';
import '../response_data.dart';

class WallerService {
  Dio dio = Dio();
  Future walletService(context) async {
    final ApiService apiService = ApiService(dio);
    try {
      // For example, calling a GET API
      ResponseModel<String?> response = await apiService.getData<String>(context, // Pass the BuildContext
        Endpoints.refferalRecords, // Pass the API endpoint
      );

      var data = response.data["data"]["reward_count"];
      log("check reffrals records data $data");

      // Handle the response
      if (response.responseStatus == ResponseStatus.success) {
        return data;//;
        // Do something with the data
      } else {
        // API call failed
        // Handle the failure
      }
    } catch (e) {
      // Handle any exceptions
    }
  }

  Future walletTransactionsService(context) async {
    final ApiService apiService = ApiService(dio);
    try {
      // For example, calling a GET API
      ResponseModel<String?> response = await apiService.getData<String>(
        context, // Pass the BuildContext
        Endpoints.getWalletTransactions, // Pass the API endpoint
      );

      List data = response.data["data"];
      log("check wallet transactions data $data");

      // Handle the response
      if (response.responseStatus == ResponseStatus.success) {
        return data
            .map((e) => WalletTransactionsModel.fromJson(e))
            .toList(); //;
        // Do something with the data
      } else {
        // API call failed
        // Handle the failure
      }
    } catch (e) {
      // Handle any exceptions
    }
  }

  // withdrawal transaction request 
  Future withdrawalTransactions(context) async {
    final ApiService apiService = ApiService(dio);
    try {
      // For example, calling a GET API
      ResponseModel<String?> response = await apiService.getData<String>(context, // Pass the BuildContext
        Endpoints.withdrawalTransactions, // Pass the API endpoint
      );

      List data = response.data["data"];
      log("check withdrawal transactions data $data");

      // Handle the response
      if (response.responseStatus == ResponseStatus.success) {
        return data.map((e) => WithdrawalTransactionsModel.fromJson(e)).toList();//;
        // Do something with the data
      } else {
        // API call failed
        // Handle the failure
      }
    } catch (e) {
      // Handle any exceptions
    }
  }


  // Withdrawal Request functions calls
  Future<ResponseModel> requestWithdrawl(context, {notes}) async {
    try {
      final header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${GetStorage().read('accessToken')}"
      };
      Response response = await dio.post(
        Endpoints.walletRequests,
        options: Options(headers: header),
        data: {"notes": notes},
      );
      log('respose of withdrawal request us form ${response.statusCode}');

      if (response.statusCode == 200) {
        snackBarSuccess(context, message: response.data["message"]);
        log('response.body ${response.data}');
        return ResponseModel(
          responseStatus: ResponseStatus.success,
          data: response.data,
        );
      }
    } on DioException catch (e) {
      // log('respose of withdrawal request exceptions ${e.response?.data["message"]}');
      if (e.response?.statusCode == 400) {
        // log('respose of withdrawal request exceptions ${e.response}');
        log('respose of withdrawal request exceptions ${e.response?.data["errors"]}');
        snackBarError(context, message: e.response?.data["errors"]);
        return const ResponseModel(
            responseStatus: ResponseStatus.failed, data: null);
      } else {
        log('Dio Error: ${e.message}');
        snackBarError(context,
            message: 'Something went wrong. Please try again later.');
        const ResponseModel(responseStatus: ResponseStatus.failed, data: null);
      }
      return const ResponseModel(
        responseStatus: ResponseStatus.failed,
        data: null,
      );
    } catch (e) {
      // Handle other exceptions
      log('Error: $e');
      snackBarError(context,
          message: 'Something went wrong. Please try again later.');
      return const ResponseModel(
        responseStatus: ResponseStatus.failed,
        data: null,
      );
    }
    return const ResponseModel(
      responseStatus: ResponseStatus.failed,
      data: null,
    );
  }


  // withdrawal transaction request 
  Future reffralRecords(context) async {
    final ApiService apiService = ApiService(dio);
    try {
      // For example, calling a GET API
      ResponseModel<String?> response = await apiService.getData<String>(context, // Pass the BuildContext
        Endpoints.refferalRecords, // Pass the API endpoint
      );

      List data = response.data["data"]["rewards"];
      log("check reffrals records data $data");

      // Handle the response
      if (response.responseStatus == ResponseStatus.success) {
        return data.map((e) => ReffralRecordsModel.fromJson(e)).toList();//;
        // Do something with the data
      } else {
        // API call failed
        // Handle the failure
      }
    } catch (e) {
      // Handle any exceptions
    }
  }


  // Withdrawal Request functions calls
  Future<ResponseModel> reffralRedeem(context, {uniqueToken}) async {
    try {
      // log("show url ${Endpoints.walletRequests}$uniqueToken/}");
      final header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${GetStorage().read('accessToken')}"
      };
      Response response = await dio.patch("${Endpoints.reffralRedeem}$uniqueToken/",
        options: Options(headers: header),
      );
      log('respose of reffral redeem request status ${response.statusCode}');
      log('respose of reffral redeem request us form ${response.data}');

      if (response.statusCode == 200 || response.data["message"] == "Operation successful") {
        snackBarSuccess(context, message: response.data["data"]);
        log('response.body ${response.data}');
        return ResponseModel(
          responseStatus: ResponseStatus.success,
          data: response.data,
        );
      }
    } on DioException catch (e) {
      // log('respose of withdrawal request exceptions ${e.response?.data["message"]}');
      if (e.response?.statusCode == 400) {
        // log('respose of withdrawal request exceptions ${e.response}');
        log('respose of withdrawal request exceptions ${e.response?.data["errors"]}');
        snackBarError(context, message: e.response?.data["errors"]);
        return const ResponseModel(
            responseStatus: ResponseStatus.failed, data: null);
      } else {
        log('Dio Error: ${e.message}');
        snackBarError(context,
            message: 'Something went wrong. Please try again later.');
        const ResponseModel(responseStatus: ResponseStatus.failed, data: null);
      }
      return const ResponseModel(
        responseStatus: ResponseStatus.failed,
        data: null,
      );
    } catch (e) {
      // Handle other exceptions
      log('Error: $e');
      snackBarError(context,
          message: 'Something went wrong. Please try again later.');
      return const ResponseModel(
        responseStatus: ResponseStatus.failed,
        data: null,
      );
    }
    return const ResponseModel(
      responseStatus: ResponseStatus.failed,
      data: null,
    );
  }


  Future<ResponseModel> referralTokenManullySell(context, {tokenCout}) async {
    // Response? response;
    try {
      // log("show url tokenCout $tokenCout}");
      final header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${GetStorage().read('accessToken')}"
      };
      Response response = await dio.patch(Endpoints.referralTokenManullySell,
        options: Options(headers: header),
         data: {"num_tokens": tokenCout},
      );
      logger.f('respose of reffral count coins status code ${response.statusCode}');
      logger.f('respose of reffral data ${response.data}');

      if (response.statusCode == 200 || response.data["message"] == "Operation successful") {
        // snackBarSuccess(context, message: response.data["data"]);
        // logger.f('response.body ${response.data}');
        return ResponseModel(
          responseStatus: ResponseStatus.success,
          data: response.data,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        log('respose of withdrawal request exceptions ${e.response?.data["errors"]}');
         getx.Get.back();
        getx.Get.back();
        snackBarError(context, message: e.response?.data["errors"]);
        
        return const ResponseModel(
            responseStatus: ResponseStatus.failed, data: null);
            
      } else if (e.response?.statusCode == 404) {
        getx.Get.back();
        getx.Get.back();
        snackBarError(context, message: e.response?.data["errors"]);
        return const ResponseModel(
            responseStatus: ResponseStatus.failed, data: null);
      }else {
        log('Dio Error: ${e.message}');
        snackBarError(context, message: 'Something went wrong. Please try again later.');
        const ResponseModel(responseStatus: ResponseStatus.failed, data: null);
      }
      return const ResponseModel(
        responseStatus: ResponseStatus.failed,
        data: null,
      );
    } catch (e) {
      // Handle other exceptions
      log('Error: $e');
      snackBarError(context,
          message: 'Something went wrong. Please try again later.');
      return const ResponseModel(
        responseStatus: ResponseStatus.failed,
        data: null,
      );
    }
    return const ResponseModel(
      responseStatus: ResponseStatus.failed,
      data: null,
    );
  }



}
