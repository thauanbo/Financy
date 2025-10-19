// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Software Factory';

  @override
  String get hello => 'Hello';

  @override
  String get user => 'User';

  @override
  String get totalRevenue => 'Total Revenue';

  @override
  String get totalSpent => 'Total Spent';

  @override
  String get open => 'Open';

  @override
  String get closed => 'Closed';

  @override
  String get budgetsGenerated => 'Generated Budgets';

  @override
  String get seeAll => 'See all';

  @override
  String get errorLoadingData => 'Error loading data';

  @override
  String get noBudgetsFound => 'No budgets found';

  @override
  String get createFirstBudget => 'Create your first budget!';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get loading => 'Loading...';

  @override
  String get creating => 'Creating...';

  @override
  String get signInError => 'Sign in error';

  @override
  String get signUpError => 'Sign up error';

  @override
  String get weakPassword => 'The password provided is too weak.';

  @override
  String get emailAlreadyInUse => 'An account already exists for this email.';

  @override
  String get userNotFound => 'User not found';

  @override
  String get wrongPassword => 'Wrong password for this user.';

  @override
  String get invalidEmail => 'Invalid email address.';

  @override
  String get client => 'Client';

  @override
  String get budget => 'Budget';

  @override
  String get selectClient => 'Select Client';

  @override
  String get enterClientName => 'Enter client name';

  @override
  String get selectExistingClient => 'Select Existing';

  @override
  String get createNew => 'Create New';

  @override
  String get noClientsRegistered => 'No clients registered';

  @override
  String get createFirstClient => 'Create first client';

  @override
  String get enterNewClientName => 'Enter new client name';

  @override
  String get chooseExistingClient => 'Choose an existing client';

  @override
  String get phone => 'Phone';

  @override
  String get enterPhone => 'Enter phone number';

  @override
  String get address => 'Address';

  @override
  String get enterAddress => 'Enter address';

  @override
  String get description => 'Description';

  @override
  String get enterDescription => 'Enter work description';

  @override
  String get comments => 'Comments';

  @override
  String get enterComments => 'Enter additional comments';

  @override
  String get workEndDays => 'Deadline in Days';

  @override
  String get enterDays => 'Enter deadline in days';

  @override
  String get value => 'Value';

  @override
  String get enterValue => 'Enter labor value';

  @override
  String get materialsValue => 'Materials Value';

  @override
  String get enterMaterialsValue => 'Enter materials value';

  @override
  String get next => 'Next';

  @override
  String get create => 'Create';

  @override
  String get thisFieldCannotBeEmpty => 'This field cannot be empty.';

  @override
  String get clientNameRequired => 'Client name is required';

  @override
  String get selectClientOrEnterName =>
      'Select a client or enter a name to create new';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get workDescriptionRequired => 'Work description is required';

  @override
  String get laborValueRequired => 'Labor value is required';

  @override
  String get workDaysRequired => 'Deadline in days is required';

  @override
  String get statistics => 'Statistics';

  @override
  String get clients => 'Clients';

  @override
  String get profile => 'Profile';

  @override
  String get workflow => 'Create Budget';

  @override
  String get changeBudgetStatus => 'Change Budget Status';

  @override
  String get currentStatus => 'Current status';

  @override
  String get pending => 'Pending';

  @override
  String get approved => 'Approved';

  @override
  String get rejected => 'Rejected';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get budgetStatusChanged => 'Budget status changed successfully';

  @override
  String get errorChangingStatus => 'Error changing status';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get portuguese => 'Portuguese';

  @override
  String get english => 'English';

  @override
  String get language => 'Language';

  @override
  String get settings => 'Settings';

  @override
  String get signingIn => 'Signing in...';

  @override
  String get creatingAccount => 'Creating account...';

  @override
  String errorUpdatingStatus(Object error) {
    return 'Error updating status: $error';
  }

  @override
  String get pdfGeneratedSuccess => 'PDF generated and saved successfully!';

  @override
  String errorGeneratingPdf(Object error) {
    return 'Error generating PDF: $error';
  }

  @override
  String get budgetCreatedSuccess => 'Budget created successfully!';

  @override
  String errorCreatingBudget(Object error) {
    return 'Error creating budget: $error';
  }

  @override
  String get selectExisting => 'Select Existing';

  @override
  String get createNewClient => 'Create New Client';

  @override
  String get budgetSentSuccess => 'Budget sent successfully!';

  @override
  String errorSendingEmail(Object error) {
    return 'Error sending email: $error';
  }

  @override
  String get createClient => 'Create Client';

  @override
  String get addClient => 'Add Client';

  @override
  String get pleaseEnterClientName => 'Please enter client name';

  @override
  String get clientCreatedSuccess => 'Client created successfully!';

  @override
  String errorCreatingClient(Object error) {
    return 'Error creating client: $error';
  }

  @override
  String get import => 'Import';

  @override
  String errorLoadingProfile(Object error) {
    return 'Error loading profile: $error';
  }

  @override
  String get profileUpdatedSuccess => 'Profile updated successfully!';

  @override
  String get errorUpdatingProfile => 'Error updating profile. Try again.';

  @override
  String errorSavingProfile(Object error) {
    return 'Error saving profile: $error';
  }

  @override
  String get profilePhotoUpdatedSuccess =>
      'Profile photo updated successfully!';

  @override
  String errorChangingPhoto(Object error) {
    return 'Error changing photo: $error';
  }

  @override
  String errorLogout(Object error) {
    return 'Error logging out: $error';
  }

  @override
  String errorDeletingAccount(Object error) {
    return 'Error deleting account: $error';
  }

  @override
  String get clientUpdatedSuccess => 'Client updated successfully!';

  @override
  String errorUpdatingClient(Object error) {
    return 'Error updating client: $error';
  }

  @override
  String get clientDeletedSuccess => 'Client deleted successfully!';

  @override
  String errorDeletingClient(Object error) {
    return 'Error deleting client: $error';
  }

  @override
  String get pdfDownloadedSuccess => 'PDF downloaded successfully!';

  @override
  String errorDownloadingPdf(Object error) {
    return 'Error downloading PDF: $error';
  }

  @override
  String get savedPdfs => 'Saved PDFs';

  @override
  String get errorLoadingPdfs => 'Error loading PDFs';

  @override
  String get noSavedPdfs => 'No saved PDFs';

  @override
  String get createBudgetsToGeneratePdfs => 'Create budgets to generate PDFs';

  @override
  String get deletePdf => 'Delete PDF';

  @override
  String get confirmDeletePdf =>
      'Are you sure you want to delete this PDF? This action cannot be undone.';

  @override
  String get featureInDevelopment => 'Feature in development';

  @override
  String get view => 'View';

  @override
  String get download => 'Download';

  @override
  String get delete => 'Delete';

  @override
  String get pdfDeletedSuccess => 'PDF deleted successfully!';

  @override
  String errorDeletingPdf(Object error) {
    return 'Error deleting PDF: $error';
  }

  @override
  String get deleteBudget => 'Delete Budget';

  @override
  String get confirmDeleteBudget =>
      'Are you sure you want to delete this budget?';

  @override
  String get budgetDeletedSuccess => 'Budget deleted successfully!';

  @override
  String errorDeletingBudget(Object error) {
    return 'Error deleting budget: $error';
  }

  @override
  String get thisActionCannotBeUndone => 'This action cannot be undone.';

  @override
  String get spendSmarter => 'Spend Smarter';

  @override
  String get saveMore => 'Save More';

  @override
  String get letsGetStarted => 'Let\'s Get Started';

  @override
  String get accountExists => 'Already have an account?';

  @override
  String get signInLink => ' Sign In';

  @override
  String get forgotPasswordTitle => 'Forgot Password';

  @override
  String get resetPassword => 'Reset your password';

  @override
  String get resetPasswordDescription =>
      'Enter your email address and a link will be sent to reset your password';

  @override
  String get yourEmail => 'Your Email';

  @override
  String get emailExample => 'example@email.com';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get deleteClient => 'Delete Client';

  @override
  String get fullName => 'Full name';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get clientInformation => 'Client Information';

  @override
  String get registrationDate => 'Registration Date';

  @override
  String get budgetsCreated => 'Created Budgets';

  @override
  String get errorLoadingBudgets => 'Error loading budgets';

  @override
  String get noBudgetsForPeriod => 'for the selected period';

  @override
  String get generatePdf => 'Generate PDF';

  @override
  String get editStatus => 'Edit Status';

  @override
  String get week => 'Week';

  @override
  String get month => 'Month';

  @override
  String get year => 'Year';

  @override
  String get myProfile => 'My Profile';

  @override
  String get companyName => 'Company Name';

  @override
  String get companyDocument => 'CNPJ or CPF';

  @override
  String get notifications => 'Notifications';

  @override
  String get privacy => 'Privacy';

  @override
  String get termsConditions => 'Terms and Conditions';

  @override
  String get about => 'About';

  @override
  String get signOut => 'Sign Out';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get save => 'Save';

  @override
  String get share => 'Share';

  @override
  String get shareOption => 'Choose an option to share your budget';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String get additionalMessage => 'Additional Message';

  @override
  String get send => 'Send';

  @override
  String get shareYourBudget => 'Share your budget';

  @override
  String get selectShareOption => 'Select a sharing option';

  @override
  String get budgetOpen => 'Open';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get enterYourEmail => 'Enter your email';

  @override
  String get yourPassword => 'Your Password';

  @override
  String get enterYourPassword => 'Enter your password';

  @override
  String get forgotMyPassword => 'Forgot my password';

  @override
  String get yourName => 'Your name';

  @override
  String get enterYourName => 'Enter your name';

  @override
  String get choosePassword => 'Choose your password';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get confirmPasswordLabel => 'Confirm password';

  @override
  String get defaultClient => 'Client';

  @override
  String get defaultBudget => 'Budget';
}
