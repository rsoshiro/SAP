# Script para corrigir o problema do gráfico no site da Cromosit
# Este script gera um snippet HTML otimizado para o WordPress

# Configurações de cores
$Green = @{ForegroundColor = "Green"}
$Yellow = @{ForegroundColor = "Yellow"}
$Cyan = @{ForegroundColor = "Cyan"}

Clear-Host
Write-Host "=========================================" @Green
Write-Host "   GERADOR DE CÓDIGO PARA GRÁFICO SAP    " @Green
Write-Host "=========================================" @Green
Write-Host ""

# Criar arquivo de saída
$outputFile = "chart-snippet-for-wordpress.html"
Write-Host "Gerando snippet HTML otimizado para WordPress..." @Yellow

# Conteúdo do snippet HTML com o código do gráfico
$htmlContent = @"
<!-- SNIPPET PARA CORRIGIR O GRÁFICO NO SITE CROMOSIT -->
<!-- Copie e cole este código no editor HTML do WordPress -->

<!-- Container do gráfico com altura fixa -->
<div style="position: relative; height: 400px; margin-bottom: 30px;">
    <canvas id="revenueChart"></canvas>
</div>

<!-- Adiciona o Chart.js caso ainda não tenha sido carregado -->
<script>
// Verificar se Chart.js já foi carregado
if (typeof Chart === 'undefined') {
    // Carregar Chart.js dinamicamente
    var script = document.createElement('script');
    script.src = 'https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js';
    script.integrity = 'sha256-+43c3zv8YWXC2lZAm3khFfRVoDQBWriJKz4Fb9QRY7s=';
    script.crossOrigin = 'anonymous';
    script.onload = renderChart;
    document.head.appendChild(script);
} else {
    // Chart.js já está disponível, renderizar o gráfico
    renderChart();
}

// Função para renderizar o gráfico
function renderChart() {
    // Certifique-se de que o DOM está carregado
    document.addEventListener('DOMContentLoaded', function() {
        var chartRendered = false;
        
        // Função que realmente renderiza o gráfico
        function createChart() {
            if (chartRendered) return; // Prevenir renderização duplicada
            
            var canvas = document.getElementById('revenueChart');
            if (!canvas) {
                console.error('Elemento de canvas não encontrado!');
                return;
            }
            
            // Dados do gráfico
            var revenueLabels = [
                'Q4 2021', 'Q1 2022', 'Q2 2022', 'Q3 2022', 
                'Q4 2022', 'Q1 2023', 'Q2 2023', 'Q3 2023', 
                'Q4 2023', 'Q1 2024'
            ];
            
            var revenueData = [
                2.61, 2.65, 2.75, 2.80, 
                3.39, 3.67, 3.75, 3.93, 
                4.50, 4.74
            ];
            
            // Dados de crescimento ano a ano
            var growthData = [null, null, null, null, 29.9, 38.5, 36.4, 40.4, 32.7, 29.2];
            
            // Criar o gráfico
            try {
                new Chart(canvas, {
                    type: 'bar',
                    data: {
                        labels: revenueLabels,
                        datasets: [
                            {
                                label: 'Quarterly Cloud Revenue (€ billions)',
                                data: revenueData,
                                backgroundColor: 'rgba(0, 118, 203, 0.7)',
                                borderColor: 'rgba(0, 118, 203, 1)',
                                borderWidth: 1,
                                order: 1,
                                yAxisID: 'y'
                            },
                            {
                                label: 'YoY Growth (%)',
                                data: growthData,
                                type: 'line',
                                borderColor: 'rgba(41, 126, 88, 1)',
                                backgroundColor: 'rgba(41, 126, 88, 0.2)',
                                pointBackgroundColor: 'rgba(41, 126, 88, 1)',
                                pointBorderColor: '#fff',
                                pointBorderWidth: 2,
                                pointRadius: 5,
                                tension: 0.3,
                                order: 0,
                                yAxisID: 'y1'
                            }
                        ]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        interaction: {
                            mode: 'index',
                            intersect: false,
                        },
                        scales: {
                            y: {
                                beginAtZero: true,
                                title: {
                                    display: true,
                                    text: 'Revenue (€ billions)',
                                    font: {
                                        weight: 'bold'
                                    }
                                },
                                ticks: {
                                    callback: function(value) {
                                        return '€' + value + 'B';
                                    }
                                }
                            },
                            y1: {
                                beginAtZero: true,
                                position: 'right',
                                title: {
                                    display: true,
                                    text: 'YoY Growth (%)',
                                    font: {
                                        weight: 'bold'
                                    }
                                },
                                grid: {
                                    display: false,
                                },
                                ticks: {
                                    callback: function(value) {
                                        return value + '%';
                                    }
                                }
                            },
                            x: {
                                title: {
                                    display: true,
                                    text: 'Quarter',
                                    font: {
                                        weight: 'bold'
                                    }
                                }
                            }
                        }
                    }
                });
                chartRendered = true;
                console.log('Gráfico SAP renderizado com sucesso!');
            } catch (err) {
                console.error('Erro ao renderizar o gráfico SAP:', err);
            }
        }
        
        // Tentar renderizar o gráfico imediatamente
        createChart();
        
        // Se falhar, tentar novamente após um pequeno atraso
        setTimeout(createChart, 1000);
    });
    
    // Também tentar renderizar quando a janela estiver totalmente carregada
    window.addEventListener('load', function() {
        var canvas = document.getElementById('revenueChart');
        if (canvas && typeof Chart !== 'undefined' && !chartRendered) {
            renderChart();
        }
    });
}
</script>
<!-- FIM DO SNIPPET -->
"@

# Salvar o conteúdo no arquivo
$htmlContent | Out-File -FilePath $outputFile -Encoding utf8

# Exibir instruções
Write-Host "Arquivo criado: $outputFile" @Cyan
Write-Host "`nInstruções para corrigir o gráfico no site Cromosit:" @Green
Write-Host "1. Acesse o painel administrativo do WordPress" @Yellow
Write-Host "2. Edite a página 'SAP Cloud Revenue Growth'" @Yellow
Write-Host "3. Na seção 'Financial Growth', encontre o código do gráfico existente" @Yellow
Write-Host "4. Substitua esse código pelo conteúdo do arquivo $outputFile" @Yellow
Write-Host "5. Certifique-se de usar o editor HTML do WordPress (não o visual)" @Yellow
Write-Host "6. Salve as alterações e visualize a página" @Yellow

Write-Host "`nO snippet inclui:" @Green
Write-Host "- Container com altura fixa para o gráfico" @Cyan
Write-Host "- Carregamento dinâmico do Chart.js" @Cyan
Write-Host "- Verificações de segurança para evitar erros" @Cyan
Write-Host "- Código de inicialização robusto" @Cyan

# Pausa final
Read-Host "`nPressione ENTER para sair" 