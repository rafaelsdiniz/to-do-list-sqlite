# 📝 To Do List com SQLite

Aplicação de exemplo do seminário de **Persistência Local com SQLite** (Dispositivos Móveis I, Grupo 5).

**Integrantes:** Rafael, Guilherme, Pedro Lucas e João Vitor de Araújo

É uma lista de tarefas feita em Flutter que grava os dados em um banco **SQLite** no próprio aparelho, usando o pacote `sqflite`. Você pode cadastrar tarefas, marcar como concluída ou pendente e excluir. **Os dados continuam salvos depois de fechar o app.**

O visual segue o estilo do iPhone, usando os widgets **Cupertino** do Flutter, com o logo e as cores da **Unitins**.

---

## 📚 Sumário

1. [O que você precisa instalar](#-1-o-que-você-precisa-instalar)
2. [Baixando e rodando o projeto](#-2-baixando-e-rodando-o-projeto)
3. [Estrutura do projeto](#-3-estrutura-do-projeto)
4. [Como o código funciona](#-4-como-o-código-funciona)
5. [Rodando os testes](#-5-rodando-os-testes)
6. [Problemas comuns](#-6-problemas-comuns)
7. [Desafios para praticar](#-7-desafios-para-praticar)

---

## 🔧 1. O que você precisa instalar

### Para todo mundo

| Ferramenta | Para que serve | Onde baixar |
|---|---|---|
| **Flutter SDK** | Compilar e rodar o app | https://docs.flutter.dev/get-started/install |
| **Git** | Baixar (clonar) o projeto | https://git-scm.com/downloads |
| **VS Code** | Editar o código | https://code.visualstudio.com |
| Extensão **Flutter** do VS Code | Destaque de código, atalhos e botão de rodar | Aba *Extensions* do VS Code, procure por "Flutter" |

### Depende de onde você vai rodar o app

Escolha **uma** das opções abaixo. A mais fácil é rodar no seu próprio computador.

| Onde rodar | O que instalar a mais |
|---|---|
| 🪟 **Windows** | **Visual Studio** (não é o VS Code) com a carga de trabalho **"Desenvolvimento para desktop com C++"** |
| 🍎 **macOS** | **Xcode**, pela App Store |
| 🐧 **Linux** | `sudo apt install clang cmake ninja-build pkg-config libgtk-3-dev libsqlite3-dev` |
| 🤖 **Celular Android** | **Android Studio** e a *Depuração USB* ligada no celular |
| 📱 **iPhone** | Um Mac com **Xcode** |

> ⚠️ **Não funciona no navegador (Chrome, Edge).** O SQLite do `sqflite` precisa de acesso ao sistema de arquivos do aparelho, e o navegador não oferece isso.

Depois de instalar, confira se está tudo certo:

```bash
flutter doctor
```

As linhas com ✓ estão prontas. Uma linha com ✗ só importa se for a plataforma que você vai usar.

---

## 🚀 2. Baixando e rodando o projeto

**Passo 1. Clone o repositório**

```bash
git clone https://github.com/rafaelsdiniz/to-do-list-sqlite.git
```

**Passo 2. Entre na pasta do projeto**

```bash
cd to-do-list-sqlite
```

**Passo 3. Baixe as dependências**

```bash
flutter pub get
```

**Passo 4. Rode o app**

```bash
flutter run
```

Se aparecer mais de um dispositivo, o Flutter pergunta qual usar. Digite o número dele e aperte Enter. Para escolher direto:

```bash
flutter run -d windows   # Windows
flutter run -d macos     # macOS
flutter run -d linux     # Linux
flutter devices          # mostra a lista de dispositivos disponíveis
```

A primeira execução demora um pouco, porque o Flutter compila tudo. As próximas são bem mais rápidas.

### ⌨️ Atalhos com o app rodando

Com o terminal do `flutter run` selecionado:

| Tecla | O que faz |
|---|---|
| `r` | **Hot reload**: aplica a mudança no código sem fechar o app |
| `R` | **Hot restart**: reinicia o app do zero |
| `q` | Fecha o app |

> 💡 O banco **não é apagado** no hot reload nem no hot restart. As tarefas continuam lá, e é justamente isso que o seminário quer mostrar.

### 🧭 Usando o app

- Digite a tarefa no campo **Nova tarefa** e aperte **+** ou Enter.
- **Toque** em uma tarefa para marcar como concluída. Toque de novo para voltar para pendente.
- **Arraste para a esquerda** para excluir. No computador, clique e arraste com o mouse.

---

## 🗂️ 3. Estrutura do projeto

O código que importa para o seminário fica todo dentro de `lib/`. As pastas `android/`, `ios/`, `windows/`, `macos/` e `linux/` são geradas pelo Flutter e não precisam ser alteradas.

```
lib/
├── main.dart                    # ponto de partida: prepara o banco e abre o app
├── app_tarefas.dart             # nome do app, tema (cores) e primeira tela
├── modelos/
│   └── tarefa.dart              # classe Tarefa (o que é uma tarefa)
├── banco/
│   └── banco_dados.dart         # cria o banco e faz todo o SQL
├── telas/
│   └── tela_tarefas.dart        # a tela: guarda a lista e conversa com o banco
├── componentes/
│   ├── logo_unitins.dart        # logo no topo da tela
│   ├── campo_nova_tarefa.dart   # campo de texto + botão de adicionar
│   └── item_tarefa.dart         # uma linha da lista
└── tema/
    └── cores_unitins.dart       # azul e amarelo da Unitins
assets/
└── imagens/
    └── logo_unitins.png         # logo usado na tela
test/
└── tarefa_test.dart             # testes da classe Tarefa
```

| Pasta | O que guarda |
|---|---|
| `modelos/` | Os dados do app, sem nada de tela ou de banco |
| `banco/` | Tudo que fala com o SQLite |
| `telas/` | As telas completas, que juntam os componentes |
| `componentes/` | Pedaços de tela reaproveitáveis, sem acesso ao banco |
| `tema/` | Cores do app |

A ideia é separar em **três camadas**, cada uma com uma responsabilidade:

```
  TelaTarefas   ──chama──▶   BancoDados   ──SQL──▶   arquivo tarefas.db
  (o que aparece)            (o que grava)            (onde fica salvo)
          ╲                       ╱
           ╲── ambos usam ──▶ Tarefa (o modelo)
```

A tela **nunca** escreve SQL. Ela só pede para o `BancoDados` inserir, listar, atualizar ou excluir.

---

## 🧠 4. Como o código funciona

### 4.1 A tabela `tarefas`

| Coluna | Tipo | Observação |
|---|---|---|
| `id` | `INTEGER PRIMARY KEY AUTOINCREMENT` | O banco gera sozinho |
| `descricao` | `TEXT NOT NULL` | O texto da tarefa |
| `concluida` | `INTEGER NOT NULL DEFAULT 0` | `0` = pendente, `1` = concluída |

> 💡 O SQLite **não tem tipo booleano**. Por isso guardamos `true` como `1` e `false` como `0`.

### 4.2 O modelo: `lib/modelos/tarefa.dart`

A classe `Tarefa` representa **uma linha da tabela**. Ela tem dois métodos que fazem a "tradução" entre o Dart e o banco:

| Método | Direção | Exemplo |
|---|---|---|
| `paraMapa()` | Objeto Dart ➜ banco | `concluida: true` vira `'concluida': 1` |
| `Tarefa.doMapa(mapa)` | Banco ➜ objeto Dart | `'concluida': 1` vira `concluida: true` |
| `copiarCom(...)` | Cria uma cópia mudando só um campo | `tarefa.copiarCom(concluida: true)` |

```dart
Map<String, dynamic> paraMapa() {
  return {'id': id, 'descricao': descricao, 'concluida': concluida ? 1 : 0};
}
```

### 4.3 O banco: `lib/banco/banco_dados.dart`

A classe `BancoDados` é o **único lugar do app que conhece SQL**.

**Singleton.** Existe uma única instância, acessada por `BancoDados.instancia`. Assim o app abre **uma** conexão só e reaproveita.

**Abrindo o banco.** Na primeira vez que alguém usa a `conexao`, o arquivo `tarefas.db` é aberto. Se ele ainda não existir, o `onCreate` roda o `CREATE TABLE`:

```dart
Future<Database> _abrirBanco() async {
  final caminho = join(await getDatabasesPath(), _nomeArquivo);
  return openDatabase(caminho, version: _versao, onCreate: _criarTabelas);
}
```

**CRUD.** Cada operação é um método:

| Operação | Método | SQL equivalente |
|---|---|---|
| **C**reate | `inserir(tarefa)` | `INSERT INTO tarefas ...` |
| **R**ead | `listar()` | `SELECT * FROM tarefas ORDER BY concluida, id DESC` |
| **U**pdate | `atualizar(tarefa)` | `UPDATE tarefas SET ... WHERE id = ?` |
| **D**elete | `excluir(id)` | `DELETE FROM tarefas WHERE id = ?` |

> 🔒 **Sempre use `?` e `whereArgs`**, nunca junte texto na mão dentro do SQL. Isso evita *SQL Injection*.
>
> ```dart
> banco.delete(tabela, where: 'id = ?', whereArgs: [id]);   // ✅ certo
> banco.rawDelete('DELETE FROM tarefas WHERE id = $id');     // ❌ evite
> ```

### 4.4 A tela: `lib/telas/tela_tarefas.dart`

A `TelaTarefas` é um `StatefulWidget`. Ela guarda a lista `_tarefas` e segue sempre o mesmo ciclo:

```
usuário faz algo ──▶ chama o BancoDados ──▶ _carregar() lê o banco de novo ──▶ setState() redesenha a tela
```

| Método da tela | O que faz | Usa do banco |
|---|---|---|
| `_carregar()` | Busca a lista e chama `setState` | `listar()` |
| `_salvar()` | Grava o texto digitado | `inserir()` |
| `_alternarSituacao()` | Troca entre concluída e pendente | `atualizar()` |
| `_excluir()` | Apaga a tarefa arrastada | `excluir()` |

A tela é montada com três componentes, um embaixo do outro:

```dart
Column(
  children: [
    const LogoUnitins(),
    CampoNovaTarefa(controlador: _campoDescricao, aoSalvar: _salvar),
    Expanded(child: _montarLista()),   // cada linha é um ItemTarefa
  ],
)
```

### 4.5 Os componentes: `lib/componentes/`

Os componentes são `StatelessWidget`: só desenham o que recebem. Quem decide o que acontece é a tela, que passa funções como `aoSalvar`, `aoTocar` e `aoExcluir`.

| Componente | O que mostra | O que recebe |
|---|---|---|
| `LogoUnitins` | O logo da Unitins | Nada |
| `CampoNovaTarefa` | Campo "Nova tarefa" e botão **+** amarelo | O controlador do texto e a função `aoSalvar` |
| `ItemTarefa` | Uma tarefa com o círculo de concluída | A `tarefa` e as funções `aoTocar` e `aoExcluir` |

Widgets Cupertino usados para o visual de iPhone:

| Widget | Onde aparece |
|---|---|
| `CupertinoApp` e `CupertinoThemeData` | O app inteiro e as cores, em `app_tarefas.dart` |
| `CupertinoPageScaffold` e `CupertinoNavigationBar` | A estrutura da tela e a barra azul do título |
| `CupertinoTextField` | O campo "Nova tarefa" |
| `CupertinoButton` | O botão **+** |
| `CupertinoListSection.insetGrouped` | A lista com cantos arredondados, igual aos Ajustes do iPhone |
| `CupertinoListTile` | Cada tarefa |
| `Dismissible` | Arrastar para o lado para excluir |

### 4.6 Cores e logo da Unitins

As cores ficam em `lib/tema/cores_unitins.dart` e foram tiradas do próprio logo:

| Cor | Código | Onde é usada |
|---|---|---|
| 🔵 Azul | `#18428F` | Barra do título e tarefas concluídas |
| 🟡 Amarelo | `#FDB813` | Botão de adicionar |

O tema do app, em `app_tarefas.dart`, aplica o azul em todas as barras:

```dart
theme: CupertinoThemeData(
  brightness: Brightness.light,
  primaryColor: CoresUnitins.azul,
  barBackgroundColor: CoresUnitins.azul,
  scaffoldBackgroundColor: CupertinoColors.systemGroupedBackground,
),
```

O logo fica em `assets/imagens/logo_unitins.png`. Para o Flutter encontrar a imagem, a pasta precisa estar registrada no `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/imagens/
```

Depois é só usar `Image.asset('assets/imagens/logo_unitins.png')`.

### 4.7 O ponto de partida: `lib/main.dart`

No Android, iOS e macOS o `sqflite` funciona sozinho. No **Windows** e no **Linux** ele precisa do pacote `sqflite_common_ffi`, que usa o SQLite do computador. É só isso que a função `prepararBancoNoComputador()` faz:

```dart
void main() {
  prepararBancoNoComputador();
  runApp(const AppTarefas());
}

void prepararBancoNoComputador() {
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
}
```

### 4.8 Pacotes usados

| Pacote | Para que serve |
|---|---|
| [`sqflite`](https://pub.dev/packages/sqflite) | SQLite no Android, iOS e macOS |
| [`sqflite_common_ffi`](https://pub.dev/packages/sqflite_common_ffi) | SQLite no Windows e no Linux |
| [`path`](https://pub.dev/packages/path) | Monta o caminho do arquivo `.db` com o `join()` |

### 4.9 Onde fica o arquivo do banco?

| Plataforma | Local |
|---|---|
| Android | `/data/data/com.grupo5.todo_sqlite/databases/tarefas.db` |
| iOS / macOS | Pasta de documentos do app |
| Windows / Linux | `.dart_tool/sqflite_common_ffi/databases/tarefas.db`, dentro da pasta do projeto |

No Windows e no Linux você pode abrir esse arquivo com o [DB Browser for SQLite](https://sqlitebrowser.org/) e ver as linhas da tabela mudando enquanto usa o app.

---

## 🧪 5. Rodando os testes

Os testes ficam em `test/tarefa_test.dart` e conferem a classe `Tarefa`: a conversão `true`/`false` ⇄ `1`/`0` e o `copiarCom()`.

```bash
flutter test
```

Resultado esperado:

```
00:00 +9: All tests passed!
```

Para verificar se o código segue as boas práticas do Dart:

```bash
flutter analyze
```

---

## 🩹 6. Problemas comuns

**`No supported devices connected`**
Nenhum dispositivo compatível foi encontrado. No Windows, instale o Visual Studio com a carga de trabalho de C++ e rode `flutter doctor` de novo. Para celular, confira se a Depuração USB está ligada e o cabo conectado.

**O app abriu no Chrome, ou o Chrome aparece na lista**
O navegador não é suportado. Rode com `flutter run -d windows`, `-d macos` ou `-d linux`.

**`databaseFactory not initialized`**
A função `prepararBancoNoComputador()` do `main.dart` foi apagada ou alterada. Ela precisa rodar antes do `runApp`.

**Quero começar com o banco vazio**
No computador, apague a pasta `.dart_tool/sqflite_common_ffi`. No celular, desinstale o app.

**O logo não aparece**
Confira se a pasta `assets/imagens/` está no `pubspec.yaml`. Depois de mexer no `pubspec.yaml`, rode `flutter pub get` e reinicie o app com `q` e `flutter run`. O hot reload não carrega imagens novas.

**`Build process failed` no Windows**
Quase sempre é porque o app ainda está aberto de uma execução anterior. Feche a janela do app e rode de novo.

**`flutter` não é reconhecido como comando**
O Flutter não está no PATH. Siga de novo a parte de "Update your path" no guia de instalação.

**Erro ao compilar depois de trocar de branch ou de versão**
Limpe e baixe tudo de novo:

```bash
flutter clean
flutter pub get
flutter run
```

---

## 🏋️ 7. Desafios para praticar

1. Mostre uma mensagem quando o usuário tentar salvar uma tarefa vazia, usando `showCupertinoDialog`.
2. Adicione uma coluna `data_criacao` na tabela. Dica: aumente a `_versao` e use o `onUpgrade` do `openDatabase`.
3. Crie um botão para apagar todas as tarefas concluídas de uma vez, com um novo método no `BancoDados`.
4. Permita editar a descrição de uma tarefa já cadastrada.
5. Adicione uma busca que filtra as tarefas pelo texto, usando `WHERE descricao LIKE ?`.
