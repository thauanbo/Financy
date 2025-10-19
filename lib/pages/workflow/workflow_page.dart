import 'package:fabrica_de_software/common/constants/app_colors.dart';
import 'package:fabrica_de_software/common/constants/app_text_styles.dart';
import 'package:fabrica_de_software/widgets/custom_primary_button.dart';
import 'package:fabrica_de_software/locator.dart';
import 'package:fabrica_de_software/services/client_firestore_service.dart';
import 'package:fabrica_de_software/services/budget_firestore_service.dart';
import 'package:fabrica_de_software/common/models/client_model.dart';
import 'package:fabrica_de_software/common/models/budget_model.dart';
import 'package:fabrica_de_software/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class WorkflowPage extends StatefulWidget {
  const WorkflowPage({super.key});

  @override
  State<WorkflowPage> createState() => _WorkflowPageState();
}

class _WorkflowPageState extends State<WorkflowPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _clientService = locator.get<ClientFirestoreService>();
  final _budgetService = locator.get<BudgetFirestoreService>();
  final _clientController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _commentsController = TextEditingController();
  final _daysController = TextEditingController();
  final _valueController = TextEditingController();
  final _materialsController = TextEditingController();
  bool _isLoading = false;

  // Para gerenciamento de clientes
  List<ClientModel> _availableClients = [];
  ClientModel? _selectedClient;
  bool _isCreatingNewClient = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadAvailableClients();
  }

  Future<void> _loadAvailableClients() async {
    _clientService.getUserClients().listen((clients) {
      if (mounted) {
        setState(() {
          _availableClients = clients;
        });
      }
    });
  }

  void _selectExistingClient(ClientModel client) {
    setState(() {
      _selectedClient = client;
      _isCreatingNewClient = false;
      _clientController.text = client.name;
      _phoneController.text = client.phone;
      _emailController.text = client.email;
      _addressController.text = client.address;
    });
  }

  void _startCreatingNewClient() {
    setState(() {
      _selectedClient = null;
      _isCreatingNewClient = true;
      _clientController.clear();
      _phoneController.clear();
      _emailController.clear();
      _addressController.clear();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _clientController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _commentsController.dispose();
    _daysController.dispose();
    _valueController.dispose();
    _materialsController.dispose();
    super.dispose();
  }

  Future<void> _createBudget() async {
    if (!_validateForm()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      String clientId;
      String clientName;

      if (_selectedClient != null) {
        // Cliente existente selecionado
        clientId = _selectedClient!.id ?? '';
        clientName = _selectedClient!.name;
      } else {
        // Criar novo cliente
        final client = ClientModel(
          name: _clientController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          address: _addressController.text.trim(),
          createdAt: DateTime.now(),
          ownerId: '', // Será preenchido pelo serviço
        );

        final newClientId = await _clientService.createClient(client);
        if (newClientId == null) {
          throw Exception('Erro ao criar cliente');
        }
        clientId = newClientId;
        clientName = client.name;
      }

      // Depois, criar o orçamento
      final laborValue = double.tryParse(_valueController.text) ?? 0.0;
      final materialsValue = double.tryParse(_materialsController.text) ?? 0.0;
      final workDays = int.tryParse(_daysController.text) ?? 0;
      final totalValue = laborValue + materialsValue;

      final budget = BudgetModel(
        clientId: clientId,
        clientName: clientName,
        description: _descriptionController.text.trim(),
        comments: _commentsController.text.trim(),
        workDays: workDays,
        laborValue: laborValue,
        materialsValue: materialsValue,
        totalValue: totalValue,
        status: 'aberto', // Status inicial
        createdAt: DateTime.now(),
        ownerId: '', // Será preenchido pelo serviço
      );

      await _budgetService.createBudget(budget);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.budgetCreatedSuccess),
            backgroundColor: Colors.green,
          ),
        );

        // Navegar de volta para a página inicial
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.errorCreatingBudget(e.toString()),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  bool _validateForm() {
    // Validar cliente
    if (_selectedClient == null && _clientController.text.trim().isEmpty) {
      _showError('Selecione um cliente ou digite um nome para criar novo');
      return false;
    }

    // Se está criando novo cliente, validar campos obrigatórios
    if (_isCreatingNewClient || _selectedClient == null) {
      if (_emailController.text.trim().isEmpty) {
        _showError('Email é obrigatório');
        return false;
      }
    }

    if (_descriptionController.text.trim().isEmpty) {
      _showError('Descrição do trabalho é obrigatória');
      return false;
    }
    if (_valueController.text.trim().isEmpty) {
      _showError('Valor da mão de obra é obrigatório');
      return false;
    }
    if (_daysController.text.trim().isEmpty) {
      _showError('Dias de trabalho é obrigatório');
      return false;
    }
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greenlightTwo,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Fluxo de Trabalho',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.mediumText.copyWith(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Tab Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      labelColor: AppColors.greenlightTwo,
                      unselectedLabelColor: Colors.white,
                      dividerColor: Colors.transparent,
                      tabs: const [
                        Tab(text: 'Cliente'),
                        Tab(text: 'Orçamento'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: TabBarView(
                  controller: _tabController,
                  children: [_buildClientTab(), _buildBudgetTab()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClientTab() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 20),
                Text(
                  'Cliente',
                  style: AppTextStyles.smallText16.copyWith(
                    color: AppColors.darkgrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                _buildClientSelector(),
                const SizedBox(height: 15),
                Text(
                  'Numero',
                  style: AppTextStyles.smallText16.copyWith(
                    color: AppColors.darkgrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Telefone',
                    hintText:
                        _selectedClient != null
                            ? _selectedClient!.phone.isEmpty
                                ? 'Digite o telefone'
                                : _selectedClient!.phone
                            : 'Digite o telefone',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Email',
                  style: AppTextStyles.smallText16.copyWith(
                    color: AppColors.darkgrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText:
                        _selectedClient != null
                            ? _selectedClient!.email.isEmpty
                                ? 'Digite o email'
                                : _selectedClient!.email
                            : 'Digite o email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Endereço',
                  style: AppTextStyles.smallText16.copyWith(
                    color: AppColors.darkgrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Endereço',
                    hintText:
                        _selectedClient != null
                            ? _selectedClient!.address.isEmpty
                                ? 'Digite o endereço'
                                : _selectedClient!.address
                            : 'Digite o endereço',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          PrimaryButton(
            text: 'Proximo',
            onPressed: () {
              _tabController.animateTo(1);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetTab() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 20),
                Text(
                  'Orçamento',
                  style: AppTextStyles.smallText16.copyWith(
                    color: AppColors.darkgrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                _buildSimpleClientSelector(),
                const SizedBox(height: 15),
                Text(
                  'Descricão',
                  style: AppTextStyles.smallText16.copyWith(
                    color: AppColors.darkgrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _descriptionController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Descrição do Trabalho',
                    hintText: 'Digite a descrição',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Comentarios',
                  style: AppTextStyles.smallText16.copyWith(
                    color: AppColors.darkgrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _commentsController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Comentários Adicionais',
                    hintText: 'Digite comentários adicionais',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Dias de Trabalho',
                  style: AppTextStyles.smallText16.copyWith(
                    color: AppColors.darkgrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _daysController,
                  decoration: const InputDecoration(
                    labelText: '10 days',
                    hintText: 'Digite os dias',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Valor',
                  style: AppTextStyles.smallText16.copyWith(
                    color: AppColors.darkgrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _valueController,
                  decoration: const InputDecoration(
                    labelText: 'R\$ 750,00',
                    hintText: 'Digite o valor',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Valor dos Materiais',
                  style: AppTextStyles.smallText16.copyWith(
                    color: AppColors.darkgrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _materialsController,
                  decoration: const InputDecoration(
                    labelText: 'R\$ 48,00',
                    hintText: 'Digite o valor dos materiais',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: AppColors.greenlightOne.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.greenlightOne),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: AppTextStyles.smallText.copyWith(
                          color: AppColors.greenlightTwo,
                        ),
                      ),
                      Text(
                        'R\$ 798,00',
                        style: AppTextStyles.smallText16.copyWith(
                          color: AppColors.greenlightTwo,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          PrimaryButton(
            text: _isLoading ? 'Criando...' : 'Criar Orçamento',
            onPressed: _isLoading ? null : _createBudget,
          ),
        ],
      ),
    );
  }

  Widget _buildClientSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              // Header com botões de toggle
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isCreatingNewClient = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              !_isCreatingNewClient
                                  ? AppColors.greenlightTwo
                                  : Colors.grey.shade300,
                          foregroundColor:
                              !_isCreatingNewClient
                                  ? Colors.white
                                  : Colors.grey.shade600,
                          elevation: 0,
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.selectExisting,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _startCreatingNewClient,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _isCreatingNewClient
                                  ? AppColors.greenlightTwo
                                  : Colors.grey.shade300,
                          foregroundColor:
                              _isCreatingNewClient
                                  ? Colors.white
                                  : Colors.grey.shade600,
                          elevation: 0,
                        ),
                        child: Text(AppLocalizations.of(context)!.createNew),
                      ),
                    ),
                  ],
                ),
              ),
              // Conteúdo baseado no modo selecionado
              Padding(
                padding: const EdgeInsets.all(12),
                child:
                    _isCreatingNewClient
                        ? TextField(
                          controller: _clientController,
                          decoration: const InputDecoration(
                            labelText: 'Nome do Cliente',
                            hintText: 'Digite o nome do novo cliente',
                            border: OutlineInputBorder(),
                          ),
                        )
                        : _buildClientDropdown(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClientDropdown() {
    if (_availableClients.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              Icons.person_add_outlined,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 8),
            Text(
              'Nenhum cliente cadastrado',
              style: AppTextStyles.smallText.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _startCreatingNewClient,
              child: Text(AppLocalizations.of(context)!.createFirstClient),
            ),
          ],
        ),
      );
    }

    return DropdownButtonFormField<ClientModel>(
      initialValue: _selectedClient,
      decoration: const InputDecoration(
        labelText: 'Selecionar Cliente',
        hintText: 'Escolha um cliente existente',
        border: OutlineInputBorder(),
      ),
      items:
          _availableClients.map((client) {
            return DropdownMenuItem<ClientModel>(
              value: client,
              child: Text(
                client.name,
                style: AppTextStyles.smallText16.copyWith(
                  color: AppColors.darkgrey,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
      onChanged: (ClientModel? client) {
        if (client != null) {
          _selectExistingClient(client);
        }
      },
    );
  }

  Widget _buildSimpleClientSelector() {
    if (_availableClients.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            Icon(
              Icons.person_add_outlined,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 8),
            Text(
              'Nenhum cliente cadastrado',
              style: AppTextStyles.smallText.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Vá para a aba Cliente para cadastrar',
              style: AppTextStyles.smallText.copyWith(
                color: Colors.grey.shade500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    return DropdownButtonFormField<ClientModel>(
      value: _selectedClient,
      decoration: const InputDecoration(
        labelText: 'Selecionar Cliente',
        hintText: 'Escolha um cliente existente',
        border: OutlineInputBorder(),
      ),
      items:
          _availableClients.map((client) {
            return DropdownMenuItem<ClientModel>(
              value: client,
              child: Text(
                client.name,
                style: AppTextStyles.smallText16.copyWith(
                  color: AppColors.darkgrey,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
      onChanged: (ClientModel? client) {
        if (client != null) {
          _selectExistingClient(client);
        }
      },
    );
  }
}
