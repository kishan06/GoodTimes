import 'package:dio/dio.dart';

import '../../models/event_category.dart';
import '../api_services.dart';
import '../endpoints.dart';
import '../response_data.dart';

class EventCategoryDrawarService{
  Dio dio = Dio();
  Future<ResponseModel> eventDrawarService(context) async {
    final ApiService apiService = ApiService(dio);
    try {
      ResponseModel<String?> response = await apiService.getData<String>(
        context, // Pass the BuildContext
        Endpoints.eventCategoryDrawar,
      );
      if (response.responseStatus == ResponseStatus.success) {
        var data = response.data["data"];
        return ResponseModel(
          responseStatus: ResponseStatus.success,
          data: data.map((e)=>EventCategoryModal.fromjson(e)).toList(),
        );
      }else{
        return const ResponseModel(data: null,responseStatus: ResponseStatus.failed);
      }
    } catch (e) {
      logger.e("error on $e");
      return const ResponseModel(data: null,responseStatus: ResponseStatus.failed);
    }
  }


}