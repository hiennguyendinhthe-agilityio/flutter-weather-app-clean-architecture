import 'package:flutter/material.dart';

class MusicModel {
  final String title;
  final String artist;

  const MusicModel({required this.title, required this.artist});

  String get displayName => '$title ($artist)';
}

class MusicPickerDropdown extends StatefulWidget {
  final String? labelText;
  final MusicModel? initialValue;
  final void Function(MusicModel?) onChanged;

  const MusicPickerDropdown({
    super.key,
    this.labelText,
    this.initialValue,
    required this.onChanged,
  });

  @override
  State<MusicPickerDropdown> createState() => _MusicPickerDropdownState();
}

class _MusicPickerDropdownState extends State<MusicPickerDropdown> {
  late TextEditingController _controller;
  late List<MusicModel> _musicList;
  MusicModel? _selectedMusic;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _musicList = [
      const MusicModel(title: 'Begin Again', artist: 'Taylor Swift'),
      const MusicModel(title: 'Shape of You', artist: 'Ed Sheeran'),
      const MusicModel(title: 'Someone Like You', artist: 'Adele'),
      const MusicModel(title: 'Blinding Lights', artist: 'The Weeknd'),
      const MusicModel(title: 'Perfect', artist: 'Ed Sheeran'),
      const MusicModel(title: 'Hello', artist: 'Adele'),
    ];
    _selectedMusic = widget.initialValue;
    _controller.text = _selectedMusic?.displayName ?? '';
  }

  void _openMusicPickerDialog() async {
    final result = await showDialog<MusicModel>(
      context: context,
      builder: (context) {
        String query = '';
        return StatefulBuilder(
          builder: (context, setState) {
            final filteredList = _musicList
                .where((m) =>
                    m.displayName.toLowerCase().contains(query.toLowerCase()))
                .toList();

            return AlertDialog(
              title: const Text('Select Music'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(hintText: 'Search...'),
                    onChanged: (val) => setState(() => query = val),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    width: double.maxFinite,
                    child: ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final music = filteredList[index];
                        return ListTile(
                          leading: const Icon(Icons.music_note,
                              color: Colors.blueAccent),
                          title: Text(music.title),
                          subtitle: Text(music.artist),
                          onTap: () => Navigator.pop(context, music),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        _selectedMusic = result;
        _controller.text = result.displayName;
      });
      widget.onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
        ],
        GestureDetector(
          onTap: _openMusicPickerDialog,
          child: TextField(
            controller: _controller,
            enabled: false,
            decoration: InputDecoration(
              prefixIcon:
                  const Icon(Icons.music_note, color: Colors.blueAccent),
              suffixIcon: const Icon(Icons.search, color: Colors.grey),
              hintText: 'Add music (Optional)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
