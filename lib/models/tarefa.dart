/// Modelo que representa uma linha da tabela "tarefas".
class Tarefa {
  final int? id; // null enquanto a tarefa ainda nao foi salva no banco
  final String descricao;
  final bool concluida;

  const Tarefa({this.id, required this.descricao, this.concluida = false});

  /// Objeto Dart -> Map (formato que o sqflite grava no banco).
  /// O SQLite nao tem BOOLEAN, entao true/false vira 1/0.
  Map<String, dynamic> toMap() {
    // TODO(Passo 1): devolver um Map com as chaves 'id', 'descricao' e
    // 'concluida' (true vira 1, false vira 0).
    throw UnimplementedError('Passo 1: escrever o toMap()');
  }

  /// Map (linha lida do banco) -> objeto Dart.
  factory Tarefa.fromMap(Map<String, dynamic> map) {
    // TODO(Passo 1): criar a Tarefa lendo o Map (1 vira true, 0 vira false).
    throw UnimplementedError('Passo 1: escrever o fromMap()');
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
