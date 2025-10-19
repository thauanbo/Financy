#!/bin/bash
# Script para encontrar textos não traduzidos no projeto Flutter

echo "🔍 Procurando textos hardcoded no projeto..."
echo "========================================="

# Procurar por Text('...')
echo "📄 Textos em widgets Text:"
grep -r "Text('" lib/ --include="*.dart" | grep -v "AppLocalizations"

echo ""
echo "📄 Textos em SnackBar:"
grep -r "SnackBar.*Text('" lib/ --include="*.dart"

echo ""
echo "📄 Textos em showDialog:"
grep -r "showDialog.*Text('" lib/ --include="*.dart"

echo ""
echo "✅ Use AppLocalizations.of(context)! para traduzir estes textos"