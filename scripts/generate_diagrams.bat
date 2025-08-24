@echo off
echo ========================================
echo   Gerador de Diagramas - TimeBack App
echo ========================================
echo.

echo Verificando se Node.js esta instalado...
node --version >nul 2>&1
if errorlevel 1 (
    echo ERRO: Node.js nao encontrado!
    echo Por favor, instale o Node.js de: https://nodejs.org/
    pause
    exit /b 1
)

echo Node.js encontrado!
echo.

echo Verificando dependencias...
if not exist "node_modules" (
    echo Instalando dependencias...
    npm install
    if errorlevel 1 (
        echo ERRO: Falha ao instalar dependencias!
        pause
        exit /b 1
    )
)

echo.
echo Gerando diagramas PNG...
npm run generate

if errorlevel 1 (
    echo.
    echo ERRO: Falha ao gerar diagramas!
    pause
    exit /b 1
)

echo.
echo ========================================
echo   Diagramas gerados com sucesso!
echo ========================================
echo.
echo Arquivos gerados em: docs/images/
echo - arquitetura_geral.png
echo - fluxo_navegacao.png
echo - diagrama_classes.png
echo.

pause
