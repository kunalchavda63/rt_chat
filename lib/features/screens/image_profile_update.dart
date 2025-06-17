import 'package:flutter/material.dart';
import 'package:rt_chat/core/app_ui/src/widgets/custom_widgets.dart';

class ImageProfileUpdate extends StatelessWidget {
  const ImageProfileUpdate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidgets.customAppBar(title: Text('Profile Setup')),
    );
  }
}
