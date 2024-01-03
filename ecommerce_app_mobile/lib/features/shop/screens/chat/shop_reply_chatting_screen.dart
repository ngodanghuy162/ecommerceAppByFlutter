import 'package:ecommerce_app_mobile/Service/Model/chat_model/chat_model.dart';
import 'package:ecommerce_app_mobile/Service/Model/user_model.dart';
import 'package:ecommerce_app_mobile/Service/repository/user_repository.dart';
import 'package:ecommerce_app_mobile/Service/repository/authentication_repository.dart';
import 'package:ecommerce_app_mobile/common/widgets/appbar/appbar.dart';
import 'package:ecommerce_app_mobile/features/shop/controllers/chat_controller/chat_controller.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/chat/shop_chatting_screen.dart';
import 'package:ecommerce_app_mobile/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopReplyChattingScreen extends StatefulWidget {
  const ShopReplyChattingScreen({super.key});

  @override
  State<ShopReplyChattingScreen> createState() =>
      _ShopReplyChattingScreenState();
}

class _ShopReplyChattingScreenState extends State<ShopReplyChattingScreen> {
  final chatController = Get.put(ChatController());
  final _authRepo = Get.put(AuthenticationRepository());
  final userController = Get.put(UserRepository());

  @override
  Widget build(BuildContext context) {
    String shopEmail = _authRepo.firebaseUser.value!.email!;

    return Scaffold(
      appBar: const TAppBar(
        title: Text(
          'Chatting with customer',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        showBackArrow: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.spaceBtwItems),
        child: FutureBuilder(
          future: chatController.getAllChatModelByShopEmail(shopEmail),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                List<ChatModel> chatList = snapshot.data!;

                if (chatList.isEmpty) {
                  return const Text('Chưa có tin nhắn nào');
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: chatList.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder(
                        future: userController
                            .getUserDetails(chatList[index].userEmail),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasData) {
                              UserModel user = snapshot.data!;
                              return _buildChatItem(
                                userEmail: user.email,
                                chatId: chatList[index].id!,
                                userName: user.lastName + ' ' + user.firstName,
                                lastMessage: 'This user want to talk to you',
                                avatarUrl: user.avatar_imgURL!,
                              );
                            } else if (snapshot.hasError) {
                              print(snapshot.error);
                            }
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );
                    },
                  );
                }
              } else if (snapshot.hasError) {
                print(snapshot.error);
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildChatItem({
    required String userName,
    required String lastMessage,
    required String avatarUrl,
    required String chatId,
    required userEmail
  }) {
    return InkWell(
      onTap: () {
        // Add logic to navigate to the chat screen for this user
        Get.to(() => ShopChattingScreen(chatId: chatId, userEmail: userEmail, userName: userName,));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(avatarUrl),
              radius: 30.0,
            ),
            const SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4.0),
                Text(
                  lastMessage,
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
