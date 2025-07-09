import 'package:flutter/material.dart';
import 'package:task_management_app/data/models/project.dart';
import 'package:task_management_app/data/models/project_picker_dropdown.dart';

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
  final ProjectRepository _projectRepository = ProjectRepository();
  late Future<List<ProjectModel>> _projectsFuture;
  ProjectModel? _selectedProject;

  @override
  void initState() {
    super.initState();
    _projectsFuture = _projectRepository.getProjects();
    _selectedProject = widget.initialValue;
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
        FutureBuilder<List<ProjectModel>>(
          future: _projectsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2)));
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No projects found.');
            }

            final projects = snapshot.data!;

            if (_selectedProject != null &&
                !projects.any(
                    (p) => p.projectName == _selectedProject!.projectName)) {
              _selectedProject = null;
            }

            return Container(
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
                  items: projects.map((project) {
                    return DropdownMenuItem<ProjectModel>(
                      value: project,
                      child: Row(
                        children: [
                          Text(project.projectName,
                              style: const TextStyle(fontSize: 14)),
                          const Spacer(),
                          Text(
                            project.fullClientInfo,
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 13),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
