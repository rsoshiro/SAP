# Script para converter o GitPusher.ps1 em um executável
# Execute este script para criar o executável GitPusher.exe

# Verificar se o módulo PS2EXE está instalado
if (-not (Get-Module -ListAvailable -Name PS2EXE)) {
    Write-Host "Instalando o módulo PS2EXE..." -ForegroundColor Yellow
    Install-Module -Name PS2EXE -Scope CurrentUser -Force
}

# Importar o módulo PS2EXE
Import-Module PS2EXE

# Verificar se o arquivo GitPusher.ps1 existe
if (-not (Test-Path "GitPusher.ps1")) {
    Write-Host "ERRO: O arquivo GitPusher.ps1 não foi encontrado no diretório atual." -ForegroundColor Red
    Write-Host "Certifique-se de que o arquivo GitPusher.ps1 está no mesmo diretório que este script." -ForegroundColor Yellow
    exit 1
}

# Converter o script para executável
Write-Host "Convertendo GitPusher.ps1 para executável..." -ForegroundColor Green
Invoke-ps2exe -InputFile "GitPusher.ps1" -OutputFile "GitPusher.exe" -NoConsole:$false -NoOutput:$false -NoError:$false -IconFile:$null

# Verificar se o executável foi criado com sucesso
if (Test-Path "GitPusher.exe") {
    Write-Host "Executável criado com sucesso!" -ForegroundColor Green
    Write-Host "Você pode agora executar GitPusher.exe para enviar os arquivos para o GitHub." -ForegroundColor Green
} else {
    Write-Host "ERRO: Não foi possível criar o executável." -ForegroundColor Red
    Write-Host "Tente executar o script GitPusher.ps1 diretamente." -ForegroundColor Yellow
}

# Instruções para utilização
Write-Host "`nInstruções de Uso:" -ForegroundColor Cyan
Write-Host "1. Certifique-se de que todos os arquivos estão na pasta 'cromosit'" -ForegroundColor White
Write-Host "2. Execute o arquivo GitPusher.exe" -ForegroundColor White
Write-Host "3. Siga as instruções apresentadas na tela" -ForegroundColor White
Write-Host "4. Verifique o resultado em https://github.com/rsoshiro/SAP/tree/master/cromosit" -ForegroundColor White

# Pausa final
Read-Host "`nPressione ENTER para sair" 