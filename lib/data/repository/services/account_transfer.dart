import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:good_times/data/repository/response_data.dart';
import '../../common/scaffold_snackbar.dart';
import '../../models/account_trasfer_modal.dart';
import '../api_services.dart';
import '../endpoints.dart';

class AccoutTransferService {
  Dio dio = Dio();
  Future<ResponseModel> accoutTransferService(context) async {
    final ApiService apiService = ApiService(dio);
    try {
      ResponseModel<String?> response = await apiService.getData<String>(
        context, // Pass the BuildContext
        Endpoints.accountTransfer, // Pass the API endpointishwar@yopmail.com
      );
      if (response.responseStatus == ResponseStatus.success) {
        var data = response.data;
        return ResponseModel(
          responseStatus: ResponseStatus.success,
          data: AccountTransferModal.fromjson(data["data"]),
        );
      }else{
        return const ResponseModel(data: null,responseStatus: ResponseStatus.failed);
      }
    } catch (e) {
      logger.e("error on $e");
      return const ResponseModel(data: null,responseStatus: ResponseStatus.failed);
    }
  }


  //! call post api in reset password account

  Future<ResponseModel> resetPasswordDoneService(context) async {

    try {
      final header = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${GetStorage().read('accessToken')}"
      };
      Response response = await dio.post(Endpoints.accountTransferDone,options: Options(headers: header));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ResponseModel(
          responseStatus: ResponseStatus.success,
          data: response.data,
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        snackBarError(context, message: e.response?.data["message"]);
        return const ResponseModel(
            responseStatus: ResponseStatus.failed, data: null);
      } else {
        snackBarError(context,message: 'Something went wronng try again.');
        const ResponseModel(responseStatus: ResponseStatus.failed, data: null);
      }
      return const ResponseModel(
        responseStatus: ResponseStatus.failed,
        data: null,
      );
    } catch (e) {
      snackBarError(context,
          message: 'Something went wronng try again.');
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
