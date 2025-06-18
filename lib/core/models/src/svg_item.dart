import '../../app_ui/app_ui.dart';

class _SvgItem {
  final Alignment alignment;
  final Offset offset;
  final AnimationType animationType;
  final Color? c;

  _SvgItem({
    required this.alignment,
    required this.offset,
    required this.animationType,
    this.c,
  });
}

final svgItems = <_SvgItem>[
  _SvgItem(
    alignment: Alignment.topLeft,
    offset: Offset(10, 10),
    animationType: AnimationType.fade,
  ),
  _SvgItem(
    alignment: Alignment.topCenter,
    offset: Offset(0, 20),
    animationType: AnimationType.fadeScale,
  ),
  _SvgItem(
    alignment: Alignment.topRight,
    offset: Offset(-20, 10),
    animationType: AnimationType.scale,
  ),
  _SvgItem(
    alignment: Alignment.centerLeft,
    offset: Offset(20, 0),
    animationType: AnimationType.fade,
  ),
  _SvgItem(
    alignment: Alignment.center,
    offset: Offset(0, 0),
    animationType: AnimationType.scale,
  ),
  _SvgItem(
    alignment: Alignment.centerRight,
    offset: Offset(-20, 0),
    animationType: AnimationType.fade,
  ),
  _SvgItem(
    alignment: Alignment.bottomLeft,
    offset: Offset(20, -50),
    animationType: AnimationType.fadeScale,
    c: AppColors.hexEeeb.withAlpha(64).withAlpha(64),
  ),
  _SvgItem(
    alignment: Alignment.bottomCenter,
    offset: Offset(0, -60),
    animationType: AnimationType.scale,
    c: AppColors.hexEeeb.withAlpha(64),
  ),
  _SvgItem(
    alignment: Alignment.bottomRight,
    offset: Offset(-20, -50),
    animationType: AnimationType.fade,
    c: AppColors.hexEeeb.withAlpha(64),
  ),
  _SvgItem(
    alignment: Alignment.topLeft,
    offset: Offset(60, 80),
    animationType: AnimationType.fade,
    c: AppColors.hexEeeb.withAlpha(64),
  ),
  _SvgItem(
    alignment: Alignment.topRight,
    offset: Offset(-60, 80),
    animationType: AnimationType.fadeScale,
    c: AppColors.hexEeeb.withAlpha(64),
  ),
  _SvgItem(
    alignment: Alignment.centerLeft,
    offset: Offset(60, 30),
    animationType: AnimationType.fade,
    c: AppColors.hexEeeb.withAlpha(64),
  ),
  _SvgItem(
    alignment: Alignment.centerRight,
    offset: Offset(-60, 30),
    animationType: AnimationType.fadeScale,
    c: AppColors.hexEeeb.withAlpha(64),
  ),
  _SvgItem(
    alignment: Alignment.bottomLeft,
    offset: Offset(60, -100),
    animationType: AnimationType.fade,
  ),
  _SvgItem(
    alignment: Alignment.bottomRight,
    offset: Offset(-60, -100),
    animationType: AnimationType.fadeScale,
  ),
  _SvgItem(
    alignment: Alignment.center,
    offset: Offset(0, -100),
    animationType: AnimationType.fade,
  ),
];
