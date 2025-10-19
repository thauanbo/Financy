import 'package:fabrica_de_software/common/constants/app_colors.dart';
import 'package:fabrica_de_software/common/constants/app_text_styles.dart';
import 'package:fabrica_de_software/common/models/budget_model.dart';
import 'package:fabrica_de_software/locator.dart';
import 'package:fabrica_de_software/services/budget_firestore_service.dart';
import 'package:fabrica_de_software/generated/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _budgetService = locator.get<BudgetFirestoreService>();
  Map<String, dynamic> _statistics = {};
  String _userName = 'Usuário';

  String _getCurrentDayOfWeek() {
    final now = DateTime.now();
    const days = [
      'Segunda',
      'Terça',
      'Quarta',
      'Quinta',
      'Sexta',
      'Sábado',
      'Domingo',
    ];
    return days[now.weekday - 1];
  }

  @override
  void initState() {
    super.initState();
    _loadStatistics();
    _loadUserName();
  }

  Future<void> _loadStatistics() async {
    try {
      final stats = await _budgetService.getUserStatistics();
      if (mounted) {
        setState(() {
          _statistics = stats;
        });
      }
    } catch (e) {
      // Silently handle statistics loading error
    }
  }

  Future<void> _loadUserName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && mounted) {
        setState(() {
          _userName =
              user.displayName?.isNotEmpty == true
                  ? user.displayName!
                  : user.email?.split('@')[0] ?? 'Usuário';
        });
      }
    } catch (e) {
      // Silently handle user name loading error
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.greenlightTwo,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: AppColors.gradientColors,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${localizations.hello},',
                            style: AppTextStyles.smallText16.copyWith(
                              color: AppColors.white.withOpacity(0.8),
                            ),
                          ),
                          Text(
                            _userName,
                            style: AppTextStyles.smallText16.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'R\$ ${(_statistics['totalRevenue']?.toStringAsFixed(2) ?? '0.00')}',
                            style: AppTextStyles.smallText16.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _getCurrentDayOfWeek(),
                              style: AppTextStyles.smallText.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Total Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: AppColors.white.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Gerado',
                              style: AppTextStyles.smallText.copyWith(
                                color: AppColors.white.withOpacity(0.8),
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${_statistics['totalBudgets'] ?? 0}',
                          style: AppTextStyles.bigText.copyWith(
                            color: AppColors.white,
                            fontSize: 48,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Abertos',
                                        style: AppTextStyles.smallText.copyWith(
                                          color: AppColors.white.withOpacity(
                                            0.8,
                                          ),
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Fechados',
                                        style: AppTextStyles.smallText.copyWith(
                                          color: AppColors.white.withOpacity(
                                            0.8,
                                          ),
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Content Section
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    // Orçamentos Header
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Orçamentos Gerados',
                            style: AppTextStyles.smallText16.copyWith(
                              color: AppColors.darkgrey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Budgets List
                    Expanded(
                      child: StreamBuilder<List<BudgetModel>>(
                        stream: _budgetService.getUserBudgets(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: AppColors.grey,
                                    size: 48,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Erro ao carregar dados',
                                    style: AppTextStyles.smallText16.copyWith(
                                      color: AppColors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          final budgets = snapshot.data ?? [];

                          if (budgets.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.receipt_long_outlined,
                                    color: AppColors.grey,
                                    size: 48,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Nenhum orçamento encontrado',
                                    style: AppTextStyles.smallText16.copyWith(
                                      color: AppColors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Crie seu primeiro orçamento!',
                                    style: AppTextStyles.smallText.copyWith(
                                      color: AppColors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: budgets.length,
                            itemBuilder: (context, index) {
                              final budget = budgets[index];

                              // Definir cor e ícone baseado no status
                              Color color;
                              IconData icon;

                              switch (budget.status) {
                                case 'approved':
                                  color = Colors.green;
                                  icon = Icons.check_circle_outline;
                                  break;
                                case 'rejected':
                                  color = Colors.red;
                                  icon = Icons.cancel_outlined;
                                  break;
                                case 'pending':
                                default:
                                  color = Colors.orange;
                                  icon = Icons.schedule_outlined;
                                  break;
                              }

                              return Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: color.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(icon, color: color, size: 20),
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            budget.clientName,
                                            style: AppTextStyles.smallText16
                                                .copyWith(
                                                  color: AppColors.darkgrey,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          Text(
                                            '${budget.createdAt.day}/${budget.createdAt.month}/${budget.createdAt.year}',
                                            style: AppTextStyles.smallText
                                                .copyWith(
                                                  color: AppColors.grey,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      budget.formattedTotalValue,
                                      style: AppTextStyles.smallText16.copyWith(
                                        color: color,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
