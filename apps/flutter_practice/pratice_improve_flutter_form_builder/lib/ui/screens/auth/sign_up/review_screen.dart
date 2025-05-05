import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pratice_improve_flutter_form_builder/models/resume_file.dart';

import '../../../../controllers/application_controller.dart';

class ReviewScreen extends StatelessWidget {
  final ApplicationController controller;

  const ReviewScreen({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildSection(
              context,
              'Personal information',
              [
                _buildInfoItem(context, 'Full name',
                    controller.application.fullName.value),
                _buildInfoItem(context, 'Phone number',
                    controller.application.phoneNumber.value),
                _buildInfoItem(context, 'Email address',
                    controller.application.emailAddress.value),
                _buildInfoItem(
                  context,
                  'Personal website',
                  controller.application.personalWebsite.value.isEmpty
                      ? 'No answer'
                      : controller.application.personalWebsite.value,
                ),
                _buildInfoItem(
                  context,
                  'Portfolio URL',
                  controller.application.portfolioUrl.value.isEmpty
                      ? 'No answer'
                      : controller.application.portfolioUrl.value,
                ),
              ],
              onEdit: () => controller.goToStep(0),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              'Additional information',
              [
                _buildInfoItem(context, 'Cover letter',
                    controller.application.coverLetter.value),
                const SizedBox(height: 16),
                _buildResumeListSection(context),
              ],
              onEdit: () => controller.goToStep(1),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Header section
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Review your application',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text('Is the information you have submitted correct?',
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  // Build individual section with title and content
  Widget _buildSection(BuildContext context, String title, List<Widget> items,
      {required VoidCallback onEdit}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.scrim.withValues(alpha: 0.1),
          ),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Edit'),
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.scrim,
                    foregroundColor: Theme.of(context).colorScheme.surface,
                    iconColor: Theme.of(context).colorScheme.surface,
                    elevation: 0,
                    minimumSize: Size.zero,
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  // Build individual info items
  Widget _buildInfoItem(BuildContext context, String label, String value,
      {String? subtitle, bool isFile = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 6.0, top: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 4),
          if (isFile && value != 'No file selected')
            _buildFileInfo(context, value, subtitle)
          else if (label == 'Cover letter')
            Text(value,
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: 3,
                overflow: TextOverflow.ellipsis)
          else
            Text(value,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // Build the file info (resume)
  Widget _buildFileInfo(BuildContext context, String value, String? subtitle) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.description,
              color: Theme.of(context).colorScheme.primary, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              if (subtitle != null)
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }

  // Display resume list section
  Widget _buildResumeListSection(BuildContext context) {
    return Obx(() {
      final List<ResumeFile> files = controller.application.resumeFiles;
      if (files.isEmpty) {
        return _buildInfoItem(context, 'Resume', 'No resume uploaded');
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Resume', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          Column(
            children: files
                .map((file) => _buildSingleResumeDisplay(context, file))
                .toList(),
          ),
        ],
      );
    });
  }

  // Display individual resume file
  Widget _buildSingleResumeDisplay(BuildContext context, ResumeFile file) {
    final fileSizeInMB = (file.size / (1024 * 1024)).toStringAsFixed(2);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.description_outlined,
                color: Theme.of(context).colorScheme.primary, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(file.name,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
                Text('${fileSizeInMB}MB',
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
