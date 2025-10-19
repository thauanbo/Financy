import 'package:fabrica_de_software/common/constants/app_colors.dart';
import 'package:fabrica_de_software/common/constants/app_text_styles.dart';
import 'package:fabrica_de_software/common/constants/routes.dart';
import 'package:fabrica_de_software/common/models/client_model.dart';
import 'package:fabrica_de_software/locator.dart';
import 'package:fabrica_de_software/services/client_firestore_service.dart';
import 'package:fabrica_de_software/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class ClientsPageWithFirestore extends StatefulWidget {
  const ClientsPageWithFirestore({super.key});

  @override
  State<ClientsPageWithFirestore> createState() =>
      _ClientsPageWithFirestoreState();
}

class _ClientsPageWithFirestoreState extends State<ClientsPageWithFirestore> {
  final _clientService = locator.get<ClientFirestoreService>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
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
              child: Text(
                'Clientes',
                textAlign: TextAlign.center,
                style: AppTextStyles.smallText16.copyWith(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Content com StreamBuilder
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
                    const SizedBox(height: 20),

                    // Lista de clientes em tempo real
                    Expanded(
                      child: StreamBuilder<List<ClientModel>>(
                        stream: _clientService.getUserClients(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                'Erro ao carregar clientes: ${snapshot.error}',
                                style: AppTextStyles.smallText.copyWith(
                                  color: Colors.red,
                                ),
                              ),
                            );
                          }

                          final clients = snapshot.data ?? [];

                          if (clients.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.people_outline,
                                    size: 64,
                                    color: AppColors.grey,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Nenhum cliente encontrado',
                                    style: AppTextStyles.smallText16.copyWith(
                                      color: AppColors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Adicione seu primeiro cliente!',
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
                            itemCount: clients.length,
                            itemBuilder: (context, index) {
                              final client = clients[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: AppColors.greenlightOne
                                        .withValues(alpha: 0.2),
                                    child: Text(
                                      client.name.isNotEmpty
                                          ? client.name[0].toUpperCase()
                                          : 'C',
                                      style: AppTextStyles.smallText16.copyWith(
                                        color: AppColors.greenlightTwo,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    client.name,
                                    style: AppTextStyles.smallText16.copyWith(
                                      color: AppColors.darkgrey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Adicionado em ${_formatDate(client.createdAt)}',
                                    style: AppTextStyles.smallText.copyWith(
                                      color: AppColors.grey,
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.chevron_right,
                                    color: AppColors.grey,
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      NamedRoutes.clientProfile,
                                      arguments: {'client': client},
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    // Botões na parte inferior
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _showCreateClientDialog,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.greenlightTwo,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.createClient,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                // Implementar importação de clientes
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Funcionalidade em desenvolvimento',
                                    ),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.greenlightTwo,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                side: BorderSide(
                                  color: AppColors.greenlightTwo,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(AppLocalizations.of(context)!.import),
                            ),
                          ),
                        ],
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _showCreateClientDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.grey,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Criar Novo Cliente',
                    style: AppTextStyles.smallText16.copyWith(
                      color: AppColors.darkgrey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome do Cliente',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Telefone',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Endereço',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(AppLocalizations.of(context)!.cancel),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _createClient,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.greenlightTwo,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(AppLocalizations.of(context)!.create),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
    );
  }

  void _createClient() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.pleaseEnterClientName),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final client = ClientModel(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        createdAt: DateTime.now(),
        ownerId: '', // Será preenchido pelo serviço
      );

      await _clientService.createClient(client);

      // Limpar campos
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _addressController.clear();

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.clientCreatedSuccess),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.errorCreatingClient(e.toString()),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
