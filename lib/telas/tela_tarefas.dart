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
  late Future<List<Tarefa>> _tarefasFuture;

  @override
  void initState() {
    super.initState();
    _tarefasFuture = DBHelper.instance.listar();
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
    return FutureBuilder<List<Tarefa>>(
      future: _tarefasFuture,
      builder: (context, snapshot) {
        // 1. Carregando: so na primeira leitura. Nas proximas o FutureBuilder
        //    mantem a lista anterior na tela enquanto espera, sem piscar.
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Center(child: CupertinoActivityIndicator());
        }

        // 2. Erro
        if (snapshot.hasError) {
          return Center(child: Text('Erro ao carregar: ${snapshot.error}'));
        }

        // 3. Lista vazia
        final tarefas = snapshot.data ?? [];
        if (tarefas.isEmpty) {
          return const Center(
            child: Text(
              'Nenhuma tarefa cadastrada',
              style: TextStyle(color: CupertinoColors.systemGrey),
            ),
          );
        }

        // 4. Dados
        return _montarDados(tarefas);
      },
    );
  }

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
