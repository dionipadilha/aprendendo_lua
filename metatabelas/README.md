# Metatabelas

Metatabelas permitem personalizar o comportamento das tabelas em Lua. Toda tabela pode receber, via `setmetatable`, uma segunda tabela — a metatabela — cujos campos especiais (**metamétodos**, sempre com o prefixo `__`) dizem ao interpretador o que fazer em situações que a tabela sozinha não saberia resolver: somar duas tabelas, converter para texto, tratar acesso a chaves inexistentes, ser chamada como função etc. É o mecanismo que sustenta operadores personalizados, herança e POO em Lua.

```lua
local t = setmetatable({}, { __tostring = function() return "olá!" end })
print(t) --> olá!
```

## Metamétodos cobertos nesta pasta

| Metamétodo | O que personaliza | Arquivo |
|---|---|---|
| `__add` | Operador `+` (soma pura, sem mutar os operandos) | `metatabela.lua` |
| `__tostring` | Conversão para texto (`print`/`tostring`) | `tostring.lua`, `metatabela.lua` |
| `__index` | Leitura de chave inexistente (herança/somente leitura) | `somente_leitura.lua` |
| `__newindex` | Escrita de chave inexistente (bloqueio/interceptação) | `somente_leitura.lua`, `tabela_proxy.lua` |
| `__call` | Chamar a tabela como se fosse uma função | `chamada.lua` |
| `__close` | Variáveis to-be-closed (`local x <close>`, Lua 5.4) | `finalizadores.lua` |
| `__gc` | Finalizadores executados pelo coletor de lixo | `finalizadores.lua` |

Outros metamétodos relacionados aparecem em outras pastas: `__mode` (tabelas fracas) em `../gc/` e o uso de `__index` para classes em `../poo/`.

## Referências

- [Manual de Lua 5.4 — Metatables and Metamethods](https://www.lua.org/manual/5.4/manual.html#2.4)
- [Gist com uma visão geral de metamétodos](https://gist.github.com/oatmealine/655c9e64599d0f0dd47687c1186de99f)
