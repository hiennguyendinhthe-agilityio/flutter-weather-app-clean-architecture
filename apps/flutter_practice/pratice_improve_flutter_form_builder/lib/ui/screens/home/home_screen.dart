import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pratice_improve_flutter_form_builder/data/models/auth_model/api_user.dart';
import 'package:pratice_improve_flutter_form_builder/service/user_service.dart';
import 'package:pratice_improve_flutter_form_builder/ui/widgets/form_field/custom_text_form_field.dart';

import '../../../controllers/application_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late Future<ApiUser> futureApiUser;
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    futureApiUser = UserService().fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Get.find<ApplicationController>().logout();
            },
          ),
        ],
      ),
      body: FutureBuilder<ApiUser>(
        future: futureApiUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final user = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFormField(
                      name: 'name',
                      labelText: 'Name',
                      initialValue: user.name,
                      isRequired: true,
                      isEnabled: isEditMode,
                      onChanged: (value) {
                        user.name = value;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      name: 'email',
                      labelText: 'Email',
                      initialValue: user.email,
                      isRequired: true,
                      isEnabled: isEditMode,
                      onChanged: (value) {
                        user.email = value;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      name: 'phoneNumber',
                      labelText: 'Phone Number',
                      initialValue: user.phoneNumber,
                      isRequired: true,
                      isEnabled: isEditMode,
                      onChanged: (value) {
                        user.phoneNumber = value;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      name: 'personalWebsite',
                      labelText: 'Personal Website',
                      initialValue: user.personalWebsite,
                      isEnabled: isEditMode,
                      onChanged: (value) {
                        user.personalWebsite = value;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      name: 'portfolioUrl',
                      labelText: 'Portfolio URL',
                      initialValue: user.portfolioUrl,
                      isEnabled: isEditMode,
                      onChanged: (value) {
                        user.portfolioUrl = value;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      name: 'coverLetter',
                      labelText: 'Cover Letter',
                      initialValue: user.coverLetter,
                      isEnabled: isEditMode,
                      onChanged: (value) {
                        user.coverLetter = value;
                      },
                      maxLines: 5,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        final controller = Get.find<ApplicationController>();
                        controller.editProfile(user);
                      },
                      child: const Text("Edit Profile"),
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
