import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fabrica_de_software/common/models/budget_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BudgetFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Referência da coleção de orçamentos
  CollectionReference get _budgetsCollection =>
      _firestore.collection('budgets');

  // Obter ID do usuário atual
  String? get _currentUserId => _auth.currentUser?.uid;

  // Criar novo orçamento
  Future<String?> createBudget(BudgetModel budget) async {
    try {
      if (_currentUserId == null) throw Exception('Usuário não logado');

      final budgetWithOwner = budget.copyWith(ownerId: _currentUserId!);
      final docRef = await _budgetsCollection.add(budgetWithOwner.toMap());

      // Atualizar estatísticas do usuário
      await _updateUserStatistics();

      return docRef.id;
    } catch (e) {
      rethrow;
    }
  }

  // Buscar todos os orçamentos do usuário atual
  Stream<List<BudgetModel>> getUserBudgets() {
    if (_currentUserId == null) {
      return Stream.value([]);
    }

    return _budgetsCollection
        .where('ownerId', isEqualTo: _currentUserId)
        .snapshots()
        .map((snapshot) {
          var budgets =
              snapshot.docs
                  .map((doc) => BudgetModel.fromDocument(doc))
                  .toList();

          // Ordenar no lado do cliente para evitar necessidade de índice composto
          budgets.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return budgets;
        });
  }

  // Buscar orçamentos por status
  Stream<List<BudgetModel>> getBudgetsByStatus(String status) {
    if (_currentUserId == null) {
      return Stream.value([]);
    }

    return _budgetsCollection
        .where('ownerId', isEqualTo: _currentUserId)
        .where('status', isEqualTo: status)
        .snapshots()
        .map((snapshot) {
          var budgets =
              snapshot.docs
                  .map((doc) => BudgetModel.fromDocument(doc))
                  .toList();

          // Ordenar no lado do cliente para evitar necessidade de índice composto
          budgets.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return budgets;
        });
  }

  // Buscar orçamento por ID
  Future<BudgetModel?> getBudgetById(String budgetId) async {
    try {
      final doc = await _budgetsCollection.doc(budgetId).get();
      if (doc.exists) {
        return BudgetModel.fromDocument(doc);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Atualizar orçamento
  Future<void> updateBudget(String budgetId, BudgetModel budget) async {
    try {
      await _budgetsCollection.doc(budgetId).update(budget.toMap());
      await _updateUserStatistics();
    } catch (e) {
      rethrow;
    }
  }

  // Atualizar apenas o status do orçamento
  Future<void> updateBudgetStatus(String budgetId, String status) async {
    try {
      await _budgetsCollection.doc(budgetId).update({'status': status});
      await _updateUserStatistics();
    } catch (e) {
      rethrow;
    }
  }

  // Deletar orçamento
  Future<void> deleteBudget(String budgetId) async {
    try {
      await _budgetsCollection.doc(budgetId).delete();
      await _updateUserStatistics();
    } catch (e) {
      rethrow;
    }
  }

  // Buscar orçamentos por período
  Stream<List<BudgetModel>> getBudgetsByPeriod(
    DateTime startDate,
    DateTime endDate,
  ) {
    if (_currentUserId == null) {
      return Stream.value([]);
    }

    return _budgetsCollection
        .where('ownerId', isEqualTo: _currentUserId)
        .where(
          'createdAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
        )
        .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => BudgetModel.fromDocument(doc))
              .toList();
        });
  }

  // Obter estatísticas do usuário
  Future<Map<String, dynamic>> getUserStatistics() async {
    try {
      if (_currentUserId == null) return {};

      final snapshot =
          await _budgetsCollection
              .where('ownerId', isEqualTo: _currentUserId)
              .get();

      double totalRevenue = 0;
      int totalBudgets = snapshot.docs.length;
      int openBudgets = 0;
      int closedBudgets = 0;

      for (var doc in snapshot.docs) {
        final budget = BudgetModel.fromDocument(doc);
        totalRevenue += budget.totalValue;

        if (budget.status == 'open') {
          openBudgets++;
        } else if (budget.status == 'closed') {
          closedBudgets++;
        }
      }

      return {
        'totalBudgets': totalBudgets,
        'totalRevenue': totalRevenue,
        'openBudgets': openBudgets,
        'closedBudgets': closedBudgets,
        'averageBudgetValue':
            totalBudgets > 0 ? totalRevenue / totalBudgets : 0,
      };
    } catch (e) {
      return {};
    }
  }

  // Atualizar estatísticas do usuário (método privado)
  Future<void> _updateUserStatistics() async {
    try {
      if (_currentUserId == null) return;

      final stats = await getUserStatistics();
      await _firestore.collection('statistics').doc(_currentUserId).set({
        ...stats,
        'lastUpdated': Timestamp.now(),
      });
    } catch (e) {
      // Silently handle statistics update error
    }
  }

  // Obter estatísticas mensais
  Future<Map<String, double>> getMonthlyRevenue() async {
    try {
      if (_currentUserId == null) return {};

      final now = DateTime.now();
      final startOfYear = DateTime(now.year, 1, 1);
      final endOfYear = DateTime(now.year, 12, 31);

      final snapshot =
          await _budgetsCollection
              .where('ownerId', isEqualTo: _currentUserId)
              .where(
                'createdAt',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startOfYear),
              )
              .where(
                'createdAt',
                isLessThanOrEqualTo: Timestamp.fromDate(endOfYear),
              )
              .get();

      Map<String, double> monthlyData = {};

      for (var doc in snapshot.docs) {
        final budget = BudgetModel.fromDocument(doc);
        final monthKey =
            '${budget.createdAt.year}-${budget.createdAt.month.toString().padLeft(2, '0')}';

        monthlyData[monthKey] =
            (monthlyData[monthKey] ?? 0) + budget.totalValue;
      }

      return monthlyData;
    } catch (e) {
      return {};
    }
  }
}
