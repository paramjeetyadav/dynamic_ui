import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polaris/presentation/screens/cubit/base_view_model.dart';
import 'package:polaris/presentation/screens/cubit/form_view_model.dart';
import 'package:polaris/presentation/screens/cubit/sync_view_model.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

import 'data/db/sqflite_helper.dart';
import 'data/network/network_service.dart';
import 'domain/form_repo_impl.dart';
import 'infrastructure/config/app_config.dart';
import 'infrastructure/routes/routes.dart';
import 'infrastructure/utils/theme_constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initializing the Database
  await SqfLiteHelper().initializeSqlDB();
  // Initializing the flavour
  Environment().initConfig();
  // Initializing WorkManager
  initializeWorkManager();
  runApp(MyApp());
}

// return current network status
Future<bool> _checkNetworkStatus() async {
  bool isOnline = false;
  try {
    final result = await InternetAddress.lookup('google.com');
    isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    isOnline = false;
  }

  return isOnline;
}

void initializeWorkManager() async {
  if (!kIsWeb) {
    Workmanager workManager = Workmanager();
    await workManager.initialize(
      callbackDispatcher,
      isInDebugMode: kDebugMode,
    );
    workManager.registerPeriodicTask("post_sync", "post_sync",
        frequency: const Duration(minutes: 10), constraints: Constraints(networkType: NetworkType.connected));
    workManager.registerPeriodicTask("photo_sync", "photo_sync",
        frequency: const Duration(minutes: 10), constraints: Constraints(networkType: NetworkType.connected));
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask(
    (taskName, inputData) async {
      if (!await _checkNetworkStatus()) return Future.value(false);
      switch (taskName) {
        case 'post_sync':
          await SyncViewModel().syncDataToServer();
          break;
        case 'photo_sync':
          await SyncViewModel().syncImageToServer();
          break;
      }
      return Future.value(true);
    },
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ThemeData myTheme = ThemeData(
    colorSchemeSeed: Colors.blueAccent,
    scaffoldBackgroundColor: Colors.grey,
    appBarTheme: const AppBarTheme(
      color: Colors.blueAccent,
      elevation: 5,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: ThemeConstant.formWidgetColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(ThemeConstant.formWidgetColor),
        textStyle: WidgetStateProperty.all(const TextStyle(color: Colors.white)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Adjust button shape
          ),
        ),
      ),
    ),
    cardTheme: CardTheme(
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => BaseViewModel()),
        BlocProvider(create: (_) => SyncViewModel()),
        BlocProvider(create: (_) => FormViewModel(formRepository: FormResponseRepository())),
        BlocProvider(create: (_) => FormResponseViewModel(formRepository: FormResponseRepository())),
        StreamProvider<NetworkStatus>(
          create: (context) => NetworkStatusService().networkStatusController.stream,
          initialData: NetworkStatus.Online,
        ),
      ],
      child: MaterialApp.router(
        theme: myTheme,
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter,
      ),
    );
  }
}
