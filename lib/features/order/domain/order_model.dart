class OrderModel {
  final int id;
  final int userId;
  final int tukangId;
  final String deskripsi;
  final String alamat;
  final String status;
  final String? tukangName;
  final String? userName;
  final String? createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.tukangId,
    required this.deskripsi,
    required this.alamat,
    required this.status,
    this.tukangName,
    this.userName,
    this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    id: json['id'],
    userId: json['user_id'],
    tukangId: json['tukang_id'],
    deskripsi: json['deskripsi'],
    alamat: json['alamat'],
    status: json['status'],
    tukangName: json['tukang']?['name'] ?? '',
    userName: json['user']?['name'] ?? '',
    createdAt: json['created_at'],
  );
}
