import 'package:flutter/cupertino.dart';

import '../tema/cores_unitins.dart';

/// O campo onde se digita a tarefa, com o botão + do lado.
/// Apertar Enter no teclado também salva.
class CampoNovaTarefa extends StatelessWidget {
  final TextEditingController controlador;
  final VoidCallback aoSalvar;

  const CampoNovaTarefa({
    super.key,
    required this.controlador,
    required this.aoSalvar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: CupertinoTextField(
              controller: controlador,
              placeholder: 'Nova tarefa',
              padding: const EdgeInsets.all(12),
              onSubmitted: (_) => aoSalvar(),
            ),
          ),
          const SizedBox(width: 8),
          CupertinoButton(
            color: CoresUnitins.amarelo,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            onPressed: aoSalvar,
            child: const Icon(CupertinoIcons.add, color: CoresUnitins.azul),
          ),
        ],
      ),
    );
  }
}
