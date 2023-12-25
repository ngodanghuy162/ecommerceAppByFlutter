import 'package:ecommerce_app_mobile/Service/Model/user_model.dart';
import 'package:ecommerce_app_mobile/Service/repository/user_repository.dart';
import 'package:ecommerce_app_mobile/features/shop/screens/cart/cart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/products/cart/cart_menu_icon.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/text_strings.dart';

class THomeAppBar extends StatelessWidget {
  THomeAppBar({
    super.key,
  });
  final userController = Get.put(UserRepository());

  @override
  Widget build(BuildContext context) {
    return TAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(TTexts.homeAppbarTitle,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .apply(color: TColors.grey)),
          FutureBuilder(
              future: userController
                  .getUserDetails(FirebaseAuth.instance.currentUser!.email!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    UserModel user = snapshot.data!;

                    return Text('${user.firstName} ${user.lastName}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .apply(color: TColors.white));
                  } else if (snapshot.hasError) {
                    print(snapshot.error.toString());
                    return Center(child: Text(snapshot.error.toString()));
                  } else {
                    return Center(child: Text("smt went wrong"));
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              })
        ],
      ),
      showBackArrow: false,
      actions: [
        TCartCounterIcon(
          onPressed: () {
            Get.to(const CartScreen());
          },
          iconColor: TColors.white,
        ),
      ],
    );
  }
}
