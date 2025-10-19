import 'dart:io';
import 'package:universal_html/html.dart' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fabrica_de_software/common/models/budget_model.dart';
import 'package:fabrica_de_software/common/models/client_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';

class BudgetPdfService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _currentUserId => _auth.currentUser?.uid;

  // Modelo de PDF salvo no Firestore
  static const String _pdfCollection = 'budget_pdfs';

  /// Gerar e baixar PDF diretamente (Web e Mobile)
  Future<void> generateAndDownloadPdf({
    required BudgetModel budget,
    required ClientModel client,
    String? companyName,
    String? companyDocument,
  }) async {
    try {
      // Gerar PDF bytes
      final pdfBytes = await generateBudgetPdf(
        budget: budget,
        client: client,
        companyName: companyName,
        companyDocument: companyDocument,
      );

      final fileName =
          'orcamento_${client.name.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf';

      if (kIsWeb) {
        // Download direto no navegador
        final blob = html.Blob([pdfBytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);

        html.AnchorElement(href: url)
          ..setAttribute('download', fileName)
          ..click();

        html.Url.revokeObjectUrl(url);
      } else {
        // Download no mobile (Android/iOS)
        await _downloadPdfToMobile(pdfBytes, fileName);
      }
    } catch (e) {
      throw Exception('Erro ao gerar PDF para download: $e');
    }
  }

  /// Download do PDF para dispositivos móveis
  Future<void> _downloadPdfToMobile(Uint8List pdfBytes, String fileName) async {
    try {
      // Solicitar permissões
      bool hasPermission = await _requestStoragePermission();
      if (!hasPermission) {
        throw Exception('Permissão de armazenamento negada');
      }

      // Obter diretório de downloads
      Directory? downloadsDir;
      if (Platform.isAndroid) {
        downloadsDir = Directory('/storage/emulated/0/Download');
        if (!await downloadsDir.exists()) {
          downloadsDir = await getExternalStorageDirectory();
        }
      } else if (Platform.isIOS) {
        downloadsDir = await getApplicationDocumentsDirectory();
      }

      if (downloadsDir == null) {
        throw Exception('Não foi possível acessar o diretório de downloads');
      }

      // Criar arquivo
      final file = File('${downloadsDir.path}/$fileName');
      await file.writeAsBytes(pdfBytes);

      // Abrir arquivo automaticamente
      await OpenFile.open(file.path);
    } catch (e) {
      throw Exception('Erro ao baixar PDF no dispositivo: $e');
    }
  }

  /// Solicitar permissões de armazenamento
  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      // Para Android 13+ (API 33+)
      if (await Permission.photos.isGranted ||
          await Permission.videos.isGranted ||
          await Permission.audio.isGranted) {
        return true;
      }

      // Para Android 11-12 (API 30-32)
      if (await Permission.manageExternalStorage.isGranted) {
        return true;
      }

      // Para Android 10 e inferior (API 29-)
      if (await Permission.storage.isGranted) {
        return true;
      }

      // Solicitar permissões
      Map<Permission, PermissionStatus> statuses =
          await [
            Permission.storage,
            Permission.manageExternalStorage,
          ].request();

      return statuses[Permission.storage]?.isGranted == true ||
          statuses[Permission.manageExternalStorage]?.isGranted == true;
    }

    return true; // iOS não precisa de permissões específicas
  }

  /// Gerar PDF do orçamento
  Future<Uint8List> generateBudgetPdf({
    required BudgetModel budget,
    required ClientModel client,
    String? companyName,
    String? companyDocument,
  }) async {
    // Buscar dados do usuário logado
    String userEmail = '';
    String userPhone = '';
    String userAddress = '';
    String userCompanyName = companyName ?? 'Fábrica de Software';
    String userCompanyDocument = companyDocument ?? '';

    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        userEmail = currentUser.email ?? '';

        // Buscar dados adicionais do usuário no Firestore
        final userDoc =
            await _firestore.collection('users').doc(currentUser.uid).get();
        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;
          userPhone = userData['phone'] ?? '';
          userAddress = userData['address'] ?? '';

          // Usar dados da empresa do usuário se disponível
          if (userData['companyName'] != null &&
              userData['companyName'].toString().isNotEmpty) {
            userCompanyName = userData['companyName'];
          }
          if (userData['companyDocument'] != null &&
              userData['companyDocument'].toString().isNotEmpty) {
            userCompanyDocument = userData['companyDocument'];
          }
        }
      }
    } catch (e) {
      // Continua com valores padrão em caso de erro
    }

    final pdf = pw.Document();

    // Cores personalizadas
    final primaryColor = PdfColors.green700;
    final secondaryColor = PdfColors.grey600;
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return [
            // Cabeçalho
            _buildHeader(
              userCompanyName,
              primaryColor,
              companyDocument: userCompanyDocument,
            ),
            pw.SizedBox(height: 20),

            // Informações lado a lado: Cliente e Empresa
            _buildSideBySideInfo(
              client,
              userCompanyName,
              userCompanyDocument,
              userEmail,
              userPhone,
              userAddress,
              primaryColor,
              secondaryColor,
            ),
            pw.SizedBox(height: 20),

            // Informações do orçamento
            _buildSection(
              'DETALHES DO ORÇAMENTO',
              [
                _buildInfoRow('Data:', _formatDate(budget.createdAt)),
                _buildInfoRow('Prazo:', '${budget.workDays} dias'),
                _buildInfoRow('Status:', _getStatusText(budget.status)),
              ],
              primaryColor,
              secondaryColor,
            ),
            pw.SizedBox(height: 20),

            // Descrição em formato quadrado se for grande
            _buildDescriptionSection(
              budget.description,
              primaryColor,
              secondaryColor,
            ),
            pw.SizedBox(height: 20),

            // Comentários em formato quadrado se for grande
            _buildCommentsSection(
              budget.comments.isNotEmpty
                  ? budget.comments
                  : 'Nenhum comentário adicional',
              primaryColor,
              secondaryColor,
            ),
            pw.SizedBox(height: 20),

            // Detalhamento financeiro
            _buildFinancialSection(budget, primaryColor, secondaryColor),
            pw.SizedBox(height: 30),

            // Rodapé
            _buildFooter(secondaryColor),
          ];
        },
      ),
    );

    final result = await pdf.save();
    return result;
  }

  /// Salvar PDF no Firebase Storage e registrar no Firestore
  Future<String> saveBudgetPdf({
    required BudgetModel budget,
    required ClientModel client,
    String? companyName,
    String? companyDocument,
  }) async {
    if (_currentUserId == null) {
      throw Exception('Usuário não autenticado');
    }

    try {
      // Gerar PDF
      final pdfBytes = await generateBudgetPdf(
        budget: budget,
        client: client,
        companyName: companyName,
        companyDocument: companyDocument,
      );

      // Nome do arquivo
      final fileName =
          'orcamento_${client.name.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final filePath = 'pdfs/$_currentUserId/$fileName';

      // Upload para Firebase Storage com timeout
      final uploadTask = _storage
          .ref(filePath)
          .putData(pdfBytes, SettableMetadata(contentType: 'application/pdf'));

      final snapshot = await uploadTask.timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception(
            'Timeout no upload para Firebase Storage após 30 segundos',
          );
        },
      );

      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Registrar no Firestore
      await _firestore.collection(_pdfCollection).add({
        'userId': _currentUserId,
        'budgetId': budget.id,
        'clientId': budget.clientId,
        'clientName': client.name,
        'fileName': fileName,
        'downloadUrl': downloadUrl,
        'storagePath': filePath,
        'createdAt': FieldValue.serverTimestamp(),
        'budgetTotal': budget.totalValue,
        'budgetDescription': budget.description,
      });

      return downloadUrl;
    } catch (e) {
      throw Exception('Erro ao salvar PDF: $e');
    }
  }

  /// Listar PDFs salvos do usuário
  Stream<List<Map<String, dynamic>>> getUserPdfs() {
    if (_currentUserId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection(_pdfCollection)
        .where('userId', isEqualTo: _currentUserId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return data;
          }).toList();
        });
  }

  /// Deletar PDF
  Future<void> deletePdf(String pdfId, String storagePath) async {
    try {
      // Deletar do Firestore
      await _firestore.collection(_pdfCollection).doc(pdfId).delete();

      // Deletar do Storage
      await _storage.ref(storagePath).delete();
    } catch (e) {
      throw Exception('Erro ao deletar PDF: $e');
    }
  }

  /// Baixar PDF para dispositivo local a partir de URL
  Future<void> downloadPdfToDevice(String downloadUrl, String fileName) async {
    try {
      if (kIsWeb) {
        // No web, abrir em nova aba
        html.window.open(downloadUrl, '_blank');
        return;
      }

      // Para mobile, baixar e salvar
      final response =
          await FirebaseStorage.instance.refFromURL(downloadUrl).getData();
      if (response == null) {
        throw Exception('Não foi possível baixar o arquivo');
      }

      await _downloadPdfToMobile(response, fileName);
    } catch (e) {
      throw Exception('Erro ao baixar PDF: $e');
    }
  }

  // Métodos auxiliares para construção do PDF

  pw.Widget _buildHeader(
    String companyName,
    PdfColor primaryColor, {
    String? companyDocument,
  }) {
    return pw.Container(
      width: double.infinity,
      decoration: pw.BoxDecoration(
        color: primaryColor,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      padding: const pw.EdgeInsets.all(20),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            companyName,
            style: pw.TextStyle(
              color: PdfColors.white,
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          if (companyDocument != null && companyDocument.isNotEmpty) ...[
            pw.SizedBox(height: 4),
            pw.Text(
              companyDocument,
              style: pw.TextStyle(
                color: PdfColors.white,
                fontSize: 14,
                fontWeight: pw.FontWeight.normal,
              ),
            ),
          ],
          pw.SizedBox(height: 8),
          pw.Text(
            'ORÇAMENTO',
            style: pw.TextStyle(
              color: PdfColors.white,
              fontSize: 18,
              fontWeight: pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói as informações do cliente e empresa lado a lado
  pw.Widget _buildSideBySideInfo(
    ClientModel client,
    String companyName,
    String companyDocument,
    String userEmail,
    String userPhone,
    String userAddress,
    PdfColor primaryColor,
    PdfColor secondaryColor,
  ) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Coluna da esquerda - Dados do Cliente
        pw.Expanded(
          child: _buildSection(
            'DADOS DO CLIENTE',
            [
              _buildInfoRow('Nome:', client.name),
              _buildInfoRow('Email:', client.email),
              _buildInfoRow('Telefone:', client.phone),
              _buildInfoRow('Endereço:', client.address),
            ],
            primaryColor,
            secondaryColor,
          ),
        ),
        pw.SizedBox(width: 16), // Espaçamento entre as colunas
        // Coluna da direita - Dados da Empresa
        pw.Expanded(
          child: _buildSection(
            'DADOS DA EMPRESA',
            [
              _buildInfoRow('Empresa:', companyName),
              if (companyDocument.isNotEmpty)
                _buildInfoRow('Documento:', companyDocument),
              _buildInfoRow(
                'Email:',
                userEmail.isNotEmpty
                    ? userEmail
                    : 'contato@fabricadesoftware.com',
              ),
              _buildInfoRow(
                'Telefone:',
                userPhone.isNotEmpty ? userPhone : '(11) 99999-9999',
              ),
              _buildInfoRow(
                'Endereço:',
                userAddress.isNotEmpty ? userAddress : 'São Paulo, SP',
              ),
            ],
            primaryColor,
            secondaryColor,
          ),
        ),
      ],
    );
  }

  /// Constrói a seção de descrição em formato quadrado para textos longos
  pw.Widget _buildDescriptionSection(
    String description,
    PdfColor primaryColor,
    PdfColor secondaryColor,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: pw.BoxDecoration(
            color: primaryColor.shade(0.1),
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Text(
            'DESCRIÇÃO',
            style: pw.TextStyle(
              color: primaryColor,
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.SizedBox(height: 12),
        pw.Container(
          width: double.infinity,
          constraints: pw.BoxConstraints(
            minHeight:
                description.length > 100
                    ? 80
                    : 40, // Altura mínima baseada no tamanho do texto
          ),
          padding: const pw.EdgeInsets.all(16),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300),
            borderRadius: pw.BorderRadius.circular(4),
            color: PdfColors.grey50,
          ),
          child: pw.Text(
            description,
            style: pw.TextStyle(
              fontSize: 12,
              height: 1.5, // Espaçamento entre linhas
            ),
            textAlign: pw.TextAlign.justify,
          ),
        ),
      ],
    );
  }

  /// Constrói a seção de comentários em formato quadrado para textos longos
  pw.Widget _buildCommentsSection(
    String comments,
    PdfColor primaryColor,
    PdfColor secondaryColor,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: pw.BoxDecoration(
            color: primaryColor.shade(0.1),
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Text(
            'OBSERVAÇÕES E COMENTÁRIOS',
            style: pw.TextStyle(
              color: primaryColor,
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.SizedBox(height: 12),
        pw.Container(
          width: double.infinity,
          constraints: pw.BoxConstraints(
            minHeight:
                comments.length > 50
                    ? 60
                    : 30, // Altura mínima baseada no tamanho do texto
          ),
          padding: const pw.EdgeInsets.all(16),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300),
            borderRadius: pw.BorderRadius.circular(4),
            color: PdfColors.grey50,
          ),
          child: pw.Text(
            comments,
            style: pw.TextStyle(
              fontSize: 11,
              height: 1.4, // Espaçamento entre linhas
              fontStyle: pw.FontStyle.italic,
            ),
            textAlign: pw.TextAlign.justify,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildSection(
    String title,
    List<pw.Widget> children,
    PdfColor primaryColor,
    PdfColor secondaryColor,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: pw.BoxDecoration(
            color: primaryColor.shade(0.1),
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Text(
            title,
            style: pw.TextStyle(
              color: primaryColor,
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.SizedBox(height: 12),
        pw.Container(
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300),
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Column(children: children),
        ),
      ],
    );
  }

  pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text(
              label,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
            ),
          ),
          pw.Expanded(
            child: pw.Text(value, style: const pw.TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildFinancialSection(
    BudgetModel budget,
    PdfColor primaryColor,
    PdfColor secondaryColor,
  ) {
    return pw.Column(
      children: [
        _buildSection(
          'VALORES',
          [
            _buildInfoRow(
              'Mão de obra:',
              'R\$ ${budget.laborValue.toStringAsFixed(2)}',
            ),
            _buildInfoRow(
              'Materiais:',
              'R\$ ${budget.materialsValue.toStringAsFixed(2)}',
            ),
            pw.Divider(color: PdfColors.grey400),
            _buildTotalRow(
              'TOTAL:',
              'R\$ ${budget.totalValue.toStringAsFixed(2)}',
            ),
          ],
          primaryColor,
          secondaryColor,
        ),
      ],
    );
  }

  pw.Widget _buildTotalRow(String label, String value) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 8),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 16,
              color: PdfColors.green700,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildFooter(PdfColor secondaryColor) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            'Este orçamento tem validade de 15 dias.',
            style: pw.TextStyle(
              fontSize: 10,
              color: secondaryColor,
              fontStyle: pw.FontStyle.italic,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            'Documento gerado automaticamente em ${_formatDate(DateTime.now())}',
            style: pw.TextStyle(fontSize: 8, color: secondaryColor),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Pendente';
      case 'approved':
        return 'Aprovado';
      case 'rejected':
        return 'Recusado';
      default:
        return 'Pendente';
    }
  }
}
