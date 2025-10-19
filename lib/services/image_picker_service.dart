import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  static final ImagePicker _picker = ImagePicker();

  // Selecionar imagem da galeria
  static Future<Uint8List?> pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        return bytes;
      }
      return null;
    } catch (e) {
      rethrow; // Re-throw to let the caller handle it
    }
  }

  // Selecionar imagem da câmera
  static Future<Uint8List?> pickFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        return bytes;
      }
      return null;
    } catch (e) {
      rethrow; // Re-throw to let the caller handle it
    }
  }

  // Mostrar opções de seleção (para web, só galeria é suportada)
  static Future<Uint8List?> showImageSourceOptions() async {
    if (kIsWeb) {
      // Na web, apenas galeria é suportada
      return await pickFromGallery();
    } else {
      // Em mobile, pode escolher entre galeria e câmera
      // Esta implementação básica usa apenas galeria por enquanto
      // Para mostrar dialog de opções, seria necessário um contexto
      return await pickFromGallery();
    }
  }
}
