import 'package:flutter/cupertino.dart';

import '../componentes/aviso.dart';
import '../componentes/campo_nova_tarefa.dart';
import '../componentes/item_tarefa.dart';
import '../componentes/logo_unitins.dart';
import '../database/db_helper.dart';
import '../models/tarefa.dart';

/// Tela principal: formulario em cima e lista de tarefas embaixo.
class TelaTarefas extends StatefulWidget {
  const TelaTarefas({super.key});

  @override
  State<TelaTarefas> createState() => _TelaTarefasState();
}

class _TelaTarefasState extends State<TelaTarefas> {
  final _campoDescricao = TextEditingController();

  // Future guardado no State: o FutureBuilder nao refaz a consulta a cada build.
  // ignore: unused_field (sera usado no Passo 4)
  late Future<List<Tarefa>> _tarefasFuture;

  @override
  void initState() {
    super.initState();
    // TODO(Passo 4): buscar as tarefas no banco e guardar em _tarefasFuture.
    // Depois deste passo, use hot restart (R), nao hot reload (r).
  }

  @override
  void dispose() {
    _campoDescricao.dispose();
    super.dispose();
  }

  /// Troca o Future dentro do setState, o que faz o FutureBuilder reler o banco.
  void _recarregar() {
    setState(() {
      _tarefasFuture = DBHelper.instance.listar();
    });
  }

  /// CREATE
  Future<void> _salvar() async {
    final descricao = _campoDescricao.text.trim();
    if (descricao.isEmpty) {
      mostrarAviso(context, 'Digite a descrição da tarefa');
      return;
    }

    await DBHelper.instance.inserir(Tarefa(descricao: descricao));

    if (!mounted) return; // a tela pode ter fechado durante o await
    _campoDescricao.clear();
    mostrarAviso(context, 'Tarefa cadastrada!');
    _recarregar();
  }

  /// UPDATE: marca como concluida ou pendente.
  Future<void> _alternarSituacao(Tarefa tarefa) async {
    final atualizada = tarefa.copyWith(concluida: !tarefa.concluida);
    await DBHelper.instance.atualizar(atualizada);

    if (!mounted) return;
    mostrarAviso(
      context,
      atualizada.concluida
          ? 'Tarefa concluída!'
          : 'Tarefa marcada como pendente',
    );
    _recarregar();
  }

  /// DELETE
  Future<void> _excluir(Tarefa tarefa) async {
    await DBHelper.instance.excluir(tarefa.id!);

    if (!mounted) return;
    mostrarAviso(context, 'Tarefa excluída');
    _recarregar();
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
    // TODO(Passo 4): trocar este texto por um FutureBuilder que usa o
    // _tarefasFuture e trata: carregando, erro, lista vazia e dados.
    // Para os dados, chamar _montarDados(tarefas).
    return const Center(
      child: Text(
        'A lista aparece aqui no Passo 4',
        style: TextStyle(color: CupertinoColors.systemGrey),
      ),
    );
  }

  // ignore: unused_element (sera usado no Passo 4)
  Widget _montarDados(List<Tarefa> tarefas) {
    final pendentes = tarefas.where((t) => !t.concluida).length;
    const estiloLegenda = TextStyle(
      fontSize: 13,
      color: CupertinoColors.systemGrey,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 20, 32, 6),
          child: Text(
            '$pendentes PENDENTE(S) DE ${tarefas.length}',
            style: estiloLegenda,
          ),
        ),
        // Cartao branco com cantos arredondados, como nos Ajustes do iPhone.
        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: CupertinoColors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: tarefas.length,
              itemBuilder: (context, index) {
                final tarefa = tarefas[index];
                return ItemTarefa(
                  key: ValueKey(tarefa.id),
                  tarefa: tarefa,
                  aoTocar: () => _alternarSituacao(tarefa),
                  aoExcluir: () {
                    // O Dismissible exige que o item saia da tela logo apos
                    // ser arrastado. Tiramos da lista na hora e depois
                    // apagamos do banco.
                    setState(() {
                      tarefas.remove(tarefa);
                    });
                    _excluir(tarefa);
                  },
                );
              },
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(32, 6, 32, 16),
          child: Text(
            'Toque para concluir. Arraste para a esquerda para excluir.',
            style: estiloLegenda,
          ),
        ),
      ],
    );
  }
}
