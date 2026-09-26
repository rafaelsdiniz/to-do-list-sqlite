/// Modelo que representa uma linha da tabela "tarefas".
class Tarefa {
  final int? id; // null enquanto a tarefa ainda nao foi salva no banco
  final String descricao;
  final bool concluida;

  const Tarefa({this.id, required this.descricao, this.concluida = false});

  /// Objeto Dart -> Map (formato que o sqflite grava no banco).
  /// O SQLite nao tem BOOLEAN, entao true/false vira 1/0.
  Map<String, dynamic> toMap() {
    return {'id': id, 'descricao': descricao, 'concluida': concluida ? 1 : 0};
  }

  /// Map (linha lida do banco) -> objeto Dart.
  factory Tarefa.fromMap(Map<String, dynamic> map) {
    return Tarefa(
      id: map['id'] as int?,
      descricao: map['descricao'] as String,
      concluida: map['concluida'] == 1,
    );
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
