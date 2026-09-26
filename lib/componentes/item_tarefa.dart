import 'package:flutter/cupertino.dart';

import '../models/tarefa.dart';
import '../tema/cores_unitins.dart';

/// Uma linha da lista.
/// Tocar marca como concluida. Arrastar para a esquerda exclui.
class ItemTarefa extends StatelessWidget {
  final Tarefa tarefa;
  final VoidCallback aoTocar;
  final VoidCallback aoExcluir;

  const ItemTarefa({
    super.key,
    required this.tarefa,
    required this.aoTocar,
    required this.aoExcluir,
  });

  @override
  Widget build(BuildContext context) {
    // Dismissible permite arrastar o item para o lado para apagar.
    return Dismissible(
      key: ValueKey(tarefa.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => aoExcluir(),
      background: Container(
        color: CupertinoColors.destructiveRed,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(CupertinoIcons.trash, color: CupertinoColors.white),
      ),
      // Fundo branco com linha fina embaixo, como nas listas do iPhone.
      child: Container(
        decoration: const BoxDecoration(
          color: CupertinoColors.white,
          border: Border(
            bottom: BorderSide(color: Color(0xFFE5E5EA), width: 0.5),
          ),
        ),
        child: CupertinoListTile(
          onTap: aoTocar,
          leading: Icon(
            tarefa.concluida
                ? CupertinoIcons.checkmark_circle_fill
                : CupertinoIcons.circle,
            color: tarefa.concluida
                ? CoresUnitins.azul
                : CupertinoColors.systemGrey,
          ),
          title: Text(
            tarefa.descricao,
            style: TextStyle(
              color: tarefa.concluida ? CupertinoColors.systemGrey : null,
              decoration: tarefa.concluida ? TextDecoration.lineThrough : null,
            ),
          ),
        ),
      ),
    );
  }
}
