import 'package:flutter/cupertino.dart';

/// Logo da Unitins no topo da tela.
/// A imagem fica em assets/imagens e esta registrada no pubspec.yaml.
class LogoUnitins extends StatelessWidget {
  const LogoUnitins({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Image.asset('assets/imagens/logo_unitins.png', height: 90),
    );
  }
}
