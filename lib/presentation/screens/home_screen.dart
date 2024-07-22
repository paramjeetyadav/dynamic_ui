import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:polaris/presentation/screens/cubit/base_view_model.dart';
import 'package:polaris/presentation/widgets/text_widget.dart';

import '../../data/model/form_model.dart';
import '../../data/network/network_service.dart';
import '../../infrastructure/routes/route_names.dart';
import '../../infrastructure/utils/dialog_helper.dart';
import '../screens/cubit/sync_view_model.dart';
import '../widgets/common_card_widget.dart';
// import 'cubit/form_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _syncAnimController;
  late StreamController<NetworkStatus> _networkStream;
  @override
  void initState() {
    _syncAnimController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _syncAnimController.repeat(reverse: false);
        }
      });
    _networkStream = NetworkStatusService().networkStatusController;
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      initListener();
      // if (context.read<NetworkStatus>() == NetworkStatus.Online) {
      //   context.read<SyncViewModel>().syncData(context, true);
      // }
    });
    super.initState();
  }

  @override
  void dispose() {
    _syncAnimController.dispose();
    _networkStream.close();
    super.dispose();
  }

  void initListener() {
    _networkStream.stream.listen((event) {
      context.read<SyncViewModel>().syncData(context, event == NetworkStatus.Online);
    });
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 5,
        title: const Text("Polaris Smart Metering"),
        centerTitle: false,
        actions: [
          BlocBuilder<SyncViewModel, SyncState>(
            builder: (context, state) {
              if (state.isLoading) {
                _syncAnimController.forward();
              }
              if (!state.isLoading) {
                _syncAnimController.stop();
                _syncAnimController.reset();
              }
              context.read<SyncViewModel>().unSyncedCount();

              return Stack(
                children: [
                  IconButton(
                    onPressed: () async {
                      debugPrint("On TAP connection is ${context.read<BaseViewModel>().state.isConnected}");
                      if (context.read<NetworkStatus>() == NetworkStatus.Offline) {
                        DialogHelper(context: context)
                            .showFlushBar(title: "No Internet", message: "Please connect to internet!", type: FlushBarType.error);
                        return;
                      }

                      if (state.isLoading) return;

                      await context.read<SyncViewModel>().syncData(context, true);
                    },
                    icon: RotationTransition(
                      turns: Tween(begin: 0.0, end: 1.0).animate(_syncAnimController),
                      child: const Icon(
                        Icons.sync,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 9,
                    right: 9,
                    child: Container(
                      height: 14,
                      width: 14,
                      decoration: BoxDecoration(
                        // color: Colors.greenAccent,
                        color: kIsWeb
                            ? Colors.green
                            : context.watch<NetworkStatus>() == NetworkStatus.Online
                                ? Colors.green.shade600
                                : Colors.red,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Center(
                        child: TextWidget(
                          text: "${state.unSyncedData}",
                          color: Colors.white,
                          size: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<FormViewModel, FormDataState>(
            builder: (context, state) {
              return Visibility(
                visible: !state.isLoading,
                replacement: const RepaintBoundary(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.formList.length,
                  itemBuilder: (context, index) {
                    FormModel formModel = state.formList[index];
                    return CommonCardWidget(
                      formModel: formModel,
                      onTap: () {
                        context.goNamed(RouteName.form, pathParameters: {"form": formModel.formName ?? ''});
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
