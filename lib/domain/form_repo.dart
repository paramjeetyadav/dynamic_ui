import '../data/model/form_model.dart';

abstract class FormRepo {
  Future<List<FormModel>> getFormResponse([bool isOnline = false]);

  Future<FormModel?> getFormByName(String formName);

  Future<List<FormModel>> getFormListFromAPI();

  Future<int> insertFormResponse(String formName, Map<String, dynamic> responses, [bool isOnline = false]);

  Future<int> pushToServer(List<dynamic> responses);

  Future<void> syncFormResponse(List<Map<String, dynamic>> responses);
}
