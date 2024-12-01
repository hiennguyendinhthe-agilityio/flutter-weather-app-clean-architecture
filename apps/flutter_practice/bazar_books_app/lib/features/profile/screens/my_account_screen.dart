import 'package:bazar_books_app/di.dart';
import 'package:bazar_books_app/features/auth/data/auth_repository_impl.dart';
import 'package:bazar_books_app/features/profile/bloc/profile_bloc.dart';
import 'package:bazar_books_app/features/profile/bloc/profile_event.dart';
import 'package:bazar_books_app/features/profile/bloc/profile_state.dart';
import 'package:bazar_books_design/constants.dart';
import 'package:bazar_books_design/core/responsive/size_extension.dart';
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
          title: const Text(
            'My Account',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<ProfileBloc, MyAccountState>(
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
                              child: const Text(
                                'Change Picture',
                                style: TextStyle(
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
                        label: 'Name',
                        value: user.name ?? 'No Name',
                      ),
                      const SizedBox(height: 16),
                      // Display Email
                      BazUiInfoDisplay(
                        label: 'Email',
                        value: user.email ?? 'No Email',
                      ),
                      const SizedBox(height: 16),
                      // Display Phone Number
                      BazUiInfoDisplay(
                        label: 'Phone Number',
                        value: user.phoneNumber ?? 'No Phone Number',
                        icon: const Icon(Icons.phone, color: Colors.purple),
                      ),
                      const SizedBox(height: 16),
                      // Display Password
                      const BazUiInfoDisplay(
                        label: 'Password',
                        value: '••••••••',
                        trailing:
                            Icon(Icons.visibility_off, color: Colors.grey),
                      ),
                      const SizedBox(height: 32),
                      // Save Changes Button
                      SizedBox(
                        width: double.infinity,
                        child: BazUiElevatedButton(
                          onPressed: () {}, // Handle save changes
                          text: 'Save Changes',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return const Center(child: Text('Unknown State'));
          },
        ),
      ),
    );
  }
}
