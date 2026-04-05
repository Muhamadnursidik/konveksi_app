class UserModel {
  final int    id;
  final String name;
  final String email;
  final String role;
   final String? photo;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.photo,
  });

  factory UserModel.fromJson(Map<String, dynamic> j) => UserModel(
    id:    j['id'],
    name:  j['name'],
    email: j['email'],
    role:  j['role'],
    photo: j['photo'],
  );

  // Label role yang lebih ramah
  String get roleLabel {
    switch (role) {
      case 'pemotong':  return 'Pemotong';
      case 'penjahit':  return 'Penjahit';
      case 'finishing': return 'Finishing';
      default:          return role;
    }
  }
}