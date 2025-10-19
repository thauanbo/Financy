import 'package:fabrica_de_software/common/constants/app_colors.dart';
import 'package:fabrica_de_software/common/constants/app_text_styles.dart';
import 'package:fabrica_de_software/locator.dart';
import 'package:fabrica_de_software/services/budget_firestore_service.dart';
import 'package:fabrica_de_software/services/budget_pdf_service.dart';
import 'package:fabrica_de_software/services/client_firestore_service.dart';
import 'package:fabrica_de_software/services/user_profile_service.dart';
import 'package:fabrica_de_software/common/models/budget_model.dart';
import 'package:fabrica_de_software/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final _budgetService = locator.get<BudgetFirestoreService>();
  final _pdfService = locator.get<BudgetPdfService>();
  final _clientService = locator.get<ClientFirestoreService>();
  final _userProfileService = locator.get<UserProfileService>();
  String _selectedPeriod = 'Ano';
  Map<String, dynamic> _statistics = {};
  List<BudgetModel> _budgets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    try {
      final stats = await _budgetService.getUserStatistics();
      if (mounted) {
        setState(() {
          _statistics = stats;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  List<BudgetModel> _getFilteredBudgets() {
    final now = DateTime.now();
    DateTime startDate;

    switch (_selectedPeriod) {
      case 'Dia':
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case 'Semana':
        startDate = now.subtract(Duration(days: now.weekday - 1));
        startDate = DateTime(startDate.year, startDate.month, startDate.day);
        break;
      case 'Mês':
        startDate = DateTime(now.year, now.month, 1);
        break;
      case 'Ano':
      default:
        startDate = DateTime(now.year, 1, 1);
        break;
    }

    return _budgets
        .where(
          (budget) => budget.createdAt.isAfter(
            startDate.subtract(const Duration(days: 1)),
          ),
        )
        .toList();
  }

  double _getTotalRevenue() {
    final filteredBudgets = _getFilteredBudgets();
    return filteredBudgets.fold(
      0.0,
      (sum, budget) =>
          budget.status == 'approved' ? sum + budget.totalValue : sum,
    );
  }

  int _getApprovedBudgets() {
    final filteredBudgets = _getFilteredBudgets();
    return filteredBudgets
        .where((budget) => budget.status == 'approved')
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Period Selector
            Row(
              children: [
                _buildPeriodButton('Dia'),
                const SizedBox(width: 10),
                _buildPeriodButton('Semana'),
                const SizedBox(width: 10),
                _buildPeriodButton('Mês'),
                const SizedBox(width: 10),
                _buildPeriodButton('Ano'),
              ],
            ),
            const SizedBox(height: 30),

            // Chart Container
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: StreamBuilder<List<BudgetModel>>(
                stream: _budgetService.getUserBudgets(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting &&
                      _budgets.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasData) {
                    _budgets = snapshot.data!;
                  }

                  final totalRevenue = _getTotalRevenue();
                  final approvedBudgets = _getApprovedBudgets();

                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'R\$ ${totalRevenue.toStringAsFixed(2)}',
                              style: AppTextStyles.smallText16.copyWith(
                                color: AppColors.darkgrey,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.greenlightTwo,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '$approvedBudgets aprovados',
                                style: AppTextStyles.smallText.copyWith(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _buildChartBar(0.3, 'Mar'),
                              _buildChartBar(0.5, 'Apr'),
                              _buildChartBar(0.8, 'May', isActive: true),
                              _buildChartBar(0.4, 'Jun'),
                              _buildChartBar(0.6, 'Jul'),
                              _buildChartBar(0.2, 'Aug'),
                              _buildChartBar(0.7, 'Sep'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            // Budgets Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Orçamentos Criados',
                  style: AppTextStyles.smallText16.copyWith(
                    color: AppColors.darkgrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _selectedPeriod,
                  style: AppTextStyles.smallText.copyWith(
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Budget Items
            Expanded(
              child: StreamBuilder<List<BudgetModel>>(
                stream: _budgetService.getUserBudgets(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.grey[400],
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Erro ao carregar orçamentos',
                            style: AppTextStyles.smallText16.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (snapshot.hasData) {
                    _budgets = snapshot.data!;
                  }
                  final filteredBudgets = _getFilteredBudgets();

                  if (filteredBudgets.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            color: Colors.grey[400],
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Nenhum orçamento encontrado',
                            style: AppTextStyles.smallText16.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'para o período selecionado',
                            style: AppTextStyles.smallText.copyWith(
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: filteredBudgets.length,
                    separatorBuilder:
                        (context, index) => const SizedBox(height: 15),
                    itemBuilder: (context, index) {
                      final budget = filteredBudgets[index];

                      return _buildBudgetItem(
                        budget.clientName,
                        '${budget.createdAt.day}/${budget.createdAt.month}/${budget.createdAt.year}',
                        budget.formattedTotalValue,
                        budget.statusColor,
                        status: budget.status,
                        onTap: () => _showStatusChangeDialog(budget),
                        budget: budget,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodButton(String period) {
    final isSelected = _selectedPeriod == period;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedPeriod = period;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.greenlightTwo : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            period,
            textAlign: TextAlign.center,
            style: AppTextStyles.smallText.copyWith(
              color: isSelected ? Colors.white : AppColors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChartBar(double height, String label, {bool isActive = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 30,
          height: height * 120,
          decoration: BoxDecoration(
            color: isActive ? AppColors.greenlightTwo : Colors.grey.shade300,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppTextStyles.smallText.copyWith(
            color: AppColors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetItem(
    String clientName,
    String date,
    String amount,
    Color color, {
    String? status,
    VoidCallback? onTap,
    BudgetModel? budget,
  }) {
    String statusText = _getStatusDisplayName(status ?? 'pendente');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clientName,
                    style: AppTextStyles.smallText16.copyWith(
                      color:
                          color == AppColors.greenlightTwo
                              ? Colors.white
                              : AppColors.darkgrey,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        date,
                        style: AppTextStyles.smallText.copyWith(
                          color:
                              color == AppColors.greenlightTwo
                                  ? Colors.white70
                                  : AppColors.grey,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color:
                              color == AppColors.greenlightTwo
                                  ? Colors.white.withOpacity(0.2)
                                  : AppColors.greenlightTwo.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          statusText,
                          style: AppTextStyles.smallText.copyWith(
                            color:
                                color == AppColors.greenlightTwo
                                    ? Colors.white
                                    : AppColors.greenlightTwo,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Row(
              children: [
                Text(
                  amount,
                  style: AppTextStyles.smallText16.copyWith(
                    color:
                        color == AppColors.greenlightTwo
                            ? Colors.white
                            : AppColors.greenlightTwo,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                if (budget != null)
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      size: 16,
                      color:
                          color == AppColors.greenlightTwo
                              ? Colors.white70
                              : AppColors.grey,
                    ),
                    onSelected: (value) async {
                      switch (value) {
                        case 'pdf':
                          await _generatePdf(budget);
                          break;
                        case 'edit':
                          if (onTap != null) onTap();
                          break;
                        case 'delete':
                          await _showDeleteConfirmationDialog(budget);
                          break;
                      }
                    },
                    itemBuilder:
                        (context) => [
                          PopupMenuItem(
                            value: 'pdf',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.picture_as_pdf,
                                  size: 16,
                                  color: Colors.red,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Gerar PDF',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.edit,
                                  size: 16,
                                  color: AppColors.greenlightTwo,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Editar Status',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          // Mostrar opção de deletar apenas para orçamentos rejeitados
                          if (budget.status == 'rejected')
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete,
                                    size: 16,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Deletar',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                        ],
                  )
                else
                  Icon(
                    Icons.edit,
                    size: 16,
                    color:
                        color == AppColors.greenlightTwo
                            ? Colors.white70
                            : AppColors.grey,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showStatusChangeDialog(BudgetModel budget) async {
    final newStatus = await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Alterar Status do Orçamento',
              style: AppTextStyles.smallText16.copyWith(
                color: AppColors.darkgrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cliente: ${budget.clientName}',
                  style: AppTextStyles.smallText.copyWith(
                    color: AppColors.grey,
                  ),
                ),
                Text(
                  'Valor: ${budget.formattedTotalValue}',
                  style: AppTextStyles.smallText.copyWith(
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Status atual: ${_getStatusDisplayName(budget.status)}',
                  style: AppTextStyles.smallText.copyWith(
                    color: AppColors.darkgrey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Selecione o novo status:',
                  style: AppTextStyles.smallText.copyWith(
                    color: AppColors.darkgrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),

                // Botões para cada status
                _buildStatusButton(
                  context,
                  'pending',
                  'Pendente',
                  Colors.orange,
                ),
                const SizedBox(height: 8),
                _buildStatusButton(
                  context,
                  'approved',
                  'Aprovado',
                  Colors.green,
                ),
                const SizedBox(height: 8),
                _buildStatusButton(
                  context,
                  'rejected',
                  'Rejeitado',
                  Colors.red,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancelar',
                  style: AppTextStyles.smallText.copyWith(
                    color: AppColors.greenlightTwo,
                  ),
                ),
              ),
            ],
          ),
    );

    if (newStatus != null && newStatus != budget.status) {
      try {
        await _budgetService.updateBudgetStatus(budget.id!, newStatus);

        // Força atualização local imediata da lista de orçamentos
        if (mounted) {
          final updatedBudgetIndex = _budgets.indexWhere(
            (b) => b.id == budget.id,
          );
          if (updatedBudgetIndex != -1) {
            setState(() {
              _budgets[updatedBudgetIndex] = _budgets[updatedBudgetIndex]
                  .copyWith(status: newStatus);
            });
          }
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Status atualizado para ${_getStatusDisplayName(newStatus)}!',
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.errorUpdatingStatus(e.toString()),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _showDeleteConfirmationDialog(BudgetModel budget) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.deleteBudget,
              style: AppTextStyles.smallText16.copyWith(
                color: AppColors.darkgrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.confirmDeleteBudget,
                  style: AppTextStyles.smallText.copyWith(
                    color: AppColors.darkgrey,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cliente: ${budget.clientName}',
                        style: AppTextStyles.smallText.copyWith(
                          color: AppColors.darkgrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Valor: ${budget.formattedTotalValue}',
                        style: AppTextStyles.smallText.copyWith(
                          color: AppColors.darkgrey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Status: ${_getStatusDisplayName(budget.status)}',
                        style: AppTextStyles.smallText.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '⚠️ Esta ação não pode ser desfeita}',
                  style: AppTextStyles.smallText.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  AppLocalizations.of(context)!.cancel,
                  style: AppTextStyles.smallText.copyWith(
                    color: AppColors.greenlightTwo,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  AppLocalizations.of(context)!.delete,
                  style: AppTextStyles.smallText.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
    );

    if (shouldDelete == true) {
      try {
        await _budgetService.deleteBudget(budget.id!);

        // Remove o orçamento da lista local
        if (mounted) {
          setState(() {
            _budgets.removeWhere((b) => b.id == budget.id);
          });
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.budgetDeletedSuccess),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.errorDeletingBudget(e.toString()),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Widget _buildStatusButton(
    BuildContext context,
    String status,
    String label,
    Color color,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context, status),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          label,
          style: AppTextStyles.smallText.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String _getStatusDisplayName(String status) {
    switch (status) {
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

  Future<void> _generatePdf(BudgetModel budget) async {
    try {
      // Mostrar loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Buscar dados do cliente
      final client = await _clientService.getClientById(budget.clientId);
      if (client == null) {
        throw Exception('Cliente não encontrado');
      }

      // Buscar perfil do usuário para pegar dados da empresa
      final userProfile = await _userProfileService.getCurrentUserProfile();
      final companyName = userProfile?.companyName ?? 'Fábrica de Software';
      final companyDocument = userProfile?.companyDocument;

      // Tentar salvar no Firebase primeiro, caso falhe fazer download direto
      try {
        await _pdfService.saveBudgetPdf(
          budget: budget,
          client: client,
          companyName: companyName,
          companyDocument: companyDocument,
        );

        // Fechar loading
        Navigator.pop(context);

        // Mostrar sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.pdfGeneratedSuccess),
            backgroundColor: Colors.green,
          ),
        );
      } catch (firebaseError) {
        // Se falhar no Firebase, fazer download direto
        await _pdfService.generateAndDownloadPdf(
          budget: budget,
          client: client,
          companyName: companyName,
          companyDocument: companyDocument,
        );

        // Fechar loading
        Navigator.pop(context);

        // Mostrar sucesso com informação sobre download direto
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'PDF gerado e baixado diretamente!\nVerifique sua pasta de Downloads.',
            ),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      // Fechar loading se ainda estiver aberto
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // Mostrar erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.errorGeneratingPdf(e.toString()),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
