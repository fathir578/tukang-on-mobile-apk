class UserModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? phone;
  final String? alamat;
  final String? foto;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.alamat,
    this.foto,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        role: json['role'] ?? 'user',
        phone: json['phone'],
        alamat: json['alamat'],
        foto: json['foto'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
        'phone': phone,
        'alamat': alamat,
        'foto': foto,
      };
}
