# Script para restaurar o footer original no arquivo HTML
# Este script modifica o arquivo HTML para restaurar o footer original

# Configurações de cores
$Green = @{ForegroundColor = "Green"}
$Yellow = @{ForegroundColor = "Yellow"}
$Cyan = @{ForegroundColor = "Cyan"}
$Red = @{ForegroundColor = "Red"}

Clear-Host
Write-Host "=========================================" @Green
Write-Host "   RESTAURAÇÃO DO FOOTER ORIGINAL        " @Green
Write-Host "=========================================" @Green
Write-Host ""

# Verificar se o arquivo HTML existe
$htmlFile = "cromosit/sap-cloud-revenue-growth.html"
if (-not (Test-Path $htmlFile)) {
    Write-Host "ERRO: Arquivo HTML não encontrado em $htmlFile" @Red
    Write-Host "Certifique-se de estar no diretório correto e que o arquivo existe." @Yellow
    Read-Host "Pressione ENTER para sair"
    exit 1
}

Write-Host "Lendo arquivo HTML..." @Yellow
$htmlContent = Get-Content -Path $htmlFile -Raw

# Procurar pelo footer atual
$footerPattern = '<footer>.*?</footer>'
if ($htmlContent -match $footerPattern) {
    Write-Host "Footer atual encontrado." @Cyan
    
    # Criar o footer original
    $originalFooter = @"
        <footer>
            <div class="footer-content">
                <div class="source">Source: <a href="https://www.sap.com/about/company.html?pdf-asset=4666ecdd-b67c-0010-82c7-eda71af511fa&page=1" target="_blank">SAP Company Information</a></div>
            </div>
        </footer>
"@
    
    # Substituir o footer
    $htmlContent = $htmlContent -replace $footerPattern, $originalFooter
    
    # Salvar as alterações
    $htmlContent | Out-File -FilePath $htmlFile -Encoding utf8
    
    Write-Host "Footer original restaurado com sucesso!" @Green
    Write-Host "`nConteúdo do footer restaurado:" @Yellow
    Write-Host $originalFooter @Cyan
    
    # Verificar se há referências ao texto "2025 SAP SE or an SAP affiliate company" e removê-las
    if ($htmlContent -match "2025 SAP SE or an SAP affiliate company") {
        Write-Host "`nEncontradas outras referências ao texto de copyright da SAP. Removendo..." @Yellow
        $htmlContent = $htmlContent -replace "© 2025 SAP SE or an SAP affiliate company. All rights reserved.", ""
        $htmlContent = $htmlContent -replace "This project was created by Cromosit for demonstration purposes.", ""
        
        # Salvar novamente após as remoções adicionais
        $htmlContent | Out-File -FilePath $htmlFile -Encoding utf8
        Write-Host "Textos de copyright indesejados foram removidos." @Cyan
    }
} else {
    Write-Host "AVISO: Não foi possível encontrar o footer atual no arquivo HTML." @Red
    Write-Host "Verifique manualmente o arquivo e faça as alterações necessárias." @Yellow
}

Write-Host "`nO arquivo $htmlFile foi atualizado." @Green
Write-Host "Verifique se o footer está correto abrindo o arquivo HTML em um navegador." @Yellow

# Pausa final
Read-Host "`nPressione ENTER para sair" 