/// Modelo que representa uma linha da tabela "tarefas".
class Tarefa {
  final int? id; // null enquanto a tarefa ainda nao foi salva no banco
  final String descricao;
  final bool concluida;

  const Tarefa({this.id, required this.descricao, this.concluida = false});

  /// Objeto Dart -> Map (formato que o sqflite grava no banco).
  /// O SQLite nao tem BOOLEAN, entao true/false vira 1/0.
  Map<String, dynamic> paraMapa() {
    return {'id': id, 'descricao': descricao, 'concluida': concluida ? 1 : 0};
  }

  /// Map (linha lida do banco) -> objeto Dart.
  factory Tarefa.doMapa(Map<String, dynamic> mapa) {
    return Tarefa(
      id: mapa['id'] as int?,
      descricao: mapa['descricao'] as String,
      concluida: mapa['concluida'] == 1,
    );
  }

  /// Cria uma copia alterando so o que for informado.
  Tarefa copiarCom({int? id, String? descricao, bool? concluida}) {
    return Tarefa(
      id: id ?? this.id,
      descricao: descricao ?? this.descricao,
      concluida: concluida ?? this.concluida,
    );
  }
}
