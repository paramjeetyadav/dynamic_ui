import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:polaris/domain/form_repo.dart';

import '../data/db/sqflite_helper.dart';
import '../data/model/form_model.dart';
import '../data/network/http_services.dart';
import '../infrastructure/utils/app_constants.dart';

class FormResponseRepository extends FormRepo {
  @override
  Future<List<FormModel>> getFormResponse([bool isOnline = false]) async {
    if (kIsWeb || isOnline) {
      return await getFormListFromAPI();
    }
    return await SqfLiteHelper().fetchFormResponse();
  }

  @override
  Future<FormModel?> getFormByName(String formName) async {
    List<FormModel?> forms = [];
    forms = await SqfLiteHelper().fetchFormResponse(formName);
    if (forms.isNotEmpty) {
      return forms.first;
    }
    throw Exception("No form found");
  }

  @override
  Future<List<FormModel>> getFormListFromAPI() async {
    var response = await NetworkApi.getDataApi(
      AppConstants.getFormAPI,
      isLogin: true,
    );

    var jsonBody = jsonDecode(response.body);

    return [FormModel.fromMap(jsonBody)];
  }

  @override
  Future<int> insertFormResponse(String formName, Map<String, dynamic> responses, [bool isOnline = false]) async {
    if (isOnline) {
      return await pushToServer([responses]);
    }
    await SqfLiteHelper().saveResponse(formName, responses);
    return 200;
  }

  @override
  Future<int> pushToServer(List<dynamic> responses) async {
    var res = await NetworkApi.postData(
      AppConstants.postFormAPI,
      {'data': responses},
    );
    return res.statusCode;
  }

  @override
  Future<void> syncFormResponse(List<Map<String, dynamic>> responses) async {
    await pushToServer(responses.map((e) => jsonDecode(e['response'])).toList());

    await SqfLiteHelper().updateSyncStatus(responses.map((e) => int.tryParse(e['id']?.toString() ?? "") ?? 0).toList());
  }
}
