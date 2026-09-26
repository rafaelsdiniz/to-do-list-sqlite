import 'package:flutter_test/flutter_test.dart';
import 'package:todo_sqlite/modelos/tarefa.dart';

void main() {
  group('Tarefa.paraMapa', () {
    test('converte concluida true em 1', () {
      const tarefa = Tarefa(
        id: 1,
        descricao: 'Estudar SQLite',
        concluida: true,
      );

      expect(tarefa.paraMapa(), {
        'id': 1,
        'descricao': 'Estudar SQLite',
        'concluida': 1,
      });
    });

    test('converte concluida false em 0', () {
      const tarefa = Tarefa(id: 2, descricao: 'Montar slides');

      expect(tarefa.paraMapa()['concluida'], 0);
    });

    test('mantem id null quando a tarefa ainda nao foi salva', () {
      const tarefa = Tarefa(descricao: 'Nova tarefa');

      expect(tarefa.paraMapa()['id'], isNull);
    });
  });

  group('Tarefa.doMapa', () {
    test('converte concluida 1 em true', () {
      final tarefa = Tarefa.doMapa({
        'id': 3,
        'descricao': 'Apresentar seminario',
        'concluida': 1,
      });

      expect(tarefa.id, 3);
      expect(tarefa.descricao, 'Apresentar seminario');
      expect(tarefa.concluida, isTrue);
    });

    test('converte concluida 0 em false', () {
      final tarefa = Tarefa.doMapa({
        'id': 4,
        'descricao': 'Revisar codigo',
        'concluida': 0,
      });

      expect(tarefa.concluida, isFalse);
    });

    test('doMapa(paraMapa()) preserva os dados', () {
      const original = Tarefa(id: 5, descricao: 'Ida e volta', concluida: true);
      final copia = Tarefa.doMapa(original.paraMapa());

      expect(copia.id, original.id);
      expect(copia.descricao, original.descricao);
      expect(copia.concluida, original.concluida);
    });
  });

  group('Tarefa.copiarCom', () {
    const original = Tarefa(id: 6, descricao: 'Original', concluida: false);

    test('altera somente concluida', () {
      final copia = original.copiarCom(concluida: true);

      expect(copia.id, 6);
      expect(copia.descricao, 'Original');
      expect(copia.concluida, isTrue);
    });

    test('altera id e descricao mantendo concluida', () {
      final copia = original.copiarCom(id: 7, descricao: 'Alterada');

      expect(copia.id, 7);
      expect(copia.descricao, 'Alterada');
      expect(copia.concluida, isFalse);
    });

    test('sem argumentos gera copia identica e nao altera o original', () {
      final copia = original.copiarCom();

      expect(copia.id, original.id);
      expect(copia.descricao, original.descricao);
      expect(copia.concluida, original.concluida);
      expect(identical(copia, original), isFalse);
    });
  });
}
