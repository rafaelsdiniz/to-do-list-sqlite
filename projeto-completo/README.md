# ✅ Projeto completo

O app de lista de tarefas com SQLite **pronto e funcionando**. O que precisa instalar está no [README principal](../README.md).

## 🚀 Como rodar

Dentro desta pasta (`projeto-completo`):

```bash
flutter pub get
flutter run
```

Se aparecer mais de um dispositivo, digite o número dele. No Windows, dá para escolher direto com `flutter run -d windows`.

Com o app aberto, `r` aplica mudanças no código e `q` fecha.

**Usando o app:** digite a tarefa e aperte **+**. Toque na tarefa para concluir. Arraste para a esquerda para excluir. Feche e abra o app de novo: as tarefas continuam lá.

## 🧪 Testes

```bash
flutter test
```

## 🩹 Problemas comuns

| Problema | Solução |
|---|---|
| `No supported devices connected` | Instale a ferramenta da sua plataforma (veja o README principal) e rode `flutter doctor`. |
| `Build process failed` no Windows | O app ainda está aberto. Feche a janela e rode de novo. |
| O logo não aparece | Rode `flutter pub get` e reinicie o app. O hot reload não carrega imagens novas. |
| Quero o banco vazio | No computador, apague `.dart_tool/sqflite_common_ffi`. No celular, desinstale o app. |
