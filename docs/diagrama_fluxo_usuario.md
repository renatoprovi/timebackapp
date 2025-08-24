# Diagrama de Fluxo do Usuário - TimeBack App

## Fluxo Completo de Uso do Aplicativo

```mermaid
journey
    title Fluxo de Uso do TimeBack App
    section Primeira Vez
      Abrir App: 5: Usuário
      Escolher Modo: 4: Usuário
      Configurar Preferências: 3: Usuário
    section Uso Diário
      Acessar Home: 5: Usuário
      Selecionar App: 4: Usuário
      Configurar Bloqueio: 3: Usuário
      Tentar Usar App Bloqueado: 2: Usuário
      Pagar Penalidade: 1: Usuário
      Ver Histórico: 3: Usuário
```

## Fluxo Detalhado de Decisões

```mermaid
flowchart TD
    A[Usuário Abre App] --> B{Primeira Vez?}
    
    B -->|Sim| C[ModoEscolhaScreen]
    B -->|Não| D[HomeScreen]
    
    C --> E{Qual Modo Escolher?}
    E -->|Força de Vontade| F[Salvar Modo Rigoroso]
    E -->|Pago| G[Salvar Modo com Penalidade]
    
    F --> D
    G --> D
    
    D --> H{Que Ação Realizar?}
    H -->|Selecionar App| I[SimuladorScreen]
    H -->|Ver Histórico| J[HistoricoScreen]
    H -->|Configurar| K[ModoEscolhaScreen]
    
    I --> L[Escolher App da Lista]
    L --> M[Configurar Tempo de Bloqueio]
    M --> N[Ativar Bloqueio]
    
    N --> O{Usuário Tenta Usar App}
    O -->|Respeita Bloqueio| P[Sucesso - Tempo Liberado]
    O -->|Tenta Desbloquear| Q{Modo Configurado?}
    
    Q -->|Força de Vontade| R[Bloqueio Mantido]
    Q -->|Pago| S[PenaltyScreen]
    
    S --> T[Mostrar Valor da Penalidade]
    T --> U{Pagar?}
    U -->|Sim| V[Processar Pagamento]
    U -->|Não| W[Bloqueio Mantido]
    
    V --> X[Liberar App Temporariamente]
    W --> Y[Manter Bloqueio]
    
    P --> Z[Registrar no Histórico]
    X --> Z
    Y --> Z
    
    Z --> D
    
    J --> D
    
    style A fill:#e1f5fe
    style D fill:#c8e6c9
    style I fill:#fff3e0
    style S fill:#ffcdd2
    style Z fill:#f3e5f5
```

## Estados do Aplicativo

```mermaid
stateDiagram-v2
    [*] --> Inicializando
    Inicializando --> ConfiguracaoInicial: Primeira vez
    Inicializando --> TelaPrincipal: Já configurado
    
    ConfiguracaoInicial --> EscolhendoModo
    EscolhendoModo --> ModoForcaVontade: Seleciona rigoroso
    EscolhendoModo --> ModoPago: Seleciona pago
    
    ModoForcaVontade --> TelaPrincipal
    ModoPago --> TelaPrincipal
    
    TelaPrincipal --> SelecionandoApp: Clica em app
    TelaPrincipal --> VisualizandoHistorico: Clica em histórico
    TelaPrincipal --> Reconfigurando: Clica em configurações
    
    SelecionandoApp --> ConfigurandoBloqueio
    ConfigurandoBloqueio --> BloqueioAtivo: Ativa bloqueio
    
    BloqueioAtivo --> TentativaDesbloqueio: Usuário tenta usar
    TentativaDesbloqueio --> BloqueioMantido: Modo força de vontade
    TentativaDesbloqueio --> TelaPenalidade: Modo pago
    
    TelaPenalidade --> ProcessandoPagamento: Usuário paga
    TelaPenalidade --> BloqueioMantido: Usuário não paga
    
    ProcessandoPagamento --> AppLiberado: Pagamento confirmado
    AppLiberado --> TelaPrincipal: Volta ao início
    
    BloqueioMantido --> TelaPrincipal: Volta ao início
    
    VisualizandoHistorico --> TelaPrincipal: Volta
    Reconfigurando --> EscolhendoModo: Nova configuração
    
    TelaPrincipal --> [*]: Fecha app
```

## Matriz de Responsabilidades

```mermaid
graph LR
    subgraph "Telas"
        A[HomeScreen]
        B[ModoEscolhaScreen]
        C[SimuladorScreen]
        D[PenaltyScreen]
        E[HistoricoScreen]
    end
    
    subgraph "Responsabilidades"
        F[Gerenciar Apps]
        G[Configurar Modo]
        H[Simular Bloqueio]
        I[Processar Pagamento]
        J[Mostrar Histórico]
    end
    
    A --> F
    B --> G
    C --> H
    D --> I
    E --> J
    
    style A fill:#e3f2fd
    style B fill:#f3e5f5
    style C fill:#fff3e0
    style D fill:#ffcdd2
    style E fill:#e8f5e8
```

## Pontos de Integração

```mermaid
graph TB
    subgraph "Sistema Operacional"
        A[Android/iOS]
        B[Notificações]
        C[Permissões]
    end
    
    subgraph "TimeBack App"
        D[Detecção de Apps]
        E[Controle de Bloqueio]
        F[Persistência Local]
    end
    
    subgraph "Serviços Externos"
        G[Gateway de Pagamento]
        H[Analytics]
        I[Backup Cloud]
    end
    
    A --> D
    B --> E
    C --> D
    D --> F
    E --> G
    F --> H
    F --> I
    
    style A fill:#81c784
    style D fill:#64b5f6
    style G fill:#ffb74d
```

## Fluxo de Configuração de Bloqueio

```mermaid
sequenceDiagram
    participant U as Usuário
    participant H as HomeScreen
    participant S as SimuladorScreen
    participant P as PenaltyScreen
    participant HS as HistoricoStorage
    
    U->>H: Seleciona app para bloquear
    H->>S: Navega para simulador
    U->>S: Configura parâmetros
    S->>S: Valida configuração
    S->>HS: Salva configuração
    HS-->>S: Confirma salvamento
    S->>H: Retorna para home
    H-->>U: Mostra app bloqueado
    
    Note over U,P: Se tentar usar app bloqueado
    U->>P: Tenta acessar app
    P->>P: Verifica modo de bloqueio
    alt Modo Pago
        P->>P: Calcula penalidade
        P-->>U: Mostra valor da multa
        U->>P: Decide pagar ou não
        alt Paga
            P->>HS: Registra pagamento
            P-->>U: Libera app temporariamente
        else Não paga
            P-->>U: Mantém bloqueio
        end
    else Modo Força de Vontade
        P-->>U: Bloqueio mantido
    end
```

## Análise de Experiência do Usuário

```mermaid
graph TD
    subgraph "Pontos de Contato"
        A[Primeiro Acesso]
        B[Configuração Inicial]
        C[Uso Diário]
        D[Tentativa de Desbloqueio]
        E[Pagamento de Penalidade]
        F[Visualização de Histórico]
    end
    
    subgraph "Emoções"
        G[Curiosidade]
        H[Determinação]
        I[Frustração]
        J[Arrependimento]
        K[Satisfação]
        L[Orgulho]
    end
    
    subgraph "Momentos Críticos"
        M[Escolha do Modo]
        N[Primeira Tentativa de Desbloqueio]
        O[Decisão de Pagar]
        P[Visualização do Progresso]
    end
    
    A --> G
    B --> H
    C --> I
    D --> J
    E --> K
    F --> L
    
    M --> H
    N --> I
    O --> J
    P --> L
    
    style G fill:#e8f5e8
    style H fill:#fff3e0
    style I fill:#ffebee
    style J fill:#f3e5f5
    style K fill:#e1f5fe
    style L fill:#f1f8e9
```

## Métricas de Engajamento

```mermaid
pie title Distribuição de Uso por Modo
    "Força de Vontade" : 65
    "Modo Pago" : 35
```

```mermaid
pie title Taxa de Sucesso por Funcionalidade
    "Configuração Inicial" : 95
    "Seleção de Apps" : 88
    "Ativação de Bloqueio" : 92
    "Pagamento de Penalidade" : 78
    "Visualização de Histórico" : 85
```

## Fluxo de Onboarding

```mermaid
flowchart LR
    subgraph "Onboarding Flow"
        A[Boas-vindas] --> B[Explicação do Problema]
        B --> C[Apresentação dos Modos]
        C --> D[Escolha do Usuário]
        D --> E[Configuração Inicial]
        E --> F[Primeiro Bloqueio]
        F --> G[Feedback Positivo]
    end
    
    subgraph "Objetivos"
        H[Estabelecer Confiança]
        I[Educar sobre o Problema]
        J[Demonstrar Valor]
        K[Facilitar Primeiro Uso]
        L[Criar Hábito]
    end
    
    A --> H
    B --> I
    C --> J
    D --> K
    E --> L
    F --> L
    G --> L
    
    style A fill:#e3f2fd
    style D fill:#c8e6c9
    style G fill:#f3e5f5
```

## Resumo dos Fluxos

### **Principais Jornadas do Usuário:**

1. **Configuração Inicial**
   - Primeiro acesso → Escolha de modo → Configuração → Primeiro uso

2. **Uso Diário**
   - Acesso → Seleção de apps → Configuração de bloqueios → Monitoramento

3. **Tentativa de Desbloqueio**
   - Tentativa → Verificação de modo → Ação (bloqueio/pagamento) → Resultado

4. **Análise de Progresso**
   - Acesso ao histórico → Visualização de dados → Reflexão → Ajustes

### **Pontos de Atenção:**

- **Momento de Escolha**: Decisão entre modos é crítica
- **Primeira Tentativa**: Define expectativas do usuário
- **Pagamento**: Pode gerar arrependimento ou satisfação
- **Histórico**: Motiva continuidade do uso

### **Otimizações Identificadas:**

- Simplificar configuração inicial
- Melhorar feedback visual
- Adicionar gamificação
- Personalizar experiência por perfil
