import 'package:flutter/material.dart';

/// Widget que suprime avisos de overflow para desenvolvimento
class OverflowSafeWidget extends StatelessWidget {
  final Widget child;
  final bool suppressOverflow;

  const OverflowSafeWidget({
    super.key,
    required this.child,
    this.suppressOverflow = true,
  });

  @override
  Widget build(BuildContext context) {
    if (suppressOverflow) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                maxWidth: constraints.maxWidth,
              ),
              child: IntrinsicHeight(child: child),
            ),
          );
        },
      );
    }
    return child;
  }
}

/// Extensão para facilitar o uso do wrapper de overflow
extension OverflowSafeExtension on Widget {
  /// Envolve o widget para evitar erros de overflow
  Widget overflowSafe({bool suppressOverflow = true}) {
    return OverflowSafeWidget(suppressOverflow: suppressOverflow, child: this);
  }
}

/// Widget para texto que adapta automaticamente ao espaço disponível
class AdaptiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow overflow;
  final TextAlign textAlign;

  const AdaptiveText(
    this.text, {
    super.key,
    this.style,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calcula o tamanho ideal do texto
        final textSpan = TextSpan(text: text, style: style);
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          maxLines: maxLines,
        );
        textPainter.layout(maxWidth: constraints.maxWidth);

        // Se o texto não cabe, usa configurações adaptativas
        if (textPainter.didExceedMaxLines ||
            textPainter.width > constraints.maxWidth) {
          return Text(
            text,
            style: style,
            maxLines: maxLines,
            overflow: overflow,
            textAlign: textAlign,
            softWrap: true,
          );
        }

        return Text(
          text,
          style: style,
          maxLines: maxLines,
          textAlign: textAlign,
        );
      },
    );
  }
}
