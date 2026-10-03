import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/tarefa.dart';

/// Toda a conversa com o banco de dados acontece aqui.
/// A tela nunca escreve SQL: ela só chama inserir, listar, atualizar e excluir.
class DBHelper {
  // O construtor é privado (o "_") e existe uma instância só, a "instance".
  // Assim o app inteiro usa o mesmo DBHelper e a mesma conexão com o banco.
  // Esse jeito de fazer tem nome: singleton.
  DBHelper._();
  static final DBHelper instance = DBHelper._();

  // Nome diferente do projeto completo, para os dois bancos não se misturarem.
  static const _nomeArquivo = 'tarefas_aula.db';
  static const _versao = 1; // se um dia a tabela mudar, essa versão sobe para 2
  static const tabela = 'tarefas';

  Database? _db;

  /// Na primeira vez que alguém pede o banco, ele é aberto.
  /// Nas próximas vezes, devolvemos o mesmo que já está aberto.
  Future<Database> get database async {
    _db ??= await _abrirBanco();
    return _db!;
  }

  Future<Database> _abrirBanco() async {
    // getDatabasesPath() diz em qual pasta o sistema guarda os bancos.
    // O join junta essa pasta com o nome do arquivo.
    final caminho = join(await getDatabasesPath(), _nomeArquivo);
    return openDatabase(
      caminho,
      version: _versao,
      // O onCreate só roda se o arquivo ainda não existe,
      // ou seja, na primeira vez que o app é aberto.
      onCreate: _criarTabelas,
    );
  }

  // ===== PASSO 1: COMEÇA AQUI =====
  // Aqui é onde a tabela "tarefas" é criada. Sem ela não tem onde guardar
  // nada, e a tela mostra o erro "Falta o PASSO 1".
  // O código para colar está no README, no Passo 1.
  Future<void> _criarTabelas(Database banco, int versao) async {
    throw UnimplementedError('Falta o PASSO 1: CREATE TABLE em database/db_helper.dart');
  }
  // ===== PASSO 1: TERMINA AQUI =====

  // ===== PASSO 3: COMEÇA AQUI =====
  // Aqui a tarefa digitada é gravada no banco. Enquanto falta este passo,
  // apertar o + mostra o aviso "Falta o PASSO 3".
  // O código para colar está no README, no Passo 3.
  Future<int> inserir(Tarefa tarefa) async {
    throw UnimplementedError('Falta o PASSO 3: inserir() em database/db_helper.dart');
  }
  // ===== PASSO 3: TERMINA AQUI =====

  // ===== PASSO 4: COMEÇA AQUI =====
  // Aqui as tarefas são lidas do banco para aparecer na tela. Por enquanto
  // devolve uma lista vazia, então a tela mostra "Nenhuma tarefa cadastrada"
  // mesmo que já existam tarefas gravadas.
  // O código para colar está no README, no Passo 4.
  Future<List<Tarefa>> listar() async {
    await database; // abre o banco (e, na primeira vez, cria a tabela do Passo 1)
    return [];
  }
  // ===== PASSO 4: TERMINA AQUI =====

  // Os dois métodos abaixo já estão prontos.
  // Eles mostram como atualizar e apagar uma linha específica pelo id.

  /// Salva a mudança de uma tarefa que já existe (o U do CRUD).
  /// A gente usa para marcar como concluída ou pendente.
  Future<int> atualizar(Tarefa tarefa) async {
    final banco = await database;
    return banco.update(
      tabela,
      tarefa.toMap(),
      // O "?" é trocado pelo valor do whereArgs. Nunca monte o SQL juntando
      // texto, tipo 'id = ' + id: isso abre a porta para SQL Injection.
      where: 'id = ?',
      whereArgs: [tarefa.id],
    );
  }

  /// Apaga a tarefa com esse id (o D do CRUD).
  Future<int> excluir(int id) async {
    final banco = await database;
    return banco.delete(tabela, where: 'id = ?', whereArgs: [id]);
  }
}
