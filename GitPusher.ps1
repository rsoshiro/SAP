# GitPusher.ps1 - Script para enviar arquivos para a pasta /cromosit/ no GitHub
# Autor: Claude (Cursor.io)
# Data: 30/03/2025
# Uso: Execute este script na pasta raiz do projeto

# Configuração de cores para melhor legibilidade
$Green = @{ForegroundColor = "Green"}
$Yellow = @{ForegroundColor = "Yellow"}
$Red = @{ForegroundColor = "Red"}
$Cyan = @{ForegroundColor = "Cyan"}

# Banner inicial
Clear-Host
Write-Host "====================================" @Green
Write-Host "   CROMOSIT GITHUB PUSHER v1.0      " @Green
Write-Host "====================================" @Green
Write-Host ""

# 1. Verificar se estamos na pasta correta
$workdir = Get-Location
$cromositDir = Join-Path -Path $workdir -ChildPath "cromosit"

if (-not (Test-Path $cromositDir)) {
    Write-Host "ERRO: Pasta 'cromosit' não encontrada!" @Red
    Write-Host "Execute este programa na pasta raiz do projeto que contém a pasta 'cromosit'." @Yellow
    Read-Host "Pressione ENTER para sair"
    exit 1
}

# 2. Verificar arquivos na pasta cromosit
$arquivosRequeridos = @("sap-cloud-revenue-growth.html", "sap-cloud-revenue-growth.css", "sap-cloud-revenue-growth.js")
$arquivosFaltando = @()

foreach ($arquivo in $arquivosRequeridos) {
    $caminhoArquivo = Join-Path -Path $cromositDir -ChildPath $arquivo
    if (-not (Test-Path $caminhoArquivo)) {
        $arquivosFaltando += $arquivo
    }
}

if ($arquivosFaltando.Count -gt 0) {
    Write-Host "ERRO: Os seguintes arquivos estão faltando na pasta 'cromosit':" @Red
    foreach ($arquivo in $arquivosFaltando) {
        Write-Host " - $arquivo" @Red
    }
    Read-Host "Pressione ENTER para sair"
    exit 1
}

# 3. Configurar Git se necessário
Write-Host "Verificando configuração do Git..." @Yellow
$remoteUrl = git remote get-url origin 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Configurando repositório Git..." @Yellow
    git init
    git remote add origin https://github.com/rsoshiro/SAP.git
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERRO: Falha ao configurar Git!" @Red
        Read-Host "Pressione ENTER para sair"
        exit 1
    }
}

# 4. Verificar branch atual ou criar uma nova
$branch = git rev-parse --abbrev-ref HEAD 2>$null
if ($LASTEXITCODE -ne 0 -or $branch -eq "HEAD") {
    Write-Host "Criando e alternando para a branch 'master'..." @Yellow
    git checkout -b master
}

# 5. Preparar estrutura correta para o GitHub
Write-Host "Preparando estrutura para envio..." @Yellow

# Lista de arquivos que deveriam estar apenas na pasta cromosit
$arquivosParaRemover = @("sap-cloud-revenue-growth.html", "sap-cloud-revenue-growth.css", "sap-cloud-revenue-growth.js", "README.md")

# Remover arquivos da raiz do repositório que deveriam estar apenas na pasta cromosit
foreach ($arquivo in $arquivosParaRemover) {
    if (Test-Path $arquivo) {
        git rm -f $arquivo --quiet 2>$null
        Write-Host " - Removido '$arquivo' da raiz" @Cyan
    }
}

# 6. Adicionar arquivos da pasta cromosit
Write-Host "Adicionando arquivos da pasta 'cromosit'..." @Yellow
git add $cromositDir

# 7. Criar commit
$mensagem = "Organização dos arquivos na pasta /cromosit/"
Write-Host "Criando commit: $mensagem" @Yellow
git commit -m $mensagem

# 8. Enviar para GitHub
Write-Host "Enviando para GitHub..." @Yellow
git push -u origin master

if ($LASTEXITCODE -ne 0) {
    Write-Host "`nERRO: Falha ao enviar para GitHub!" @Red
    Write-Host "Possíveis causas:" @Yellow
    Write-Host " - Credenciais GitHub não configuradas" @Yellow
    Write-Host " - Problemas de conectividade" @Yellow
    Write-Host " - Conflitos no repositório remoto" @Yellow
    Write-Host "`nTente usar:" @Cyan
    Write-Host "git push -u origin master" @Cyan
    Read-Host "Pressione ENTER para sair"
    exit 1
}

# 9. Mensagem de sucesso
Write-Host "`n====================================" @Green
Write-Host "   OPERAÇÃO CONCLUÍDA COM SUCESSO!  " @Green
Write-Host "====================================" @Green
Write-Host "`nOs arquivos foram enviados para:" @Yellow
Write-Host "https://github.com/rsoshiro/SAP/tree/master/cromosit" @Cyan
Write-Host "`nPara verificar se tudo está correto, acesse o link acima." @Yellow
Write-Host "A estrutura final deve ser: /cromosit/sap-cloud-revenue-growth.{html,css,js}" @Yellow

# Pausa final
Read-Host "`nPressione ENTER para sair" 