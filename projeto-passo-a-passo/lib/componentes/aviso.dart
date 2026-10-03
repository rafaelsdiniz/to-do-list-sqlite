import 'package:flutter/cupertino.dart';

import '../tema/cores_unitins.dart';

// Aviso que esta na tela agora. So mostramos um por vez.
OverlayEntry? _avisoAtual;

/// Mostra um aviso curto no topo da tela, que some sozinho em 2 segundos.
/// O Overlay e uma camada por cima da tela, onde o aviso e desenhado.
void mostrarAviso(BuildContext context, String mensagem) {
  _fecharAviso();

  final aviso = OverlayEntry(builder: (_) => _Aviso(mensagem: mensagem));
  Overlay.of(context).insert(aviso);
  _avisoAtual = aviso;

  Future.delayed(const Duration(seconds: 2), () {
    if (_avisoAtual == aviso) _fecharAviso();
  });
}

void _fecharAviso() {
  _avisoAtual?.remove();
  _avisoAtual?.dispose();
  _avisoAtual = null;
}

class _Aviso extends StatelessWidget {
  final String mensagem;

  const _Aviso({required this.mensagem});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.paddingOf(context).top + 56, // logo abaixo da barra
      left: 24,
      right: 24,
      child: IgnorePointer(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: CoresUnitins.azul,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            mensagem,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: CupertinoColors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
}
