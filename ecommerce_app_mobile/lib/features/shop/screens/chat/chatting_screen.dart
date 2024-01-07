import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_mobile/Service/Model/chat_model/chat_model.dart';
import 'package:ecommerce_app_mobile/Service/Model/chat_model/message_model.dart';
import 'package:ecommerce_app_mobile/Service/repository/authentication_repository.dart';
import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/common/widgets/custom_shapes/container/rounded_container.dart';
import 'package:ecommerce_app_mobile/common/widgets/loading/custom_loading.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/chat_controller/chat_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/chat_controller/message_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/product_controller/product_variant_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_model.dart';
import 'package:ecommerce_app_mobile/features/shop/models/product_model/product_variant_model.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/chat/widget/chat_bubble.dart';
import 'package:ecommerce_app_mobile/utils/constants/colors.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/styles/product_price_text.dart';

class ChattingScreen extends StatefulWidget {
  const ChattingScreen({
    super.key,
    required this.variant,
    required this.product,
    required this.maxPrice,
    required this.minPrice,
    required this.discount,
  });

  final ProductVariantModel variant;
  final ProductModel product;
  final double maxPrice;
  final double minPrice;
  final int discount;

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  final TextEditingController _textEditingControllerController =
      TextEditingController();
  final variantsController = Get.put(ProductVariantController());
  final _authRepo = Get.put(AuthenticationRepository());
  final messageController = Get.put(MessageController());
  final chatController = Get.put(ChatController());

  late List<MessageModel> messageList;

  late String? chatId = '';

  late double maxPrice;
  late double minPrice;
  late int discount;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    maxPrice = widget.maxPrice;
    minPrice = widget.minPrice;
    discount = widget.discount;
    getChatId();
  }

  Future<void> getChatId() async {
    chatId = await chatController.getChatIfExist(
        _authRepo.firebaseUser.value!.email!, widget.product.shopEmail);
    if (chatId == null) {
      ChatModel chatModel = ChatModel(
          userEmail: _authRepo.firebaseUser.value!.email!,
          shopEmail: widget.product.shopEmail);
      chatId = await chatController.createNewChat(chatModel);
    }
    setState(() {});
  }

  void sendMessage() async {
    if (_textEditingControllerController.text.isNotEmpty &&
        _textEditingControllerController.text != '') {
      MessageModel messageModel = MessageModel(
          emailFrom: _authRepo.firebaseUser.value!.email!,
          emailTo: widget.product.shopEmail,
          time: Timestamp.now(),
          content: _textEditingControllerController.text);
      await messageController.sendMessage(messageModel, chatId!);
      _textEditingControllerController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        title: Text(
          "Chatting with shop",
        ),
        showBackArrow: true,
      ),
      body: Column(
        children: [
          TRoundedContainer(
            showBorder: true,
            borderColor: TColors.darkGrey,
            backgroundColor: Colors.transparent,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.all(12),
            child: Column(
              children: [
                const Text('Talk about:'),
                const Divider(height: 8),
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Image(
                        image: NetworkImage(widget.variant.imageURL),
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: TSizes.spaceBtwItems),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.product.name),
                          Text(
                            minPrice == maxPrice
                                ? '$minPrice'
                                : "\$$minPrice - $maxPrice",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .apply(decoration: TextDecoration.lineThrough),
                          ),
                          const SizedBox(
                            width: TSizes.spaceBtwItems,
                          ),
                          TProductPriceText(
                            price: minPrice == maxPrice
                                ? priceAfterDis(minPrice, discount)
                                : " ${priceAfterDis(minPrice, discount)} - ${priceAfterDis(maxPrice, discount)}",
                            isLarge: false,
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          const Divider(height: 1),
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
                      )),
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
