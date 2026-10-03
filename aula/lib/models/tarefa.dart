/// Modelo que representa uma linha da tabela "tarefas".
class Tarefa {
  final int? id; // null enquanto a tarefa ainda nao foi salva no banco
  final String descricao;
  final bool concluida;

  const Tarefa({this.id, required this.descricao, this.concluida = false});

  // ==========================================================================
  // PASSO 2 (parte A) - toMap(): objeto Dart -> linha do banco
  // ==========================================================================
  // O sqflite nao sabe gravar um objeto Tarefa. Ele grava um Map, em que
  // cada chave e' o NOME DE UMA COLUNA da tabela (as que criamos no PASSO 1).
  //
  // O que escrever: um return com um Map de 3 chaves:
  //   'id'        -> id
  //   'descricao' -> descricao
  //   'concluida' -> 1 se for true, 0 se for false
  //
  // Por que 1 e 0? O SQLite NAO tem tipo booleano, so INTEGER.
  // Dica: use o operador ternario   concluida ? 1 : 0
  // ==========================================================================
  Map<String, dynamic> toMap() {
    // TODO PASSO 2A: apague a linha abaixo e escreva o return com o Map.
    throw UnimplementedError('Falta o PASSO 2A: toMap() em models/tarefa.dart');
  }

  // ==========================================================================
  // PASSO 2 (parte B) - fromMap(): linha do banco -> objeto Dart
  // ==========================================================================
  // E' o caminho de volta: quando fazemos um SELECT, o banco devolve cada
  // linha como um Map. Aqui transformamos esse Map num objeto Tarefa.
  //
  // O que escrever: um return Tarefa(...) lendo cada coluna do map:
  //   id        <- map['id'] as int?
  //   descricao <- map['descricao'] as String
  //   concluida <- map['concluida'] == 1    (1 vira true, 0 vira false)
  // ==========================================================================
  factory Tarefa.fromMap(Map<String, dynamic> map) {
    // TODO PASSO 2B: apague a linha abaixo e escreva o return Tarefa(...).
    throw UnimplementedError('Falta o PASSO 2B: fromMap() em models/tarefa.dart');
  }

  /// Cria uma copia alterando so o que for informado.
  Tarefa copyWith({int? id, String? descricao, bool? concluida}) {
    return Tarefa(
      id: id ?? this.id,
      descricao: descricao ?? this.descricao,
      concluida: concluida ?? this.concluida,
    );
  }
}
