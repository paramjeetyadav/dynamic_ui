import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../data/model/form_model.dart';
import '../screens/cubit/form_view_model.dart';

class CaptureImageWidget {
  final Field field;
  final BuildContext context;
  CaptureImageWidget({required this.context, required this.field});

  Widget build() {
    return FormField(
      validator: (value) {
        if (field.isRequired) {
          if (context.read<FormResponseViewModel>().state.formResponse[field.metaInfo?.label ?? 'err']?.isEmpty ?? true) {
            return "This field is required";
          }
        }
        return null;
      },
      builder: (state) {
        final String label = field.metaInfo?.label ?? 'err';
        var imageList = context.watch<FormResponseViewModel>().state.formResponse[label] ?? [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: label,
                style: const TextStyle(fontSize: 16.0, color: Colors.black),
                children: [
                  TextSpan(text: field.isRequired ? " *" : "", style: const TextStyle(color: Colors.red)),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Visibility(
              visible: imageList.isNotEmpty,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: imageList.length,
                itemBuilder: (_, i) {
                  return Column(
                    children: [
                      Image.file(
                        File(imageList[i]),
                        height: 120,
                        errorBuilder: (context, error, stackTrace) {
                          return const Text("No image selected");
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          imageList.removeAt(i);
                          context.read<FormResponseViewModel>().setAnswer(label, imageList);
                        },
                        child: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
            Visibility(
              visible: imageList.length < (field.metaInfo?.noOfImagesToCapture ?? 1),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

                      if (pickedFile != null && context.mounted) {
                        File image = File(pickedFile.path);

                        String path = await createFolder(field.metaInfo?.savingFolder ?? 'Polaris');
                        path = "$path/Image_${DateTime.now().millisecondsSinceEpoch}.jpg";
                        await image.copy(path);
                        imageList.add(path);
                        if (context.mounted) context.read<FormResponseViewModel>().setAnswer(label, imageList);
                      }
                    },
                    child: const Text("Select Image", style: TextStyle(fontSize: 12, color: Colors.white)),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text("(${field.metaInfo?.noOfImagesToCapture ?? 1 - imageList.length} Remaining)",
                      style: const TextStyle(fontSize: 13, color: Colors.black)),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Future<String> createFolder(String folderName) async {
    Directory path = await getApplicationDocumentsDirectory();
    path = Directory("${path.path}/$folderName");
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if ((await path.exists())) {
      return path.path;
    } else {
      path.create();
      return path.path;
    }
  }
}
