class TukangModel {
  final int id;
  final String name;
  final String? email;
  final String? phone;
  final String? alamat;
  final String? keahlian;
  final String? foto;
  final String? deskripsi;
  final double rating;
  final String status;
  final int? userId;

  TukangModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.alamat,
    this.keahlian,
    this.foto,
    this.deskripsi,
    this.rating = 0,
    this.status = 'aktif',
    this.userId,
  });

  factory TukangModel.fromJson(Map<String, dynamic> json) => TukangModel(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        alamat: json['alamat'],
        keahlian: json['keahlian'],
        foto: json['foto'],
        deskripsi: json['deskripsi'],
        rating: (json['rating'] ?? 0).toDouble(),
        status: json['status'] ?? 'aktif',
        userId: json['user_id'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
        'alamat': alamat,
        'keahlian': keahlian,
        'foto': foto,
        'deskripsi': deskripsi,
      };
}
