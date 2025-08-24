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
