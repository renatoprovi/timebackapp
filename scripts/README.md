# Gerador de Diagramas PNG - TimeBack App

Este script converte os diagramas Mermaid em arquivos PNG para uso em documentação.

## 🚀 Como Usar

### Pré-requisitos
- Node.js instalado (versão 14 ou superior)
- NPM ou Yarn

### Passos para Gerar os Diagramas

1. **Instalar dependências:**
```bash
cd scripts
npm install
```

2. **Gerar diagramas PNG:**
```bash
npm run generate
```

3. **Resultado:**
Os diagramas PNG serão gerados na pasta `docs/images/`:
- `arquitetura_geral.png`
- `fluxo_navegacao.png`
- `diagrama_classes.png`

## 📁 Estrutura de Arquivos

```
scripts/
├── generate_diagrams.js    # Script principal
├── package.json           # Dependências
└── README.md             # Este arquivo

docs/
└── images/               # Diagramas PNG gerados
    ├── arquitetura_geral.png
    ├── fluxo_navegacao.png
    └── diagrama_classes.png
```

## 🔧 Personalização

Para adicionar novos diagramas, edite o array `diagrams` no arquivo `generate_diagrams.js`:

```javascript
const diagrams = [
  {
    name: 'nome_do_diagrama',
    content: `
      // Código Mermaid aqui
      graph TD
        A --> B
    `
  }
];
```

## 🎨 Configurações

Você pode personalizar:
- **Tema**: Altere `theme` em `mermaidConfig`
- **Tamanho**: Modifique as configurações de screenshot
- **Formato**: Mude `type: 'png'` para `type: 'jpeg'`

## 🛠️ Solução de Problemas

### Erro: "puppeteer not found"
```bash
npm install puppeteer
```

### Erro: "Cannot find module"
```bash
npm install
```

### Diagrama não renderiza
- Verifique se o código Mermaid está correto
- Aumente o timeout em `page.waitForTimeout(2000)`

## 📝 Alternativas Online

Se preferir não usar o script, você pode:

1. **Mermaid Live Editor**: https://mermaid.live/
   - Cole o código Mermaid
   - Clique em "Download PNG"

2. **GitHub**: 
   - Coloque os diagramas em um repositório
   - GitHub renderiza automaticamente

3. **VS Code Extensions**:
   - "Mermaid Preview"
   - "Markdown Preview Mermaid Support"

## 🎯 Diagramas Disponíveis

1. **Arquitetura Geral**: Estrutura do projeto Flutter
2. **Fluxo de Navegação**: Como as telas se conectam
3. **Diagrama de Classes**: Modelos e relacionamentos

## 📞 Suporte

Se encontrar problemas, verifique:
- Versão do Node.js
- Permissões de escrita na pasta docs/
- Conexão com internet (para baixar Mermaid)
