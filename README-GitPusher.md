# GitPusher - Ferramenta de envio para GitHub

Esta ferramenta foi criada para facilitar o envio dos arquivos do projeto SAP para a pasta correta no GitHub.

## O que esta ferramenta faz

O GitPusher automatiza o processo de envio dos arquivos para o GitHub, garantindo que eles sejam colocados na pasta correta `/cromosit/` no repositório.

A ferramenta:
1. Verifica se os arquivos necessários estão na pasta local `cromosit`
2. Remove arquivos duplicados da raiz do repositório
3. Adiciona e envia os arquivos da pasta `cromosit` para o GitHub
4. Garante que a estrutura final seja `/cromosit/` contendo os arquivos do projeto

## Requisitos

- Windows com PowerShell 5.1 ou superior
- Git instalado e configurado
- Conta no GitHub com acesso ao repositório `rsoshiro/SAP`

## Como usar

### Opção 1: Usando o executável

1. **Organize seus arquivos:**
   - Coloque todos os arquivos do projeto na pasta `cromosit` local
   - Certifique-se de que `sap-cloud-revenue-growth.html`, `sap-cloud-revenue-growth.css` e `sap-cloud-revenue-growth.js` estão na pasta

2. **Execute o GitPusher.exe:**
   - Clique duas vezes no arquivo `GitPusher.exe`
   - Siga as instruções apresentadas na tela

3. **Verifique o resultado:**
   - Acesse [https://github.com/rsoshiro/SAP/tree/master/cromosit](https://github.com/rsoshiro/SAP/tree/master/cromosit)
   - Confirme que todos os arquivos foram enviados corretamente

### Opção 2: Usando os scripts PowerShell

Se preferir não usar o executável, você pode executar os scripts PowerShell diretamente:

1. **Execute o script GitPusher.ps1:**
   ```powershell
   .\GitPusher.ps1
   ```

2. **Ou crie o executável e depois execute-o:**
   ```powershell
   .\ConvertToExecutable.ps1
   .\GitPusher.exe
   ```

## Solução de problemas

### Erro de autenticação do Git

Se você encontrar erros de autenticação:

1. Configure suas credenciais do GitHub usando:
   ```
   git config --global user.name "Seu Nome"
   git config --global user.email "seu-email@example.com"
   ```

2. Ou use um token de acesso pessoal:
   - Crie um token em [GitHub Settings > Developer settings > Personal access tokens](https://github.com/settings/tokens)
   - Use o token como senha quando solicitado

### Arquivos ausentes

Se a ferramenta relatar arquivos ausentes na pasta `cromosit`:

1. Verifique se todos os arquivos necessários estão presentes:
   - `sap-cloud-revenue-growth.html`
   - `sap-cloud-revenue-growth.css`
   - `sap-cloud-revenue-growth.js`

2. Certifique-se de que o script está sendo executado na pasta raiz do projeto (a pasta que contém a pasta `cromosit`)

## Estrutura final esperada

Após a execução bem-sucedida, o repositório GitHub deve ter a seguinte estrutura:

```
/
├── cromosit/
│   ├── sap-cloud-revenue-growth.html
│   ├── sap-cloud-revenue-growth.css
│   ├── sap-cloud-revenue-growth.js
│   └── (outros arquivos da pasta cromosit)
├── README.md
└── (outros arquivos de configuração)
```

## Criado com

- PowerShell
- PS2EXE (para criação do executável)
- Git

---

Para qualquer problema ou sugestão, entre em contato com o autor.

*Última atualização: 30/03/2025* 