# 📝 To Do List com SQLite

Aplicação de exemplo do seminário de **Persistência Local com SQLite** (Dispositivos Móveis I, Unitins, Grupo 5).

**Integrantes:** Rafael, Guilherme, Pedro Lucas e João Vitor de Araújo

Lista de tarefas em Flutter que grava os dados em um banco **SQLite** no próprio aparelho. Dá para cadastrar, concluir e excluir tarefas, e **tudo continua salvo depois de fechar o app**. O visual segue o estilo do iPhone (widgets Cupertino) com o logo e as cores da Unitins.

---

## 🔧 O que instalar

- [Flutter SDK](https://docs.flutter.dev/get-started/install), [Git](https://git-scm.com/downloads) e [VS Code](https://code.visualstudio.com) com a extensão **Flutter**.
- Mais uma ferramenta, de acordo com onde você vai rodar:

| Onde rodar | O que instalar |
|---|---|
| 🪟 Windows | **Visual Studio** com "Desenvolvimento para desktop com C++" |
| 🍎 macOS | **Xcode** |
| 🐧 Linux | `sudo apt install clang cmake ninja-build pkg-config libgtk-3-dev libsqlite3-dev` |
| 🤖 Android | **Android Studio** |

> ⚠️ **Não funciona no navegador (Chrome, Edge).** O SQLite precisa gravar um arquivo no aparelho.

Para conferir a instalação, rode `flutter doctor`.

---

## 🚀 Como rodar

```bash
git clone https://github.com/rafaelsdiniz/to-do-list-sqlite.git
cd to-do-list-sqlite
flutter pub get
flutter run
```

Se aparecer mais de um dispositivo, digite o número dele. Com o app aberto, `r` aplica mudanças no código e `q` fecha.

**Usando o app:** digite a tarefa e aperte **+**. Toque na tarefa para concluir. Arraste para a esquerda para excluir.

---

## 🗂️ Estrutura

```
lib/
├── main.dart                    # prepara o banco e abre o app
├── app_tarefas.dart             # nome, tema e primeira tela
├── modelos/tarefa.dart          # classe Tarefa
├── banco/banco_dados.dart       # todo o SQL fica aqui
├── telas/tela_tarefas.dart      # a tela: lista + CRUD
├── componentes/                 # logo, campo de texto e item da lista
└── tema/cores_unitins.dart      # azul #18428F e amarelo #FDB813
assets/imagens/logo_unitins.png
test/tarefa_test.dart            # testes da classe Tarefa
```

A tela **nunca** escreve SQL. Ela só chama o `BancoDados`:

```
TelaTarefas  ──▶  BancoDados  ──SQL──▶  tarefas.db
```

---

## 🧠 Como funciona

**Tabela `tarefas`**

| Coluna | Tipo |
|---|---|
| `id` | `INTEGER PRIMARY KEY AUTOINCREMENT` |
| `descricao` | `TEXT NOT NULL` |
| `concluida` | `INTEGER NOT NULL DEFAULT 0` (0 = pendente, 1 = concluída) |

> 💡 O SQLite não tem booleano. Por isso `true` vira `1` e `false` vira `0`.

**Modelo (`Tarefa`)**

- `paraMapa()` converte o objeto para gravar no banco.
- `Tarefa.doMapa()` converte a linha lida do banco em objeto.
- `copiarCom()` cria uma cópia mudando só um campo.

**Banco (`BancoDados`)**

É um *singleton*: uma instância só, acessada por `BancoDados.instancia`. Na primeira vez, ele cria o arquivo `tarefas.db` e roda o `CREATE TABLE`.

| CRUD | Método | SQL |
|---|---|---|
| Create | `inserir(tarefa)` | `INSERT` |
| Read | `listar()` | `SELECT ... ORDER BY concluida, id DESC` |
| Update | `atualizar(tarefa)` | `UPDATE ... WHERE id = ?` |
| Delete | `excluir(id)` | `DELETE ... WHERE id = ?` |

> 🔒 Sempre use `?` com `whereArgs`, nunca junte texto no SQL. Isso evita *SQL Injection*.

**Tela (`TelaTarefas`)**

Toda ação segue o mesmo ciclo:

```
toque do usuário ──▶ BancoDados ──▶ _carregar() ──▶ setState() redesenha a tela
```

**Windows e Linux**

No Android, iOS e macOS o `sqflite` funciona sozinho. No Windows e no Linux, a função `prepararBancoNoComputador()` do `main.dart` liga o `sqflite_common_ffi` antes de abrir o app.

---

## 🧪 Testes

```bash
flutter test
```

---

## 🩹 Problemas comuns

| Problema | Solução |
|---|---|
| `No supported devices connected` | Instale a ferramenta da sua plataforma (tabela lá em cima) e rode `flutter doctor`. |
| Abriu no Chrome | Use `flutter run -d windows`, `-d macos` ou `-d linux`. |
| `Build process failed` no Windows | O app ainda está aberto. Feche a janela e rode de novo. |
| O logo não aparece | Rode `flutter pub get` e reinicie o app. O hot reload não carrega imagens novas. |
| Quero o banco vazio | No computador, apague `.dart_tool/sqflite_common_ffi`. No celular, desinstale o app. |
