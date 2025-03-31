# Script para reorganizar os arquivos no repositório GitHub
# Movendo-os da raiz para pasta cromosit
# Uso: .\reorganize.ps1

# Cores para facilitar leitura no terminal
$Green = @{ForegroundColor = "Green"}
$Yellow = @{ForegroundColor = "Yellow"}
$Red = @{ForegroundColor = "Red"}
$Cyan = @{ForegroundColor = "Cyan"}

Write-Host "Iniciando reorganização dos arquivos no repositório GitHub..." @Green

# Verificar conexão com GitHub
$remoteUrl = git remote get-url origin 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Remote 'origin' não encontrado. Configure primeiro com: git remote add origin https://github.com/rsoshiro/SAP.git" @Red
    exit 1
}

# Obter lista de arquivos no branch master/main
Write-Host "Buscando informações do repositório remoto..." @Yellow
git fetch origin

# Determinar o nome do branch principal (main ou master)
$branches = git branch -r
$mainBranch = "master"
if ($branches -contains "origin/main") {
    $mainBranch = "main"
}

# Verificar se há arquivos na raiz que deveriam estar em /cromosit
$filesInRoot = git ls-tree -r --name-only origin/$mainBranch | Where-Object { 
    ($_ -like "sap-cloud-revenue-growth.*" -or $_ -eq "README.md" -or $_ -eq "push.ps1") -and $_ -notlike "cromosit/*" 
}

if (-not $filesInRoot) {
    Write-Host "Não foram encontrados arquivos na raiz que precisem ser movidos. A estrutura já está correta." @Green
    exit 0
}

Write-Host "Encontrados arquivos na raiz que precisam ser movidos para 'cromosit/':" @Yellow
$filesInRoot | ForEach-Object { Write-Host " - $_" @Cyan }

# Criar branch temporário para reorganização
$tempBranch = "reorganize-" + (Get-Date -Format "yyyyMMdd-HHmmss")
Write-Host "Criando branch temporário: $tempBranch..." @Yellow
git checkout -b $tempBranch origin/$mainBranch

# Verificar pasta cromosit/
if (-not (Test-Path "cromosit")) {
    Write-Host "Criando pasta 'cromosit/'..." @Yellow
    New-Item -ItemType Directory -Path "cromosit" | Out-Null
}

# Copiar arquivos da raiz para cromosit/
Write-Host "Copiando arquivos para pasta 'cromosit/'..." @Yellow
foreach ($file in $filesInRoot) {
    if (Test-Path $file) {
        $destPath = Join-Path "cromosit" (Split-Path -Leaf $file)
        Copy-Item $file -Destination $destPath -Force
        Write-Host "Copiado $file para cromosit/" @Cyan
    } else {
        Write-Host "Não foi possível encontrar o arquivo $file localmente" @Yellow
    }
}

# Adicionar novos arquivos ao git
Write-Host "Adicionando novos arquivos ao Git..." @Yellow
git add cromosit/

# Realizar commit da reorganização
git commit -m "Reorganização dos arquivos para pasta 'cromosit/'"

# Remover arquivos da raiz
Write-Host "Removendo arquivos da raiz..." @Yellow
foreach ($file in $filesInRoot) {
    git rm $file
    Write-Host "Removido $file da raiz" @Cyan
}

# Realizar commit da remoção
git commit -m "Removidos arquivos da raiz após reorganização para pasta 'cromosit/'"

# Enviar alterações para GitHub
Write-Host "Enviando alterações para GitHub..." @Yellow
git push -u origin $tempBranch

# Instruções para concluir o processo
Write-Host "`nReorganização concluída! Agora você precisa:" @Green
Write-Host "1. Criar um Pull Request no GitHub para mesclar $tempBranch em $mainBranch:" @Green
Write-Host "   https://github.com/rsoshiro/SAP/compare" @Cyan
Write-Host "2. Aprovar e mesclar o Pull Request" @Green
Write-Host "3. Excluir o branch temporário $tempBranch após a conclusão" @Green
Write-Host "4. Atualizar seu repositório local com: git checkout $mainBranch; git pull origin $mainBranch" @Green

# Dica adicional para quem tem permissão para forçar push
Write-Host "`nAlternativamente, se você tiver permissão, pode fazer um force push diretamente:" @Yellow
Write-Host "git checkout $mainBranch" @Cyan
Write-Host "git merge --no-ff $tempBranch -m 'Reorganizar arquivos para pasta cromosit/'" @Cyan
Write-Host "git push origin $mainBranch" @Cyan
Write-Host "git branch -D $tempBranch" @Cyan
Write-Host "git push origin --delete $tempBranch" @Cyan 