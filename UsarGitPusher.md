# Como Usar o Executável EnviarCromosit.exe

Este executável foi criado para ajudá-lo a enviar arquivos para a pasta `cromosit/` no repositório GitHub `rsoshiro/SAP`.

## Instruções Simples

1. **Coloque os arquivos na pasta `cromosit`**:
   - `sap-cloud-revenue-growth.html`
   - `sap-cloud-revenue-growth.css`
   - `sap-cloud-revenue-growth.js`

2. **Execute o executável**:
   - Clique duas vezes em `EnviarCromosit.exe`
   - Siga as instruções na tela

3. **Verifique o resultado**:
   - Acesse [https://github.com/rsoshiro/SAP/tree/master/cromosit](https://github.com/rsoshiro/SAP/tree/master/cromosit)
   - Confira se os arquivos foram enviados corretamente

## O que o executável faz

- Verifica se a pasta `cromosit` existe na pasta atual
- Resolve problemas de submodule git que estavam impedindo o envio correto
- Copia os arquivos para uma pasta temporária
- Envia os arquivos para o GitHub na estrutura correta
- Limpa os arquivos temporários

## Solução de Problemas

Se encontrar erros:

1. **Erro ao enviar para GitHub**:
   - Verifique suas credenciais do GitHub

2. **Pasta cromosit não encontrada**:
   - Execute o executável na mesma pasta onde está a pasta `cromosit`

3. **Arquivos ausentes**:
   - Certifique-se de que todos os arquivos necessários estão na pasta `cromosit`

## Observações

- O executável força o envio (force push) para o GitHub, o que sobrescreve o histórico remoto
- Os arquivos apenas na raiz do repositório serão removidos (sap-cloud-revenue-growth.*)
- Apenas os arquivos dentro da pasta `cromosit` serão enviados para o GitHub

Para regenerar o executável, execute:
```powershell
PowerShell -ExecutionPolicy Bypass -File .\GitPusherFinal.ps1
``` 