import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polaris/domain/form_repo_impl.dart';

import '../../../data/db/sqflite_helper.dart';
import '../../../data/model/form_model.dart';
import '../../../domain/form_repo.dart';
import '../../../infrastructure/utils/dialog_helper.dart';
import 'form_view_model.dart';

class SyncState {
  final bool isLoading;
  final int unSyncedData;

  const SyncState({required this.isLoading, required this.unSyncedData});

  SyncState copyWith({bool? isLoading, int? unSyncedData}) {
    return SyncState(
      isLoading: isLoading ?? this.isLoading,
      unSyncedData: unSyncedData ?? this.unSyncedData,
    );
  }
}

class SyncViewModel extends Cubit<SyncState> {
  SyncViewModel() : super(const SyncState(isLoading: false, unSyncedData: 0));

  void toggleLoading([bool? value]) {
    emit(state.copyWith(isLoading: value ?? !state.isLoading));
  }

  void unSyncedCount() async {
    var data = await SqfLiteHelper().getUnSyncedResponses();
    int count = data.length;
    emit(state.copyWith(unSyncedData: count));
  }

  Future<void> syncData(BuildContext context, [bool isOnline = false]) async {
    if (!isOnline) {
      await context.read<FormViewModel>().getFormResponses();
      return;
    }
    try {
      toggleLoading(true);
      await syncDataToServer();
      List<FormModel> forms = await FormResponseRepository().getFormResponse(true);
      if (forms.isNotEmpty) {
        await SqfLiteHelper().insertFormResponse(forms);
      }
      if (context.mounted) {
        await context.read<FormViewModel>().getFormResponses();
      }
      toggleLoading(false);
    } on SocketException {
      toggleLoading(false);
    } catch (e) {
      toggleLoading(false);
      if (context.mounted) {
        DialogHelper(context: context).showFlushBar(title: "Error", message: e.toString(), type: FlushBarType.error);
      }
    }
  }

  Future<void> syncDataWithoutFormSync(BuildContext context, [bool isOnline = false]) async {
    if (!isOnline) {
      return;
    }
    try {
      toggleLoading(true);
      await syncDataToServer();
      List<FormModel> forms = await FormResponseRepository().getFormResponse(true);
      if (forms.isNotEmpty) {
        await SqfLiteHelper().insertFormResponse(forms);
      }
      if (context.mounted) {
        await context.read<FormResponseViewModel>().getFormResponsesWithoutSync();
      }
      toggleLoading(false);
    } on SocketException {
      toggleLoading(false);
    } catch (e) {
      toggleLoading(false);
      if (context.mounted) {
        DialogHelper(context: context).showFlushBar(title: "Error", message: e.toString(), type: FlushBarType.error);
      }
    }
  }

  Future<void> syncDataToServer() async {
    try {
      var responseToBeSynced = await SqfLiteHelper().getUnSyncedResponses();
      if (responseToBeSynced.isEmpty) return;
      await FormResponseRepository().syncFormResponse(responseToBeSynced);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> syncImageToServer() async {
    try {
      var responseToBeSynced = await SqfLiteHelper().getUnSyncedResponses();
      var formDataList = await SqfLiteHelper().fetchFormResponse();
      for (var res in responseToBeSynced) {
        var responseData = jsonDecode(res['response']);
        var form = formDataList.firstWhere((element) => element.formName == res['form_name']);

        var imageFields = form.fields
                ?.where((element) => element.componentType?.fieldType == FieldType.captureImages)
                .map((e) => e.metaInfo?.label ?? 'err')
                .toList() ??
            [];
        List<String> images = [];
        for (var image in imageFields) {
          List<String> imageList = responseData[image] ?? [];
          images.addAll(imageList);
        }
      }
      // TODO: Implement image upload to S3
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

class FormViewModel extends Cubit<FormDataState> {
  final FormRepo formRepository;

  FormViewModel({required this.formRepository}) : super(const FormDataState());

  void toggleLoading([bool? value]) {
    emit(state.copyWith(isLoading: value ?? !state.isLoading));
  }

  Future<void> getFormResponses() async {
    toggleLoading(true);
    final formList = await formRepository.getFormResponse();
    emit(state.copyWith(formList: formList));
    toggleLoading(false);
  }
}

class FormDataState {
  final List<FormModel> formList;
  final bool isLoading;
  const FormDataState({
    this.formList = const [],
    this.isLoading = false,
  });

  FormDataState copyWith({
    List<FormModel>? formList,
    bool? isLoading,
  }) {
    return FormDataState(
      formList: formList ?? this.formList,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
