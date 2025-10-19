import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fabrica_de_software/common/models/client_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ClientFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Referência da coleção de clientes
  CollectionReference get _clientsCollection =>
      _firestore.collection('clients');

  // Obter ID do usuário atual
  String? get _currentUserId => _auth.currentUser?.uid;

  // Criar novo cliente
  Future<String?> createClient(ClientModel client) async {
    try {
      if (_currentUserId == null) throw Exception('Usuário não logado');

      final clientWithOwner = client.copyWith(ownerId: _currentUserId!);
      final docRef = await _clientsCollection.add(clientWithOwner.toMap());
      return docRef.id;
    } catch (e) {
      rethrow;
    }
  }

  // Buscar todos os clientes do usuário atual
  Stream<List<ClientModel>> getUserClients() {
    if (_currentUserId == null) {
      return Stream.value([]);
    }

    return _clientsCollection
        .where('ownerId', isEqualTo: _currentUserId)
        .snapshots()
        .map((snapshot) {
          var clients =
              snapshot.docs
                  .map((doc) => ClientModel.fromDocument(doc))
                  .toList();

          // Ordenar no lado do cliente para evitar necessidade de índice composto
          clients.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return clients;
        });
  }

  // Buscar cliente por ID
  Future<ClientModel?> getClientById(String clientId) async {
    try {
      final doc = await _clientsCollection.doc(clientId).get();
      if (doc.exists) {
        return ClientModel.fromDocument(doc);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Atualizar cliente
  Future<void> updateClient(String clientId, ClientModel client) async {
    try {
      await _clientsCollection.doc(clientId).update(client.toMap());
    } catch (e) {
      rethrow;
    }
  }

  // Deletar cliente
  Future<void> deleteClient(String clientId) async {
    try {
      await _clientsCollection.doc(clientId).delete();
    } catch (e) {
      rethrow;
    }
  }

  // Buscar clientes por nome (busca)
  Stream<List<ClientModel>> searchClients(String searchTerm) {
    if (_currentUserId == null) {
      return Stream.value([]);
    }

    return _clientsCollection
        .where('ownerId', isEqualTo: _currentUserId)
        .snapshots()
        .map((snapshot) {
          var clients =
              snapshot.docs
                  .map((doc) => ClientModel.fromDocument(doc))
                  .toList();

          // Filtrar e ordenar no lado do cliente
          clients =
              clients
                  .where(
                    (client) => client.name.toLowerCase().contains(
                      searchTerm.toLowerCase(),
                    ),
                  )
                  .toList();

          clients.sort((a, b) => a.name.compareTo(b.name));
          return clients;
        });
  }

  // Contar total de clientes do usuário
  Future<int> getClientsCount() async {
    try {
      if (_currentUserId == null) return 0;

      final snapshot =
          await _clientsCollection
              .where('ownerId', isEqualTo: _currentUserId)
              .get();
      return snapshot.docs.length;
    } catch (e) {
      return 0;
    }
  }
}
