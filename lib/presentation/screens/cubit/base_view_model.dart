import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/db/sqflite_helper.dart';

class BaseState {
  final bool isLoading;
  final bool isConnected;
  final String selectedLanguage;
  final int currentBottomIndex;
  final int unSyncedData;

  BaseState({this.isLoading = false, this.isConnected = false, this.selectedLanguage = "", this.currentBottomIndex = 0, this.unSyncedData = 0});

  BaseState copyWith({
    bool? isLoading,
    bool? isConnected,
    String? selectedLanguage,
    int? currentBottomIndex,
    int? unSyncedData,
  }) {
    return BaseState(
      isLoading: isLoading ?? this.isLoading,
      isConnected: isConnected ?? this.isConnected,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      currentBottomIndex: currentBottomIndex ?? this.currentBottomIndex,
      unSyncedData: unSyncedData ?? this.unSyncedData,
    );
  }
}

class BaseViewModel extends Cubit<BaseState> {
  BaseViewModel() : super(BaseState()); // Initialize with default state values as defined in BaseState

  void setCurrentBottomIndex(int index) {
    emit(state.copyWith(currentBottomIndex: index));
  }

  void setLanguage(String code) {
    emit(state.copyWith(selectedLanguage: code));
  }

  void setConnectionStatus(bool status) async {
    var data = await SqfLiteHelper().getUnSyncedResponses();
    int count = data.length;
    debugPrint("Setting connection $status");
    emit(state.copyWith(isConnected: status, unSyncedData: count));
  }

  void toggleLoading([bool? value]) {
    emit(state.copyWith(isLoading: value ?? !state.isLoading));
  }
}
