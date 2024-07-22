import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polaris/domain/form_repo.dart';

import '../../../data/model/form_model.dart';
import '../../../data/network/network_service.dart';
import '../../../infrastructure/utils/dialog_helper.dart';

enum FieldType { editText, checkBoxes, dropDown, radioGroup, captureImages }

extension FieldTypeExtension on String {
  FieldType get fieldType {
    switch (this) {
      case "EditText":
        return FieldType.editText;
      case "CheckBoxes":
        return FieldType.checkBoxes;
      case "DropDown":
        return FieldType.dropDown;
      case "RadioGroup":
        return FieldType.radioGroup;
      case "CaptureImages":
        return FieldType.captureImages;
      default:
        return FieldType.editText;
    }
  }
}

class FormResponseState {
  final List<FormModel> formList;
  final FormModel? currentForm;
  final bool isLoading;
  final List<GlobalKey> widgetKeyList;
  final Map<String, dynamic> formResponse;

  const FormResponseState({
    this.formList = const [],
    this.currentForm,
    this.isLoading = false,
    this.widgetKeyList = const [],
    this.formResponse = const {},
  });

  FormResponseState copyWith({
    List<FormModel>? formList,
    FormModel? currentForm,
    bool? isLoading,
    List<GlobalKey>? widgetKeyList,
    Map<String, dynamic>? formResponse,
  }) {
    return FormResponseState(
      formList: formList ?? this.formList,
      currentForm: currentForm ?? this.currentForm,
      isLoading: isLoading ?? this.isLoading,
      widgetKeyList: widgetKeyList ?? this.widgetKeyList,
      formResponse: formResponse ?? this.formResponse,
    );
  }
}

class FormResponseViewModel extends Cubit<FormResponseState> {
  final FormRepo formRepository;

  FormResponseViewModel({required this.formRepository}) : super(const FormResponseState());

  void setAnswer(String key, dynamic value) {
    final newFormResponse = Map<String, dynamic>.from(state.formResponse)..[key] = value;
    emit(state.copyWith(formResponse: newFormResponse));
  }

  void clearAnswers() {
    emit(state.copyWith(formResponse: {}));
  }

  void toggleLoading([bool? value]) {
    emit(state.copyWith(isLoading: value ?? !state.isLoading));
  }

  // Future<void> getFormResponses() async {
  //   toggleLoading(true);
  //   final formList = await formRepository.getFormResponse();
  //   emit(state.copyWith(formList: formList));
  //   toggleLoading(false);
  // }

  Future<void> getFormResponsesWithoutSync() async {
    final formList = await formRepository.getFormResponse();
    state.copyWith(formList: formList);
  }

  Future<void> getFormByName(String name, BuildContext context) async {
    try {
      emit(state.copyWith(widgetKeyList: []));
      toggleLoading(true);
      final currentForm = await formRepository.getFormByName(name);
      final widgetKeyList = List.generate(currentForm?.fields?.length ?? 0, (index) => GlobalKey());
      emit(state.copyWith(currentForm: currentForm, widgetKeyList: widgetKeyList));
      toggleLoading(false);
    } catch (e) {
      toggleLoading(false);
      if (context.mounted) {
        DialogHelper(context: context).showFlushBar(title: "Error", message: e.toString(), type: FlushBarType.error);
      }
    }
  }

  Future<void> saveAnswerToDb(BuildContext context) async {
    try {
      DialogHelper(context: context).showLoadingDialog();
      int statusCode = await formRepository.insertFormResponse(
        state.currentForm?.formName ?? "",
        state.formResponse,
        context.read<NetworkStatus>() == NetworkStatus.Online,
      );
      bool success = (statusCode == 200 || statusCode == 201);

      if (context.mounted) {
        Navigator.pop(context);
        DialogHelper(context: context).showSubmitDialog(
          title: success ? "Success" : "Error",
          description: context.read<NetworkStatus>() == NetworkStatus.Online
              ? (success ? "Form submitted successfully" : "Something went wrong")
              : "Form Saved to Local DB",
          dialogType: success ? DialogType.success : DialogType.error,
          onPrimaryTap: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        DialogHelper(context: context).showFlushBar(title: "Error", message: e.toString(), type: FlushBarType.error);
      }
    }
  }
}
