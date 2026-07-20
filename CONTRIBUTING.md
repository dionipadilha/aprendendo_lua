# Como contribuir

Este é um repositório de material didático de Lua **5.4**, todo em
**pt-BR**, em que cada exemplo é executável e se verifica sozinho com
asserts. Contribuições são bem-vindas — o essencial cabe nesta página.

## Escopo

- Material didático para **Lua 5.4** (PUC-Lua puro). Dependências
  externas (sqlite3, luasocket...) entram apenas como demonstrações
  opcionais, com guarda que avisa e sai com sucesso quando a ferramenta
  falta (veja `banco_de_dados/sqlite3.lua` e `modulos/rede_http.lua`).
- Exemplos mínimos e determinísticos: cada arquivo é independente e roda
  a partir do próprio diretório, sem depender de rede ou de tempo real.

## Convenções

- **Idioma:** tudo em pt-BR — comentários, mensagens e nomes de arquivo.
  Identificadores não levam acento (Lua só aceita ASCII em nomes):
  `heranca`, `calcularMedia`.
- **Nomenclatura:** camelCase para variáveis e funções, PascalCase para
  classes, `MAIUSCULAS_COM_SUBLINHADO` para constantes e
  `minusculas_com_sublinhado.lua` para arquivos — regra completa em
  [`documentacao/convencoes_de_nomenclatura.md`](documentacao/convencoes_de_nomenclatura.md).
- **Cabeçalho:** a primeira linha de cada `.lua` é `-- nome_do_arquivo.lua`.
- **Autoverificação:** todo exemplo prova o que afirma com asserts
  fortes, e os comentários de saída (`--> ...`) devem ser fiéis à
  execução real.
- **Sem globais:** tudo `local`. O `.luacheckrc` do repositório
  (`std = "lua54"`) é a régua — não o afrouxe para acomodar código novo.

## Validando localmente

Antes de abrir o PR, rode na raiz os dois portões que a CI executa:

```sh
./executar_testes.sh   # roda todos os .lua; deve terminar com "Falhas: 0"
luacheck . -q          # deve reportar 0 avisos / 0 erros
```

Se o seu binário se chama `lua` (Homebrew, Fedora, Arch), use
`LUA=lua ./executar_testes.sh`.

## Fluxo

1. Crie um branch a partir de `main`.
2. Faça commits com mensagens descritivas em pt-BR.
3. Abra um Pull Request contra `main` — a CI (Linux e Windows) roda os
   mesmos dois comandos acima e precisa passar.

Prefira PRs pequenos e focados (um tema por PR). O material é
distribuído sob a [licença MIT](LICENSE) — ao contribuir, você concorda
em licenciar sua contribuição nos mesmos termos.
