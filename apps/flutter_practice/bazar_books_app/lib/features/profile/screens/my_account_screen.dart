import 'package:bazar_books_app/di.dart';
import 'package:bazar_books_app/features/auth/data/auth_repository_impl.dart';
import 'package:bazar_books_app/features/profile/bloc/profile_bloc.dart';
import 'package:bazar_books_app/features/profile/bloc/profile_event.dart';
import 'package:bazar_books_app/features/profile/bloc/profile_state.dart';
import 'package:bazar_books_design/constants.dart';
import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:bazar_books_design/core/responsive/size_extension.dart';
import 'package:bazar_books_design/core/utils/size_type.dart';
import 'package:bazar_books_design/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = getIt<AuthRepositoryImpl>();
    return BlocProvider(
      create: (context) => ProfileBloc(authRepository)
        ..add(
          FetchUserInfoEvent(),
        ),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context); // Handle back button press
            },
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
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is MyAccountLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProfileErrorState) {
              return Center(child: Text(state.message));
            }

            if (state is ProfileLoadedState) {
              final user = state.user;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Profile picture and change button
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50.0.r,
                              backgroundImage: NetworkImage(
                                scale: 200,
                                user.avatarUrl ?? Constants.imgUrlDefault,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {}, // Handle change picture
                              child: Text(
                                context.bazS.changePictureTtile,
                                style: const TextStyle(
                                  color: Colors.purple,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Display Name
                      BazUiInfoDisplay(
                        label: context.bazS.generalTitleName,
                        value: user.name ?? Constants.titleDefault,
                      ),
                      const SizedBox(height: 16),
                      // Display Email
                      BazUiInfoDisplay(
                        label: context.bazS.signInPageEmail,
                        value: user.email ?? Constants.titleDefault,
                      ),
                      const SizedBox(height: 16),
                      // Display Phone Number
                      BazUiInfoDisplay(
                        label: context.bazS.phoneNumber,
                        value: user.phoneNumber ?? context.bazS.noPhone,
                        icon: BazUiBuiltInImage.icPhoneOutline(),
                      ),
                      const SizedBox(height: 16),
                      // Display Password
                      BazUiInfoDisplay(
                        label: context.bazS.signInPagePassword,
                        value: '••••••••',
                        trailing: const Icon(Icons.visibility_off,
                            color: Colors.grey),
                      ),
                      const SizedBox(height: 32),
                      // Save Changes Button
                      SizedBox(
                        width: double.infinity,
                        child: BazUiElevatedButton(
                          onPressed: () {}, // Handle save changes
                          text: context.bazS.saveChangesTtile,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Center(
                child: Text(
              context.bazS.errorUnknown,
            ));
          },
        ),
      ),
    );
  }
}
