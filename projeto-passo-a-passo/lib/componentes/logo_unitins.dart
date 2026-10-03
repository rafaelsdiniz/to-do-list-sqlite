import 'package:flutter/cupertino.dart';

/// O logo da Unitins que aparece no topo da tela.
/// Para o Flutter achar a imagem, a pasta assets/imagens precisa estar
/// listada no pubspec.yaml.
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
