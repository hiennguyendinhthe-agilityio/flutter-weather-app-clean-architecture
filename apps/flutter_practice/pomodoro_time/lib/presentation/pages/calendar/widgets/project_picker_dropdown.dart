import 'package:flutter/material.dart';
import 'package:task_management_app/data/models/project.dart';

class ProjectPickerDropdown extends StatefulWidget {
  final String? labelText;
  final ProjectModel? initialValue;
  final void Function(ProjectModel?) onChanged;

  const ProjectPickerDropdown({
    super.key,
    this.labelText,
    this.initialValue,
    required this.onChanged,
  });

  @override
  State<ProjectPickerDropdown> createState() => _ProjectPickerDropdownState();
}

class _ProjectPickerDropdownState extends State<ProjectPickerDropdown> {
  late ProjectModel? _selectedProject;

  final List<ProjectModel> _projects = [
    ProjectModel(
      projectName: 'Mobbaza App',
      clientName: 'Roberto',
      clientRole: 'Client',
      avatarUrl: 'https://i.pravatar.cc/150?img=3',
    ),
    ProjectModel(
      projectName: 'AI Landing Page',
      clientName: 'Sophia',
      clientRole: 'Manager',
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
    ),
    ProjectModel(
      projectName: 'CRM Tool',
      clientName: 'Daniel',
      clientRole: 'Stakeholder',
      avatarUrl: 'https://i.pravatar.cc/150?img=8',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedProject = widget.initialValue != null
        ? _projects.firstWhere(
            (p) => p.projectName == widget.initialValue!.projectName,
            orElse: () => _projects.first,
          )
        : null;
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<ProjectModel>(
              isExpanded: true,
              value: _selectedProject,
              hint: const Text("Select project"),
              icon: const Icon(Icons.arrow_drop_down),
              onChanged: (project) {
                setState(() => _selectedProject = project);
                widget.onChanged(project);
              },
              items: _projects.map((project) {
                return DropdownMenuItem<ProjectModel>(
                  value: project,
                  child: Row(
                    children: [
                      Text(project.projectName,
                          style: const TextStyle(fontSize: 14)),
                      const Spacer(),
                      Text(project.fullClientInfo,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          )),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
