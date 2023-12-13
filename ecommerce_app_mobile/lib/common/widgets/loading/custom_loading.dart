import 'package:ecommerce_app_mobile/utils/constants/image_strings.dart';
import 'package:ecommerce_app_mobile/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';


class CustomLoading extends StatefulWidget {
  const CustomLoading({Key? key}) : super(key: key);

  @override
  _CustomLoadingState createState() => _CustomLoadingState();
}

class _CustomLoadingState extends State<CustomLoading>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        _controller.forward();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      _buildLoading(),
    ]);
  }

  Widget _buildLoading() {
    bool isDark = THelperFunctions.isDarkMode(context);
    return Stack(alignment: Alignment.center, children: [
      isDark
          ? const Image(
              image: AssetImage(TImages.lightAppLogo),
              width: 50,
              height: 50,
            )
          : const Image(
              image: AssetImage(TImages.darkAppLogo),
              width: 50,
              height: 50,
            ),
      RotationTransition(
        alignment: Alignment.center,
        turns: _controller,
        child: const Image(
          image: AssetImage('assets/loading/loading-circle.png'),
          width: 80,
          height: 80,
        ),
      ),
    ]);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
