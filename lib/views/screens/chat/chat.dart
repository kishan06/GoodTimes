import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:web_socket_channel/io.dart';

import '../../../data/models/chat_model.dart';
import '../../../data/repository/endpoints.dart';
import '../../../data/repository/response_data.dart';
import '../../../data/repository/services/chat_service.dart';
import '../../../utils/constant.dart';
import '../../../utils/temp.dart';
import '../../../view-models/global_controller.dart';
import '../../widgets/common/parent_widget.dart';

class ChatScreens extends StatefulWidget {
  final dynamic eventIds;
  static const String routeName = "routeName";
  const ChatScreens({super.key, required this.eventIds});

  @override
  State<ChatScreens> createState() => _ChatScreensState();
}

class _ChatScreensState extends State<ChatScreens> {
  final TextEditingController _controller = TextEditingController();
  GlobalController globalController = Get.put(GlobalController());
  final scrollController = ScrollController();
  final focusNode = FocusNode();
  late final IOWebSocketChannel _channel;
  late var channelStream = _channel.stream.asBroadcastStream();
  List<ChatModel> messageList = [];
  bool firstSend = true;

  callChatApi() {
    ChatServices()
        .chatServices(context, eventId: widget.eventIds)
        .then((value) {
      if (value.responseStatus == ResponseStatus.success) {
        for (var jsonData in value.data) {
          messageList.add(jsonData);
        }
        messageList = messageList.reversed.toList();
        setState(() {});
      }
    });
  }

  void connectSoket() {
    try {
      _channel = IOWebSocketChannel.connect(
        Uri.parse(
          '${Endpoints.chatDomain}event_${widget.eventIds}/${GetStorage().read('accessToken')}/',
        ),
        pingInterval: const Duration(seconds: 2),
      );
      log('WebSocket connected.');
      listenToStream();
    } catch (e) {
      log('Error connecting to WebSocket: $e');
    }
  }

  void listenToStream() {
    channelStream.listen((dynamic data) {
      // Handle data from the WebSocket stream
      log('Received data: $data');
      setState(() {
        firstSend = true;
      });
    }, onDone: () {
      log('WebSocket closed.');
    }, onError: (error) {
      log('Error in WebSocket stream: $error');
    });
  }

  @override
  void initState() {
    super.initState();
    callChatApi();
    connectSoket();
  }

  @override
  Widget build(BuildContext context) {
    return parentWidgetWithConnectivtyChecker(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Live Chat',
            style: labelStyle.copyWith(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          iconTheme: const IconThemeData(color: kPrimaryColor),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: scaffoldPadding),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                    stream: channelStream,
                    builder: (context, snapshot) {
                      var data = snapshot.data;
                      var dataDecoded;
                      if (data != null) {
                        dataDecoded = jsonDecode(data);
                        if (firstSend) {
                          messageList.add(
                            ChatModel(
                              message: dataDecoded["message"],
                              timestamp: null,
                              // user: null,
                              user: UserModel(
                                firstName: dataDecoded["first_name"],
                                email: dataDecoded["user"],
                                profilePhoto:dataDecoded["profile_photo"]==null?"https://imgs.search.brave.com/vNq2jFE3XACsBNx6XivyUP5r0PYaPjic3GaSsrkaloE/rs:fit:860:0:0/g:ce/aHR0cHM6Ly90NC5m/dGNkbi5uZXQvanBn/LzAyLzE3LzM0LzY3/LzM2MF9GXzIxNzM0/Njc4Ml83WHBDVHQ4/YkxOSnF2VkFhRFpK/d3Zaam0wZXBRbWo2/ai5qcGc":Endpoints.domain+dataDecoded["profile_photo"]
                              ),
                            ),
                          );
                          firstSend = false;
                        }
                      }
                      return ListView.builder(
                          itemCount: messageList.length,
                          controller: scrollController,
                          shrinkWrap: true,
                          reverse: true,
                          itemBuilder: (context, index) {
                            var revMsg = messageList.reversed.toList();
                            return messageList.isNotEmpty
                                ? Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        revMsg[index].user?.email == globalController.email.value
                                            ? const SizedBox()
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child:revMsg[index].user?.profilePhoto!=null? Image.network(revMsg[index].user?.profilePhoto ??TempData.avatarImg,
                                                  width: 35,
                                                  height: 35,
                                                  fit: BoxFit.cover,
                                                ):const SizedBox(),
                                              ),
                                        const SizedBox(width: 0),
                                        Expanded(
                                          flex: 5,
                                          child: Align(
                                            alignment: revMsg[index]
                                                        .user
                                                        ?.email ==
                                                    globalController.email.value
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 12,
                                              ),
                                              decoration: BoxDecoration(
                                                // color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: revMsg[index]
                                                            .user
                                                            ?.email ==
                                                        globalController
                                                            .email.value
                                                    ? CrossAxisAlignment.end
                                                    : CrossAxisAlignment.start,
                                                children: [
                                                  revMsg[index].user?.email ==
                                                          globalController
                                                              .email.value
                                                      ? Text(
                                                          'You',
                                                          style: paragraphStyle
                                                              .copyWith(
                                                                  color:
                                                                      kPrimaryColor),
                                                        )
                                                      : Text(
                                                          '${revMsg[index].user?.firstName}',
                                                          style: paragraphStyle
                                                              .copyWith(
                                                                  color:
                                                                      kPrimaryColor),
                                                        ),
                                                  Text(
                                                    '${revMsg[index].message}',
                                                    style: paragraphStyle,
                                                    // maxLines: 2,
                                                    // overflow: TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        revMsg[index].user?.email ==
                                                globalController.email.value
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Image.network(
                                                  (globalController.profileImgPath.value =='')
                                                      ? 'https://imgs.search.brave.com/vNq2jFE3XACsBNx6XivyUP5r0PYaPjic3GaSsrkaloE/rs:fit:860:0:0/g:ce/aHR0cHM6Ly90NC5m/dGNkbi5uZXQvanBn/LzAyLzE3LzM0LzY3/LzM2MF9GXzIxNzM0/Njc4Ml83WHBDVHQ4/YkxOSnF2VkFhRFpK/d3Zaam0wZXBRbWo2/ai5qcGc'
                                                      : globalController.profileImgPath.value,
                                                  width: 35,
                                                  height: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  )
                                : const Center(
                                    child: Text('No Chat Found'),
                                  );
                          });
                    }),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: kPrimaryColor),
                  color: const Color(0xff1E1E1E),
                ),
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _controller,
                            focusNode: focusNode,
                            style: paragraphStyle,
                            textAlignVertical: TextAlignVertical.center,
                            cursorColor: kTextWhite,
                            decoration: InputDecoration(
                              hintText: '',
                              hintStyle: paragraphStyle.copyWith(
                                  color: const Color(0xff949494)),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.network(
                                    (globalController.profileImgPath.value == '')
                                        ? 'https://imgs.search.brave.com/vNq2jFE3XACsBNx6XivyUP5r0PYaPjic3GaSsrkaloE/rs:fit:860:0:0/g:ce/aHR0cHM6Ly90NC5m/dGNkbi5uZXQvanBn/LzAyLzE3LzM0LzY3/LzM2MF9GXzIxNzM0/Njc4Ml83WHBDVHQ4/YkxOSnF2VkFhRFpK/d3Zaam0wZXBRbWo2/ai5qcGc'
                                        : globalController.profileImgPath.value,
                                    width: 35,
                                     height: 35,
                                     fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () {
                            _sendMessage();
                          },
                          icon: const Icon(
                            Icons.send,
                            color: kPrimaryColor,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendMessage() {
    log('Sending message...');
    try {
      if (_controller.text.isNotEmpty) {
        _channel.sink.add(_controller.text);
        setState(() {
          firstSend = false;
        });
        _controller.clear();
      }
    } catch (e) {
      log('Error sending message: $e');
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
  }
}
