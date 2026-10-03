import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/tarefa.dart';

/// Unico lugar do app que conhece SQL.
/// As telas so chamam os metodos daqui.
class DBHelper {
  // Singleton: uma unica instancia e uma unica conexao aberta.
  DBHelper._();
  static final DBHelper instance = DBHelper._();

  // Nome diferente do projeto original, para os dois bancos nao se misturarem.
  static const _nomeArquivo = 'tarefas_aula.db';
  static const _versao = 1;
  static const tabela = 'tarefas';

  Database? _db;

  /// Abre o banco na primeira chamada e reaproveita nas proximas.
  Future<Database> get database async {
    _db ??= await _abrirBanco();
    return _db!;
  }

  Future<Database> _abrirBanco() async {
    final caminho = join(await getDatabasesPath(), _nomeArquivo);
    return openDatabase(
      caminho,
      version: _versao,
      onCreate: _criarTabelas, // roda so quando o arquivo .db ainda nao existe
    );
  }

  // ==========================================================================
  // PASSO 1 - Criar a tabela (CREATE TABLE)
  // ==========================================================================
  // O openDatabase chama este metodo UMA VEZ, quando o arquivo .db ainda
  // nao existe. E' aqui que dizemos como a tabela "tarefas" e'.
  //
  // O que escrever: um  await banco.execute('''  ...SQL...  ''');
  // com um CREATE TABLE de 3 colunas:
  //   id        INTEGER PRIMARY KEY AUTOINCREMENT  -> o banco gera 1, 2, 3...
  //   descricao TEXT NOT NULL                      -> o texto da tarefa
  //   concluida INTEGER NOT NULL DEFAULT 0         -> 0 = pendente, 1 = feita
  //
  // Dica: use $tabela no lugar do nome, para nao digitar errado.
  // ==========================================================================
  Future<void> _criarTabelas(Database banco, int versao) async {
    // TODO PASSO 1: apague a linha abaixo e escreva o CREATE TABLE.
    throw UnimplementedError('Falta o PASSO 1: CREATE TABLE em database/db_helper.dart');
  }

  // ==========================================================================
  // PASSO 3 - CREATE do CRUD: gravar uma tarefa (INSERT)
  // ==========================================================================
  // Recebe uma Tarefa e grava como uma nova linha na tabela.
  //
  // O que escrever (3 linhas):
  //   1. pegar o banco aberto:        final banco = await database;
  //   2. virar Map com o toMap() do PASSO 2 e TIRAR o 'id',
  //      porque quem gera o id e' o banco (AUTOINCREMENT):
  //                                   final dados = tarefa.toMap()..remove('id');
  //   3. gravar e devolver o id novo: return banco.insert(tabela, dados);
  //
  // Repare: nao escrevemos "INSERT INTO ..." na mao. O banco.insert monta o
  // SQL sozinho a partir do Map.
  // ==========================================================================
  Future<int> inserir(Tarefa tarefa) async {
    // TODO PASSO 3: apague a linha abaixo e escreva o INSERT.
    throw UnimplementedError('Falta o PASSO 3: inserir() em database/db_helper.dart');
  }

  // ==========================================================================
  // PASSO 4 - READ do CRUD: ler as tarefas (SELECT)
  // ==========================================================================
  // A tela chama este metodo para montar a lista. Enquanto ele devolver
  // uma lista vazia, o app mostra "Nenhuma tarefa cadastrada", mesmo que
  // ja existam tarefas gravadas no banco.
  //
  // O que escrever (2 linhas, no lugar do return []):
  //   1. fazer o SELECT, com as pendentes primeiro e as mais novas no topo:
  //        final linhas = await banco.query(tabela, orderBy: 'concluida ASC, id DESC');
  //   2. transformar cada linha (Map) em Tarefa com o fromMap() do PASSO 2:
  //        return linhas.map(Tarefa.fromMap).toList();
  // ==========================================================================
  Future<List<Tarefa>> listar() async {
    // Ja esta pronto: abre o banco. Na primeira vez, isso roda o PASSO 1.
    // ignore: unused_local_variable
    final banco = await database;

    // TODO PASSO 4: apague a linha abaixo e escreva o query + o map.
    return [];
  }

  // --------------------------------------------------------------------------
  // Os dois metodos abaixo ja estao prontos. Servem de EXEMPLO para explicar
  // o UPDATE e o DELETE, e o uso de  where: 'id = ?'  com  whereArgs.
  // --------------------------------------------------------------------------

  // UPDATE
  Future<int> atualizar(Tarefa tarefa) async {
    final banco = await database;
    return banco.update(
      tabela,
      tarefa.toMap(),
      where: 'id = ?',
      whereArgs: [tarefa.id], // sempre usar ? e whereArgs, nunca concatenar
    );
  }

  // DELETE
  Future<int> excluir(int id) async {
    final banco = await database;
    return banco.delete(tabela, where: 'id = ?', whereArgs: [id]);
  }
}
