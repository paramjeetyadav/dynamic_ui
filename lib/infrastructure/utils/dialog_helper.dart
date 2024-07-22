import 'package:another_flushbar/flushbar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:polaris/infrastructure/utils/theme_constant.dart';

enum FlushBarType { error, success, info, warning }

class DialogHelper {
  final BuildContext context;

  const DialogHelper({required this.context});

  showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const PopScope(
          canPop: false,
          child: AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  showSubmitDialog(
      {DialogType? dialogType,
      required Function() onPrimaryTap,
      String? title,
      Function()? onSecondaryTap,
      String? secondaryText,
      String? primaryText,
      String? description,
      bool? dismissOnBackKeyPress}) async {
    AwesomeDialog(
      context: context,
      title: title,
      desc: description,
      dialogType: dialogType ?? DialogType.info,
      dismissOnTouchOutside: false,
      btnCancel: onSecondaryTap == null
          ? null
          : ElevatedButton(
              onPressed: onSecondaryTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: ThemeConstant.formWidgetColor, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  secondaryText ?? "Cancel",
                  style: TextStyle(
                    color: ThemeConstant.formWidgetColor,
                  ),
                ),
              ),
            ),
      width: 500,
      btnOk: ElevatedButton(
        onPressed: onPrimaryTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeConstant.formWidgetColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            primaryText ?? "OK",
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      dismissOnBackKeyPress: dismissOnBackKeyPress ?? false,
    ).show();
  }

  showFlushBar({
    required title,
    String? message,
    required FlushBarType type,
    FlushbarPosition? position,
    double? barBlur,
    double? routeBlur,
    BorderRadius? borderRadius,
    EdgeInsets? margin,
    Offset? endOffset,
    FlushbarDismissDirection? dismissDirection,
  }) {
    Color leftBarIndicatorColor = Colors.green;
    switch (type) {
      case FlushBarType.error:
        leftBarIndicatorColor = Colors.red;
        break;
      case FlushBarType.info:
        leftBarIndicatorColor = ThemeConstant.formWidgetColor;
        break;
      case FlushBarType.success:
        leftBarIndicatorColor = Colors.green;
        break;
      case FlushBarType.warning:
        leftBarIndicatorColor = const Color.fromARGB(255, 253, 228, 0);
        break;
    }
    final size = MediaQuery.of(context).size;
    Flushbar(
      title: title,
      message: message ?? '',
      barBlur: barBlur ?? 10,
      backgroundColor: leftBarIndicatorColor,
      routeBlur: routeBlur ?? 30,
      flushbarPosition: position ?? FlushbarPosition.TOP,
      borderRadius: borderRadius ??
          const BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
      margin: margin ?? EdgeInsets.only(left: size.width * 0.01),
      endOffset: endOffset ?? const Offset(0, 0.23),
      dismissDirection: dismissDirection ?? FlushbarDismissDirection.VERTICAL,
      isDismissible: true,
      titleColor: Colors.white,
      messageColor: Colors.white,
      duration: const Duration(seconds: 2),
      leftBarIndicatorColor: leftBarIndicatorColor,
    ).show(context);
  }
}
