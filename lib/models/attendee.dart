import 'dart:convert';

class Attendee {
  final int id;
  final String name;
  final String email;
  final String isAttendee;
  final String phoneNumber;

  Attendee({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.isAttendee,
  });

  factory Attendee.fromJson(Map<String, dynamic> jsonData) {
    return Attendee(
      id: jsonDecode(jsonData['id']),
      name: jsonData['name'],
      email: jsonData['email'],
      isAttendee: jsonData['isAttendee'],
      phoneNumber: jsonData['phoneNumber'],
    );
  }
}
