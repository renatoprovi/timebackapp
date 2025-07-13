# prints explicativos dos principais cenários do seu app** para o TCC

---

## Estrutura sugerida para cada cenário no TCC

| Título do Cenário         | Descrição Resumida                                | O que mostrar no print (tela do app)                                        | O que explicar (lógica/impacto)                                                      | Dicas para a legenda/legenda visual                               |
| ------------------------- | ------------------------------------------------- | --------------------------------------------------------------------------- | ------------------------------------------------------------------------------------ | ----------------------------------------------------------------- |
| 1. Uso dentro do limite   | Usuário está usando os apps, sem passar do limite | Tela principal com tempo usado menor que limite + bônus                     | Mostra controle saudável, bônus acumulado, e apps selecionados                       | “O usuário usa 40min, limite é 60min, bônus 10min acumulado”      |
| 2. Excedeu o limite       | Usuário ultrapassa limite + bônus                 | Tela de bloqueio ou alerta (dependendo do modo de bloqueio)                 | Bloqueio automático; opção de pagar para liberar (modo pago) ou bloqueio total       | “Usuário excedeu o limite, acesso bloqueado até amanhã”           |
| 3. Simulação de bônus     | Bônus de 10 minutos é dado no reset diário        | Tela mostrando bônus aumentado após reset diário                            | Lógica de “bom comportamento” — recompensa quem não passou do limite no dia anterior | “Usuário ganhou bônus de 10 minutos porque ontem não ultrapassou” |
| 4. Troca de modo bloqueio | Alteração entre modo pago e modo força de vontade | Tela inicial com opção de mudar modo; print do efeito da troca              | Mostra diferença entre pagar para liberar e bloqueio sem opção                       | “Modo Bloqueio pago permite liberar acesso via pagamento”         |
| 5. Reset total            | Usuário ou sistema limpa todos os dados           | Tela inicial após reset; sem uso, bônus zerados, apps selecionados intactos | Útil para testes e para quando o app é reinstalado                                   | “Reset de dados reinicia contador e bônus”                        |
| 6. Histórico de uso       | Visualização do histórico diário/semanal          | Tela de histórico (gráfico ou lista simples)                                | Mostra evolução do uso e reforça o monitoramento                                     | “Histórico permite acompanhar evolução do uso ao longo do tempo”  |

---

## Cenário 1: Uso dentro do limite

**Descrição:**
Neste cenário, o usuário está utilizando os aplicativos limitados, mas o tempo total usado ainda está abaixo do limite diário somado ao bônus acumulado. O app exibe o tempo usado no dia, o limite definido e o bônus disponível, incentivando o controle saudável do uso.

**Lógica do sistema:**

* O app carrega os dados do dia atual.
* O tempo usado (`usedMinutes`) está menor que a soma de `dailyLimit + bonusMinutes`.
* A interface permite ao usuário continuar usando os apps normalmente e ajustar as configurações de limite e apps.

**Impacto no usuário:**
Permite monitorar o uso e estimula o equilíbrio digital, mostrando claramente o tempo restante e o bônus acumulado.

---

## Cenário 2: Excedeu o limite diário

**Descrição:**
Aqui, o usuário ultrapassou o limite diário somado ao bônus disponível. O app bloqueia o acesso aos apps limitados. Dependendo do modo de bloqueio configurado, o usuário pode pagar para liberar mais tempo (modo pago) ou receber um bloqueio rígido (modo força de vontade).

**Lógica do sistema:**

* Quando `usedMinutes >= dailyLimit + bonusMinutes`, o app ativa a restrição.
* No modo pago, o app direciona para a tela de pagamento, onde o usuário pode adquirir minutos extras.
* No modo força de vontade, é exibido um alerta informando que o limite foi atingido e que o acesso só será liberado no dia seguinte.

**Impacto no usuário:**
Incentiva a disciplina no uso dos apps, com opção de pagamento para quem prefere flexibilidade, ou bloqueio total para quem quer mais rigor.

---

## Cenário 3: Simulação de bônus diário

**Descrição:**
Ao iniciar um novo dia, se o usuário não ultrapassou o limite no dia anterior, o app concede um bônus de 10 minutos ao limite diário, recompensando o bom comportamento digital.

**Lógica do sistema:**

* Ao detectar que a data atual mudou, o app verifica se o limite do dia anterior foi excedido.
* Se não, adiciona 10 minutos ao `bonusMinutes`.
* Reseta o contador de uso para zero para o novo dia.
* Atualiza os dados armazenados localmente.

**Impacto no usuário:**
Motiva o usuário a manter o uso dentro do limite para ganhar minutos extras, reforçando hábitos saudáveis.

---

## Cenário 4: Troca de modo de bloqueio

**Descrição:**
O usuário pode alternar entre o modo de bloqueio pago e o modo força de vontade, escolhendo entre uma abordagem mais flexível ou mais rígida para o controle do uso dos apps.

**Lógica do sistema:**

* O modo de bloqueio é armazenado nas preferências do app.
* O modo pago permite compra de tempo extra.
* O modo força de vontade bloqueia o acesso automaticamente sem opções de liberação até o próximo dia.

**Impacto no usuário:**
Oferece personalização da experiência de controle digital, respeitando diferentes níveis de disciplina.

---

## Cenário 5: Reset total dos dados

**Descrição:**
O reset dos dados permite limpar o histórico de uso, o bônus acumulado e o tempo usado, iniciando o app como se fosse uma nova instalação, mas mantendo os apps selecionados para limitar.

**Lógica do sistema:**

* Apaga os dados de uso e bônus armazenados localmente.
* Mantém as configurações dos apps selecionados intactas.
* Reinicia os contadores para valores padrão.

**Impacto no usuário:**
Útil para testes, para recuperação após erros, ou para começar o monitoramento do zero.

---

## Cenário 6: Visualização do histórico de uso

**Descrição:**
O usuário pode acessar uma tela que exibe o histórico diário e semanal do uso dos apps, mostrando a evolução do controle e permitindo reflexões sobre hábitos digitais.

**Lógica do sistema:**

* O app recupera dados armazenados em histórico local, organizados por dia e por semana.
* Exibe gráficos simples ou listas com o tempo usado em cada período.
* Facilita a análise visual do progresso ao longo do tempo.

**Impacto no usuário:**
Aumenta a consciência sobre o uso dos apps, ajudando a manter a disciplina e observar tendências.

---
