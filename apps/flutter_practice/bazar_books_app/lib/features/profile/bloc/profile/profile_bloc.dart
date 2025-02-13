import 'dart:io';

import 'package:bazar_books_app/features/auth/data/auth_repository_impl.dart';
import 'package:bazar_books_app/features/profile/bloc/profile/profile_event.dart';
import 'package:bazar_books_app/features/profile/bloc/profile/profile_state.dart';
import 'package:bazar_books_app/features/profile/data/profile_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepositoryImpl authRepository;
  final ImagePicker imagePicker;
  final ProfileRepository profileRepository;

  ProfileBloc(
      {required this.authRepository,
      required this.imagePicker,
      required this.profileRepository})
      : super(MyAccountInitialState()) {
    on<FetchUserInfoEvent>(_onFetchUserInfo);
    on<ChangeAvatarEvent>(_onChangeAvatar);
  }

  Future<void> _onFetchUserInfo(
      FetchUserInfoEvent event, Emitter<ProfileState> emit) async {
    try {
      emit(MyAccountLoadingState());
      final user = await authRepository.getCurrentUser();
      final avatar = await profileRepository.getAvatar();

      emit(ProfileLoadedState(user!, avatar: avatar));
    } catch (e) {
      emit(ProfileErrorState('Failed to load profile: $e'));
    }
  }

  Future<void> _onChangeAvatar(
      ChangeAvatarEvent event, Emitter<ProfileState> emit) async {
    try {
      emit(AvatarLoadingState());

      final hasPermission = await _checkAndRequestPermission(event.source);
      if (!hasPermission) {
        emit(ProfileErrorState('Permission denied'));
        return;
      }

      final pickedFile = await imagePicker.pickImage(source: event.source);

      if (pickedFile != null) {
        final avatar = File(pickedFile.path);
        await profileRepository.saveAvatar(avatar);

        final user = await authRepository.getCurrentUser();
        emit(ProfileLoadedState(
          user!,
          avatar: avatar,
        ));
      } else {
        final user = await authRepository.getCurrentUser();
        final avatar = await profileRepository.getAvatar();
        emit(ProfileLoadedState(user!, avatar: avatar));
      }
    } catch (e) {
      emit(ProfileErrorState('Failed to change avatar: $e'));
    }
  }

  Future<bool> _checkAndRequestPermission(ImageSource source) async {
    if (source == ImageSource.camera) {
      final cameraStatus = await Permission.camera.request();
      if (cameraStatus.isPermanentlyDenied) {
        return false;
      }
      return cameraStatus.isGranted;
    } else if (source == ImageSource.gallery) {
      final galleryStatus = await Permission.photos.request();

      if (galleryStatus == PermissionStatus.limited) {
        return true;
      }

      if (galleryStatus.isPermanentlyDenied) {
        return false;
      }

      return galleryStatus.isGranted;
    }
    return false;
  }
}
