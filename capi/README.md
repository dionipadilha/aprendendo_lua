# A API C de Lua

Lua nasceu para ser **embutida**: o interpretador é uma biblioteca C
(`liblua`) com uma API pequena, e é essa API que motores de jogos,
editores e servidores usam para rodar scripts. Ela funciona nos dois
sentidos:

| Arquivo | Sentido | O que demonstra |
|---|---|---|
| [`embutir.c`](embutir.c) | C chama Lua | criar um estado, executar código, ler uma global e chamar uma função Lua |
| [`modulo_c.c`](modulo_c.c) | Lua chama C | um módulo carregável via `require`, com validação de argumentos |
| [`testar_modulo.lua`](testar_modulo.lua) | — | testa o módulo compilado (com skip gracioso quando não há `.so`) |

## A ideia central: a pilha virtual

C e Lua não compartilham representação de valores — toda conversa passa
por uma **pilha** que pertence ao estado Lua:

```
        (topo)  -1  ← último valor empilhado
                -2
                 2
        (base)   1  ← primeiro valor
```

- O C **empilha** valores para entregá-los ao Lua
  (`lua_pushinteger`, `lua_pushstring`, ...).
- O C **lê** da pilha o que o Lua devolve
  (`lua_tointeger(L, -1)` lê o topo).
- Índices positivos contam da base; negativos contam do topo.
- Quem empilha desempilha: valores esquecidos na pilha são o vazamento
  clássico de quem começa na API.

Numa função C exposta para Lua, os argumentos chegam nas posições
`1, 2, ...` da pilha, e a função devolve **quantos resultados
empilhou** — é o que `somar` e `inverter` fazem em `modulo_c.c`.

## Compilar e executar

### Linux (o que a CI executa)

Requisitos: um compilador C e os headers do Lua 5.4
(`sudo apt install build-essential liblua5.4-dev`).

```sh
cd capi
make            # compila embutir e modulo_c.so
./embutir       # o host C executando Lua
lua5.4 testar_modulo.lua  # o Lua carregando o módulo C
make clean      # remove os artefatos
```

### Windows (MSVC)

No *Developer Command Prompt* (com o Lua compilado pelo MSVC e
`lua54.lib`/headers acessíveis):

```bat
cl /O2 /I<pasta-dos-headers> embutir.c /link <caminho>\lua54.lib
cl /O2 /I<pasta-dos-headers> /LD modulo_c.c /link <caminho>\lua54.lib /OUT:modulo_c.dll
```

No Windows o módulo vira `modulo_c.dll` (e o `require` o encontra pelo
`package.cpath` com `?.dll`). A CI compila e testa apenas no Linux; as
linhas acima ficam como referência.

## Detalhe de linkedição que vale aprender

- O **host** (`embutir`) linka com a `liblua` — ele carrega o
  interpretador dentro de si.
- O **módulo** (`modulo_c.so`) **não** linka com a `liblua` — quando o
  `require` o carrega, os símbolos do Lua já existem no processo do
  interpretador. Linkar duas cópias da liblua é fonte clássica de bugs.

## Onde estudar mais

- [Programming in Lua, parte IV](https://www.lua.org/pil/24.html) — a
  referência didática da API C.
- [Manual 5.4, §4](https://www.lua.org/manual/5.4/manual.html#4) — a
  referência completa de cada função.
- Para distribuir um módulo C como pacote, o LuaRocks compila C
  nativamente — veja [`../modulos/empacotamento.md`](../modulos/empacotamento.md).
