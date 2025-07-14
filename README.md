## TimeBack

**Aplicativo de Autorregulação Digital com Incentivo Financeiro e Impacto Social**

O TimeBack é um app Flutter que ajuda usuários a regularem o tempo gasto em redes sociais.
Caso ultrapassem o limite diário de uso, uma penalidade voluntária em dinheiro é proposta — revertida a instituições de apoio a dependentes tecnológicos.

---

## Funcionalidades Atuais

* ✅ Definição de limite diário de uso (em minutos)
* ✅ Simulação de uso incremental
* ✅ Alerta ao ultrapassar o tempo
* ✅ Tela de penalidade com "pagamento simbólico"
* ✅ Ao pagar, o tempo extra é concedido
* ✅ Persistência de dados com `shared_preferences`

---

## Requisitos

* Flutter SDK (versão estável)
* VSCode ou Android Studio
* Google Chrome (para rodar via Web)

---

## Estrutura do projeto

```
lib/
├── models/
│   ├── app_info.dart
│   └── modo_bloqueio.dart
├── screens/
│   ├── historico_screen.dart
│   ├── home_screen.dart
│   ├── modo_escolha_screen.dart
│   ├── penalty_screen.dart
│   └── simulador_screen.dart
├── utils/
│   └── historico_storage.dart
├── widgets/
│   └── app_selector_grid.dart
└── main.dart

```

---

## Como rodar o projeto

### 1. Clone o repositório

```bash
git clone https://github.com/seu-usuario/timeback_app.git
cd timeback_app
```

### 2. Instale as dependências

```bash
flutter pub get
```

### 3. Rode o app no navegador (modo web)

```bash
flutter run -d web-server
```

🔗 O link será algo como: `http://localhost:XXXXX`
Abra no navegador caso não abra automaticamente.

---

## Testes (futuramente)

Por enquanto não há testes implementados.
Você pode excluir o arquivo `test/widget_test.dart` se quiser limpar o projeto.

---

## Próximos passos (roadmap)

* [ ] Reset automático do tempo diariamente
* [ ] Integração com Pix (doação real da penalidade)
* [ ] Autenticação de usuários
* [ ] Histórico de uso e penalidades
* [ ] Modo escuro / acessibilidade
* [ ] Publicação na Play Store

---

## Licença

Projeto acadêmico sem fins lucrativos.
Se inspirou? Dê créditos e faça o bem. 🙏

---

Se quiser, eu te gero isso pronto como arquivo `.md`, ou já preparo para colocar no GitHub.
Vamos em frente, isso aqui tem futuro!
