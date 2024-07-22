// To parse this JSON data, do
//
//     final formResponseModel = formResponseModelFromJson(jsonString);

import 'dart:convert';

FormModel formResponseModelFromJson(String str) => FormModel.fromJson(json.decode(str));

String formResponseModelToJson(FormModel data) => json.encode(data.toJson());

class FormModel {
  final String? formName;
  final List<Field>? fields;

  FormModel({
    this.formName,
    this.fields,
  });

  FormModel copyWith({
    String? formName,
    List<Field>? fields,
  }) =>
      FormModel(
        formName: formName ?? this.formName,
        fields: fields ?? this.fields,
      );

  factory FormModel.fromMap(Map<String, dynamic> json) => FormModel(
        formName: json["form_name"],
        fields: json["fields"] == null ? [] : List<Field>.from(json["fields"].map((x) => Field.fromJson(x))),
      );

  factory FormModel.fromJson(Map<String, dynamic> json) => FormModel(
        formName: json["form_name"],
        fields: json["fields"] == null ? [] : List<Field>.from(jsonDecode(json["fields"]?.toString() ?? '[]').map((x) => Field.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "form_name": formName,
        "fields": jsonEncode(fields == null ? [] : List<dynamic>.from(fields!.map((x) => x.toJson()))),
      };
}

class Field {
  final MetaInfo? metaInfo;
  final String? componentType;

  Field({
    this.metaInfo,
    this.componentType,
  });

  Field copyWith({
    MetaInfo? metaInfo,
    String? componentType,
  }) =>
      Field(
        metaInfo: metaInfo ?? this.metaInfo,
        componentType: componentType ?? this.componentType,
      );

  factory Field.fromJson(Map<String, dynamic> json) => Field(
        metaInfo: json["meta_info"] == null ? null : MetaInfo.fromJson(json["meta_info"]),
        componentType: json["component_type"],
      );

  Map<String, dynamic> toJson() => {
        "meta_info": metaInfo?.toJson(),
        "component_type": componentType,
      };

  bool get isNumeric => metaInfo?.componentInputType == 'INTEGER';
  bool get isRequired => metaInfo?.mandatory == 'yes';
}

class MetaInfo {
  final String? label;
  final String? componentInputType;
  final String? mandatory;
  final List<String>? options;
  final int? noOfImagesToCapture;
  final String? savingFolder;

  MetaInfo({
    this.label,
    this.componentInputType,
    this.mandatory,
    this.options,
    this.noOfImagesToCapture,
    this.savingFolder,
  });

  MetaInfo copyWith({
    String? label,
    String? componentInputType,
    String? mandatory,
    List<String>? options,
    int? noOfImagesToCapture,
    String? savingFolder,
  }) =>
      MetaInfo(
        label: label ?? this.label,
        componentInputType: componentInputType ?? this.componentInputType,
        mandatory: mandatory ?? this.mandatory,
        options: options ?? this.options,
        noOfImagesToCapture: noOfImagesToCapture ?? this.noOfImagesToCapture,
        savingFolder: savingFolder ?? this.savingFolder,
      );

  factory MetaInfo.fromJson(Map<String, dynamic> json) => MetaInfo(
        label: json["label"],
        componentInputType: json["component_input_type"],
        mandatory: json["mandatory"],
        options: json["options"] == null ? [] : List<String>.from(json["options"]!.map((x) => x)),
        noOfImagesToCapture: json["no_of_images_to_capture"],
        savingFolder: json["saving_folder"],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "component_input_type": componentInputType,
        "mandatory": mandatory,
        "options": options == null ? [] : List<dynamic>.from(options!.map((x) => x)),
        "no_of_images_to_capture": noOfImagesToCapture,
        "saving_folder": savingFolder,
      };
}
