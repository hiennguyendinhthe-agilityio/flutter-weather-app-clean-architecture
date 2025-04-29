import 'package:flutter/material.dart';
import 'package:pratice_improve_flutter_form_builder/models/resume_file.dart';

class FileUploadWidget extends StatelessWidget {
  final List<ResumeFile> resumeFiles;

  final VoidCallback onAddFilePressed;

  final Function(ResumeFile) onRemoveFilePressed;

  final String label;

  final String addButtonText;

  final String addButtonDescription;

  const FileUploadWidget({
    super.key,
    required this.resumeFiles,
    required this.onAddFilePressed,
    required this.onRemoveFilePressed,
    this.label = 'Resume',
    this.addButtonText = 'Add a file',
    this.addButtonDescription = 'Max file size 12MB (.pdf, .doc, .docx)',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 8),
        if (resumeFiles.isNotEmpty)
          Column(
            children: resumeFiles.map((file) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _buildFilePreview(context, file, onRemoveFilePressed),
              );
            }).toList(),
          ),
        if (resumeFiles.isNotEmpty) const SizedBox(height: 16),
        _buildUploadButton(
            context, onAddFilePressed, addButtonText, addButtonDescription),
      ],
    );
  }

  Widget _buildUploadButton(
    BuildContext context,
    VoidCallback onPressed,
    String buttonText,
    String descriptionText,
  ) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add,
              size: 32,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  buttonText,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  descriptionText,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilePreview(
    BuildContext context,
    ResumeFile file,
    Function(ResumeFile) onRemovePressed,
  ) {
    final fileSizeInMB =
        file.size > 0 ? (file.size / (1024 * 1024)).toStringAsFixed(1) : '0';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.description_outlined,
              color: Theme.of(context).colorScheme.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  file.name,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '$fileSizeInMB MB',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.close,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 20,
            ),
            onPressed: () => onRemovePressed(file),
            tooltip: 'Remove this file',
            splashRadius: 20,
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(4),
          ),
        ],
      ),
    );
  }
}
