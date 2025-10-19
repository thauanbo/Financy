import 'package:fabrica_de_software/common/constants/app_colors.dart';
import 'package:fabrica_de_software/common/constants/app_text_styles.dart';
import 'package:fabrica_de_software/common/constants/routes.dart';
import 'package:fabrica_de_software/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  // Mock data para demonstração
  final List<Map<String, dynamic>> _clients = [
    {'name': 'Marcia Lobo', 'phone': 'Add: 01/02/24', 'id': '001'},
    {'name': 'João Cristo', 'phone': 'Add: 01/02/24', 'id': '002'},
    {'name': 'Paulo Rodrigues', 'phone': 'Add: 01/04/24', 'id': '003'},
    {'name': 'Ingrid Da Silva', 'phone': 'Add: 01/05/24', 'id': '004'},
    {'name': 'Fernando Oliveira', 'phone': 'Add: 16/11/24', 'id': '005'},
    {'name': 'Ana Paula', 'phone': 'Add: 14/10/24', 'id': '006'},
  ];

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
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
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
                  const SizedBox(width: 48), // Para balancear o botão de voltar
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
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Lista de clientes
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _clients.length,
                        itemBuilder: (context, index) {
                          final client = _clients[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColors.greenlightOne
                                    .withOpacity(0.2),
                                child: Text(
                                  client['name'].toString().substring(0, 1),
                                  style: AppTextStyles.smallText16.copyWith(
                                    color: AppColors.greenlightTwo,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                client['name'],
                                style: AppTextStyles.smallText16.copyWith(
                                  color: AppColors.darkgrey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                client['phone'],
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
                                  NamedRoutes.profile,
                                  arguments: client,
                                );
                              },
                            ),
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
                              onPressed: () {
                                _showCreateClientDialog();
                              },
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
                                // Implementar adição de cliente existente
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
                              child: Text(
                                AppLocalizations.of(context)!.addClient,
                              ),
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

  void _showCreateClientDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
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
                  decoration: const InputDecoration(
                    labelText: 'Nome do Cliente',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
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
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(
                                  context,
                                )!.clientCreatedSuccess,
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
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
    );
  }
}
