import 'dart:io';
import 'package:bfriends_app/services/image_generation_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends FormField<XFile?> {
  UserImagePicker({
    super.key,
    required void Function(XFile? pickedImage) onSave,
    required String? Function(XFile? pickedImage) super.validator,
    required BuildContext context,
  }) : super(
          onSaved: onSave,
          initialValue: null,
          builder: (FormFieldState<XFile?> state) {
            void _pickImage() async {
              try {
                final pickedImage = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 50,
                  maxWidth: 150,
                );

                if (pickedImage == null) {
                  return;
                }

                state.didChange(pickedImage);
              } catch (error) {
                debugPrint('Error picking image: $error');
              }
            }

            var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;
            ImageGenerationService imageGenerationService = ImageGenerationService();
            return Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: width,
                      height: height * 0.30,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(12),
                        image: state.value != null
                            ? DecorationImage(
                                image: _getForegroundImage(state)!,
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: _pickImage,
                                  borderRadius: BorderRadius.circular(40),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: _pickImage,
                                          borderRadius: BorderRadius.circular(40),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.upload,
                                              color: Theme.of(context).colorScheme.onPrimary,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Upload Image',
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.onPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: _pickImage,
                                  borderRadius: BorderRadius.circular(40),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () => imageGenerationService.generateImage("Dog riding a rocket!"),
                                          borderRadius: BorderRadius.circular(40),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.auto_awesome,
                                              color: Theme.of(context).colorScheme.onPrimary,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Generate Image',
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.onPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      state.errorText!,
                      style:
                          Theme.of(context).inputDecorationTheme.prefixStyle ??
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                    ),
                  ),
              ],
            );
          },
        );

  static ImageProvider? _getForegroundImage(FormFieldState<XFile?> state) {
    if (state.value == null) {
      return null;
    }

    if (kIsWeb) {
      return NetworkImage(state.value!.path);
    } else {
      return FileImage(File(state.value!.path));
    }
  }
}