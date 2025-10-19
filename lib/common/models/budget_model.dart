import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BudgetModel {
  final String? id;
  final String clientId;
  final String clientName;
  final String description;
  final String comments;
  final int workDays;
  final double laborValue;
  final double materialsValue;
  final double totalValue;
  final String status; // 'open' | 'closed' | 'pending'
  final DateTime createdAt;
  final String ownerId;

  BudgetModel({
    this.id,
    required this.clientId,
    required this.clientName,
    required this.description,
    required this.comments,
    required this.workDays,
    required this.laborValue,
    required this.materialsValue,
    required this.totalValue,
    required this.status,
    required this.createdAt,
    required this.ownerId,
  });

  // Converter para Map (para salvar no Firestore)
  Map<String, dynamic> toMap() {
    return {
      'clientId': clientId,
      'clientName': clientName,
      'description': description,
      'comments': comments,
      'workDays': workDays,
      'laborValue': laborValue,
      'materialsValue': materialsValue,
      'totalValue': totalValue,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'ownerId': ownerId,
    };
  }

  // Converter de Map (para ler do Firestore)
  factory BudgetModel.fromMap(Map<String, dynamic> map, String documentId) {
    return BudgetModel(
      id: documentId,
      clientId: map['clientId'] ?? '',
      clientName: map['clientName'] ?? '',
      description: map['description'] ?? '',
      comments: map['comments'] ?? '',
      workDays: map['workDays']?.toInt() ?? 0,
      laborValue: map['laborValue']?.toDouble() ?? 0.0,
      materialsValue: map['materialsValue']?.toDouble() ?? 0.0,
      totalValue: map['totalValue']?.toDouble() ?? 0.0,
      status: map['status'] ?? 'pending',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      ownerId: map['ownerId'] ?? '',
    );
  }

  // Converter de DocumentSnapshot
  factory BudgetModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BudgetModel.fromMap(data, doc.id);
  }

  // Método para copiar com alterações
  BudgetModel copyWith({
    String? id,
    String? clientId,
    String? clientName,
    String? description,
    String? comments,
    int? workDays,
    double? laborValue,
    double? materialsValue,
    double? totalValue,
    String? status,
    DateTime? createdAt,
    String? ownerId,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      description: description ?? this.description,
      comments: comments ?? this.comments,
      workDays: workDays ?? this.workDays,
      laborValue: laborValue ?? this.laborValue,
      materialsValue: materialsValue ?? this.materialsValue,
      totalValue: totalValue ?? this.totalValue,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      ownerId: ownerId ?? this.ownerId,
    );
  }

  // Formatação de valores para exibição
  String get formattedLaborValue => 'R\$ ${laborValue.toStringAsFixed(2)}';
  String get formattedMaterialsValue =>
      'R\$ ${materialsValue.toStringAsFixed(2)}';
  String get formattedTotalValue => 'R\$ ${totalValue.toStringAsFixed(2)}';

  // Status formatado
  String get statusDisplay {
    switch (status) {
      case 'open':
        return 'Aberto';
      case 'closed':
        return 'Fechado';
      case 'pending':
        return 'Pendente';
      case 'approved':
        return 'Aprovado';
      case 'rejected':
        return 'Rejeitado';
      default:
        return 'Desconhecido';
    }
  }

  // Cor do status
  Color get statusColor {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      case 'open':
        return Colors.blue;
      case 'closed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
