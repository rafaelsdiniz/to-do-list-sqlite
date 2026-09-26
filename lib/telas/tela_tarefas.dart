import 'package:flutter/cupertino.dart';

import '../banco/banco_dados.dart';
import '../componentes/campo_nova_tarefa.dart';
import '../componentes/item_tarefa.dart';
import '../componentes/logo_unitins.dart';
import '../modelos/tarefa.dart';

/// Tela principal. Guarda a lista e conversa com o banco.
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
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          'Minhas Tarefas',
          style: TextStyle(color: CupertinoColors.white),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const LogoUnitins(),
            CampoNovaTarefa(controlador: _campoDescricao, aoSalvar: _salvar),
            Expanded(child: _montarLista()),
          ],
        ),
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
          children: [
            for (final tarefa in _tarefas)
              ItemTarefa(
                key: ValueKey(tarefa.id),
                tarefa: tarefa,
                aoTocar: () => _alternarSituacao(tarefa),
                aoExcluir: () => _excluir(tarefa),
              ),
          ],
        ),
      ],
    );
  }
}
