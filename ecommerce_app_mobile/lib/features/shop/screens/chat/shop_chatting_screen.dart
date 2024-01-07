import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/Service/Model/chat_model/message_model.dart';
import 'package:ecommerce_app_mobile/Service/repository/authentication_repository.dart';
import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/common/widgets/loading/custom_loading.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/chat_controller/chat_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/chat_controller/message_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/chat/widget/chat_bubble.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopChattingScreen extends StatefulWidget {
  const ShopChattingScreen(
      {super.key,
      required this.chatId,
      required this.userEmail,
      required this.userName});

  final String chatId;
  final String userEmail;
  final String userName;

  @override
  State<ShopChattingScreen> createState() => _ShopChattingScreenState();
}

class _ShopChattingScreenState extends State<ShopChattingScreen> {
  final TextEditingController _textEditingControllerController =
      TextEditingController();
  final _authRepo = Get.put(AuthenticationRepository());
  final messageController = Get.put(MessageController());
  final chatController = Get.put(ChatController());

  late List<MessageModel> messageList;

  late String? chatId = '';

  @override
  void initState() {
    super.initState();
    chatId = widget.chatId;
  }

  void sendMessage() async {
    if (_textEditingControllerController.text.isNotEmpty &&
        _textEditingControllerController.text != '') {
      MessageModel messageModel = MessageModel(
          emailFrom: _authRepo.firebaseUser.value!.email!,
          emailTo: widget.userEmail,
          time: Timestamp.now(),
          content: _textEditingControllerController.text);
      await messageController.sendMessage(messageModel, chatId!);
      _textEditingControllerController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        title: Text(
          "Chatting with ${widget.userName}",
        ),
        showBackArrow: true,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: TSizes.spaceBtwItems,
          ),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  /// Message
                  (chatId != null && chatId != '')
                      ? _buildMessageList()
                      : const CircularProgressIndicator(),

                  /// User input
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(8.0),
                      width: THelperFunctions.screenWidth(),
                      child: _buildMessageInput(),
                      // child: Row(children: [Text('keke')],),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: messageController.getAllMessageByChatId(chatId!),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CustomLoading());
        }

        messageList = snapshot.data!;

        return ListView.builder(
          cacheExtent: messageList.length.toDouble(),
          shrinkWrap: true,
          itemCount: messageList.length + 1,
          itemBuilder: (context, index) {
            return index == messageList.length
                ? const SizedBox(
                    height: 75,
                  )
                : _buildMessageItem(messageList[index]);
          },
        );
      },
    );
  }

  /// Build message item
  Widget _buildMessageItem(MessageModel messageModel) {
    bool checkUser;
    if ((_authRepo.firebaseUser.value!.email == messageModel.emailFrom)) {
      checkUser = true;
    } else {
      checkUser = false;
    }
    var alignment = checkUser ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment:
              checkUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisAlignment:
              checkUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Text(messageModel.emailFrom),
            ChatBubble(
              message: messageModel.content,
              checkUser: checkUser,
            ),
            Text(
              messageModel.formattedDate,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  /// Build message input
  Widget _buildMessageInput() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: TextField(
            controller: _textEditingControllerController,
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: TColors.darkerGrey,
                ),
                borderRadius: BorderRadius.all(Radius.circular(18)),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: TColors.darkerGrey,
                ),
                borderRadius: BorderRadius.all(Radius.circular(18)),
              ),
              hintText: 'Nhập tin nhắn của bạn',
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: () {
            sendMessage();
          },
        )
      ],
    );
  }
}

String priceAfterDis(double price, int discount) {
  double res = price * ((100 - discount) / 100);
  return res.toStringAsFixed(1);
}
