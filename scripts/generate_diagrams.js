const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');

// Configuração do Mermaid
const mermaidConfig = {
  theme: 'default',
  flowchart: {
    useMaxWidth: true,
    htmlLabels: true
  }
};

// Lista de diagramas para gerar
const diagrams = [
  {
    name: 'arquitetura_geral',
    content: `
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
    `
  },
  {
    name: 'fluxo_navegacao',
    content: `
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
    `
  },
  {
    name: 'diagrama_classes',
    content: `
classDiagram
    class TimeBackApp {
        +Future~Widget~ _decidirTelaInicial()
        +Widget build(BuildContext context)
    }
    
    class AppInfo {
        +String nome
        +IconData icone
        +AppInfo({required String nome, required IconData icone})
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
    `
  }
];

async function generateDiagram(diagram) {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  
  // HTML template com Mermaid
  const html = `
    <!DOCTYPE html>
    <html>
    <head>
        <script src="https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.min.js"></script>
        <style>
            body { margin: 0; padding: 20px; background: white; }
            .mermaid { text-align: center; }
        </style>
    </head>
    <body>
        <div class="mermaid">
            ${diagram.content}
        </div>
        <script>
            mermaid.initialize(${JSON.stringify(mermaidConfig)});
        </script>
    </body>
    </html>
  `;
  
  await page.setContent(html);
  await page.waitForSelector('.mermaid svg');
  
  // Aguarda um pouco para garantir que o diagrama foi renderizado
  await page.waitForTimeout(2000);
  
  // Captura screenshot
  const element = await page.$('.mermaid');
  await element.screenshot({
    path: `docs/images/${diagram.name}.png`,
    type: 'png'
  });
  
  console.log(`✅ Diagrama ${diagram.name}.png gerado com sucesso!`);
  await browser.close();
}

async function generateAllDiagrams() {
  // Cria diretório de imagens se não existir
  const imagesDir = path.join(__dirname, '../docs/images');
  if (!fs.existsSync(imagesDir)) {
    fs.mkdirSync(imagesDir, { recursive: true });
  }
  
  console.log('🚀 Iniciando geração de diagramas...');
  
  for (const diagram of diagrams) {
    try {
      await generateDiagram(diagram);
    } catch (error) {
      console.error(`❌ Erro ao gerar ${diagram.name}:`, error.message);
    }
  }
  
  console.log('🎉 Geração de diagramas concluída!');
}

// Executa se chamado diretamente
if (require.main === module) {
  generateAllDiagrams();
}

module.exports = { generateAllDiagrams, generateDiagram };
