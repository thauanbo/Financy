import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class UserProfileModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String? companyName;
  final String? companyDocument; // CNPJ ou CPF
  final String? profileImageUrl;

  UserProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.companyName,
    this.companyDocument,
    this.profileImageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'companyName': companyName,
      'companyDocument': companyDocument,
      'profileImageUrl': profileImageUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      companyName: map['companyName'],
      companyDocument: map['companyDocument'],
      profileImageUrl: map['profileImageUrl'],
    );
  }
}

class UserProfileService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obter dados do perfil do usuário atual
  Future<UserProfileModel?> getCurrentUserProfile() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return null;
      }

      // Primeiro, buscar dados do Firestore
      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists) {
        final data = doc.data()!;

        final profile = UserProfileModel(
          id: user.uid,
          name: data['name'] ?? user.displayName ?? '',
          email: data['email'] ?? user.email ?? '',
          phone: data['phone'] ?? '',
          address: data['address'] ?? '',
          companyName: data['companyName'],
          companyDocument: data['companyDocument'],
          profileImageUrl: data['profileImageUrl'],
        );

        return profile;
      } else {
        // Se não existe no Firestore, criar com dados do Firebase Auth
        final profile = UserProfileModel(
          id: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
          phone: '',
          address: '',
          companyName: null,
          companyDocument: null,
          profileImageUrl: null,
        );
        await updateUserProfile(profile);
        return profile;
      }
    } catch (e) {
      return null;
    }
  }

  // Atualizar perfil do usuário
  Future<bool> updateUserProfile(UserProfileModel profile) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      // Atualizar Firebase Auth (nome e email)
      if (profile.name != user.displayName) {
        await user.updateDisplayName(profile.name);
      }

      // Atualizar email no Firebase Auth se for diferente
      if (profile.email != user.email) {
        await user.updateEmail(profile.email);
      }

      // Atualizar dados no Firestore
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(profile.toMap(), SetOptions(merge: true));

      return true;
    } catch (e) {
      return false;
    }
  }

  // Deletar conta do usuário
  Future<bool> deleteUserAccount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      // Deletar dados do Firestore
      await _firestore.collection('users').doc(user.uid).delete();

      // Deletar dados relacionados (orçamentos, clientes)
      final budgetsQuery =
          await _firestore
              .collection('budgets')
              .where('userId', isEqualTo: user.uid)
              .get();

      for (final doc in budgetsQuery.docs) {
        await doc.reference.delete();
      }

      final clientsQuery =
          await _firestore
              .collection('clients')
              .where('userId', isEqualTo: user.uid)
              .get();

      for (final doc in clientsQuery.docs) {
        await doc.reference.delete();
      }

      // Deletar conta do Firebase Auth
      await user.delete();

      return true;
    } catch (e) {
      return false;
    }
  }

  // Stream para observar mudanças no perfil
  Stream<UserProfileModel?> watchUserProfile() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(null);

    return _firestore.collection('users').doc(user.uid).snapshots().map((doc) {
      if (doc.exists) {
        return UserProfileModel.fromMap(doc.data()!);
      }
      return null;
    });
  }

  // Upload de imagem de perfil
  Future<String?> uploadProfileImage(Uint8List imageBytes) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('Usuário não autenticado');
      }

      final storage = FirebaseStorage.instance;
      final fileName =
          'profile_${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = storage.ref().child('profile_images/$fileName');

      // Upload da imagem com progresso
      final uploadTask = ref.putData(
        imageBytes,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      // Monitor do progresso
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        // Progress monitoring can be added here if needed
      });

      final snapshot = await uploadTask;

      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  // Atualizar URL da imagem de perfil
  Future<bool> updateProfileImage(String imageUrl) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final currentProfile = await getCurrentUserProfile();
      if (currentProfile == null) return false;

      final updatedProfile = UserProfileModel(
        id: currentProfile.id,
        name: currentProfile.name,
        email: currentProfile.email,
        phone: currentProfile.phone,
        address: currentProfile.address,
        companyName: currentProfile.companyName,
        companyDocument: currentProfile.companyDocument,
        profileImageUrl: imageUrl,
      );

      return await updateUserProfile(updatedProfile);
    } catch (e) {
      return false;
    }
  }
}
