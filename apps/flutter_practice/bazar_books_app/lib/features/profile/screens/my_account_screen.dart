import 'dart:io';

import 'package:bazar_books_app/features/profile/bloc/profile/profile_bloc.dart';
import 'package:bazar_books_app/features/profile/bloc/profile/profile_event.dart';
import 'package:bazar_books_app/features/profile/bloc/profile/profile_state.dart';
import 'package:bazar_books_design/core/core.dart';
import 'package:bazar_books_design/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          context.bazS.generalTitleMyAccount,
          style: context.textTheme.titleLarge?.copyWith(
            fontSize: context.fontSize(SizeType.m),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const CustomAvatarWidget(),
              const SizedBox(height: 24),
              BlocBuilder<ProfileBloc, ProfileState>(
                buildWhen: (previous, current) =>
                    current is ProfileLoadedState ||
                    current is ProfileErrorState,
                builder: (context, state) {
                  if (state is AvatarLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ProfileErrorState) {
                    return _buildPermissionDeniedUI(context, state.message);
                  }

                  if (state is ProfileLoadedState) {
                    return _buildProfileInfo(context, state);
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildPermissionDeniedUI(BuildContext context, String message) {
  return Column(
    children: [
      const CircleAvatar(
        radius: 50,
        child: Icon(Icons.person),
      ),
      const SizedBox(height: 16),
      Text(
        message,
        style: const TextStyle(color: Colors.red),
      ),
      const SizedBox(height: 16),
      ElevatedButton(
        onPressed: () async {
          final opened = await openAppSettings();
          if (!opened) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Could not open settings')),
            );
          }
        },
        child: const Text('Open Settings'),
      ),
    ],
  );
}

Widget _buildProfileInfo(BuildContext context, ProfileLoadedState state) {
  final user = state.user;
  return Column(
    children: [
      BazUiInfoDisplay(
        label: context.bazS.generalTitleName,
        value: user.name ?? Constants.titleDefault,
      ),
      const SizedBox(height: 16),
      BazUiInfoDisplay(
        label: context.bazS.signInPageEmail,
        value: user.email ?? Constants.titleDefault,
      ),
      const SizedBox(height: 16),
      BazUiInfoDisplay(
        label: context.bazS.phoneNumber,
        value: user.phoneNumber ?? context.bazS.noPhone,
        icon: BazUiBuiltInImage.icPhoneOutline(),
      ),
      const SizedBox(height: 16),
      BazUiInfoDisplay(
        label: context.bazS.signInPagePassword,
        value: '••••••••',
        trailing: const Icon(Icons.visibility_off, color: Colors.grey),
      ),
      const SizedBox(height: 32),
      SizedBox(
        width: double.infinity,
        child: BazUiElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
              context.colorScheme.secondaryContainer,
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(200)),
            ),
          ),
          onPressed: () {},
          text: context.bazS.saveChangesTtile,
        ),
      ),
    ],
  );
}

class CustomAvatarWidget extends StatelessWidget {
  const CustomAvatarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoadedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message ?? context.bazS.updatedAvatarSuccessfully,
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is AvatarLoadingState) {
          return const CircularProgressIndicator();
        }

        if (state is ProfileErrorState) {
          return _buildErrorAvatar(context, state.message);
        }

        if (state is ProfileLoadedState) {
          return _buildAvatarWithActions(context, state.avatar);
        }

        return const CircularProgressIndicator();
      },
    );
  }

  Widget _buildErrorAvatar(BuildContext context, String message) {
    return Column(
      children: [
        const CircleAvatar(radius: 50, child: Icon(Icons.person)),
        const SizedBox(height: 16),
        Text(message, style: const TextStyle(color: Colors.red)),
      ],
    );
  }

  Widget _buildAvatarWithActions(BuildContext context, File? avatar) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: avatar != null ? FileImage(avatar) : null,
          child: avatar == null ? const Icon(Icons.person, size: 50) : null,
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => _showImagePickerModal(context),
          child: Text(
            context.bazS.changePictureTtile,
            style: const TextStyle(
              color: Color.fromARGB(255, 175, 144, 180),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  void _showImagePickerModal(BuildContext context) {
    final profileBloc = context.read<ProfileBloc>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(context.bazS.selectFromGallery),
              onTap: () {
                Navigator.pop(context);
                profileBloc.add(ChangeAvatarEvent(source: ImageSource.gallery));
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(context.bazS.captureNewPhoto),
              onTap: () {
                Navigator.pop(context);
                profileBloc.add(ChangeAvatarEvent(source: ImageSource.camera));
              },
            ),
          ],
        );
      },
    );
  }
}
