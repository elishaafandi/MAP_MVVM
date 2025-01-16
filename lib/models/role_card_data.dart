import 'package:movease/models/user_role.dart';

class RoleCardData {
  final String image;
  final String title;
  final String subtitle;
  final UserRole role;

  const RoleCardData({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.role,
  });
}
