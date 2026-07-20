-- decorador.lua

-- Padrão Decorator: acrescentar comportamento a algo existente sem
-- modificá-lo. Em Lua há duas formas comuns:
--   #1. decorador de FUNÇÃO (idiomático em linguagens com funções de
--       primeira classe): envolve uma função em outra;
--   #2. decorador de OBJETO (a forma clássica do GoF): objetos
--       empilháveis que preservam a interface do componente original.

--------------------------------------------------------------------------------
-- #1. Decorador de função: o invólucro repassa os argumentos (`...`)
-- e devolve o resultado da função original — sem isso, funções com
-- parâmetros ou com retorno não sobreviveriam à decoração.

local acontecimentos = {}

local function comRegistro(funcao)
  return function(...)
    table.insert(acontecimentos, "antes")
    local resultado = funcao(...)
    table.insert(acontecimentos, "depois")
    return resultado
  end
end

local function somar(a, b)
  table.insert(acontecimentos, "soma")
  return a + b
end

-- aplica o decorador:
somar = comRegistro(somar)

-- argumentos e retorno atravessam o decorador intactos:
assert(somar(2, 3) == 5)
assert(table.concat(acontecimentos, " -> ") == "antes -> soma -> depois")

--------------------------------------------------------------------------------
-- #2. Decorador de objeto (GoF): cada decorador envolve um componente
-- e expõe a MESMA interface (custo/descricao), então decoradores podem
-- ser empilhados em qualquer ordem — e o cliente não distingue um café
-- puro de um café decorado.

local Cafe = {}
Cafe.__index = Cafe

function Cafe.novo()
  return setmetatable({}, Cafe)
end

function Cafe:custo() return 5.0 end
function Cafe:descricao() return "café" end

local function comLeite(componente)
  local decorado = {}
  function decorado:custo() return componente:custo() + 2.0 end
  function decorado:descricao() return componente:descricao() .. " com leite" end
  return decorado
end

local function comChocolate(componente)
  local decorado = {}
  function decorado:custo() return componente:custo() + 3.0 end
  function decorado:descricao() return componente:descricao() .. " com chocolate" end
  return decorado
end

-- empilhando decoradores — cada um envolve o resultado do anterior:
local pedido = comChocolate(comLeite(Cafe.novo()))
assert(pedido:custo() == 10.0)
assert(pedido:descricao() == "café com leite com chocolate")

-- o componente original continua intacto:
local simples = Cafe.novo()
assert(simples:custo() == 5.0 and simples:descricao() == "café")

print(("Decorator: %s custa %.2f"):format(pedido:descricao(), pedido:custo()))
