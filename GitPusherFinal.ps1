# Script final para enviar a pasta cromosit para GitHub
# Feito para resolver de vez o problema do submodule
# Autor: Claude via Cursor

# Banner
Write-Host "============================================" -ForegroundColor Green
Write-Host "  ENVIO DA PASTA CROMOSIT PARA GITHUB   " -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""

# Verificar pasta cromosit
if (-not (Test-Path "cromosit")) {
    Write-Host "Erro: Pasta 'cromosit' não encontrada!" -ForegroundColor Red
    Write-Host "Execute este script no diretório raiz que contém a pasta 'cromosit'." -ForegroundColor Yellow
    Read-Host "Pressione ENTER para sair"
    exit 1
}

# Configurar git
Write-Host "Configurando repositório Git..." -ForegroundColor Yellow
git init -q
git remote remove origin 2>$null
git remote add origin https://github.com/rsoshiro/SAP.git

# Remover qualquer submodule
if (Test-Path "cromosit/.git") {
    Write-Host "Removendo submodule git da pasta cromosit..." -ForegroundColor Yellow
    Remove-Item -Path "cromosit/.git" -Recurse -Force
}

# Remover registros de submodule
if (Test-Path ".git/modules/cromosit") {
    Write-Host "Removendo registros de submodule..." -ForegroundColor Yellow
    Remove-Item -Path ".git/modules/cromosit" -Recurse -Force
}

# Limpar índice git
git rm --cached cromosit -f -q 2>$null

# Listar arquivos na pasta cromosit
Write-Host "Verificando arquivos na pasta cromosit..." -ForegroundColor Yellow
$arquivos = Get-ChildItem -Path "cromosit" -File
Write-Host "Encontrados $($arquivos.Count) arquivos:" -ForegroundColor Cyan
$arquivos | ForEach-Object { Write-Host " - $($_.Name)" -ForegroundColor Cyan }

# Copiar arquivos para pasta temporária
Write-Host "Preparando arquivos para envio..." -ForegroundColor Yellow
$tempDir = "temp_upload"
if (Test-Path $tempDir) {
    Remove-Item -Path $tempDir -Recurse -Force
}
New-Item -ItemType Directory -Path "$tempDir/cromosit" -Force | Out-Null

# Copiar arquivos
foreach ($arquivo in $arquivos) {
    Copy-Item -Path $arquivo.FullName -Destination "$tempDir/cromosit/" -Force
    Write-Host "Copiado $($arquivo.Name) para pasta temporária" -ForegroundColor Gray
}

# Trocar para a pasta temporária
Push-Location $tempDir

# Inicializar git na pasta temporária
git init -q
git remote add origin https://github.com/rsoshiro/SAP.git

# Adicionar arquivos
Write-Host "Adicionando arquivos ao git..." -ForegroundColor Yellow
git add .

# Verificar se há algo para commitar
$status = git status --porcelain
if (-not $status) {
    Write-Host "Nenhum arquivo novo para enviar." -ForegroundColor Red
    Pop-Location
    Read-Host "Pressione ENTER para sair"
    exit 0
}

# Commit
Write-Host "Criando commit..." -ForegroundColor Yellow
git commit -m "Organização dos arquivos na pasta cromosit [correto]"

# Push force
Write-Host "Enviando para GitHub..." -ForegroundColor Yellow
git push -u origin master --force

# Voltar para pasta original
Pop-Location

# Limpar pasta temporária
Write-Host "Limpando arquivos temporários..." -ForegroundColor Gray
Remove-Item -Path $tempDir -Recurse -Force

# Criar executável
Write-Host "`nConcluído! Verifique em https://github.com/rsoshiro/SAP/tree/master/cromosit" -ForegroundColor Green
Write-Host "`nCriando executável..." -ForegroundColor Yellow

try {
    if (-not (Get-Module -ListAvailable -Name PS2EXE)) {
        Install-Module -Name PS2EXE -Scope CurrentUser -Force
    }
    Import-Module PS2EXE
    Invoke-ps2exe -InputFile "GitPusherFinal.ps1" -OutputFile "EnviarCromosit.exe" -NoConsole:$false
    
    if (Test-Path "EnviarCromosit.exe") {
        Write-Host "Executável 'EnviarCromosit.exe' criado com sucesso!" -ForegroundColor Green
        Write-Host "Pode usar este executável para enviar a pasta cromosit para o GitHub." -ForegroundColor Green
    }
} catch {
    Write-Host "Não foi possível criar o executável automaticamente." -ForegroundColor Red
    Write-Host "Execute este script diretamente para enviar a pasta 'cromosit'" -ForegroundColor Yellow
}

Read-Host "`nPressione ENTER para sair" 