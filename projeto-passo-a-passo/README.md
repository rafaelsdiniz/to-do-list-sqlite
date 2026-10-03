# ✏️ Projeto passo a passo

O mesmo app do [projeto completo](../projeto-completo/), só que com **4 partes faltando**. Você vai colar cada parte, rodar o app e ver o que muda. No final, terá uma lista de tarefas que guarda tudo num banco SQLite. O que precisa instalar está no [README principal](../README.md).

| Passo | Arquivo | O que você vai colar |
|---|---|---|
| 1 | `lib/database/db_helper.dart` | A criação da tabela (`CREATE TABLE`) |
| 2 | `lib/models/tarefa.dart` | A conversão entre Tarefa e Map (`toMap` e `fromMap`) |
| 3 | `lib/database/db_helper.dart` | A gravação de uma tarefa (`INSERT`) |
| 4 | `lib/database/db_helper.dart` | A leitura das tarefas (`SELECT`) |

---

## 🚀 Antes de começar

Dentro desta pasta (`projeto-passo-a-passo`), rode:

```bash
flutter pub get
flutter run -d windows
```

O app vai abrir mostrando **"Falta o PASSO 1"**. Isso é esperado: ele avisa na tela qual passo está faltando.

### Como colar cada passo

No código, cada passo está entre duas linhas assim:

```dart
  // ===== PASSO 1: COMEÇA AQUI =====
  ...
  // ===== PASSO 1: TERMINA AQUI =====
```

1. Selecione **desde a linha `COMEÇA AQUI` até a linha `TERMINA AQUI`**, incluindo as duas. No VS Code: clique bem no começo da primeira linha, segure **Shift** e clique no fim da última.
2. Cole (**Ctrl+V**) o código do passo, que está logo abaixo neste README.
3. Salve (**Ctrl+S**) e aperte **`R` maiúsculo** no terminal onde o app está rodando. Isso reinicia o app com o código novo.

> Se a indentação ficar torta, aperte **Shift+Alt+F** para o VS Code arrumar.

---

## 1️⃣ Passo 1: criar a tabela

📄 Arquivo: `lib/database/db_helper.dart`

Selecione o trecho do **PASSO 1** e cole:

```dart
  Future<void> _criarTabelas(Database banco, int versao) async {
    // id: o próprio banco numera as tarefas (1, 2, 3...) por causa do AUTOINCREMENT.
    // concluida: é INTEGER porque o SQLite não tem booleano (0 = pendente, 1 = feita).
    await banco.execute('''
      CREATE TABLE $tabela (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        descricao TEXT NOT NULL,
        concluida INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }
```

**O que muda no app:** o erro some e aparece "Nenhuma tarefa cadastrada".

**Entendendo:**
- Um banco SQLite é **um arquivo só**, guardado no próprio aparelho. Dentro dele ficam as tabelas, que funcionam como uma planilha: cada coluna é um campo e cada linha é uma tarefa.
- O `CREATE TABLE` diz quais colunas a tabela tem: um número de identificação (`id`), o texto da tarefa (`descricao`) e se ela já foi feita (`concluida`).
- Com o `AUTOINCREMENT`, quem escolhe o `id` é o próprio banco: 1, 2, 3...
- O SQLite não tem tipo verdadeiro/falso. Por isso a coluna `concluida` é um número: **0 é pendente e 1 é concluída**.
- Este código roda **uma vez só**, quando o arquivo do banco ainda não existe. Nas outras vezes que o app abre, a tabela já está lá.

---

## 2️⃣ Passo 2: converter Tarefa ↔ Map

📄 Arquivo: `lib/models/tarefa.dart`

Selecione o trecho do **PASSO 2** e cole:

```dart
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
```

**O que muda no app:** nada aparece ainda, mas agora o app sabe traduzir as tarefas. Para conferir, rode `flutter test` num outro terminal: os testes que estavam falhando passam.

**Entendendo:**
- No app, uma tarefa é um objeto `Tarefa`. O banco não entende objetos: ele trabalha com **Map**, uma lista de pares "nome da coluna → valor".
- O `toMap()` transforma a Tarefa em Map. É usado na hora de **gravar**.
- O `fromMap()` faz o caminho contrário, de Map para Tarefa. É usado na hora de **ler**.
- É aqui que o `true`/`false` do Dart vira `1`/`0` para o banco, e depois volta.

---

## 3️⃣ Passo 3: gravar uma tarefa (INSERT)

📄 Arquivo: `lib/database/db_helper.dart`

Selecione o trecho do **PASSO 3** e cole:

```dart
  /// Grava uma tarefa nova (o C do CRUD) e devolve o id que o banco deu para ela.
  Future<int> inserir(Tarefa tarefa) async {
    final banco = await database;
    // Tiramos o id do Map porque quem escolhe o id é o banco.
    final dados = tarefa.toMap()..remove('id');
    return banco.insert(tabela, dados);
  }
```

**O que muda no app:** digite uma tarefa e aperte **+**. Aparece "Tarefa cadastrada!", mas **a tarefa não aparece na lista**. Ela foi gravada no banco, só que o app ainda não sabe ler de lá. Cadastre duas ou três e siga para o Passo 4.

**Entendendo:**
- CRUD são as quatro coisas que se faz com dados: **C**riar, **R**ead (ler), **U**pdate (atualizar) e **D**elete (apagar). Este passo é o **C**.
- Não precisa escrever o SQL (`INSERT INTO ...`) na mão. O `banco.insert` monta o SQL sozinho, usando o Map que veio do `toMap()` do Passo 2.
- O `remove('id')` tira o id do Map, porque quem escolhe o id é o banco.
- O `await` faz o app esperar o banco terminar de gravar antes de continuar.

---

## 4️⃣ Passo 4: ler as tarefas (SELECT)

📄 Arquivo: `lib/database/db_helper.dart`

Selecione o trecho do **PASSO 4** e cole:

```dart
  /// Busca todas as tarefas (o R do CRUD).
  /// As pendentes vêm primeiro, e as mais novas ficam no topo.
  Future<List<Tarefa>> listar() async {
    final banco = await database;
    final linhas = await banco.query(tabela, orderBy: 'concluida ASC, id DESC');
    // Cada linha chega como um Map, e o fromMap transforma em Tarefa.
    return linhas.map(Tarefa.fromMap).toList();
  }
```

**O que muda no app:** aparecem **todas as tarefas que você cadastrou no Passo 3**. Elas estavam guardadas no banco o tempo todo.

**Entendendo:**
- O `banco.query` é o `SELECT`, o **R** do CRUD. Ele busca as linhas da tabela.
- O `orderBy` escolhe a ordem. `concluida ASC` coloca as pendentes (0) antes das concluídas (1). `id DESC` coloca as mais novas no topo.
- Cada linha chega como Map, e o `fromMap()` do Passo 2 transforma em `Tarefa`.
- A tela recebe essa lista num `FutureBuilder`, que mostra uma rodinha enquanto o banco responde e a lista quando os dados chegam.

### 🎉 O teste final

Feche o app e rode de novo. **As tarefas continuam lá.** É isso que um banco local resolve: os dados ficam salvos no aparelho, mesmo depois de fechar o app.

Agora toque numa tarefa para concluir e arraste outra para a esquerda para apagar. Essas duas partes (o **U** e o **D** do CRUD) já vieram prontas, no fim do `db_helper.dart`. Dá para ler o código delas lá.

---

## 🔁 Começar de novo

- **Voltar o código com as partes faltando:** dentro desta pasta, rode `git checkout -- lib`.
- **Apagar o banco:** feche o app e apague a pasta `.dart_tool/sqflite_common_ffi`. No celular, desinstale o app.

Se travar em algum passo, o código pronto está no [projeto completo](../projeto-completo/lib/).
