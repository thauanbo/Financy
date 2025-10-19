import 'package:fabrica_de_software/common/constants/app_colors.dart';
import 'package:fabrica_de_software/common/constants/app_text_styles.dart';
import 'package:fabrica_de_software/generated/app_localizations.dart';
import 'package:fabrica_de_software/locator.dart';
import 'package:fabrica_de_software/services/budget_pdf_service.dart';
import 'package:flutter/material.dart';

class SavedPdfsPage extends StatelessWidget {
  const SavedPdfsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pdfService = locator.get<BudgetPdfService>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.greenlightTwo,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.savedPdfs,
          style: AppTextStyles.smallText16.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: pdfService.getUserPdfs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: AppColors.grey, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.errorLoadingPdfs,
                    style: AppTextStyles.smallText16.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          final pdfs = snapshot.data ?? [];

          if (pdfs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.picture_as_pdf_outlined,
                    color: AppColors.grey,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.noSavedPdfs,
                    style: AppTextStyles.smallText16.copyWith(
                      color: AppColors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.createBudgetsToGeneratePdfs,
                    style: AppTextStyles.smallText.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: pdfs.length,
            itemBuilder: (context, index) {
              final pdf = pdfs[index];
              return _buildPdfItem(context, pdf, pdfService);
            },
          );
        },
      ),
    );
  }

  Widget _buildPdfItem(
    BuildContext context,
    Map<String, dynamic> pdf,
    BudgetPdfService pdfService,
  ) {
    final createdAt = pdf['createdAt']?.toDate() ?? DateTime.now();
    final formattedDate =
        '${createdAt.day.toString().padLeft(2, '0')}/'
        '${createdAt.month.toString().padLeft(2, '0')}/'
        '${createdAt.year}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.greenlightTwo.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.picture_as_pdf,
              color: AppColors.greenlightTwo,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pdf['clientName'] ?? 'Cliente',
                  style: AppTextStyles.smallText16.copyWith(
                    color: AppColors.darkgrey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  pdf['budgetDescription'] ?? 'Orçamento',
                  style: AppTextStyles.smallText.copyWith(
                    color: AppColors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      formattedDate,
                      style: AppTextStyles.smallText.copyWith(
                        color: AppColors.grey,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'R\$ ${(pdf['budgetTotal'] ?? 0.0).toStringAsFixed(2)}',
                      style: AppTextStyles.smallText.copyWith(
                        color: AppColors.greenlightTwo,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: AppColors.grey),
            onSelected: (value) async {
              switch (value) {
                case 'download':
                  try {
                    await pdfService.downloadPdfToDevice(
                      pdf['downloadUrl'],
                      pdf['fileName'],
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!.pdfDownloadedSuccess,
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(
                              context,
                            )!.errorDownloadingPdf(e.toString()),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                  break;
                case 'view':
                  // Temporariamente desabilitado
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(context)!.featureInDevelopment,
                      ),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  break;
                case 'delete':
                  _showDeleteDialog(context, pdf, pdfService);
                  break;
              }
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: 'view',
                    child: Row(
                      children: [
                        Icon(
                          Icons.visibility,
                          size: 20,
                          color: AppColors.darkgrey,
                        ),
                        const SizedBox(width: 8),
                        Text(AppLocalizations.of(context)!.view),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'download',
                    child: Row(
                      children: [
                        Icon(
                          Icons.download,
                          size: 20,
                          color: AppColors.greenlightTwo,
                        ),
                        const SizedBox(width: 8),
                        Text(AppLocalizations.of(context)!.download),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 20, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(AppLocalizations.of(context)!.delete),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    Map<String, dynamic> pdf,
    BudgetPdfService pdfService,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.deletePdf,
              style: AppTextStyles.smallText16.copyWith(
                color: AppColors.darkgrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              AppLocalizations.of(context)!.confirmDeletePdf,
              style: AppTextStyles.smallText.copyWith(color: AppColors.grey),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  AppLocalizations.of(context)!.cancel,
                  style: AppTextStyles.smallText.copyWith(
                    color: AppColors.greenlightTwo,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    await pdfService.deletePdf(pdf['id'], pdf['storagePath']);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('PDF deletado com sucesso!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erro ao deletar PDF: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: Text(
                  AppLocalizations.of(context)!.delete,
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
