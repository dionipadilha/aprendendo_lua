# require

Um módulo em Lua é um arquivo que retorna uma tabela; `require` carrega o
módulo uma única vez e reaproveita o resultado nas chamadas seguintes.
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
