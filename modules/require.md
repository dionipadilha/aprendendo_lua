# require

Um módulo em Lua é um arquivo que retorna uma tabela; `require` carrega o
módulo uma única vez e reaproveita o resultado nas chamadas seguintes.
O exemplo abaixo usa dois arquivos separados.

`module.lua`:

```lua
local module = {}

module.doSomething = function ()
  print("toast!")
end

return module
```

`main.lua`:

```lua
local module = require "module"
module.doSomething() --> toast!
```
