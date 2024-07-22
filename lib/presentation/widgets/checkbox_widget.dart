import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/model/form_model.dart';
import '../../infrastructure/utils/theme_constant.dart';
import '../screens/cubit/form_view_model.dart';

class CheckboxWidget {
  final Field field;
  final BuildContext context;
  CheckboxWidget({required this.context, required this.field});

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
                    _onChange(e);
                  },
                  child: Row(
                    children: [
                      Checkbox(
                        value: context.watch<FormResponseViewModel>().state.formResponse[field.metaInfo?.label ?? '']?.contains(e) ?? false,
                        onChanged: (value) {
                          _onChange(e);
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

  void _onChange(String e) {
    dynamic previousAnswers = context.read<FormResponseViewModel>().state.formResponse[field.metaInfo?.label ?? ''] ?? [];
    if (!previousAnswers.contains(e)) {
      previousAnswers.add(e);
    } else {
      previousAnswers.remove(e);
    }
    context.read<FormResponseViewModel>().setAnswer(field.metaInfo?.label ?? '', previousAnswers);
  }
}
