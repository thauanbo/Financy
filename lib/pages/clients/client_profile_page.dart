import 'package:fabrica_de_software/common/constants/app_colors.dart';
import 'package:fabrica_de_software/common/constants/app_text_styles.dart';
import 'package:fabrica_de_software/common/models/client_model.dart';
import 'package:fabrica_de_software/locator.dart';
import 'package:fabrica_de_software/services/client_firestore_service.dart';

import 'package:fabrica_de_software/widgets/validator.dart';
import 'package:fabrica_de_software/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class ClientProfilePage extends StatefulWidget {
  final ClientModel client;

  const ClientProfilePage({super.key, required this.client});

  @override
  State<ClientProfilePage> createState() => _ClientProfilePageState();
}

class _ClientProfilePageState extends State<ClientProfilePage> {
  final _clientService = locator.get<ClientFirestoreService>();
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadClientData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _loadClientData() {
    _nameController.text = widget.client.name;
    _emailController.text = widget.client.email;
    _phoneController.text = widget.client.phone;
    _addressController.text = widget.client.address;
  }

  Future<void> _saveClient() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final updatedClient = widget.client.copyWith(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
      );

      await _clientService.updateClient(widget.client.id!, updatedClient);

      setState(() {
        _isEditing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.clientUpdatedSuccess),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.errorUpdatingClient(e.toString()),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteClient() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Deletar Cliente',
              style: AppTextStyles.smallText16.copyWith(
                color: AppColors.darkgrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Tem certeza que deseja deletar o cliente "${widget.client.name}"? Esta ação não pode ser desfeita.',
              style: AppTextStyles.smallText.copyWith(color: AppColors.grey),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Cancelar',
                  style: AppTextStyles.smallText.copyWith(
                    color: AppColors.greenlightTwo,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  'Deletar',
                  style: AppTextStyles.smallText.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _clientService.deleteClient(widget.client.id!);

        if (mounted) {
          Navigator.pop(
            context,
            true,
          ); // Retorna true para indicar que o cliente foi deletado
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.clientDeletedSuccess),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.errorDeletingClient(e.toString()),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.darkgrey),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Perfil',
          style: AppTextStyles.mediumText.copyWith(
            color: AppColors.darkgrey,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          if (!_isLoading)
            IconButton(
              icon: Icon(
                _isEditing ? Icons.close : Icons.edit,
                color: AppColors.greenlightTwo,
              ),
              onPressed: () {
                if (_isEditing) {
                  // Cancelar edição - restaurar valores originais
                  setState(() {
                    _loadClientData();
                    _isEditing = false;
                  });
                } else {
                  setState(() {
                    _isEditing = true;
                  });
                }
              },
            ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Avatar e nome
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.greenlightTwo,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.client.name,
                        style: AppTextStyles.mediumText.copyWith(
                          color: AppColors.darkgrey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Cadastrado em ${_formatDate(widget.client.createdAt)}',
                        style: AppTextStyles.smallText.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Campos editáveis
                      Container(
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: TextFormField(
                          controller: _nameController,
                          enabled: _isEditing,
                          validator: Validator.validatorName,
                          decoration: InputDecoration(
                            labelText: 'Nome completo',
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: AppColors.greenlightTwo,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: TextFormField(
                          controller: _emailController,
                          enabled: _isEditing,
                          validator: Validator.validatorEmail,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: AppColors.greenlightTwo,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: TextFormField(
                          controller: _phoneController,
                          enabled: _isEditing,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Telefone',
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.phone_outlined,
                              color: AppColors.greenlightTwo,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: TextFormField(
                          controller: _addressController,
                          enabled: _isEditing,
                          maxLines: 2,
                          decoration: InputDecoration(
                            labelText: 'Endereço',
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.location_on_outlined,
                              color: AppColors.greenlightTwo,
                            ),
                          ),
                        ),
                      ),

                      if (_isEditing) ...[
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _saveClient,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.greenlightTwo,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Salvar Alterações',
                              style: AppTextStyles.mediumText.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 40),

                      // Informações do cliente
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Informações do Cliente',
                              style: AppTextStyles.smallText16.copyWith(
                                color: AppColors.darkgrey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),
                            _buildInfoRow(
                              'Data de Cadastro',
                              _formatDate(widget.client.createdAt),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Botão de deletar cliente
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: _deleteClient,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Deletar Cliente',
                            style: AppTextStyles.mediumText.copyWith(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            '$label:',
            style: AppTextStyles.smallText.copyWith(
              color: AppColors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.smallText.copyWith(color: AppColors.darkgrey),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
