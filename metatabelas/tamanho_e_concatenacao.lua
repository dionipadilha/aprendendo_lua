-- tamanho_e_concatenacao.lua

-- __len personaliza o operador # e __concat o operador `..`.
-- __concat é consultado quando qualquer um dos operandos é uma tabela
-- (strings e números concatenam sozinhos).

local Caminho = {}
Caminho.__index = Caminho

function Caminho.novo(segmentos)
  return setmetatable({ segmentos = segmentos or {} }, Caminho)
end

-- __len: o "tamanho" de um caminho é o seu número de segmentos:
Caminho.__len = function(caminho)
  return #caminho.segmentos
end

Caminho.__tostring = function(caminho)
  return "/" .. table.concat(caminho.segmentos, "/")
end

-- __concat: caminho .. "segmento" devolve um caminho NOVO, sem mutar
-- os operandos:
Caminho.__concat = function(caminho, segmento)
  assert(getmetatable(caminho) == Caminho and type(segmento) == "string",
    'use: caminho .. "segmento"')
  local novos = { table.unpack(caminho.segmentos) }
  table.insert(novos, segmento)
  return Caminho.novo(novos)
end

--------------------------------------------------------------------------------

local raiz = Caminho.novo { "home" }
assert(#raiz == 1) -- __len em ação

local docs = raiz .. "documentos"
assert(#docs == 2)
assert(tostring(docs) == "/home/documentos")
assert(#raiz == 1) -- o caminho original não mudou

--------------------------------------------------------------------------------
-- Armadilha: `..` é associativo À DIREITA. Encadear dois segmentos de
-- uma vez concatena primeiro as DUAS STRINGS entre si:

local surpresa = raiz .. "musicas" .. "rock" -- = raiz .. ("musicas" .. "rock")
assert(#surpresa == 2)
assert(tostring(surpresa) == "/home/musicasrock")

-- para encadear de verdade, agrupe com parênteses:
local musicas = (raiz .. "musicas") .. "rock"
assert(#musicas == 3)
assert(tostring(musicas) == "/home/musicas/rock")

print("Operadores # e .. personalizados verificados!")
