# Diagramas do Projeto TimeBack App

## 1. Arquitetura Geral do Projeto

```mermaid
graph TB
    subgraph "TimeBack App - Flutter"
        subgraph "lib/"
            A[main.dart] --> B[screens/]
            A --> C[models/]
            A --> D[widgets/]
            A --> E[utils/]
            
            subgraph "screens/"
                B1[home_screen.dart]
                B2[modo_escolha_screen.dart]
                B3[simulador_screen.dart]
                B4[penalty_screen.dart]
                B5[historico_screen.dart]
            end
            
            subgraph "models/"
                C1[app_info.dart]
                C2[modo_bloqueio.dart]
            end
            
            subgraph "widgets/"
                D1[app_selector_grid.dart]
            end
            
            subgraph "utils/"
                E1[historico_storage.dart]
            end
        end
        
        subgraph "Dependencies"
            F[shared_preferences]
            G[cupertino_icons]
        end
    end
    
    A --> F
    A --> G
    B --> C
    B --> D
    E --> F
```

## 2. Fluxo de Navegação entre Telas

```mermaid
flowchart TD
    A[App Inicia] --> B{Modo já configurado?}
    B -->|Não| C[ModoEscolhaScreen]
    B -->|Sim| D[HomeScreen]
    
    C --> E[Escolher Modo]
    E --> F[Salvar Preferência]
    F --> D
    
    D --> G[Selecionar App]
    G --> H[SimuladorScreen]
    
    H --> I[Configurar Bloqueio]
    I --> J[PenaltyScreen]
    
    J --> K[Pagar Penalidade]
    K --> L[HistoricoScreen]
    
    D --> L
    L --> D
    
    style A fill:#e1f5fe
    style D fill:#c8e6c9
    style H fill:#fff3e0
    style J fill:#ffcdd2
    style L fill:#f3e5f5
```

## 3. Diagrama de Classes/Modelos

```mermaid
classDiagram
    class TimeBackApp {
        +Future~Widget~ _decidirTelaInicial()
        +Widget build(BuildContext context)
    }
    
    class AppInfo {
        +String nome
        +IconData icone
        +AppInfo(nome, icone)
    }
    
    class ModoBloqueio {
        <<enumeration>>
        forcaDeVontade
        pago
    }
    
    class HomeScreen {
        +Widget build(BuildContext context)
        +void _iniciarBloqueio()
        +void _abrirHistorico()
    }
    
    class ModoEscolhaScreen {
        +Widget build(BuildContext context)
        +void _selecionarModo(ModoBloqueio modo)
    }
    
    class SimuladorScreen {
        +Widget build(BuildContext context)
        +void _configurarBloqueio()
    }
    
    class PenaltyScreen {
        +Widget build(BuildContext context)
        +void _pagarPenalidade()
    }
    
    class HistoricoScreen {
        +Widget build(BuildContext context)
        +Future~List~ _carregarHistorico()
    }
    
    class HistoricoStorage {
        +Future~void~ salvarHistorico(String app, DateTime data)
        +Future~List~ carregarHistorico()
    }
    
    class AppSelectorGrid {
        +Widget build(BuildContext context)
        +void _selecionarApp(AppInfo app)
    }
    
    TimeBackApp --> HomeScreen
    TimeBackApp --> ModoEscolhaScreen
    HomeScreen --> SimuladorScreen
    HomeScreen --> HistoricoScreen
    SimuladorScreen --> PenaltyScreen
    HomeScreen --> AppSelectorGrid
    AppSelectorGrid --> AppInfo
    HistoricoScreen --> HistoricoStorage
    ModoEscolhaScreen --> ModoBloqueio
```

## 4. Fluxo de Dados e Persistência

```mermaid
flowchart LR
    subgraph "UI Layer"
        A[HomeScreen]
        B[ModoEscolhaScreen]
        C[SimuladorScreen]
        D[PenaltyScreen]
        E[HistoricoScreen]
    end
    
    subgraph "Business Logic"
        F[AppInfo Model]
        G[ModoBloqueio Enum]
        H[AppSelectorGrid Widget]
    end
    
    subgraph "Data Layer"
        I[SharedPreferences]
        J[HistoricoStorage]
    end
    
    subgraph "Storage"
        K[Local Storage]
        L[App History]
    end
    
    A --> F
    A --> H
    B --> G
    B --> I
    C --> F
    D --> J
    E --> J
    I --> K
    J --> L
    
    style A fill:#e3f2fd
    style F fill:#f3e5f5
    style I fill:#e8f5e8
    style K fill:#fff3e0
```

## 5. Estrutura de Dependências

```mermaid
graph TD
    subgraph "TimeBack App"
        A[main.dart]
        B[screens/]
        C[models/]
        D[widgets/]
        E[utils/]
    end
    
    subgraph "External Dependencies"
        F[flutter]
        G[shared_preferences]
        H[cupertino_icons]
    end
    
    subgraph "Dev Dependencies"
        I[flutter_test]
        J[flutter_lints]
    end
    
    A --> F
    A --> G
    A --> H
    B --> C
    B --> D
    E --> G
    
    style F fill:#81c784
    style G fill:#64b5f6
    style H fill:#ffb74d
```

## 6. Fluxo de Configuração Inicial

```mermaid
sequenceDiagram
    participant User
    participant App
    participant SharedPrefs
    participant ModoEscolha
    participant Home
    
    User->>App: Abre o app
    App->>SharedPrefs: Verifica modo configurado
    SharedPrefs-->>App: Retorna null (primeira vez)
    App->>ModoEscolha: Navega para tela de escolha
    User->>ModoEscolha: Seleciona modo (força de vontade/pago)
    ModoEscolha->>SharedPrefs: Salva preferência
    ModoEscolha->>Home: Navega para tela principal
    Home-->>User: Exibe interface principal
```

## Resumo da Arquitetura

O **TimeBack App** é um aplicativo Flutter que implementa um sistema de controle de tempo para aplicativos móveis. A arquitetura segue o padrão MVC (Model-View-Controller) com as seguintes características:

### **Camadas:**
- **UI Layer**: Telas e widgets responsáveis pela interface
- **Business Logic**: Modelos e lógica de negócio
- **Data Layer**: Utilitários para persistência de dados
- **Storage**: Armazenamento local usando SharedPreferences

### **Funcionalidades Principais:**
1. **Seleção de Modo**: Escolha entre bloqueio por força de vontade ou pago
2. **Seleção de Apps**: Grid para escolher aplicativos para bloquear
3. **Simulação de Bloqueio**: Interface para configurar bloqueios
4. **Sistema de Penalidades**: Tela para pagar multas por uso
5. **Histórico**: Registro de atividades e bloqueios

### **Tecnologias:**
- **Framework**: Flutter/Dart
- **Persistência**: SharedPreferences
- **UI**: Material Design 3
- **Plataformas**: Android, iOS, Web, Desktop
