// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Fábrica de Software';

  @override
  String get hello => 'Olá';

  @override
  String get user => 'Usuário';

  @override
  String get totalRevenue => 'Receita Total';

  @override
  String get totalSpent => 'Total Gasto';

  @override
  String get open => 'Aberto';

  @override
  String get closed => 'Fechado';

  @override
  String get budgetsGenerated => 'Orçamentos Gerados';

  @override
  String get seeAll => 'Ver todos';

  @override
  String get errorLoadingData => 'Erro ao carregar dados';

  @override
  String get noBudgetsFound => 'Nenhum orçamento encontrado';

  @override
  String get createFirstBudget => 'Crie seu primeiro orçamento!';

  @override
  String get signIn => 'Entrar';

  @override
  String get signUp => 'Cadastrar';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Senha';

  @override
  String get confirmPassword => 'Confirmar Senha';

  @override
  String get forgotPassword => 'Esqueceu a senha?';

  @override
  String get alreadyHaveAccount => 'Já tem uma conta?';

  @override
  String get dontHaveAccount => 'Não tem uma conta?';

  @override
  String get loading => 'Carregando...';

  @override
  String get creating => 'Criando...';

  @override
  String get signInError => 'Erro ao fazer login';

  @override
  String get signUpError => 'Erro ao cadastrar';

  @override
  String get weakPassword => 'A senha fornecida é muito fraca.';

  @override
  String get emailAlreadyInUse => 'Já existe uma conta para este e-mail.';

  @override
  String get userNotFound => 'Usuário não encontrado';

  @override
  String get wrongPassword => 'Senha incorreta para este usuário.';

  @override
  String get invalidEmail => 'Endereço de e-mail inválido.';

  @override
  String get client => 'Cliente';

  @override
  String get budget => 'Orçamento';

  @override
  String get selectClient => 'Selecionar Cliente';

  @override
  String get enterClientName => 'Digite o nome do cliente';

  @override
  String get selectExistingClient => 'Selecionar Existente';

  @override
  String get createNew => 'Criar Novo';

  @override
  String get noClientsRegistered => 'Nenhum cliente cadastrado';

  @override
  String get createFirstClient => 'Criar primeiro cliente';

  @override
  String get enterNewClientName => 'Digite o nome do novo cliente';

  @override
  String get chooseExistingClient => 'Escolha um cliente existente';

  @override
  String get phone => 'Telefone';

  @override
  String get enterPhone => 'Digite o telefone';

  @override
  String get address => 'Endereço';

  @override
  String get enterAddress => 'Digite o endereço';

  @override
  String get description => 'Descrição';

  @override
  String get enterDescription => 'Digite a descrição do trabalho';

  @override
  String get comments => 'Comentários';

  @override
  String get enterComments => 'Digite comentários adicionais';

  @override
  String get workEndDays => 'Prazo em Dias';

  @override
  String get enterDays => 'Digite o prazo em dias';

  @override
  String get value => 'Valor';

  @override
  String get enterValue => 'Digite o valor da mão de obra';

  @override
  String get materialsValue => 'Valor dos Materiais';

  @override
  String get enterMaterialsValue => 'Digite o valor dos materiais';

  @override
  String get next => 'Próximo';

  @override
  String get create => 'Criar';

  @override
  String get thisFieldCannotBeEmpty => 'Este campo não pode estar vazio.';

  @override
  String get clientNameRequired => 'Nome do cliente é obrigatório';

  @override
  String get selectClientOrEnterName =>
      'Selecione um cliente ou digite um nome para criar novo';

  @override
  String get emailRequired => 'E-mail é obrigatório';

  @override
  String get workDescriptionRequired => 'Descrição do trabalho é obrigatória';

  @override
  String get laborValueRequired => 'Valor da mão de obra é obrigatório';

  @override
  String get workDaysRequired => 'Prazo em dias é obrigatório';

  @override
  String get statistics => 'Estatísticas';

  @override
  String get clients => 'Clientes';

  @override
  String get profile => 'Perfil';

  @override
  String get workflow => 'Criar Orçamento';

  @override
  String get changeBudgetStatus => 'Alterar Status do Orçamento';

  @override
  String get currentStatus => 'Status atual';

  @override
  String get pending => 'Pendente';

  @override
  String get approved => 'Aprovado';

  @override
  String get rejected => 'Rejeitado';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get budgetStatusChanged => 'Status do orçamento alterado com sucesso';

  @override
  String get errorChangingStatus => 'Erro ao alterar status';

  @override
  String get selectLanguage => 'Selecionar Idioma';

  @override
  String get portuguese => 'Português';

  @override
  String get english => 'Inglês';

  @override
  String get language => 'Idioma';

  @override
  String get settings => 'Configurações';

  @override
  String get signingIn => 'Fazendo login...';

  @override
  String get creatingAccount => 'Criando conta...';

  @override
  String errorUpdatingStatus(Object error) {
    return 'Erro ao atualizar status: $error';
  }

  @override
  String get pdfGeneratedSuccess => 'PDF gerado e salvo com sucesso!';

  @override
  String errorGeneratingPdf(Object error) {
    return 'Erro ao gerar PDF: $error';
  }

  @override
  String get budgetCreatedSuccess => 'Orçamento criado com sucesso!';

  @override
  String errorCreatingBudget(Object error) {
    return 'Erro ao criar orçamento: $error';
  }

  @override
  String get selectExisting => 'Selecionar Existente';

  @override
  String get createNewClient => 'Criar Novo Cliente';

  @override
  String get budgetSentSuccess => 'Orçamento enviado com sucesso!';

  @override
  String errorSendingEmail(Object error) {
    return 'Erro ao enviar e-mail: $error';
  }

  @override
  String get createClient => 'Criar Cliente';

  @override
  String get addClient => 'Adicionar Cliente';

  @override
  String get pleaseEnterClientName => 'Por favor, insira o nome do cliente';

  @override
  String get clientCreatedSuccess => 'Cliente criado com sucesso!';

  @override
  String errorCreatingClient(Object error) {
    return 'Erro ao criar cliente: $error';
  }

  @override
  String get import => 'Importar';

  @override
  String errorLoadingProfile(Object error) {
    return 'Erro ao carregar perfil: $error';
  }

  @override
  String get profileUpdatedSuccess => 'Perfil atualizado com sucesso!';

  @override
  String get errorUpdatingProfile =>
      'Erro ao atualizar perfil. Tente novamente.';

  @override
  String errorSavingProfile(Object error) {
    return 'Erro ao salvar perfil: $error';
  }

  @override
  String get profilePhotoUpdatedSuccess =>
      'Foto de perfil atualizada com sucesso!';

  @override
  String errorChangingPhoto(Object error) {
    return 'Erro ao alterar foto: $error';
  }

  @override
  String errorLogout(Object error) {
    return 'Erro ao fazer logout: $error';
  }

  @override
  String errorDeletingAccount(Object error) {
    return 'Erro ao deletar conta: $error';
  }

  @override
  String get clientUpdatedSuccess => 'Cliente atualizado com sucesso!';

  @override
  String errorUpdatingClient(Object error) {
    return 'Erro ao atualizar cliente: $error';
  }

  @override
  String get clientDeletedSuccess => 'Cliente deletado com sucesso!';

  @override
  String errorDeletingClient(Object error) {
    return 'Erro ao deletar cliente: $error';
  }

  @override
  String get pdfDownloadedSuccess => 'PDF baixado com sucesso!';

  @override
  String errorDownloadingPdf(Object error) {
    return 'Erro ao baixar PDF: $error';
  }

  @override
  String get savedPdfs => 'PDFs Salvos';

  @override
  String get errorLoadingPdfs => 'Erro ao carregar PDFs';

  @override
  String get noSavedPdfs => 'Nenhum PDF salvo';

  @override
  String get createBudgetsToGeneratePdfs => 'Crie orçamentos para gerar PDFs';

  @override
  String get deletePdf => 'Deletar PDF';

  @override
  String get confirmDeletePdf =>
      'Tem certeza que deseja deletar este PDF? Esta ação não pode ser desfeita.';

  @override
  String get featureInDevelopment => 'Funcionalidade em desenvolvimento';

  @override
  String get view => 'Visualizar';

  @override
  String get download => 'Baixar';

  @override
  String get delete => 'Deletar';

  @override
  String get pdfDeletedSuccess => 'PDF deletado com sucesso!';

  @override
  String errorDeletingPdf(Object error) {
    return 'Erro ao deletar PDF: $error';
  }

  @override
  String get deleteBudget => 'Deletar Orçamento';

  @override
  String get confirmDeleteBudget =>
      'Tem certeza que deseja deletar este orçamento?';

  @override
  String get budgetDeletedSuccess => 'Orçamento deletado com sucesso!';

  @override
  String errorDeletingBudget(Object error) {
    return 'Erro ao deletar orçamento: $error';
  }

  @override
  String get thisActionCannotBeUndone => 'Esta ação não pode ser desfeita.';

  @override
  String get spendSmarter => 'Gaste com Inteligência';

  @override
  String get saveMore => 'Economize Mais';

  @override
  String get letsGetStarted => 'Vamos Começar';

  @override
  String get accountExists => 'Sua conta já existe?';

  @override
  String get signInLink => ' Entrar';

  @override
  String get forgotPasswordTitle => 'Esqueci a Senha';

  @override
  String get resetPassword => 'Redefinir sua senha';

  @override
  String get resetPasswordDescription =>
      'Digite seu endereço de e-mail e um link será enviado para redefinir sua senha';

  @override
  String get yourEmail => 'Seu E-mail';

  @override
  String get emailExample => 'exemplo@email.com';

  @override
  String get sendResetLink => 'Enviar Link';

  @override
  String get backToLogin => 'Voltar ao Login';

  @override
  String get deleteClient => 'Deletar Cliente';

  @override
  String get fullName => 'Nome completo';

  @override
  String get saveChanges => 'Salvar Alterações';

  @override
  String get clientInformation => 'Informações do Cliente';

  @override
  String get registrationDate => 'Data de Cadastro';

  @override
  String get budgetsCreated => 'Orçamentos Criados';

  @override
  String get errorLoadingBudgets => 'Erro ao carregar orçamentos';

  @override
  String get noBudgetsForPeriod => 'para o período selecionado';

  @override
  String get generatePdf => 'Gerar PDF';

  @override
  String get editStatus => 'Editar Status';

  @override
  String get week => 'Semana';

  @override
  String get month => 'Mês';

  @override
  String get year => 'Ano';

  @override
  String get myProfile => 'Meu Perfil';

  @override
  String get companyName => 'Nome da Empresa';

  @override
  String get companyDocument => 'CNPJ ou CPF';

  @override
  String get notifications => 'Notificações';

  @override
  String get privacy => 'Privacidade';

  @override
  String get termsConditions => 'Termos e Condições';

  @override
  String get about => 'Sobre';

  @override
  String get signOut => 'Sair da Conta';

  @override
  String get deleteAccount => 'Deletar Conta';

  @override
  String get tryAgain => 'Tente Novamente';

  @override
  String get save => 'Salvar';

  @override
  String get share => 'Compartilhar';

  @override
  String get shareOption => 'Escolha uma opção para compartilhar seu orçamento';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String get additionalMessage => 'Mensagem Adicional';

  @override
  String get send => 'Enviar';

  @override
  String get shareYourBudget => 'Compartilhe seu orçamento';

  @override
  String get selectShareOption => 'Selecione uma opção de compartilhamento';

  @override
  String get budgetOpen => 'Aberto';

  @override
  String get welcomeBack => 'Bem-vindo de Volta';

  @override
  String get enterYourEmail => 'Entre com seu e-mail';

  @override
  String get yourPassword => 'Sua Senha';

  @override
  String get enterYourPassword => 'Entre com sua senha';

  @override
  String get forgotMyPassword => 'Esqueci minha senha';

  @override
  String get yourName => 'Seu nome';

  @override
  String get enterYourName => 'Entre com seu nome';

  @override
  String get choosePassword => 'Escolha sua senha';

  @override
  String get enterPassword => 'Entre com sua senha';

  @override
  String get confirmPasswordLabel => 'Confirmar senha';

  @override
  String get defaultClient => 'Cliente';

  @override
  String get defaultBudget => 'Orçamento';
}
