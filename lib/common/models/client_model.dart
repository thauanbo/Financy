import 'package:cloud_firestore/cloud_firestore.dart';

class ClientModel {
  final String? id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final DateTime createdAt;
  final String ownerId;

  ClientModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.createdAt,
    required this.ownerId,
  });

  // Converter para Map (para salvar no Firestore)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'createdAt': Timestamp.fromDate(createdAt),
      'ownerId': ownerId,
    };
  }

  // Converter de Map (para ler do Firestore)
  factory ClientModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ClientModel(
      id: documentId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      ownerId: map['ownerId'] ?? '',
    );
  }

  // Converter de DocumentSnapshot
  factory ClientModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ClientModel.fromMap(data, doc.id);
  }

  // Método para copiar com alterações
  ClientModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    DateTime? createdAt,
    String? ownerId,
  }) {
    return ClientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      ownerId: ownerId ?? this.ownerId,
    );
  }
}
