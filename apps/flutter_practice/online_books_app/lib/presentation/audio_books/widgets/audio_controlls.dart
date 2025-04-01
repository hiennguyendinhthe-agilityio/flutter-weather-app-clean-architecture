import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:online_books_app/presentation/audio_books/controller/audio_controller.dart';

class AudioControls extends StatelessWidget {
  final AudioController audioController;

  const AudioControls({
    super.key,
    required this.audioController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress slider
          Obx(() {
            return SliderTheme(
              data: SliderThemeData(
                trackHeight: 2,
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 6,
                ),
                overlayShape: const RoundSliderOverlayShape(
                  overlayRadius: 12,
                ),
                activeTrackColor: Colors.grey[400],
                inactiveTrackColor: Colors.grey[300],
                thumbColor: Colors.grey[600],
                overlayColor: Colors.grey.withValues(alpha: 0.2),
              ),
              child: Slider(
                value: audioController.position.value.inSeconds.toDouble(),
                max: audioController.duration.value.inSeconds.toDouble(),
                onChanged: (value) {
                  audioController.seek(Duration(seconds: value.toInt()));
                },
              ),
            );
          }),

          // Time and controls
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Current time / total time
                Obx(() {
                  final position = audioController.position.value;
                  final duration = audioController.duration.value;

                  final positionStr =
                      '${position.inMinutes.toString().padLeft(2, '0')}:${(position.inSeconds % 60).toString().padLeft(2, '0')}';
                  final durationStr =
                      '${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';

                  return Text(
                    '$positionStr/$durationStr',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  );
                }),

                // Control buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Skip backward button
                    IconButton(
                      icon: const Icon(Icons.replay_10, color: Colors.grey),
                      onPressed: audioController.skipBackward,
                    ),

                    // Play/pause button
                    Obx(() {
                      return Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.orange, width: 2),
                        ),
                        child: IconButton(
                          icon: Icon(
                            audioController.isPlaying.value
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.orange,
                          ),
                          onPressed: () {
                            if (audioController.isPlaying.value) {
                              audioController.pause();
                            } else {
                              audioController.play();
                            }
                          },
                        ),
                      );
                    }),

                    // Skip forward button
                    IconButton(
                      icon: const Icon(Icons.forward_10, color: Colors.grey),
                      onPressed: audioController.skipForward,
                    ),
                  ],
                ),

                // Empty space to balance the layout
                const SizedBox(width: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
