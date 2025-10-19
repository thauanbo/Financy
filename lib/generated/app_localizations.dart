import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Software Factory'**
  String get appTitle;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @totalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get totalRevenue;

  /// No description provided for @totalSpent.
  ///
  /// In en, this message translates to:
  /// **'Total Spent'**
  String get totalSpent;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @budgetsGenerated.
  ///
  /// In en, this message translates to:
  /// **'Generated Budgets'**
  String get budgetsGenerated;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @errorLoadingData.
  ///
  /// In en, this message translates to:
  /// **'Error loading data'**
  String get errorLoadingData;

  /// No description provided for @noBudgetsFound.
  ///
  /// In en, this message translates to:
  /// **'No budgets found'**
  String get noBudgetsFound;

  /// No description provided for @createFirstBudget.
  ///
  /// In en, this message translates to:
  /// **'Create your first budget!'**
  String get createFirstBudget;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @creating.
  ///
  /// In en, this message translates to:
  /// **'Creating...'**
  String get creating;

  /// No description provided for @signInError.
  ///
  /// In en, this message translates to:
  /// **'Sign in error'**
  String get signInError;

  /// No description provided for @signUpError.
  ///
  /// In en, this message translates to:
  /// **'Sign up error'**
  String get signUpError;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'The password provided is too weak.'**
  String get weakPassword;

  /// No description provided for @emailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'An account already exists for this email.'**
  String get emailAlreadyInUse;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get userNotFound;

  /// No description provided for @wrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong password for this user.'**
  String get wrongPassword;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address.'**
  String get invalidEmail;

  /// No description provided for @client.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get client;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @selectClient.
  ///
  /// In en, this message translates to:
  /// **'Select Client'**
  String get selectClient;

  /// No description provided for @enterClientName.
  ///
  /// In en, this message translates to:
  /// **'Enter client name'**
  String get enterClientName;

  /// No description provided for @selectExistingClient.
  ///
  /// In en, this message translates to:
  /// **'Select Existing'**
  String get selectExistingClient;

  /// No description provided for @createNew.
  ///
  /// In en, this message translates to:
  /// **'Create New'**
  String get createNew;

  /// No description provided for @noClientsRegistered.
  ///
  /// In en, this message translates to:
  /// **'No clients registered'**
  String get noClientsRegistered;

  /// No description provided for @createFirstClient.
  ///
  /// In en, this message translates to:
  /// **'Create first client'**
  String get createFirstClient;

  /// No description provided for @enterNewClientName.
  ///
  /// In en, this message translates to:
  /// **'Enter new client name'**
  String get enterNewClientName;

  /// No description provided for @chooseExistingClient.
  ///
  /// In en, this message translates to:
  /// **'Choose an existing client'**
  String get chooseExistingClient;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @enterPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get enterPhone;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @enterAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter address'**
  String get enterAddress;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @enterDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter work description'**
  String get enterDescription;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @enterComments.
  ///
  /// In en, this message translates to:
  /// **'Enter additional comments'**
  String get enterComments;

  /// No description provided for @workEndDays.
  ///
  /// In en, this message translates to:
  /// **'Deadline in Days'**
  String get workEndDays;

  /// No description provided for @enterDays.
  ///
  /// In en, this message translates to:
  /// **'Enter deadline in days'**
  String get enterDays;

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// No description provided for @enterValue.
  ///
  /// In en, this message translates to:
  /// **'Enter labor value'**
  String get enterValue;

  /// No description provided for @materialsValue.
  ///
  /// In en, this message translates to:
  /// **'Materials Value'**
  String get materialsValue;

  /// No description provided for @enterMaterialsValue.
  ///
  /// In en, this message translates to:
  /// **'Enter materials value'**
  String get enterMaterialsValue;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @thisFieldCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'This field cannot be empty.'**
  String get thisFieldCannotBeEmpty;

  /// No description provided for @clientNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Client name is required'**
  String get clientNameRequired;

  /// No description provided for @selectClientOrEnterName.
  ///
  /// In en, this message translates to:
  /// **'Select a client or enter a name to create new'**
  String get selectClientOrEnterName;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @workDescriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Work description is required'**
  String get workDescriptionRequired;

  /// No description provided for @laborValueRequired.
  ///
  /// In en, this message translates to:
  /// **'Labor value is required'**
  String get laborValueRequired;

  /// No description provided for @workDaysRequired.
  ///
  /// In en, this message translates to:
  /// **'Deadline in days is required'**
  String get workDaysRequired;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @clients.
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get clients;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @workflow.
  ///
  /// In en, this message translates to:
  /// **'Create Budget'**
  String get workflow;

  /// No description provided for @changeBudgetStatus.
  ///
  /// In en, this message translates to:
  /// **'Change Budget Status'**
  String get changeBudgetStatus;

  /// No description provided for @currentStatus.
  ///
  /// In en, this message translates to:
  /// **'Current status'**
  String get currentStatus;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @budgetStatusChanged.
  ///
  /// In en, this message translates to:
  /// **'Budget status changed successfully'**
  String get budgetStatusChanged;

  /// No description provided for @errorChangingStatus.
  ///
  /// In en, this message translates to:
  /// **'Error changing status'**
  String get errorChangingStatus;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @portuguese.
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get portuguese;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @signingIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in...'**
  String get signingIn;

  /// No description provided for @creatingAccount.
  ///
  /// In en, this message translates to:
  /// **'Creating account...'**
  String get creatingAccount;

  /// No description provided for @errorUpdatingStatus.
  ///
  /// In en, this message translates to:
  /// **'Error updating status: {error}'**
  String errorUpdatingStatus(Object error);

  /// No description provided for @pdfGeneratedSuccess.
  ///
  /// In en, this message translates to:
  /// **'PDF generated and saved successfully!'**
  String get pdfGeneratedSuccess;

  /// No description provided for @errorGeneratingPdf.
  ///
  /// In en, this message translates to:
  /// **'Error generating PDF: {error}'**
  String errorGeneratingPdf(Object error);

  /// No description provided for @budgetCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Budget created successfully!'**
  String get budgetCreatedSuccess;

  /// No description provided for @errorCreatingBudget.
  ///
  /// In en, this message translates to:
  /// **'Error creating budget: {error}'**
  String errorCreatingBudget(Object error);

  /// No description provided for @selectExisting.
  ///
  /// In en, this message translates to:
  /// **'Select Existing'**
  String get selectExisting;

  /// No description provided for @createNewClient.
  ///
  /// In en, this message translates to:
  /// **'Create New Client'**
  String get createNewClient;

  /// No description provided for @budgetSentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Budget sent successfully!'**
  String get budgetSentSuccess;

  /// No description provided for @errorSendingEmail.
  ///
  /// In en, this message translates to:
  /// **'Error sending email: {error}'**
  String errorSendingEmail(Object error);

  /// No description provided for @createClient.
  ///
  /// In en, this message translates to:
  /// **'Create Client'**
  String get createClient;

  /// No description provided for @addClient.
  ///
  /// In en, this message translates to:
  /// **'Add Client'**
  String get addClient;

  /// No description provided for @pleaseEnterClientName.
  ///
  /// In en, this message translates to:
  /// **'Please enter client name'**
  String get pleaseEnterClientName;

  /// No description provided for @clientCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Client created successfully!'**
  String get clientCreatedSuccess;

  /// No description provided for @errorCreatingClient.
  ///
  /// In en, this message translates to:
  /// **'Error creating client: {error}'**
  String errorCreatingClient(Object error);

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @errorLoadingProfile.
  ///
  /// In en, this message translates to:
  /// **'Error loading profile: {error}'**
  String errorLoadingProfile(Object error);

  /// No description provided for @profileUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdatedSuccess;

  /// No description provided for @errorUpdatingProfile.
  ///
  /// In en, this message translates to:
  /// **'Error updating profile. Try again.'**
  String get errorUpdatingProfile;

  /// No description provided for @errorSavingProfile.
  ///
  /// In en, this message translates to:
  /// **'Error saving profile: {error}'**
  String errorSavingProfile(Object error);

  /// No description provided for @profilePhotoUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile photo updated successfully!'**
  String get profilePhotoUpdatedSuccess;

  /// No description provided for @errorChangingPhoto.
  ///
  /// In en, this message translates to:
  /// **'Error changing photo: {error}'**
  String errorChangingPhoto(Object error);

  /// No description provided for @errorLogout.
  ///
  /// In en, this message translates to:
  /// **'Error logging out: {error}'**
  String errorLogout(Object error);

  /// No description provided for @errorDeletingAccount.
  ///
  /// In en, this message translates to:
  /// **'Error deleting account: {error}'**
  String errorDeletingAccount(Object error);

  /// No description provided for @clientUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Client updated successfully!'**
  String get clientUpdatedSuccess;

  /// No description provided for @errorUpdatingClient.
  ///
  /// In en, this message translates to:
  /// **'Error updating client: {error}'**
  String errorUpdatingClient(Object error);

  /// No description provided for @clientDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Client deleted successfully!'**
  String get clientDeletedSuccess;

  /// No description provided for @errorDeletingClient.
  ///
  /// In en, this message translates to:
  /// **'Error deleting client: {error}'**
  String errorDeletingClient(Object error);

  /// No description provided for @pdfDownloadedSuccess.
  ///
  /// In en, this message translates to:
  /// **'PDF downloaded successfully!'**
  String get pdfDownloadedSuccess;

  /// No description provided for @errorDownloadingPdf.
  ///
  /// In en, this message translates to:
  /// **'Error downloading PDF: {error}'**
  String errorDownloadingPdf(Object error);

  /// No description provided for @savedPdfs.
  ///
  /// In en, this message translates to:
  /// **'Saved PDFs'**
  String get savedPdfs;

  /// No description provided for @errorLoadingPdfs.
  ///
  /// In en, this message translates to:
  /// **'Error loading PDFs'**
  String get errorLoadingPdfs;

  /// No description provided for @noSavedPdfs.
  ///
  /// In en, this message translates to:
  /// **'No saved PDFs'**
  String get noSavedPdfs;

  /// No description provided for @createBudgetsToGeneratePdfs.
  ///
  /// In en, this message translates to:
  /// **'Create budgets to generate PDFs'**
  String get createBudgetsToGeneratePdfs;

  /// No description provided for @deletePdf.
  ///
  /// In en, this message translates to:
  /// **'Delete PDF'**
  String get deletePdf;

  /// No description provided for @confirmDeletePdf.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this PDF? This action cannot be undone.'**
  String get confirmDeletePdf;

  /// No description provided for @featureInDevelopment.
  ///
  /// In en, this message translates to:
  /// **'Feature in development'**
  String get featureInDevelopment;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @pdfDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'PDF deleted successfully!'**
  String get pdfDeletedSuccess;

  /// No description provided for @errorDeletingPdf.
  ///
  /// In en, this message translates to:
  /// **'Error deleting PDF: {error}'**
  String errorDeletingPdf(Object error);

  /// No description provided for @deleteBudget.
  ///
  /// In en, this message translates to:
  /// **'Delete Budget'**
  String get deleteBudget;

  /// No description provided for @confirmDeleteBudget.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this budget?'**
  String get confirmDeleteBudget;

  /// No description provided for @budgetDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Budget deleted successfully!'**
  String get budgetDeletedSuccess;

  /// No description provided for @errorDeletingBudget.
  ///
  /// In en, this message translates to:
  /// **'Error deleting budget: {error}'**
  String errorDeletingBudget(Object error);

  /// No description provided for @thisActionCannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get thisActionCannotBeUndone;

  /// No description provided for @spendSmarter.
  ///
  /// In en, this message translates to:
  /// **'Spend Smarter'**
  String get spendSmarter;

  /// No description provided for @saveMore.
  ///
  /// In en, this message translates to:
  /// **'Save More'**
  String get saveMore;

  /// No description provided for @letsGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Get Started'**
  String get letsGetStarted;

  /// No description provided for @accountExists.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get accountExists;

  /// No description provided for @signInLink.
  ///
  /// In en, this message translates to:
  /// **' Sign In'**
  String get signInLink;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordTitle;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get resetPassword;

  /// No description provided for @resetPasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and a link will be sent to reset your password'**
  String get resetPasswordDescription;

  /// No description provided for @yourEmail.
  ///
  /// In en, this message translates to:
  /// **'Your Email'**
  String get yourEmail;

  /// No description provided for @emailExample.
  ///
  /// In en, this message translates to:
  /// **'example@email.com'**
  String get emailExample;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @deleteClient.
  ///
  /// In en, this message translates to:
  /// **'Delete Client'**
  String get deleteClient;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @clientInformation.
  ///
  /// In en, this message translates to:
  /// **'Client Information'**
  String get clientInformation;

  /// No description provided for @registrationDate.
  ///
  /// In en, this message translates to:
  /// **'Registration Date'**
  String get registrationDate;

  /// No description provided for @budgetsCreated.
  ///
  /// In en, this message translates to:
  /// **'Created Budgets'**
  String get budgetsCreated;

  /// No description provided for @errorLoadingBudgets.
  ///
  /// In en, this message translates to:
  /// **'Error loading budgets'**
  String get errorLoadingBudgets;

  /// No description provided for @noBudgetsForPeriod.
  ///
  /// In en, this message translates to:
  /// **'for the selected period'**
  String get noBudgetsForPeriod;

  /// No description provided for @generatePdf.
  ///
  /// In en, this message translates to:
  /// **'Generate PDF'**
  String get generatePdf;

  /// No description provided for @editStatus.
  ///
  /// In en, this message translates to:
  /// **'Edit Status'**
  String get editStatus;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @companyName.
  ///
  /// In en, this message translates to:
  /// **'Company Name'**
  String get companyName;

  /// No description provided for @companyDocument.
  ///
  /// In en, this message translates to:
  /// **'CNPJ or CPF'**
  String get companyDocument;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @termsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsConditions;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @shareOption.
  ///
  /// In en, this message translates to:
  /// **'Choose an option to share your budget'**
  String get shareOption;

  /// No description provided for @whatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsapp;

  /// No description provided for @additionalMessage.
  ///
  /// In en, this message translates to:
  /// **'Additional Message'**
  String get additionalMessage;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @shareYourBudget.
  ///
  /// In en, this message translates to:
  /// **'Share your budget'**
  String get shareYourBudget;

  /// No description provided for @selectShareOption.
  ///
  /// In en, this message translates to:
  /// **'Select a sharing option'**
  String get selectShareOption;

  /// No description provided for @budgetOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get budgetOpen;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @yourPassword.
  ///
  /// In en, this message translates to:
  /// **'Your Password'**
  String get yourPassword;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// No description provided for @forgotMyPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot my password'**
  String get forgotMyPassword;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get yourName;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @choosePassword.
  ///
  /// In en, this message translates to:
  /// **'Choose your password'**
  String get choosePassword;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPasswordLabel;

  /// No description provided for @defaultClient.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get defaultClient;

  /// No description provided for @defaultBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get defaultBudget;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
