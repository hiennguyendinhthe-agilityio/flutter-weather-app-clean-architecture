import 'package:flutter/material.dart';

class MusicPickerTile extends StatelessWidget {
  const MusicPickerTile({
    super.key,
    this.selectedTitle,
    this.selectedArtist,
    required this.onPickMusic,
    this.labelText,
  });

  /// The title of the selected music, if any.
  final String? selectedTitle;

  /// The artist of the selected music, if any.
  final String? selectedArtist;

  /// Callback triggered when the user taps to pick music.
  final VoidCallback onPickMusic;

  /// Optional label text shown above the music tile.
  final String? labelText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
        ],
        GestureDetector(
          onTap: onPickMusic,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.music_note, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    selectedTitle != null
                        ? '$selectedTitle ($selectedArtist)'
                        : 'Add music (Optional)',
                    style: TextStyle(
                      fontSize: 14,
                      color: selectedTitle != null
                          ? Colors.black87
                          : Colors.grey.shade600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.search, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
