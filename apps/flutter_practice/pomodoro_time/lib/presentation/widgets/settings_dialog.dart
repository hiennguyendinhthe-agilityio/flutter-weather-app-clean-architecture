import 'package:flutter/material.dart';
import 'package:task_management_app/data/models/settings.dart';
import 'package:task_management_app/presentation/widgets/dialog_footer.dart';
import 'package:task_management_app/presentation/widgets/dialog_header.dart';
import 'package:task_management_app/presentation/widgets/notification_settings_tab.dart';
import 'package:task_management_app/presentation/widgets/time_settings_tab.dart';
import 'package:task_management_app/presentation/widgets/ui_settings_tab.dart';

class SettingsDialog extends StatefulWidget {
  final Settings settings;
  final Function(Settings) onSettingsChanged;
  final Function(int) onAddDuration;
  final Function(int) onRemoveDuration;

  const SettingsDialog({
    super.key,
    required this.settings,
    required this.onSettingsChanged,
    required this.onAddDuration,
    required this.onRemoveDuration,
  });

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 500.0,
          maxHeight: 600.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DialogHeader(
              title: 'Settings',
              onClose: () => Navigator.of(context).pop(),
            ),
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.timer), text: 'Timers'),
                Tab(icon: Icon(Icons.notifications), text: 'Notifications'),
                Tab(icon: Icon(Icons.palette), text: 'Theme'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  TimeSettingsTab(
                    settings: widget.settings,
                    onSettingsChanged: widget.onSettingsChanged,
                    onAddDuration: widget.onAddDuration,
                    onRemoveDuration: widget.onRemoveDuration,
                  ),
                  NotificationSettingsTab(
                    settings: widget.settings,
                    onSettingsChanged: widget.onSettingsChanged,
                  ),
                  UISettingsTab(
                    settings: widget.settings,
                    onSettingsChanged: widget.onSettingsChanged,
                  ),
                ],
              ),
            ),
            DialogFooter(
              onCancel: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
