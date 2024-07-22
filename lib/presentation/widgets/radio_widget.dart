import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/model/form_model.dart';
import '../../infrastructure/utils/theme_constant.dart';
import '../screens/cubit/form_view_model.dart';

class RadioWidget {
  final Field field;
  final BuildContext context;
  RadioWidget({required this.context, required this.field});

  Widget build() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: field.metaInfo?.label ?? "",
            style: const TextStyle(fontSize: 16.0, color: Colors.black),
            children: [
              TextSpan(text: field.isRequired ? " *" : "", style: const TextStyle(color: Colors.red)),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Column(
          children: field.metaInfo?.options?.map((e) {
                return GestureDetector(
                  onTap: () {
                    context.read<FormResponseViewModel>().setAnswer(field.metaInfo?.label ?? '', e);
                  },
                  child: Row(
                    children: [
                      Radio<String>(
                        value: e,
                        groupValue: context.watch<FormResponseViewModel>().state.formResponse[field.metaInfo?.label ?? ''],
                        onChanged: (value) {
                          context.read<FormResponseViewModel>().setAnswer(field.metaInfo?.label ?? '', value ?? '');
                        },
                        activeColor: ThemeConstant.formWidgetColor,
                      ),
                      Text(e),
                    ],
                  ),
                );
              }).toList() ??
              [],
        ),
      ],
    );
  }
}
