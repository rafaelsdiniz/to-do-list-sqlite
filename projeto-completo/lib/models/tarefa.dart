/// Uma tarefa da lista. Cada Tarefa é uma linha da tabela "tarefas" no banco.
class Tarefa {
  final int? id; // fica null até a tarefa ser salva, porque quem cria o id é o banco
  final String descricao;
  final bool concluida;

  const Tarefa({this.id, required this.descricao, this.concluida = false});

  /// Transforma a tarefa em um Map, que é o formato que o sqflite sabe gravar.
  /// Cada chave do Map tem o mesmo nome de uma coluna da tabela.
  ///
  /// Repare no "concluida ? 1 : 0": o SQLite não tem true/false,
  /// então guardamos 1 para concluída e 0 para pendente.
  Map<String, dynamic> toMap() {
    return {'id': id, 'descricao': descricao, 'concluida': concluida ? 1 : 0};
  }

  /// Faz o caminho contrário do toMap: pega uma linha que veio do banco
  /// e monta a Tarefa de novo. Aqui o 1 volta a ser true e o 0 volta a ser false.
  factory Tarefa.fromMap(Map<String, dynamic> map) {
    return Tarefa(
      id: map['id'] as int?,
      descricao: map['descricao'] as String,
      concluida: map['concluida'] == 1,
    );
  }

  /// Os campos são final, então uma tarefa não muda depois de criada.
  /// O copyWith cria uma tarefa nova igual a esta, trocando só o que você passar.
  /// Exemplo: tarefa.copyWith(concluida: true)
  Tarefa copyWith({int? id, String? descricao, bool? concluida}) {
    return Tarefa(
      id: id ?? this.id,
      descricao: descricao ?? this.descricao,
      concluida: concluida ?? this.concluida,
    );
  }
}
