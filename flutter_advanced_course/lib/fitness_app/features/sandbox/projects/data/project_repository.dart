import 'package:flutter_advanced_course/fitness_app/core/constants/colors.dart';
import 'package:flutter_advanced_course/fitness_app/features/sandbox/projects/models/project_data.dart';

class ProjectRepository {
  static ProjectSummary getSummary(String period) {
    switch (period) {
      case 'Day':
        return const ProjectSummary(
          title: 'Projects',
          totalHours: 8,
          dateRange: 'Today, 21 April',
          projects: [
            ProjectData(
              name: 'Lexend',
              percentage: 0.45,
              hours: 3.5,
              color: FitnessColors.projectLime,
            ),
            ProjectData(
              name: 'Spoticod',
              percentage: 0.25,
              hours: 2,
              color: FitnessColors.sleep,
            ),
            ProjectData(
              name: 'Logitolk',
              percentage: 0.15,
              hours: 1.2,
              color: FitnessColors.projectPurple,
            ),
          ],
        );
      case 'Month':
        return const ProjectSummary(
          title: 'Projects',
          totalHours: 960,
          dateRange: '01 April - 30 April',
          projects: [
            ProjectData(
              name: 'Lexend',
              percentage: 0.28,
              hours: 268,
              color: FitnessColors.projectLime,
            ),
            ProjectData(
              name: 'Spoticod',
              percentage: 0.32,
              hours: 308,
              color: FitnessColors.sleep,
            ),
            ProjectData(
              name: 'Logitolk',
              percentage: 0.10,
              hours: 96,
              color: FitnessColors.projectPurple,
            ),
          ],
        );
      case 'Year':
        return const ProjectSummary(
          title: 'Projects',
          totalHours: 11520,
          dateRange: '2025 - 2026',
          projects: [
            ProjectData(
              name: 'Lexend',
              percentage: 0.40,
              hours: 4608,
              color: FitnessColors.projectLime,
            ),
            ProjectData(
              name: 'Spoticod',
              percentage: 0.15,
              hours: 1728,
              color: FitnessColors.sleep,
            ),
            ProjectData(
              name: 'Logitolk',
              percentage: 0.20,
              hours: 2304,
              color: FitnessColors.projectPurple,
            ),
          ],
        );
      case 'Week':
      default:
        return const ProjectSummary(
          title: 'Projects',
          totalHours: 240,
          dateRange: '21.04 - 28.04',
          projects: [
            ProjectData(
              name: 'Lexend',
              percentage: 0.35,
              hours: 86,
              color: FitnessColors.projectLime,
            ),
            ProjectData(
              name: 'Spoticod',
              percentage: 0.16,
              hours: 40,
              color: FitnessColors.sleep,
            ),
            ProjectData(
              name: 'Logitolk',
              percentage: 0.05,
              hours: 12,
              color: FitnessColors.projectPurple,
            ),
          ],
        );
    }
  }
}
