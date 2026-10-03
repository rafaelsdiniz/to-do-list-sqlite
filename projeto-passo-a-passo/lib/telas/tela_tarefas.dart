import 'package:flutter/cupertino.dart';

import '../componentes/aviso.dart';
import '../componentes/campo_nova_tarefa.dart';
import '../componentes/item_tarefa.dart';
import '../componentes/logo_unitins.dart';
import '../database/db_helper.dart';
import '../models/tarefa.dart';

/// A única tela do app: o campo para digitar em cima e a lista de tarefas embaixo.
class TelaTarefas extends StatefulWidget {
  const TelaTarefas({super.key});

  @override
  State<TelaTarefas> createState() => _TelaTarefasState();
}

class _TelaTarefasState extends State<TelaTarefas> {
  final _campoDescricao = TextEditingController();

  // A busca no banco fica guardada aqui. Se chamássemos listar() direto no
  // build, o app ia no banco de novo toda vez que a tela fosse redesenhada.
  late Future<List<Tarefa>> _tarefasFuture;

  @override
  void initState() {
    super.initState();
    _tarefasFuture = DBHelper.instance.listar(); // primeira leitura, quando a tela abre
  }

  @override
  void dispose() {
    _campoDescricao.dispose();
    super.dispose();
  }

  /// Chamado depois de toda mudança no banco. Trocar o Future dentro do
  /// setState faz o FutureBuilder buscar a lista de novo.
  void _recarregar() {
    setState(() {
      _tarefasFuture = DBHelper.instance.listar();
    });
  }

  /// Botão +: grava a tarefa que foi digitada.
  Future<void> _salvar() async {
    final descricao = _campoDescricao.text.trim();
    if (descricao.isEmpty) {
      mostrarAviso(context, 'Digite a descrição da tarefa');
      return;
    }

    try {
      await DBHelper.instance.inserir(Tarefa(descricao: descricao));
    } catch (erro) {
      // Se ainda faltar algum passo, o erro aparece num aviso na tela.
      // Sem isso, o botão + simplesmente não faria nada.
      if (mounted) mostrarAviso(context, '$erro');
      return;
    }

    // Enquanto o banco gravava, a tela pode ter sido fechada.
    // Se foi, paramos aqui para não mexer numa tela que não existe mais.
    if (!mounted) return;
    _campoDescricao.clear();
    mostrarAviso(context, 'Tarefa cadastrada!');
    _recarregar();
  }

  /// Toque na tarefa: se estava pendente vira concluída, e o contrário também.
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

  /// Arrastou para o lado: apaga a tarefa do banco.
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
        // Ainda esperando o banco responder pela primeira vez: mostra a rodinha.
        // Nas outras vezes a lista antiga continua na tela enquanto carrega,
        // então nada fica piscando.
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Center(child: CupertinoActivityIndicator());
        }

        // Deu algum erro ao ler o banco.
        if (snapshot.hasError) {
          return Center(child: Text('Erro ao carregar: ${snapshot.error}'));
        }

        // O banco respondeu, mas ainda não tem nenhuma tarefa.
        final tarefas = snapshot.data ?? [];
        if (tarefas.isEmpty) {
          return const Center(
            child: Text(
              'Nenhuma tarefa cadastrada',
              style: TextStyle(color: CupertinoColors.systemGrey),
            ),
          );
        }

        // Tem tarefas: monta a lista.
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
        // Cartão branco de cantos arredondados, igual à tela de Ajustes do iPhone.
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
                    // Quando o item é arrastado, o Flutter exige que ele suma
                    // da lista na mesma hora. Por isso tiramos ele da lista
                    // primeiro e só depois apagamos do banco.
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
