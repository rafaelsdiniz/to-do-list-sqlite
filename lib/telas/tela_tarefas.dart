import 'package:flutter/cupertino.dart';

import '../banco/banco_dados.dart';
import '../modelos/tarefa.dart';

class TelaTarefas extends StatefulWidget {
  const TelaTarefas({super.key});

  @override
  State<TelaTarefas> createState() => _TelaTarefasState();
}

class _TelaTarefasState extends State<TelaTarefas> {
  final _banco = BancoDados.instancia;
  final _campoDescricao = TextEditingController();

  // Lista que aparece na tela. Sempre vem do banco.
  List<Tarefa> _tarefas = [];

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  @override
  void dispose() {
    _campoDescricao.dispose();
    super.dispose();
  }

  /// READ: busca as tarefas no banco e redesenha a tela.
  Future<void> _carregar() async {
    final tarefas = await _banco.listar();
    setState(() {
      _tarefas = tarefas;
    });
  }

  /// CREATE: grava a tarefa digitada.
  Future<void> _salvar() async {
    final descricao = _campoDescricao.text.trim();
    if (descricao.isEmpty) return;

    await _banco.inserir(Tarefa(descricao: descricao));
    _campoDescricao.clear();
    _carregar();
  }

  /// UPDATE: marca como concluida ou pendente.
  Future<void> _alternarSituacao(Tarefa tarefa) async {
    await _banco.atualizar(tarefa.copiarCom(concluida: !tarefa.concluida));
    _carregar();
  }

  /// DELETE: apaga a tarefa.
  Future<void> _excluir(Tarefa tarefa) async {
    // Tira da tela na hora, porque o item ja foi arrastado para fora.
    setState(() {
      _tarefas.remove(tarefa);
    });
    await _banco.excluir(tarefa.id!);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Minhas Tarefas'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _montarFormulario(),
            Expanded(child: _montarLista()),
          ],
        ),
      ),
    );
  }

  Widget _montarFormulario() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: CupertinoTextField(
              controller: _campoDescricao,
              placeholder: 'Nova tarefa',
              padding: const EdgeInsets.all(12),
              onSubmitted: (_) => _salvar(),
            ),
          ),
          const SizedBox(width: 8),
          CupertinoButton.filled(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            onPressed: _salvar,
            child: const Icon(CupertinoIcons.add),
          ),
        ],
      ),
    );
  }

  Widget _montarLista() {
    if (_tarefas.isEmpty) {
      return const Center(
        child: Text(
          'Nenhuma tarefa cadastrada',
          style: TextStyle(color: CupertinoColors.systemGrey),
        ),
      );
    }

    final pendentes = _tarefas.where((t) => !t.concluida).length;

    return ListView(
      children: [
        CupertinoListSection.insetGrouped(
          header: Text('$pendentes pendente(s) de ${_tarefas.length}'),
          footer: const Text(
            'Toque para concluir. Arraste para a esquerda para excluir.',
          ),
          children: _tarefas.map(_montarItem).toList(),
        ),
      ],
    );
  }

  Widget _montarItem(Tarefa tarefa) {
    // Dismissible permite arrastar o item para o lado para apagar.
    return Dismissible(
      key: ValueKey(tarefa.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _excluir(tarefa),
      background: Container(
        color: CupertinoColors.destructiveRed,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(CupertinoIcons.trash, color: CupertinoColors.white),
      ),
      child: CupertinoListTile(
        onTap: () => _alternarSituacao(tarefa),
        leading: Icon(
          tarefa.concluida
              ? CupertinoIcons.checkmark_circle_fill
              : CupertinoIcons.circle,
          color: tarefa.concluida
              ? CupertinoColors.activeGreen
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
    );
  }
}
