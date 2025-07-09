import 'package:task_management_app/data/models/project.dart';

class ProjectRepository {
  Future<List<ProjectModel>> getProjects() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
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
  }
}
