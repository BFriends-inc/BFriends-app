import 'dart:io';
import 'package:bfriends_app/model/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bfriends_app/services/auth_service.dart';
import 'package:provider/provider.dart';

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

            final authService = Provider.of<AuthService>(context, listen: false);
            final user = authService.user;

            return Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey,
                      foregroundImage: _getForegroundImage(state, user),
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _pickImage,
                          borderRadius: BorderRadius.circular(40),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Icon(
                                Icons.upload,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
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

  static ImageProvider? _getForegroundImage(FormFieldState<XFile?> state, UserModel? user) {
    
    if (state.value == null && user == null) {
      return null;
    }
    else if(state.value == null && user != null) {
      return Image.network(user.avatarURL.toString()).image;
    }

    if (kIsWeb) {
      return NetworkImage(state.value!.path);
    } else {
      return FileImage(File(state.value!.path));
    }
  }
}

class EditImagePicker extends FormField<XFile?> {
  EditImagePicker({
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

            final authService = Provider.of<AuthService>(context, listen: false);
            final user = authService.user;

            return Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey,
                      foregroundImage: _getForegroundImage(state, user),
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _pickImage,
                          borderRadius: BorderRadius.circular(40),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Icon(
                                Icons.upload,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
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

  static ImageProvider? _getForegroundImage(FormFieldState<XFile?> state, UserModel? user) {
    
    if(state.value == null && user != null) {
      return Image.network(user.avatarURL.toString()).image;
    }

    if (kIsWeb) {
      return NetworkImage(state.value!.path);
    } else {
      return FileImage(File(state.value!.path));
    }
  }
}