import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/model/form_model.dart';
import '../screens/cubit/form_view_model.dart';

class DropdownWidget {
  final Field field;
  final BuildContext context;
  DropdownWidget({required this.context, required this.field});

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
        DropdownButtonFormField<String>(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: Colors.black),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          items: field.metaInfo?.options?.map((e) {
            return DropdownMenuItem<String>(
              value: e,
              child: Text(
                e,
                style: const TextStyle(fontSize: 14),
              ),
            );
          }).toList(),
          onChanged: (value) {
            context.read<FormResponseViewModel>().setAnswer(field.metaInfo?.label ?? '', value ?? '');
          },
          validator: (value) {
            if (field.isRequired) {
              if (value?.isEmpty ?? true) {
                return "This field is required";
              }
            }
            return null;
          },
        ),
      ],
    );
  }
}
