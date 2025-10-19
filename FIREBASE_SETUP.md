# Fábrica de Software - Flutter App

## ⚠️ Configuração do Firebase

Este projeto usa Firebase para autenticação e armazenamento. Para executar localmente, você precisa configurar suas próprias credenciais do Firebase.

### Passos para Configuração:

1. **Criar projeto no Firebase Console**

   - Acesse [Firebase Console](https://console.firebase.google.com/)
   - Crie um novo projeto

2. **Configurar Firebase para Flutter**

   ```bash
   # Instalar Firebase CLI
   npm install -g firebase-tools

   # Fazer login
   firebase login

   # Instalar FlutterFire CLI
   dart pub global activate flutterfire_cli

   # Configurar o projeto
   flutterfire configure
   ```

3. **Arquivos de Configuração**

   Copie os arquivos template e substitua pelas suas credenciais:

   ```bash
   # Firebase Options
   cp lib/firebase_options.dart.template lib/firebase_options.dart

   # Google Services (Android)
   cp android/app/google-services.json.template android/app/google-services.json
   ```

4. **Configurar Regras do Firebase**

   Configure as regras de segurança no Firebase Console para:

   - Authentication
   - Firestore Database
   - Storage

### Variáveis de Ambiente

As seguintes variáveis podem ser configuradas:

- `FIREBASE_PROJECT_ID`: ID do projeto Firebase
- `FIREBASE_API_KEY_WEB`: API Key para web
- `FIREBASE_API_KEY_ANDROID`: API Key para Android
- `FIREBASE_API_KEY_IOS`: API Key para iOS

### Serviços Firebase Utilizados

- **Authentication**: Login/cadastro de usuários
- **Firestore**: Banco de dados NoSQL
- **Storage**: Armazenamento de arquivos (PDFs, imagens)

## Executando o Projeto

```bash
# Instalar dependências
flutter pub get

# Executar em desenvolvimento
flutter run

# Build para produção
flutter build apk --release
```
