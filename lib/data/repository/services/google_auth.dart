// import 'dart:developer';

// import 'package:dio/dio.dart';

// import '../../../view-models/auth/google_auth.dart';
// import '../api_services.dart';
// import '../endpoints.dart';
// import '../response_data.dart';

// class GoogleAuth {
//   Dio dio = Dio();
//   Future callApi(context) async {
//     handleSignIn().then(
//       ((value) {
//         log('developer take the token $value');
//       }),
//     );

//     final ApiService apiService = ApiService(dio);

//     try {
//       // For example, calling a GET API
//       ResponseModel<String?> response = await apiService.postData<String>(
//           context, // Pass the BuildContext
//           Endpoints.googleLogin, // Pass the API endpoint
//           data: {
//             "access_token":
//                 "ya29.a0AfB_byAr8CiwX2mqd3YWle36t4rKEpztRFV-u8lky9lupA2iq9vZTSYLnJDf5nxei-1HTwhXqlAynV9IL1rxUWxqDnbjS7C0v4etQRizTeZn_UEkm3RD_0dMqEmVlAJf5PfOsgnkA32uPilBsDFq7-ljHRiyBBE3WwaCgYKAV4SARMSFQHGX2MiEN1hcv3uy88foGN0kDEKsA0169"
//           });

//       // Handle the response
//       if (response.responseStatus == ResponseStatus.success) {
//         // API call was successful
//         List data = response.data;
//         // log('data api services $data');
//         return data;
//         // Do something with the data
//       } else {
//         // API call failed
//         // Handle the failure
//       }
//     } catch (e) {
//       // Handle any exceptions
//     }
//   }
// }
