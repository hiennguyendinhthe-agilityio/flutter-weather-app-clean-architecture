import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pratice_improve_flutter_form_builder/models/resume_file.dart';

import '../../controllers/application_controller.dart';

class FileUploadWidget extends StatelessWidget {
  final ApplicationController controller;

  const FileUploadWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resume',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 8),
        Obx(() {
          if (controller.application.resumeFiles.isEmpty) {
            return const SizedBox.shrink();
          }

          return Column(
            children: controller.application.resumeFiles.map((file) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _buildFilePreview(context, file),
              );
            }).toList(),
          );
        }),
        Obx(() => SizedBox(
            height: controller.application.resumeFiles.isNotEmpty ? 16 : 0)),
        _buildUploadButton(context),
      ],
    );
  }

  Widget _buildUploadButton(BuildContext context) {
    return InkWell(
      onTap: controller.pickResume,
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.scrim,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add,
              size: 32,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add a file',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Max file size 12MB (.pdf, .doc, .docx)',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilePreview(BuildContext context, ResumeFile file) {
    final fileSizeInMB = (file.size / (1024 * 1024)).toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.description,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${fileSizeInMB}MB',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => controller.removeResume(file),
            tooltip: 'Remove this file',
            splashRadius: 20,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
