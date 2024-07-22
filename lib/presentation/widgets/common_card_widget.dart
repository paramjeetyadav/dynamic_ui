import 'package:flutter/material.dart';
import 'package:polaris/infrastructure/utils/theme_constant.dart';
import 'package:polaris/presentation/widgets/text_widget.dart';

import '../../data/model/form_model.dart';

class CommonCardWidget extends StatelessWidget {
  const CommonCardWidget({
    super.key,
    required this.formModel,
    this.onTap,
  });

  final FormModel formModel;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.white,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              border: Border.all(
                color: ThemeConstant.primaryColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8.0)),
          child: Row(
            children: [
              const SizedBox(
                width: 50,
                height: 50,
                child: Icon(
                  Icons.text_snippet_outlined,
                  color: ThemeConstant.primaryColor,
                  size: 35,
                ),
              ),
              const SizedBox(width: 10),
              Center(
                child: TextWidget(
                  text: formModel.formName ?? '',
                  size: 18,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.keyboard_arrow_right_sharp,
                size: 30,
                color: ThemeConstant.primaryColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
