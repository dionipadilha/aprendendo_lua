### Funções Anônimas em LUA

- Chama diretamente uma função anônima com um argumento:
```lua
local y = (function(x) return x + 1 end)(3)
assert(y == 4)
```

- Atribui uma função anônima a uma variável:
```lua
local sucessor = function(x) return x + 1 end
assert(sucessor(3) == 4)
```

- Recebe múltiplos argumentos:
```lua
local somar = function(a, b) return a + b end
assert(somar(2, 3) == 5)
```

- Funções de primeira classe:
```lua
local function multiplicarPor(x)
  return function(y) return x * y end
end

local vezesDois = multiplicarPor(2)
assert(vezesDois(3) == 6)

local vezesCinco = multiplicarPor(5)
assert(vezesCinco(3) == 15)
```

- Funções de ordem superior:
```lua
local function aplicar(f, x)
  return f(x)
end

assert(aplicar(function(x) return x + 1 end, 3) == 4)
assert(aplicar(function(x) return x * 2 end, 3) == 6)
```

- Clausuras (closures):
```lua
local function novoContador()
  local i = 0
  return function() i = i + 1 return i end
end

local contar = novoContador()
assert(contar() == 1)
assert(contar() == 2)
assert(contar() == 3)
-- ...
```
