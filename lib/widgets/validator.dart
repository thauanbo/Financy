class Validator {
  Validator._();

  static String? validatorName(String? value) {
    if (value!.isEmpty) {
      return 'Por favor, digite seu nome';
    } else if (value.length < 2) {
      return 'Nome deve ter pelo menos 2 caracteres';
    } else if (value.length > 30) {
      return 'Nome deve ter menos de 30 caracteres';
    } else if (!RegExp(r'^[a-zA-Z]+(?: [a-zA-Z]+)*$').hasMatch(value)) {
      return 'Nome pode conter apenas letras e espaços';
    }
    return null;
  }

  static String? validatorEmail(String? value) {
    if (value!.isEmpty) {
      return 'Por favor, digite seu email';
    } else if (!RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(value)) {
      return 'Por favor, digite um endereço de email válido';
    }
    return null;
  }

  static String? validatorPassword(String? value) {
    if (value!.isEmpty) {
      return 'Por favor, digite sua senha';
    } else if (value.length < 8) {
      return 'Senha deve ter pelo menos 8 caracteres';
    } else if (value.length > 20) {
      return 'Senha deve ter menos de 20 caracteres';
    } else if (!RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$',
    ).hasMatch(value)) {
      return 'Senha deve conter pelo menos uma letra maiúscula, uma minúscula e um número';
    }
    return null;
  }

  static String? validatorConfirmPassword(String? first, String? second) {
    if (second == null || second.isEmpty) {
      return 'Por favor, confirme sua senha';
    } else if (first != second) {
      return 'Senhas não coincidem';
    }
    return null;
  }
}
