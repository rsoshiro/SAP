# Script simples para enviar a pasta cromosit para GitHub
# Sem complicações, apenas faz o trabalho

# Mostrar o que vamos fazer
Write-Host "Enviando pasta cromosit para GitHub..." -ForegroundColor Green

# Verificar se estamos no diretório correto
if (-not (Test-Path "cromosit")) {
    Write-Host "Erro: Pasta 'cromosit' não encontrada. Execute este script no diretório que contém a pasta 'cromosit'." -ForegroundColor Red
    Read-Host "Pressione ENTER para sair"
    exit 1
}

# Verificar se o cromosit é um repositório git
if (Test-Path "cromosit/.git") {
    Write-Host "Removendo submodule git da pasta cromosit..." -ForegroundColor Yellow
    Remove-Item -Path "cromosit/.git" -Recurse -Force
}

# Configurar git se necessário
$remoteExists = git remote -v 2>$null | Select-String -Pattern "origin"
if (-not $remoteExists) {
    Write-Host "Configurando repositório Git..." -ForegroundColor Yellow
    git init
    git remote add origin https://github.com/rsoshiro/SAP.git
}

# Obter conteúdo do repositório remoto primeiro para evitar erro de push
Write-Host "Sincronizando com repositório remoto..." -ForegroundColor Yellow
git fetch origin 2>$null
git pull origin master --allow-unrelated-histories 2>$null

# Garantir que estamos no branch master
git checkout master -B 2>$null

# Apagar arquivos da raiz que não deveriam estar lá
Get-ChildItem -Path "." -File | Where-Object { $_.Name -like "sap-cloud-revenue-growth*" } | ForEach-Object {
    git rm --cached $_.Name -f 2>$null
    Write-Host "Removido $($_.Name) da raiz do repositório" -ForegroundColor Yellow
}

# Adicionar conteúdo da pasta cromosit (não como submodule)
Write-Host "Adicionando arquivos da pasta cromosit ao Git..." -ForegroundColor Green
$arquivosCromosit = Get-ChildItem -Path "cromosit" -Recurse -File
foreach ($arquivo in $arquivosCromosit) {
    $relativePath = $arquivo.FullName.Substring((Get-Location).Path.Length + 1)
    git add $relativePath
    Write-Host "Adicionado $relativePath" -ForegroundColor Cyan
}

# Commit 
git commit -m "Organizando arquivos na pasta cromosit"

# Forçar push (cuidado! isso sobrescreve o histórico remoto)
Write-Host "Enviando para GitHub (pode pedir credenciais)..." -ForegroundColor Yellow
git push -u origin master --force

Write-Host "`nConcluído! Verifique em https://github.com/rsoshiro/SAP/tree/master/cromosit" -ForegroundColor Green

# Criar o executável
Write-Host "`nCriando executável..." -ForegroundColor Yellow
try {
    if (-not (Get-Module -ListAvailable -Name PS2EXE)) {
        Install-Module -Name PS2EXE -Scope CurrentUser -Force
    }
    Import-Module PS2EXE
    Invoke-ps2exe -InputFile "GitPusherSimples.ps1" -OutputFile "EnviarCromosit.exe" -NoConsole:$false
    
    if (Test-Path "EnviarCromosit.exe") {
        Write-Host "Executável 'EnviarCromosit.exe' criado com sucesso!" -ForegroundColor Green
    }
} catch {
    Write-Host "Não foi possível criar o executável automaticamente." -ForegroundColor Red
    Write-Host "Execute este script diretamente para enviar a pasta 'cromosit'" -ForegroundColor Yellow
}

Read-Host "Pressione ENTER para sair" 