# DDTank41 — Render Web Foundation (fase 1)

**Importante:** este componente é um portal web **separado** do servidor DDTank original. Registro e login aqui **não** criam contas no DDTank legado. O painel lista apenas contas do portal; ainda não envia itens, moedas ou comandos ao jogo.

## Recursos implementados
- Site responsivo, cadastro e login com scrypt
- Sessões persistidas no PostgreSQL (token salvo somente como hash)
- Painel administrativo com listagem de contas do portal
- Dashboard com status da integração original explicitamente **offline**
- Health check /health, limites de requisições, cabeçalhos de segurança
- Blueprint `render.yaml` para Render Node + PostgreSQL

## Deploy pelo Render
1. Revise o PR e faça merge quando estiver satisfeito.
2. Render Dashboard > New > Blueprint > conecte `9rafaelbassis-pixel/DDTank41`.
3. Configure `ADMIN_EMAIL` e `ADMIN_PASSWORD` com senha longa e exclusiva (NÃO coloque no GitHub).
4. Aplique o Blueprint. A API ficará em `https://<nome-do-servico>.onrender.com`.
5. Para verificação, abra `/health`; ele retorna JSON com estado do banco.

O primeiro boot cria as tabelas do **portal** e a conta administradora somente se não existir. O valor de ADMIN_PASSWORD é lido nessa inicialização; mudar a variável depois **não redefine** a senha existente.

## Desenvolvimento
```sh
cd render-web
npm install
cp .env.example .env
# Configure DATABASE_URL e a senha somente no .env local
npm start
```

## Limitações do jogo original (fase 2, ainda pendente)
- `Game.Server` depende de .NET Framework 4.7.2, e `GameAdmin` de ASP.NET 4.6/IIS.
- Banco original contém backups `.bak` de SQL Server; **não são** compatíveis diretamente com PostgreSQL.
- O protocolo multiplayer possui portas TCP próprias. Render Web Services expõem HTTP/HTTPS, não essas portas TCP públicas.
- O cliente Flash precisa de análise específica com Ruffle ou de reimplementação autorizada.
- Para rodar **tudo** no Render será necessária portabilidade profunda do jogo, persistência e protocolo de comunicação (ex.: WebSocket), não apenas um Dockerfile.
- Nenhuma dessas funcionalidades legadas está implementada neste PR.

## Segurança
O repositório original contém segredos hardcoded em configurações legadas. Não reutilize essas credenciais, troque-as no banco original e retire segredos do histórico se forem ativos. Não exponha SQL Server à internet. Antes de conectar o painel ao jogo, definir API autenticada, controle de acesso e trilha de auditoria.
