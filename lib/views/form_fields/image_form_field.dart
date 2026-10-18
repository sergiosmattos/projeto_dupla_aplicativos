import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageFormfield extends StatelessWidget {
  const ImageFormfield({
    super.key,
    required this.fallback,
    required this.imageHolder,
    required this.validator,
    required this.onTap,
  });
  final Image fallback;
  final XFile? imageHolder;
  final String? Function(XFile? value) validator;
  final Function(XFile? pickedImage) onTap;
  static final _picker = ImagePicker();

  Future<XFile?> pickImage() async {
    return await _picker.pickImage(source: ImageSource.gallery);
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Size size = MediaQuery.sizeOf(context);

    XFile? futureFile;

    return FormField<XFile>(
      validator: validator,
      builder: (state) {
        return Column(
          children: [
            ListTile(
              tileColor: colorScheme.primaryContainer,
              contentPadding: EdgeInsets.all(size.height * 0.025),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(size.width * 0.0325),
              ),
              title: const Text("Selecionar imagem..."),
              subtitle: Column(
                children: [
                  const Divider(),
                  SizedBox(height: size.width * 0.025),
                  Image(
                    height: size.height * 0.15,
                    image: (imageHolder != null)
                        ? FileImage(File(imageHolder!.path))
                        : fallback.image,
                  ),
                ],
              ),
              onTap: () async {
                futureFile = await pickImage();

                if (futureFile != null) {
                  state.didChange(futureFile);
                  onTap.call(futureFile);
                }
              },
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 10),
                child: Text(
                  state.errorText!,
                  style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontSize: 13,
                    color: Colors.red[700],
                    height: 0.5,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
