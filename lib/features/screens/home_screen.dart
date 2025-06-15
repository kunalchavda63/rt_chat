import 'package:flutter/material.dart';
import 'package:rt_chat/core/app_ui/src/colors.dart';
import 'package:rt_chat/core/app_ui/src/widgets/custom_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidgets.customAppBar(
        title: Text('Chats'),
        elevation: 10,
        bgColor: AppColors.hex5c23,
      ),
    );
  }
}
