-- fabrica.lua

-- Padrão Fábrica (Factory Method): uma função criadora decide QUAL tipo
-- concreto instanciar a partir de um parâmetro. O código cliente pede
-- "um inimigo" pelo nome e recebe o tipo certo — sem conhecer as classes
-- concretas e sem espalhar if/else de criação pelo programa.
--
-- Para criar FAMÍLIAS de produtos compatíveis (vários componentes por
-- fábrica), veja fabrica_abstrata.lua.

--------------------------------------------------------------------------------
-- Classe base e tipos concretos:

local Inimigo = {}

function Inimigo:novo(instancia)
  instancia = instancia or {}
  setmetatable(instancia, self)
  self.__index = self
  return instancia
end

function Inimigo:atacar()
  error("Este método deve ser sobrescrito pelo tipo concreto")
end

local Zumbi = Inimigo:novo { vida = 30 }
function Zumbi:atacar()
  return ("Zumbi morde (vida %d)"):format(self.vida)
end

local Esqueleto = Inimigo:novo { vida = 20 }
function Esqueleto:atacar()
  return ("Esqueleto atira flechas (vida %d)"):format(self.vida)
end

--------------------------------------------------------------------------------
-- O método fabril: a decisão de qual classe instanciar fica em UM lugar.

local tiposDeInimigo = {
  zumbi = Zumbi,
  esqueleto = Esqueleto
}

local function criarInimigo(tipo, atributos)
  local classe = tiposDeInimigo[tipo]
  assert(classe, "tipo de inimigo desconhecido: " .. tostring(tipo))
  return classe:novo(atributos)
end

--------------------------------------------------------------------------------
-- Uso: o cliente cria por NOME e trata todos os produtos pela mesma
-- interface (atacar), sem tocar nas classes concretas.

local horda = {
  criarInimigo("zumbi"),
  criarInimigo("esqueleto"),
  criarInimigo("zumbi", { vida = 50 }) -- atributos opcionais por instância
}

assert(horda[1]:atacar() == "Zumbi morde (vida 30)")
assert(horda[2]:atacar() == "Esqueleto atira flechas (vida 20)")
assert(horda[3]:atacar() == "Zumbi morde (vida 50)")

for _, inimigo in ipairs(horda) do
  print(inimigo:atacar())
end

-- tipos desconhecidos falham com mensagem clara:
local ok, erro = pcall(criarInimigo, "dragao")
assert(not ok and tostring(erro):find("tipo de inimigo desconhecido"))

--------------------------------------------------------------------------------
-- Extensão sem alterar o cliente: registrar um tipo novo basta.

local Fantasma = Inimigo:novo { vida = 10 }
function Fantasma:atacar()
  return ("Fantasma assombra (vida %d)"):format(self.vida)
end

tiposDeInimigo.fantasma = Fantasma
assert(criarInimigo("fantasma"):atacar() == "Fantasma assombra (vida 10)")

print("Factory Method: todos os inimigos criados pelo nome.")
