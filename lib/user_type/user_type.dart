enum UserType { lecturer, student }

extension UserRoleExtension on UserType {
  List<String> get permissions {
    switch (this) {
      case UserType.student:
        return [
          'view_courses',
          'manage_courses',
          'comment on courses',
          'view comments',
        ];
      case UserType.lecturer:
        return [
          'view_courses',
          'manage_courses',
          'grade_students',
          'manage_comments',
          'view_reports',
          'upload courses',
        ];
      default:
        return [];
    }
  }

  List<String> get access {
    switch (this) {
      case UserType.student:
        return [
          'student_dashboard',
          'course_materials',
        ];
      case UserType.lecturer:
        return [
          'lecturer_dashboard',
          'course_materials',
          'edit uploaded content',
          'reports',
        ];
      default:
        return [];
    }
  }

  String get displayName {
    switch (this) {
      case UserType.student:
        return 'Student';
      case UserType.lecturer:
        return 'Lecturer';
      default:
        return '';
    }
  }
}
