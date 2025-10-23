# 🏭 Financy - App de Gestão Financeira e Orçamentos

<img src="https://raw.githubusercontent.com/thauanbo/thauanbo/refs/heads/main/img/banner-project.png" alt="Banner" width="100%">

Financy é um aplicativo de gestão financeira para profissionais e pequenas empresas. Permite criar e gerenciar orçamentos, acompanhar clientes, visualizar estatísticas de receitas, gerar PDFs profissionais e controlar status de aprovação. Oferece interface intuitiva, autenticação segura via Firebase e recursos completos para organizar seu fluxo financeiro de forma eficiente.

## ✨ Funcionalidades Implementadas

### 🔐 Autenticação Completa

### 📱 Interface Moderna

### 📊 Dashboard Principal (HomePage)

### 📈 Estatísticas (Statistics)

### 💼 Sistema de Orçamentos (WorkFlow)

### 👥 Gestão de Clientes

## 🛠 Tecnologias Utilizadas

- **Flutter 3.7.2+**: Framework multiplataforma
- **Firebase Core & Auth**: Backend e autenticação
- **GetIt**: Injeção de dependências
- **Flutter Secure Storage**: Armazenamento seguro
- **Rive**: Animações (preparado para uso)
- **Mocktail**: Testes unitários

## 📁 Estrutura do Projeto

````
fabrica_de_software/
├── lib/
│   ├── common/
│   │   ├── constants/          
│   │   │   ├── app_colors.dart
│   │   │   ├── app_text_styles.dart
│   │   │   └── routes.dart
│   │   └── models/             
│   ├── pages/
│   │   ├── app.dart           
│   │   ├── clients/          
│   │   ├── forgot_password/  
│   │   ├── home/             
│   │   ├── onboarding/       
│   │   ├── profile/           
│   │   ├── sign_in/           
│   │   ├── sign_up/           
│   │   ├── statistics/    
│   │   └── workflow/         
│   ├── services/            
│   ├── splash/                
│   ├── themes/               
│   ├── widgets/              
│   └── main.dart             
├── assets/                  
├── test/                     
└── README.md                 

## 🚀 Como Executar o Projeto

### Pré-requisitos
- Flutter SDK 3.7.2 ou superior
- Dart SDK
- VS Code ou Android Studio
- Git

````
### Passos para Instalação

1. **Clone o repositório**
   ```bash
   git clone https://github.com/thauanbo/Financy.git
   cd Financy
````
````

2. **Instale as dependências**

   ```bash
   flutter pub get
   ```

3. **Configure o Firebase (já configurado)**

   - O projeto já possui configuração Firebase
   - Arquivos `firebase_options.dart` e `google-services.json` incluídos

4. **Execute o projeto**

   ```bash
   flutter run
   ```

5. **Para web especificamente**
   ```bash
   flutter run -d chrome
   # ou
   flutter run -d edge
   ```

### Plataformas Suportadas

- ✅ **Web** (Chrome, Edge, Firefox, Safari)
- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 12.0+)
- ✅ **Windows** (Windows 10+)
- ✅ **macOS** (macOS 10.14+)
- ✅ **Linux** (Ubuntu 16.04+)

## 🧪 Testes

```bash
# Executar todos os testes
flutter test

# Análise de código
flutter analyze

# Verificar cobertura
flutter test --coverage
```


## 🎯 Próximas Funcionalidades

### Planejadas para implementar

- [ ] **WhatsApp API**: Integração real com WhatsApp Business
- [ ] **Notificações Push**: Firebase Cloud Messaging
- [ ] **Backup na nuvem**: Sincronização de dados
- [ ] **Modo escuro**: Theme switcher
- [ ] **Múltiplas empresas**: Multi-tenant
- [ ] **Relatórios avançados**: Analytics detalhados
- [ ] **Sistema de pagamentos**: Stripe/PagSeguro integration
- [ ] **Calendário**: Agendamento de serviços
- [ ] **Chat interno**: Comunicação com clientes

### Melhorias técnicas

- [ ] **CI/CD**: GitHub Actions
- [ ] **Internacionalização**: Suporte multi-idiomas
- [ ] **Acessibilidade**: Melhor suporte a screen readers
- [ ] **Performance**: Otimizações de renderização
- [ ] **Offline mode**: Funcionalidades sem internet

## 🔧 Scripts Úteis

```bash
# Compilar para produção
flutter build web --release
flutter build apk --release
flutter build windows --release

# Limpar projeto
flutter clean
flutter pub get

# Atualizar dependências
flutter pub upgrade

# Verificar dependências desatualizadas
flutter pub outdated

# Gerar ícones do app
flutter packages pub run flutter_launcher_icons:main

# Build runner (se necessário)
flutter packages pub run build_runner build
```

## 📝 Contribuição

### Como contribuir

1. **Fork** o projeto
2. **Crie uma branch** para sua feature
   ```bash
   git checkout -b feature/nova-funcionalidade
   ```
3. **Commit** suas mudanças
   ```bash
   git commit -m 'feat: adiciona nova funcionalidade'
   ```
4. **Push** para a branch
   ```bash
   git push origin feature/nova-funcionalidade
   ```
5. **Abra um Pull Request**

### Convenções de Commit

- `feat:` Nova funcionalidade
- `fix:` Correção de bug
- `docs:` Documentação
- `style:` Formatação
- `refactor:` Refatoração
- `test:` Testes
- `chore:` Tarefas de build

## 📋 Checklist de Desenvolvimento

### ✅ Implementado

- [x] Autenticação completa (login/register/forgot password)
- [x] Dashboard financeiro
- [x] Sistema de orçamentos (workflow)
- [x] Gestão de clientes
- [x] Perfil do usuário
- [x] Estatísticas e gráficos
- [x] Navegação bottom nav
- [x] Tratamento de erros
- [x] Design system consistente
- [x] Armazenamento seguro
- [x] Splash screen
- [x] Validações de formulário

### 🚧 Em desenvolvimento

- [ ] Integração WhatsApp
- [ ] Testes unitários completos

## 🐛 Problemas Conhecidos

- Avisos de `withOpacity` deprecated (cosmético)
- Algumas variáveis não utilizadas nos testes
- 
## 📄 Licença

Este projeto está sob a licença MIT.

## 👨‍💻 Autor

**Thauan**

- GitHub: [@thauanbo](https://github.com/thauanbo)
- Email: hunterdevelop@outlook.com

## 📞 Suporte

Para suporte, você pode:

- Abrir uma [issue](https://github.com/thauanbo/financy/issues) no GitHub
- Entrar em contato pelo email

---

⭐ **Se este projeto foi útil para você, considere dar uma estrela!** ⭐


## Stack utilizada

**Front-end:**

- Flutter

- Dart

- Material Design

**Back-end:**

- FireBase

## Clone o Projeto

```bash
  git clone https://github.com/thauanbo/financy.git
````

## Demonstração

![Img-Exemplo](/assets/photos/7AC6FD37-E61B-46B3-AD65-8FF1C28834E3.JPG)

Principais Componentes

```Dart
class SignUpController extends ChangeNotifier {
  final AuthService _service;

  SignUpController(this._service);

  Future<bool> signUp(String email, String password, String name) async {
  }
}
```

## 🔗 Links

[![github](https://img.shields.io/badge/my_portfolio-000?style=for-the-badge&logo=ko-fi&logoColor=white)](https://github.com/thauanbo)
[![linkedin](https://img.shields.io/badge/linkedin-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/thauan-barbosa/)
