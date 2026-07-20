# Pluralizador de substantivos do inglês

Recebe um substantivo do **inglês** e devolve o plural (ex.: `man --> men`,
`baby --> babies`). Os dados são palavras em inglês de propósito; código,
comentários e mensagens seguem a convenção pt-BR do repositório.

A decisão percorre uma cadeia simples, na ordem:

1. `irregulares.lua` — dicionário de plurais irregulares (`man --> men`,
   `child --> children`);
2. `excecoes.lua` — palavras que fogem das regras gerais de sufixo;
3. `regulares.lua` — regras por sufixo (`s/x/z/ch/sh --> es`,
   consoante + `y --> ies`, etc.), aplicadas por último.

| Arquivo | Papel |
|---------|-------|
| `principal.lua` | A função `plural`, que encadeia as três etapas |
| `irregulares.lua`, `excecoes.lua`, `regulares.lua` | As etapas da cadeia |
| `validacao.lua` | Tabela de casos de teste (entrada → saída esperada) |
| `teste.lua` | Executa todos os casos de `validacao.lua` com asserts |

Execute os testes a partir deste diretório:

```sh
lua5.4 teste.lua
```
