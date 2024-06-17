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

                if (pickedImage != null) {
                  state.didChange(pickedImage);
                }

              } catch (error) {
                debugPrint('Error picking image: $error');
              }
            }

            Future<void> generateImage() async {
              try {
                ImageGenerationService imageGenerationService = ImageGenerationService();
                final generatedImage = await imageGenerationService.generateImage("Dog riding a rocket!");

                if (generatedImage != null) {
                  state.didChange(generatedImage);
                }
              } catch (error) {
                debugPrint('Error generating image: $error');
              }
            }

            var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;

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
                              Column(
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
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: _pickImage,
                                      borderRadius: BorderRadius.circular(40),
                                      child: Text(
                                        'Upload Image',
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.onPrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: generateImage,
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
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: generateImage,
                                      borderRadius: BorderRadius.circular(40),
                                      child: Text(
                                        'Generate Image',
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.onPrimary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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

    String path = state.value!.path;
    
    if (path.startsWith('http') || path.startsWith('https')) {
      return NetworkImage(path);
    } else {
      return FileImage(File(path));
    }
  }
}