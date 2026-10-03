# ✏️ Projeto passo a passo

O mesmo app do [projeto completo](../projeto-completo/), **com 4 passos faltando** para a turma completar junto com a gente. O que precisa instalar está no [README principal](../README.md).

O app abre e roda mesmo sem os passos. Enquanto um passo estiver faltando, aparece na tela uma mensagem como **"Falta o PASSO 1"**. Cada passo está marcado no código com `TODO PASSO` e tem um comentário explicando o que escrever.

| Passo | Arquivo | O que faz | Parte do SQLite |
|---|---|---|---|
| 1 | `lib/database/db_helper.dart` | Cria a tabela | `CREATE TABLE` |
| 2 | `lib/models/tarefa.dart` | Converte Tarefa ↔ Map | `toMap()` / `fromMap()` |
| 3 | `lib/database/db_helper.dart` | Grava uma tarefa | `INSERT` (Create) |
| 4 | `lib/database/db_helper.dart` | Lê as tarefas | `SELECT` (Read) |

O `UPDATE` e o `DELETE` já estão prontos e servem de exemplo.

---

## 🚀 Como rodar

Dentro desta pasta (`projeto-passo-a-passo`):

```bash
flutter pub get
flutter run -d windows
```

> ⚠️ Depois de terminar cada passo, aperte **`R` maiúsculo** (hot restart) no terminal. O `r` minúsculo não refaz a leitura do banco.

---

## 1️⃣ Passo 1: criar a tabela

📄 `lib/database/db_helper.dart` → método `_criarTabelas`

**Antes:** a tela mostra `Erro ao carregar: ... Falta o PASSO 1`.

Apague o `throw` e digite:

```dart
await banco.execute('''
  CREATE TABLE $tabela (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    descricao TEXT NOT NULL,
    concluida INTEGER NOT NULL DEFAULT 0
  )
''');
```

**Depois:** a tela mostra "Nenhuma tarefa cadastrada".

**O que explicar:**
- O `openDatabase` só chama o `onCreate` quando o arquivo `.db` ainda **não existe**. Ou seja, a tabela é criada uma vez só, na primeira vez que o app abre.
- `AUTOINCREMENT`: quem gera o `id` é o banco.
- `concluida` é `INTEGER` porque **o SQLite não tem booleano**. Isso vai importar no Passo 2.

---

## 2️⃣ Passo 2: converter Tarefa ↔ Map

📄 `lib/models/tarefa.dart`

O `sqflite` não grava objetos. Ele grava e devolve **Maps**, em que cada chave é o nome de uma coluna.

**2A. `toMap()`**: apague o `throw` e digite:

```dart
return {'id': id, 'descricao': descricao, 'concluida': concluida ? 1 : 0};
```

**2B. `fromMap()`**: apague o `throw` e digite:

```dart
return Tarefa(
  id: map['id'] as int?,
  descricao: map['descricao'] as String,
  concluida: map['concluida'] == 1,
);
```

**Como conferir:** rode `flutter test`. Os testes de `test/tarefa_test.dart` falham antes desse passo e passam depois.

**O que explicar:**
- `toMap()` serve para **gravar** (objeto → banco). `fromMap()` serve para **ler** (banco → objeto).
- `true` vira `1` e `false` vira `0` por causa da coluna `INTEGER` do Passo 1.

---

## 3️⃣ Passo 3: gravar uma tarefa (INSERT)

📄 `lib/database/db_helper.dart` → método `inserir`

**Antes:** ao apertar **+**, aparece o aviso "Falta o PASSO 3".

Apague o `throw` e digite:

```dart
final banco = await database;
final dados = tarefa.toMap()..remove('id'); // o banco gera o id
return banco.insert(tabela, dados);
```

**Depois:** aparece "Tarefa cadastrada!", **mas a tarefa não aparece na lista**. Ela foi gravada, só que o app ainda não lê o banco. Isso é o Passo 4.

**O que explicar:**
- A gente não escreve `INSERT INTO ...` na mão. O `banco.insert` monta o SQL a partir do Map do `toMap()`.
- Tiramos o `id` porque ele é gerado pelo `AUTOINCREMENT`.

---

## 4️⃣ Passo 4: ler as tarefas (SELECT)

📄 `lib/database/db_helper.dart` → método `listar`

Apague o `return [];` e digite:

```dart
final linhas = await banco.query(tabela, orderBy: 'concluida ASC, id DESC');
return linhas.map(Tarefa.fromMap).toList();
```

**Depois:** aparecem **todas as tarefas cadastradas no Passo 3**. Isso mostra que elas ficaram salvas no banco.

**O que explicar:**
- `banco.query` faz o `SELECT * FROM tarefas ORDER BY concluida ASC, id DESC`: as pendentes vêm primeiro e as mais novas ficam no topo.
- Cada linha volta como Map, e o `fromMap()` do Passo 2 transforma em `Tarefa`.
- A tela usa um `FutureBuilder` com esse resultado para montar a lista.

**Final:** feche o app e abra de novo. As tarefas continuam lá. É isso que a persistência local com SQLite resolve.

---

## 🔁 Antes de apresentar: zerar o banco

Se vocês ensaiarem com todos os passos prontos, o banco vai ficar criado e com tarefas. Para começar do zero na apresentação:

- **Windows/Linux:** feche o app e apague a pasta `.dart_tool/sqflite_common_ffi`.
- **Celular:** desinstale o app.

Para voltar o código para a versão com os passos faltando, rode dentro desta pasta:

```bash
git checkout -- lib
```

Se travar em algum passo, o código pronto está no [projeto completo](../projeto-completo/lib/).
