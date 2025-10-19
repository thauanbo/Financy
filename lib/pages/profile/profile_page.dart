import 'package:fabrica_de_software/common/constants/app_colors.dart';
import 'package:fabrica_de_software/common/constants/app_text_styles.dart';
import 'package:fabrica_de_software/common/constants/routes.dart';
import 'package:fabrica_de_software/locator.dart';
import 'package:fabrica_de_software/services/secure_storage.dart';
import 'package:fabrica_de_software/services/user_profile_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fabrica_de_software/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final SecureStorage _secureStorage = const SecureStorage();
  final UserProfileService _userProfileService = locator<UserProfileService>();

  bool _isEditing = false;
  bool _isLoading = false;
  UserProfileModel? _userProfile;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _companyDocumentController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _companyNameController.dispose();
    _companyDocumentController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final profile = await _userProfileService.getCurrentUserProfile();
      if (profile != null) {
        setState(() {
          _userProfile = profile;
          _nameController.text = profile.name;
          _emailController.text = profile.email;
          _phoneController.text = profile.phone;
          _addressController.text = profile.address;
          _companyNameController.text = profile.companyName ?? '';
          _companyDocumentController.text = profile.companyDocument ?? '';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.errorLoadingProfile(e.toString()),
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

  Future<void> _saveProfile() async {
    if (_userProfile == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final updatedProfile = UserProfileModel(
        id: _userProfile!.id,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        companyName:
            _companyNameController.text.trim().isEmpty
                ? null
                : _companyNameController.text.trim(),
        companyDocument:
            _companyDocumentController.text.trim().isEmpty
                ? null
                : _companyDocumentController.text.trim(),
        profileImageUrl: _userProfile!.profileImageUrl,
      );

      final success = await _userProfileService.updateUserProfile(
        updatedProfile,
      );

      if (success) {
        setState(() {
          _userProfile = updatedProfile;
          _isEditing = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.profileUpdatedSuccess,
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.errorUpdatingProfile),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.errorSavingProfile(e.toString()),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.greenlightTwo.withOpacity(0.1),
              Colors.white,
              Colors.grey.shade50,
            ],
            stops: const [0.0, 0.3, 1.0],
          ),
        ),
        child:
            _isLoading
                ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'Carregando...',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                )
                : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Column(
                    children: [
                      // Header moderno com padding extra
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Meu Perfil',
                              style: AppTextStyles.mediumText.copyWith(
                                color: AppColors.darkgrey,
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            ),
                            if (!_isLoading)
                              IconButton(
                                icon: Icon(
                                  _isEditing ? Icons.close : Icons.edit,
                                  color: AppColors.greenlightTwo,
                                ),
                                onPressed: () {
                                  if (_isEditing) {
                                    // Cancelar edição - restaurar valores originais
                                    if (_userProfile != null) {
                                      setState(() {
                                        _nameController.text =
                                            _userProfile!.name;
                                        _emailController.text =
                                            _userProfile!.email;
                                        _phoneController.text =
                                            _userProfile!.phone;
                                        _addressController.text =
                                            _userProfile!.address;
                                        _isEditing = false;
                                      });
                                    }
                                  } else {
                                    setState(() {
                                      _isEditing = true;
                                    });
                                  }
                                },
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Avatar moderno com sombra
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.greenlightTwo,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.greenlightTwo.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                          border: Border.all(color: Colors.white, width: 4),
                          image:
                              _userProfile?.profileImageUrl != null
                                  ? DecorationImage(
                                    image: NetworkImage(
                                      _userProfile!.profileImageUrl!,
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                  : null,
                        ),
                        child:
                            _userProfile?.profileImageUrl == null
                                ? Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.white,
                                )
                                : null,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _userProfile?.name ?? 'Carregando...',
                        style: AppTextStyles.mediumText.copyWith(
                          color: AppColors.darkgrey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _userProfile?.email ?? '',
                        style: AppTextStyles.smallText.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Campos editáveis
                      _buildEditableProfileItem(
                        'Nome completo',
                        Icons.person_outline,
                        _nameController,
                      ),
                      const SizedBox(height: 15),
                      _buildEditableProfileItem(
                        'Email',
                        Icons.email_outlined,
                        _emailController,
                      ),
                      const SizedBox(height: 15),
                      _buildEditableProfileItem(
                        'Telefone',
                        Icons.phone_outlined,
                        _phoneController,
                      ),
                      const SizedBox(height: 15),
                      _buildEditableProfileItem(
                        'Endereço',
                        Icons.location_on_outlined,
                        _addressController,
                      ),

                      // Seção da Empresa
                      const SizedBox(height: 25),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Informações da Empresa (Opcional)',
                          style: AppTextStyles.smallText.copyWith(
                            color: AppColors.darkgrey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildEditableProfileItem(
                        'Nome da Empresa',
                        Icons.business_outlined,
                        _companyNameController,
                      ),
                      const SizedBox(height: 15),
                      _buildDocumentField(),

                      if (_isEditing) ...[
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _saveProfile,
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

                      // Opções do perfil
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            NamedRoutes.languageSettings,
                          );
                        },
                        child: _buildProfileItem(
                          'Idioma',
                          Icons.language_outlined,
                        ),
                      ),
                      const SizedBox(height: 15),
                      _buildProfileItem(
                        'Notificações',
                        Icons.notifications_outlined,
                      ),
                      const SizedBox(height: 15),
                      _buildProfileItem('Privacidade', Icons.lock_outline),
                      const SizedBox(height: 15),
                      _buildProfileItem(
                        'Termos e Condições',
                        Icons.description_outlined,
                      ),
                      const SizedBox(height: 15),
                      _buildProfileItem('Sobre', Icons.info_outline),

                      const SizedBox(height: 230),

                      // Botão de logout
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _showLogoutDialog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.greenlightTwo,
                            elevation: 6,
                            shadowColor: AppColors.greenlightTwo.withOpacity(
                              0.4,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'Sair da Conta',
                            style: AppTextStyles.mediumText.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 55),

                      // Botão de deletar conta
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: _showDeleteAccountDialog,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red, width: 2),
                            elevation: 2,
                            shadowColor: Colors.red.withOpacity(0.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'Deletar Conta',
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

  Widget _buildProfileItem(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.greenlightTwo),
          const SizedBox(width: 15),
          Text(
            title,
            style: AppTextStyles.smallText16.copyWith(
              color: AppColors.darkgrey,
            ),
          ),
          const Spacer(),
          Icon(Icons.chevron_right, color: AppColors.grey),
        ],
      ),
    );
  }

  Widget _buildEditableProfileItem(
    String title,
    IconData icon,
    TextEditingController controller,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border:
            _isEditing
                ? Border.all(
                  color: AppColors.greenlightTwo.withOpacity(0.3),
                  width: 2,
                )
                : null,
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.greenlightTwo),
          const SizedBox(width: 15),
          Expanded(
            child:
                _isEditing
                    ? TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: title,
                        hintStyle: AppTextStyles.smallText16.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                      style: AppTextStyles.smallText16.copyWith(
                        color: AppColors.darkgrey,
                      ),
                    )
                    : Text(
                      controller.text.isEmpty ? title : controller.text,
                      style: AppTextStyles.smallText16.copyWith(
                        color:
                            controller.text.isEmpty
                                ? AppColors.grey
                                : AppColors.darkgrey,
                      ),
                    ),
          ),
          if (!_isEditing && !_isLoading)
            Icon(Icons.chevron_right, color: AppColors.grey),
        ],
      ),
    );
  }

  Widget _buildDocumentField() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.badge_outlined, color: AppColors.greenlightTwo),
          const SizedBox(width: 15),
          Expanded(
            child:
                _isEditing
                    ? TextField(
                      controller: _companyDocumentController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'CNPJ ou CPF (apenas números)',
                        hintStyle: AppTextStyles.smallText16.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                      style: AppTextStyles.smallText16.copyWith(
                        color: AppColors.darkgrey,
                      ),
                      onChanged: (value) {
                        // Remover caracteres não numéricos
                        final numbersOnly = value.replaceAll(
                          RegExp(r'[^\d]'),
                          '',
                        );

                        String formatted = '';
                        if (numbersOnly.length <= 11) {
                          // Formatação CPF: 000.000.000-00
                          if (numbersOnly.length > 3) {
                            formatted += '${numbersOnly.substring(0, 3)}.';
                            if (numbersOnly.length > 6) {
                              formatted += '${numbersOnly.substring(3, 6)}.';
                              if (numbersOnly.length > 9) {
                                formatted += '${numbersOnly.substring(6, 9)}-';
                                formatted += numbersOnly.substring(9);
                              } else {
                                formatted += numbersOnly.substring(6);
                              }
                            } else {
                              formatted += numbersOnly.substring(3);
                            }
                          } else {
                            formatted = numbersOnly;
                          }
                        } else {
                          // Formatação CNPJ: 00.000.000/0000-00
                          if (numbersOnly.length > 2) {
                            formatted += '${numbersOnly.substring(0, 2)}.';
                            if (numbersOnly.length > 5) {
                              formatted += '${numbersOnly.substring(2, 5)}.';
                              if (numbersOnly.length > 8) {
                                formatted += '${numbersOnly.substring(5, 8)}/';
                                if (numbersOnly.length > 12) {
                                  formatted +=
                                      '${numbersOnly.substring(8, 12)}-';
                                  formatted += numbersOnly.substring(12, 14);
                                } else {
                                  formatted += numbersOnly.substring(8);
                                }
                              } else {
                                formatted += numbersOnly.substring(5);
                              }
                            } else {
                              formatted += numbersOnly.substring(2);
                            }
                          } else {
                            formatted = numbersOnly;
                          }
                        }

                        _companyDocumentController.value = TextEditingValue(
                          text: formatted,
                          selection: TextSelection.collapsed(
                            offset: formatted.length,
                          ),
                        );
                      },
                    )
                    : Text(
                      _companyDocumentController.text.isEmpty
                          ? 'CNPJ ou CPF'
                          : _companyDocumentController.text,
                      style: AppTextStyles.smallText16.copyWith(
                        color:
                            _companyDocumentController.text.isEmpty
                                ? AppColors.grey
                                : AppColors.darkgrey,
                      ),
                    ),
          ),
          if (!_isEditing && !_isLoading)
            Icon(Icons.chevron_right, color: AppColors.grey),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Sair da Conta',
              style: AppTextStyles.smallText16.copyWith(
                color: AppColors.darkgrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Tem certeza que deseja sair da sua conta?',
              style: AppTextStyles.smallText.copyWith(color: AppColors.grey),
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
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await _logout();
                },
                child: Text(
                  'Sair',
                  style: AppTextStyles.smallText.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Future<void> _logout() async {
    try {
      // Fazer logout do Firebase
      await FirebaseAuth.instance.signOut();

      // Limpar dados do storage local
      await _secureStorage.deleteOne(key: "CURRENT_USER");

      // Navegar para tela de login
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          NamedRoutes.signIn,
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao fazer logout: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Deletar Conta',
              style: AppTextStyles.smallText16.copyWith(
                color: AppColors.darkgrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Tem certeza que deseja deletar sua conta? Esta ação não pode ser desfeita e todos os seus dados serão permanentemente removidos.',
              style: AppTextStyles.smallText.copyWith(color: AppColors.grey),
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
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);

                  setState(() {
                    _isLoading = true;
                  });

                  try {
                    final success =
                        await _userProfileService.deleteUserAccount();
                    if (success) {
                      await _secureStorage.deleteOne(key: "CURRENT_USER");
                      if (mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          NamedRoutes.initial,
                          (route) => false,
                        );
                      }
                    } else {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Erro ao deletar conta. Tente novamente.',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erro ao deletar conta: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                },
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
  }
}
