// import 'dart:developer';
// import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:path_provider/path_provider.dart';


// var dio = Dio();
// Future download()async{
//   Directory directory = await getApplicationDocumentsDirectory();
//   log('path directory $directory');
//   String imgUrl = 'https://plus.unsplash.com/premium_photo-1697729897664-8c14e4bbf139?q=80&w=3387&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D';
//   Response response = await dio.download(imgUrl, '$directory/test.jpeg');
//   log('response ${response.statusCode} $response');
// }

// Future uploadFile() async {
//   FilePickerResult? filePicker = await FilePicker.platform.pickFiles();

//   if (filePicker != null) {
//     File file = File(filePicker.files.single.path ?? ' ');

//     var fileName = file.path.split('/').last;
//     var filePath = file.path;

//     FormData formData = FormData.fromMap({
//       'key': 'a11939791cf901b80ba676d09eee5f41',
//       'image': await MultipartFile.fromFile(filePath, filename: fileName),
//       'name': 'testimage',
//     });

//     var response = await dio.post(
//       'https://api.imgbb.com/1/upload',
//       data: formData,
//       onSendProgress: (count, total) {
//         log('$count, $total');
//       },
//     );
//     log('response $response');
//   }else{
//     log('Result is null');
//   }
// }
