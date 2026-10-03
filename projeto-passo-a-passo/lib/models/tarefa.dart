/// Uma tarefa da lista. Cada Tarefa é uma linha da tabela "tarefas" no banco.
class Tarefa {
  final int? id; // fica null até a tarefa ser salva, porque quem cria o id é o banco
  final String descricao;
  final bool concluida;

  const Tarefa({this.id, required this.descricao, this.concluida = false});

  // ===== PASSO 2: COMEÇA AQUI =====
  // Aqui ficam o toMap e o fromMap, que traduzem a Tarefa para o formato do
  // banco e de volta. Enquanto eles não existem, o app não consegue nem gravar
  // nem ler tarefas. O código para colar está no README, no Passo 2.
  Map<String, dynamic> toMap() {
    throw UnimplementedError('Falta o PASSO 2: toMap() em models/tarefa.dart');
  }

  factory Tarefa.fromMap(Map<String, dynamic> map) {
    throw UnimplementedError('Falta o PASSO 2: fromMap() em models/tarefa.dart');
  }
  // ===== PASSO 2: TERMINA AQUI =====

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
