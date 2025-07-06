import 'package:rt_chat/core/app_ui/src/widgets/src/buttons/src/custom_pop_up_menu_btn.dart';
import 'package:rt_chat/core/app_ui/src/widgets/src/custom_circle_icon.dart';

import 'widgets.dart';

class CustomWidgets {
  // Custom Text field
  static Widget customTextField({
    String? label,
    String? hintText,
    String? Function(String?)? validator,
    InputBorder? border,
    TextEditingController? controller,
    Widget? suffixIcon,
    Widget? prefixIcon,
    EdgeInsets? padding,
    TextInputAction? textInputAction,
    TextInputType? textInputType,
    TextCapitalization? textCapitalization,
    bool? isExpand,
    Color? fillColor,
    bool? filled,
    TextStyle? style,
    TextStyle? labelStyle,
    TextStyle? hintStyle,
    FocusNode? focusNode,
    String? initialValue,
    int? maxLength,
    Color? cursorColor,
  }) {
    return CustomTextField(
      cusrsonColor: cursorColor,
      focusNode: focusNode,
      label: label,
      hintText: hintText,
      hintStyle: hintStyle,
      labelStyle: labelStyle,
      validator: validator,
      border: border,
      controller: controller,
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      padding: padding,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      textInputType: textInputType,
      isExpand: isExpand,
      fillColor: fillColor,
      filled: filled,
      style: style,
      maxLength: maxLength,
    );
  }

  // Custom Container
  static Widget customContainer({
    double? h,
    double? w,
    Widget? child,
    EdgeInsets? padding,
    EdgeInsets? margin,
    BoxConstraints? constraints,
    BorderRadius? borderRadius,
    Border? border,
    BoxShape? boxShape,
    VoidCallback? onTap,
    Color? color,
    List<BoxShadow>? boxShadow,
    Alignment? alignment,
    BlendMode? blendMode,
    Clip? clip,
    String? path,
  }) {
    return CustomContainer(
      h: h,
      w: w,
      margin: margin,
      constraints: constraints,
      color: color,
      padding: padding,
      border: border,
      borderRadius: borderRadius,
      onTap: onTap,
      boxShadow: boxShadow,
      alignment: alignment,
      boxShape: boxShape,
      blendMode: blendMode,
      clipBehaviour: clip,
      path: path,
      child: child,
    );
  }

  // Custom Back Button
  static Widget customCircleBackButton({Color? color}) {
    return CustomCircleBackButton(color: color);
  }

  // Custom Image View
  static Widget customImageView({
    String? path,
    ImageType? sourceType,
    double? height,
    double? width,
    BoxFit? fit,
  }) {
    return CustomImageView(
      path: path ?? '',
      sourceType: sourceType ?? ImageType.asset,
      height: height,
      width: width,
      fit: fit,
    );
  }

  // Custom Green Button
  static Widget customGreenButton({
    String? text,
    VoidCallback? onTap,
    TextStyle? style,
  }) {
    return CustomGreenButton(text: text, onTap: onTap, style: style);
  }

  // Custom White border button
  static Widget customWhiteBorderButton({
    required String buttonTitle,
    VoidCallback? onTap,
    required String path,
    TextStyle? style,
  }) {
    return CustomWhiteBorderButton(
      buttonTitle: buttonTitle,
      onTap: onTap,
      path: path,
      style: style,
    );
  }

  // Custom Appbar
  static PreferredSizeWidget customAppBar({
    Widget? leading,
    Widget? title,
    Color? bgColor,
    bool? isCenterTitle,
    double? bottomOpacity,
    double? elevation,
    double? scrollUnderElevation,
    bool? autoImplyLeading,
    double? height,
    List<Widget>? actions,
  }) {
    return CustomAppbar(
      leading: leading,
      title: title,
      bgColor: bgColor,
      isCenterTitle: isCenterTitle ?? true,
      bottomOpacity: bottomOpacity ?? 1.0,
      elevation: elevation ?? 0,
      scrollUnderElevation: scrollUnderElevation ?? 0,
      autoImplyLeading: autoImplyLeading ?? true,
      height: height ?? 60,
      actions: actions,
    );
  }

  // Custom text widget
  static Widget customText({
    String data = '',
    TextStyle? style,
    TextOverflow? overflow,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDecoration? textDecoration,
    Locale? locale,
    bool? softWrap,
    double? textScaleFactor,
    TextScaler? textScaler,
    int? maxLines,
    String? semanticsLabel,
    String? semanticsIdentifier,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
    Color? selectionColor,
    TextDirection? textDirection,
  }) {
    return CustomText(
      data: data,
      style: style,
      overflow: overflow,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDecoration: textDecoration,
      locale: locale,
      softWrap: softWrap,
      textScaleFactor: textScaleFactor,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      semanticsIdentifier: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
      textDirection: textDirection,
    );
  }

  // Custom Floating Action Button
  static Widget customFloatingActionButton({
    String? label,
    VoidCallback? onTap,
    Color? backgroundColor,
    String? toolTip,
    Widget? child,
    FabType fabType = FabType.normal, // ✅ Set default
  }) {
    return CustomFloatingButton(
      label: label,
      onTap: onTap,
      backgroundColor: backgroundColor,
      toolTip: toolTip,
      type: fabType,
      // ✅ This was missing
      child: child,
    );
  }

  //Custom Bottom Navigation Bar
  static Widget customBottomNavigationBar({
    List<BottomNavModel>? bottomNavList,
    int? currentIndex,
    ValueChanged<int>? onTap,
  }) {
    return CustomBottomNav(
      bottomNavList: bottomNavList ?? [],
      currentIndex: currentIndex ?? 0,
      onTap: onTap,
    );
  }

  // Custom Icon Widget
  static Widget customIconWidget({
    IconData? icon,
    double? size,
    Color? color,
    double? fill,
    BlendMode? blendMode,
    String? semanticLabel,
    double? opticalSize,
    List<Shadow>? shadows,
  }) {
    return CustomMaterialIcon(
      icon: icon,
      size: size,
      color: color,
      fill: fill,
      blendMode: blendMode,
      semanticLabel: semanticLabel,
      opticalSize: opticalSize,
      shadows: shadows,
    );
  }

  // Custom Can Copy Text
  static Widget customCanCopyText(String text) {
    return CustomCanCopy(text: text);
  }

  // Custom Playlist card
  static Widget customPlaylistCard() {
    return CustomPlaylistCard();
  }

  // Custom Animation Wrapper
  static Widget customAnimationWrapper({
    AnimationType? animationType,
    Duration? duration,
    Curve? curve,
    Widget? child,
  }) {
    return CustomAnimatedWrapper(
      animationType: animationType ?? AnimationType.fade,
      duration: duration ?? Duration(milliseconds: 800),
      curve: curve ?? Curves.easeInOut,
      child: child ?? Center(),
    );
  }

  // Custom Button
  static Widget customButton({String? label, VoidCallback? onTap}) {
    return CustomButton(label: label, onTap: onTap);
  }

  // static Widget customChatCard({UserModel? user,VoidCallback? onTap}) {
  //   return CustomChatCard(userModel: user,onTap: onTap,);
  // }

  static Widget customPopUpMenuBtm({
    List<String>? items,
    AnimationStyle? animationStyle,
    Color? boxColor,
    Offset? offset,
    Widget? eachChild,
    BorderRadius? borderRadius,
    PopupMenuPosition? popupMenuPosition,
    ShapeBorder? shapeBorder,

    void Function(String value)? onSelected,
    Icon? icon,
  }) {
    return CustomPopupMenuButton(
      items: items ?? const [],
      animationStyle: animationStyle,
      boxColor: boxColor,
      offset: offset,
      eachChild: eachChild,
      popupMenuPosition: popupMenuPosition,
      onSelected: onSelected ?? (v) {},
      icon: icon ?? Icon(Icons.more_vert),
      shapeBorder: shapeBorder,
    );
  }

  static Widget customCircleIcon({
    double? h,
    double? w,
    Border? border,
    Color? bgColor,
    IconData? iconData,
    double? iconSize,
    Color? iconColor,
    VoidCallback? onTap,
    EdgeInsets? padding,
  }) {
    return CustomCircleIcon(
      h: h,
      w: w,
      border: border,
      bgColor: bgColor,
      iconData: iconData ?? Icons.person,
      iconSize: iconSize,
      iconColor: iconColor,
      padding: padding,
      onTap: onTap,
    );
  }
}
