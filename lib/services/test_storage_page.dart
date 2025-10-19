import 'package:flutter/material.dart';
import 'package:fabrica_de_software/services/secure_storage.dart';

class TestStoragePage extends StatelessWidget {
  final _storage = const SecureStorage();

  const TestStoragePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Testar Secure Storage')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                const userJson =
                    '{"id":"e5refBJ6XPRGpyWXlNsexl3alKy1","name":"Teste","email":"teste@gmail.com","password":null}';

                await _storage.write(key: 'CURRENT_USER', value: userJson);

                // Verifique se o widget ainda está montado antes de chamar o contexto
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Usuário salvo!')),
                  );
                }
              },
              child: const Text('Salvar CURRENT_USER'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _storage.deleteOne(key: 'CURRENT_USER');

                // Verifique se o widget ainda está montado antes de chamar o contexto
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Usuário removido!')),
                  );
                }
              },
              child: const Text('Remover CURRENT_USER'),
            ),
          ],
        ),
      ),
    );
  }
}
  
  
    // Future<void> _deleteAll() async {
    //   await _storage.deleteAll();
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Todos os dados removidos!')),
    //   );
    // }
  