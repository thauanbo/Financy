import 'package:fabrica_de_software/common/constants/app_colors.dart';
import 'package:fabrica_de_software/common/constants/app_text_styles.dart';
import 'package:fabrica_de_software/widgets/custom_primary_button.dart';
import 'package:fabrica_de_software/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class WorkflowSharePage extends StatefulWidget {
  const WorkflowSharePage({super.key});

  @override
  State<WorkflowSharePage> createState() => _WorkflowSharePageState();
}

class _WorkflowSharePageState extends State<WorkflowSharePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _messageController.dispose();
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
              child: Column(
                children: [
                  Text(
                    'Orçamento',
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
                        Tab(text: 'Salvar'),
                        Tab(text: 'Compartilhar'),
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
                  children: [_buildSaveTab(), _buildShareTab()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveTab() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 20),
                Text(
                  'Escolha uma opção para compartilhar seu orçamento',
                  style: AppTextStyles.smallText16.copyWith(
                    color: AppColors.darkgrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),

                // Share Options
                _buildShareOption('WhatsApp', Icons.message, true),
                const SizedBox(height: 10),
                _buildShareOption('Email', Icons.email, false),
                const SizedBox(height: 10),
                _buildShareOption('PDF', Icons.picture_as_pdf, false),

                const SizedBox(height: 30),
                Text(
                  'Messagem Adicional',
                  style: AppTextStyles.smallText16.copyWith(
                    color: AppColors.darkgrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 120,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.grey.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'This is a Budget...........',
                        style: AppTextStyles.smallText.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          'A. JhamellBusiness1',
                          style: AppTextStyles.smallText.copyWith(
                            color: AppColors.greenlightTwo,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          PrimaryButton(
            text: 'Enviar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context)!.budgetSentSuccess,
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildShareTab() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.share, size: 80, color: AppColors.greenlightTwo),
          const SizedBox(height: 20),
          Text(
            'Compartilhe seu orçamento',
            style: AppTextStyles.smallText16.copyWith(
              color: AppColors.darkgrey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Selecione uma opção de compartilhamento',
            style: AppTextStyles.smallText.copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: 40),
          PrimaryButton(
            text: 'Compartilhar',
            onPressed: () {
              _tabController.animateTo(0);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildShareOption(String title, IconData icon, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color:
            isSelected
                ? AppColors.greenlightTwo.withOpacity(0.1)
                : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? AppColors.greenlightTwo : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.greenlightTwo : AppColors.grey,
          ),
          const SizedBox(width: 15),
          Text(
            title,
            style: AppTextStyles.smallText16.copyWith(
              color: isSelected ? AppColors.greenlightTwo : AppColors.darkgrey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const Spacer(),
          if (isSelected)
            Icon(Icons.check_circle, color: AppColors.greenlightTwo),
        ],
      ),
    );
  }
}
