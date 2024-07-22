import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polaris/presentation/widgets/checkbox_widget.dart';
import 'package:polaris/presentation/widgets/dropdown_widget.dart';
import 'package:polaris/presentation/widgets/edit_text_widget.dart';
import 'package:polaris/presentation/widgets/radio_widget.dart';

import '../../data/model/form_model.dart';
import '../widgets/capture_image_widget.dart';
import 'cubit/form_view_model.dart';

class DynamicFormScreen extends StatefulWidget {
  final String formName;
  const DynamicFormScreen({super.key, required this.formName});

  @override
  State<DynamicFormScreen> createState() => _DynamicFormScreenState();
}

class _DynamicFormScreenState extends State<DynamicFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  int index = 0;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<FormResponseViewModel>().clearAnswers();
      context.read<FormResponseViewModel>().getFormByName(widget.formName, context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.formName),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: ElevatedButton(
              onPressed: () {
                if (!_formKey.currentState!.validate()) {
                  List<Field> allFields = context.read<FormResponseViewModel>().state.currentForm?.fields ?? [];

                  int emptyRequiredFields = allFields.indexWhere((element) =>
                      element.isRequired &&
                      (context.read<FormResponseViewModel>().state.formResponse[element.metaInfo?.label ?? '']?.isEmpty ?? true));

                  if (emptyRequiredFields >= 0) {
                    RenderBox? box = context.read<FormResponseViewModel>().state.widgetKeyList[emptyRequiredFields].currentContext?.findRenderObject()
                        as RenderBox?;
                    if (box != null) {
                      Offset position = box.localToGlobal(Offset.zero);
                      _scrollController.animateTo(
                        position.dy,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                      );
                    }
                  }
                  return;
                }
                context.read<FormResponseViewModel>().saveAnswerToDb(context);
              },
              child: const Text("Submit", style: TextStyle(fontSize: 14, color: Colors.white)),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: double.maxFinite,
          width: double.maxFinite,
          child: Form(
            key: _formKey,
            child: BlocBuilder<FormResponseViewModel, FormResponseState>(
              builder: (context, state) {
                // _keys.clear();
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: state.currentForm?.fields?.map((e) => buildField(e, state)).toList() ?? [],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildField(Field e, FormResponseState model) {
    Widget widget = generateWidget(e);

    GlobalKey key = model.widgetKeyList[model.currentForm?.fields?.indexOf(e) ?? 0];

    return Padding(
      key: key,
      padding: const EdgeInsets.only(bottom: 10),
      child: widget,
    );
  }

  Widget generateWidget(Field field) {
    switch (field.componentType!.fieldType) {
      case FieldType.editText:
        return EditTextWidget(field: field, context: context).build();
      case FieldType.checkBoxes:
        return CheckboxWidget(context: context, field: field).build();
      case FieldType.dropDown:
        return DropdownWidget(context: context, field: field).build();
      case FieldType.radioGroup:
        return RadioWidget(context: context, field: field).build();
      case FieldType.captureImages:
        return CaptureImageWidget(context: context, field: field).build();
    }
  }
}
