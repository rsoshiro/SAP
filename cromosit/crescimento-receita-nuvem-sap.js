document.addEventListener('DOMContentLoaded', function() {
    // Chart.js para o Gráfico de Crescimento de Receita
    const revenueCtx = document.getElementById('revenueChart').getContext('2d');
    
    const revenueLabels = [
        'Q4 2021', 'Q1 2022', 'Q2 2022', 'Q3 2022', 
        'Q4 2022', 'Q1 2023', 'Q2 2023', 'Q3 2023', 
        'Q4 2023', 'Q1 2024'
    ];
    
    const revenueData = [
        2.61, 2.65, 2.75, 2.80, 
        3.39, 3.67, 3.75, 3.93, 
        4.50, 4.74
    ];
    
    // Calcula as taxas de crescimento ano a ano
    const growthData = [];
    for (let i = 4; i < revenueData.length; i++) {
        const growth = ((revenueData[i] - revenueData[i-4]) / revenueData[i-4]) * 100;
        growthData.push(growth.toFixed(1));
    }
    
    // Obtém as etiquetas do gráfico para crescimento (começando a partir de Q4 2022)
    const growthLabels = revenueLabels.slice(4);
    
    new Chart(revenueCtx, {
        type: 'bar',
        data: {
            labels: revenueLabels,
            datasets: [
                {
                    label: 'Receita Trimestral em Nuvem (€ bilhões)',
                    data: revenueData,
                    backgroundColor: 'rgba(0, 118, 203, 0.7)',
                    borderColor: 'rgba(0, 118, 203, 1)',
                    borderWidth: 1,
                    order: 1,
                    yAxisID: 'y'
                },
                {
                    label: 'Crescimento YoY (%)',
                    data: [null, null, null, null, 29.9, 38.5, 36.4, 40.4, 32.7, 29.2],
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
                        text: 'Receita (€ bilhões)',
                        font: {
                            weight: 'bold'
                        }
                    },
                    grid: {
                        display: true,
                        drawBorder: true,
                        drawOnChartArea: true,
                        drawTicks: true,
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
                        text: 'Crescimento YoY (%)',
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
                        text: 'Trimestre',
                        font: {
                            weight: 'bold'
                        }
                    }
                }
            },
            plugins: {
                legend: {
                    position: 'top',
                },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            let label = context.dataset.label || '';
                            if (label) {
                                label += ': ';
                            }
                            if (context.dataset.yAxisID === 'y') {
                                label += '€' + context.parsed.y + 'B';
                            } else {
                                if (context.parsed.y !== null) {
                                    label += context.parsed.y + '%';
                                }
                            }
                            return label;
                        }
                    }
                }
            }
        }
    });
}); 