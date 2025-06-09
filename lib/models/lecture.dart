class Student {
  int id;
  String name;
  Student({required this.id, required this.name});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Lecture{
  String name;
  String? code;
  int id;
  int? totalWeeks;
  String professorName;
  List<Student>? students;

  Lecture({required this.name, required this.code, required this.id, required this.professorName, required this.students, required this.totalWeeks});

  factory Lecture.fromJson(Map<String, dynamic> json) {
    return Lecture(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      totalWeeks: json['total_weeks'],
      professorName: json['professor_name'],
      students: (json['students'] as List<dynamic>)
          .map((s) => Student.fromJson(s))
          .toList(),
    );
  }
}

class LectureStudent{
  String name;
  int lectureId;
  String professor;
  String lectureCode;

  LectureStudent({required this.name, required this.lectureId, required this.professor, required this.lectureCode});

  factory LectureStudent.fromJson(Map<String, dynamic> json) {
    return LectureStudent(name: json['name'], lectureId: json['lecture_id'], professor: json['professor'], lectureCode: json['lecture_code']);
  }
}