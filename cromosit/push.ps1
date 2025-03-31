# Script para reorganizar arquivos no GitHub e garantir que fiquem na pasta cromosit/
# Uso: .\push.ps1 "Mensagem de commit"

param (
    [Parameter(Mandatory=$true)]
    [string]$CommitMessage
)

# Cores para facilitar leitura no terminal
$Green = @{ForegroundColor = "Green"}
$Yellow = @{ForegroundColor = "Yellow"}
$Red = @{ForegroundColor = "Red"}
$Cyan = @{ForegroundColor = "Cyan"}

Write-Host "Iniciando o processo de envio para GitHub (pasta cromosit)..." @Green

# Verificar e corrigir URL do remote
$remoteUrl = git remote get-url origin 2>$null
$correctRemoteUrl = "https://github.com/rsoshiro/SAP.git"

if ($LASTEXITCODE -ne 0) {
    Write-Host "Remote 'origin' não encontrado. Configurando..." @Yellow
    git remote add origin $correctRemoteUrl
} else {
    # Verifica se o URL contém erro comum com tokens (está mal formatado)
    if ($remoteUrl -match "github_pat") {
        Write-Host "URL do remote contém token mal formatado. Corrigindo..." @Yellow
        git remote remove origin
        git remote add origin $correctRemoteUrl
        Write-Host "Configuração do remote corrigida!" @Green
    }
}

# Etapa 1: Verificar se estamos na pasta correta (cromosit)
$currentDir = Split-Path -Leaf (Get-Location)
$repoRoot = Get-Location

if ($currentDir -ne "cromosit") {
    Write-Host "Não estamos na pasta 'cromosit'. Verificando estrutura..." @Yellow
    
    # Verificar se cromosit existe no diretório atual
    if (Test-Path "cromosit") {
        Write-Host "Pasta 'cromosit' encontrada. Entrando na pasta..." @Yellow
        Set-Location "cromosit"
    } else {
        Write-Host "Erro: Pasta 'cromosit' não encontrada. Certifique-se de estar na pasta correta." @Red
        exit 1
    }
}

# Etapa 2: Verificar se os arquivos necessários existem
$requiredFiles = @(
    "sap-cloud-revenue-growth.html",
    "sap-cloud-revenue-growth.css",
    "sap-cloud-revenue-growth.js",
    "README.md"
)

foreach ($file in $requiredFiles) {
    if (-not (Test-Path $file)) {
        Write-Host "Erro: Arquivo $file não encontrado na pasta atual." @Red
        exit 1
    }
}

# Etapa 3: Verificar estrutura no repositório remoto
$branches = git branch -r 2>$null
if ($LASTEXITCODE -ne 0 -or $branches -eq $null) {
    # Primeiro push, não há branches remotos ainda
    Write-Host "Nenhum branch remoto encontrado. Preparando primeiro push..." @Yellow
} else {
    Write-Host "Verificando estrutura no repositório remoto..." @Yellow
    
    # Obter lista de arquivos no branch master/main
    git fetch origin
    
    # Determinar o nome do branch principal (main ou master)
    $mainBranch = "master"
    if ($branches -contains "origin/main") {
        $mainBranch = "main"
    }
    
    # Verificar se arquivos estão na raiz em vez de /cromosit
    $filesInRoot = git ls-tree -r --name-only origin/$mainBranch | Where-Object { 
        $_ -like "sap-cloud-revenue-growth.*" -and $_ -notlike "cromosit/*" 
    }
    
    if ($filesInRoot) {
        Write-Host "AVISO: Encontrados arquivos na raiz do repositório que deveriam estar na pasta 'cromosit/':" @Red
        $filesInRoot | ForEach-Object { Write-Host " - $_" @Red }
        
        Write-Host "Use o script 'reorganize.ps1' para corrigir a estrutura antes de continuar." @Yellow
        Write-Host "Deseja continuar mesmo assim? (S/N)" @Yellow
        $response = Read-Host
        if ($response -ne "S" -and $response -ne "s") {
            exit 0
        }
    }
}

# Etapa 4: Adicionar e commitar alterações
Write-Host "Adicionando arquivos modificados..." @Yellow
git add .

# Verificar se há alterações para commit
$status = git status --porcelain
if (-not $status) {
    Write-Host "Não há alterações para enviar ao repositório." @Red
    exit 0
}

# Criar commit com a mensagem fornecida
Write-Host "Criando commit: $CommitMessage" @Yellow
git commit -m $CommitMessage

# Determinar a branch atual ou usar 'master'
$currentBranch = git rev-parse --abbrev-ref HEAD 2>$null
if ($LASTEXITCODE -ne 0 -or -not $currentBranch) {
    $currentBranch = "master"
}

# Etapa 5: Enviar para o GitHub
try {
    Write-Host "Enviando para GitHub (branch $currentBranch)..." @Yellow
    git push -u origin $currentBranch
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Arquivos enviados com sucesso!" @Green
        
        Write-Host "Arquivos enviados:" @Cyan
        git diff --name-only HEAD~1 HEAD | ForEach-Object { 
            Write-Host " - $_" @Cyan
        }
    } else {
        Write-Host "Falha ao enviar para o GitHub. Pode ser necessário configurar credenciais." @Red
        Write-Host "Tente usar: git push -u origin $currentBranch" @Yellow
    }
} catch {
    Write-Host "Erro ao executar git push: $_" @Red
}

Write-Host "Verifique o repositório em: https://github.com/rsoshiro/SAP/tree/$currentBranch/cromosit" @Green 