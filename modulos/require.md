# require

Um módulo em Lua é um arquivo que devolve um valor — tipicamente uma
tabela com as funções públicas, mas qualquer valor serve: o pluralizador
deste repositório (`projetos/pluralizador/principal.lua`), por exemplo,
devolve uma função. `require` carrega o módulo uma única vez e reaproveita
o resultado nas chamadas seguintes.
O exemplo abaixo usa dois arquivos separados.

`modulo.lua`:

```lua
local modulo = {}

modulo.fazAlgo = function ()
  print("torrada!")
end

return modulo
```

`principal.lua`:

```lua
local modulo = require "modulo"
modulo.fazAlgo() --> torrada!
```
