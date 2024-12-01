import 'package:bazar_books_app/di.dart';
import 'package:bazar_books_app/features/auth/data/auth_repository_impl.dart';
import 'package:bazar_books_app/features/profile/bloc/profile_bloc.dart';
import 'package:bazar_books_app/features/profile/bloc/profile_event.dart';
import 'package:bazar_books_app/features/profile/bloc/profile_state.dart';
import 'package:bazar_books_design/bazar_books_design.dart';
import 'package:bazar_books_design/constants.dart';
import 'package:bazar_books_design/core/responsive/size_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
          title: const Text(
            'Profile',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
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
              return Column(
                children: [
                  const Divider(height: 1),
                  // Profile Header
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 16),
                    child: Row(
                      children: [
                        // Profile Image
                        CircleAvatar(
                          radius: 30.0.r,
                          backgroundImage: NetworkImage(
                            scale: 200,
                            user.avatarUrl ?? Constants.imgUrlDefault,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // User Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name ?? 'No Name',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user.phoneNumber ?? 'No Phone Number',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        // Logout Button
                        GestureDetector(
                          onTap: () {
                            // Handle logout action
                          },
                          child: const Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  // Menu Options
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: ListView(
                        children: [
                          MenuItem(
                            icon: Icons.person,
                            title: 'My Account',
                            onTap: () {
                              // Navigate to My Account screen
                              context.go(
                                '${RoutePaths.profile}/${RoutePaths.account}',
                              );
                            },
                          ),
                          const MenuItem(
                            icon: Icons.location_on,
                            title: 'Address',
                          ),
                          const MenuItem(
                            icon: Icons.local_offer,
                            title: 'Offers & Promos',
                          ),
                          const MenuItem(
                            icon: Icons.favorite,
                            title: 'Your Favorites',
                          ),
                          const MenuItem(
                            icon: Icons.history,
                            title: 'Order History',
                          ),
                          const MenuItem(
                            icon: Icons.help,
                            title: 'Help Center',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return const Center(child: Text('Unknown State'));
          },
        ),
      ),
    );
  }
}
