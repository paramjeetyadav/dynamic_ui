import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/form_model.dart';
import '../screens/cubit/form_view_model.dart';

class EditTextWidget {
  final Field field;
  final BuildContext context;
  EditTextWidget({required this.context, required this.field});

  Widget build() {
    RegExp numRegex = RegExp("^\\d+\\.?\\d*");

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
        TextFormField(
          cursorColor: Colors.black,
          onChanged: (_) {
            context.read<FormResponseViewModel>().setAnswer(field.metaInfo?.label ?? '', _);
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (_) {
            if (field.isRequired) {
              if (_?.isEmpty ?? true) {
                return "This field is required";
              }
            }
            return null;
          },
          keyboardType: field.isNumeric ? TextInputType.number : null,
          inputFormatters: field.isNumeric ? [FilteringTextInputFormatter.allow(numRegex)] : null,
          decoration: InputDecoration(
            hintText: "Enter ${field.metaInfo?.label}",
            hintStyle: TextStyle(
              color: Colors.grey.withOpacity(0.8),
              fontSize: 14,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: Colors.black),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      ],
    );
  }
}
