# LuaJIT e as versões de Lua — guia de bolso

Este repositório tem como alvo o **PUC-Lua 5.4**. Fora daqui você vai
esbarrar em muito código 5.1 e em **LuaJIT**, que implementa a linguagem
5.1 com extensões. Este guia mapeia o que muda **de verdade** ao
transitar entre versões — não é uma enciclopédia, é o mínimo para não se
machucar.

## PUC-Lua: o que mudou de 5.1 a 5.4 (o que morde)

- **5.2 (2011)** — `setfenv`/`getfenv` saem: ambientes viram a variável
  `_ENV`. O `unpack` global vira `table.unpack`. Chegam `goto` e os
  rótulos `::nome::`. `xpcall` passa a aceitar argumentos extras.
- **5.3 (2015)** — inteiros de verdade: subtipos integer/float
  (`math.type`), divisão inteira `//` e overflow com *wraparound*.
  Operadores bit a bit nativos (`&`, `|`, `~`, `<<`, `>>`) substituem a
  biblioteca `bit32` que existiu só na 5.2. Chegam `string.pack`/
  `string.unpack` e a biblioteca `utf8`.
- **5.4 (2020)** — atributos `<const>` e `<close>` (variáveis
  *to-be-closed*), GC geracional e `math.random` já semeado
  automaticamente na partida.

## Tabela-resumo: recurso × versão

| Recurso | 5.1 | 5.2 | 5.3 | 5.4 | LuaJIT |
|---|---|---|---|---|---|
| `unpack` | global | `table.unpack` | `table.unpack` | `table.unpack` | global¹ |
| Ambientes | `setfenv`/`getfenv` | `_ENV` | `_ENV` | `_ENV` | `setfenv`/`getfenv` |
| Inteiros nativos | — (só float) | — | sim | sim | — (float; int64 via FFI) |
| Bit a bit | — | `bit32` | operadores nativos | operadores nativos | biblioteca `bit` |
| `goto` / rótulos | — | sim | sim | sim | sim (extensão) |
| `//` divisão inteira | — | — | sim | sim | — |
| `string.pack`/`unpack` | — | — | sim | sim | — |
| Biblioteca `utf8` | — | — | sim | sim | — |
| `<const>` / `<close>` | — | — | — | sim | — |
| GC geracional | — | experimental | — | sim | GC próprio |

¹ LuaJIT compilado com `LUAJIT_ENABLE_LUA52COMPAT` ganha parte da 5.2
(`table.unpack`, `goto` já é padrão, entre outros).

## LuaJIT em poucas palavras

- Implementa **Lua 5.1** com um compilador JIT muito rápido, a **FFI**
  (chamar C sem escrever módulo C) e a biblioteca `bit`.
- Onde vive: **Neovim** (configuração e plugins), **OpenResty**/nginx e
  motores de jogo (LÖVE, por exemplo). O Roblox usa **Luau**, um dialeto
  próprio derivado de 5.1 — nem PUC nem LuaJIT.
- O que importa saber: está em todo lugar, mas **a linguagem parou na
  5.1** — os recursos de 5.3/5.4 usados neste repositório não existem lá.

## Adaptações típicas ao portar código deste repositório

1. `table.unpack` → `unpack`. Idioma portátil:
   `local unpack = table.unpack or unpack`.
2. Inteiros: não há `math.type` nem subtipo integer — todo número é
   float (double). `7 // 2` nem compila: use `math.floor(7 / 2)`.
3. Operadores bit a bit (`&`, `|`, `<<`...) não compilam: use
   `bit.band`, `bit.bor`, `bit.lshift` (LuaJIT) ou `bit32` (PUC 5.2).
4. `<const>` e `<close>` não compilam: remova o atributo e feche
   recursos explicitamente em TODOS os caminhos (o padrão pré-5.4 de
   `pcall` + `close`).
5. `string.pack`/`string.unpack`/`packsize` não existem: no LuaJIT a
   FFI cobre o caso; em PUC 5.1/5.2, bibliotecas externas (lua-struct).
6. A biblioteca `utf8` não existe: só bibliotecas externas — e valem em
   dobro os avisos de bytes × caracteres de `basico/cadeias_de_texto.lua`.
7. `goto` funciona no LuaJIT (extensão), mas **não** no PUC-Lua 5.1.
8. Sandbox/ambientes: sem `_ENV` na 5.1, o idioma é `setfenv`.

Dica final: para código que precisa rodar nos dois mundos, mire o
subconjunto 5.1 mais o idioma `table.unpack or unpack` — é o que fazem
as bibliotecas portáveis do ecossistema.
