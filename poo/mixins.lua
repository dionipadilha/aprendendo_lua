-- mixins.lua

-- Mixins: composição de comportamento com __index como FUNÇÃO (PiL 16.3).
--
-- heranca.lua usa __index-TABELA: uma cadeia ÚNICA de busca (filha →
-- pai). Quando um objeto precisa combinar capacidades de VÁRIAS origens
-- independentes, __index pode ser uma função que procura o campo numa
-- LISTA de mixins — "herança múltipla" por busca.
--
-- Quando preferir cada um:
--  * __index-tabela (heranca.lua): relação "é um" com um só pai; a
--    busca na cadeia é feita pela própria VM — simples e rápida.
--  * __index-função (este arquivo): capacidades ortogonais ("tem nome",
--    "tem auditoria") combinadas à la carte. O custo: uma chamada de
--    função Lua a cada acesso que NÃO está na instância, e uma regra de
--    precedência que passa a ser SUA responsabilidade (aqui: o primeiro
--    mixin da lista vence).

-- Mixin #1: Nomeavel — sabe se apresentar.
local Nomeavel = {}

function Nomeavel:apresentar()
  return "eu sou " .. self.nome
end

function Nomeavel:descrever()
  return "nomeavel: " .. self.nome
end

-- Mixin #2: Auditavel — registra eventos.
local Auditavel = {}

function Auditavel:registrar(evento)
  -- O histórico nasce na primeira gravação e mora NA INSTÂNCIA (self):
  -- mixins fornecem COMPORTAMENTO; o estado é de cada objeto.
  self.historico = self.historico or {}
  table.insert(self.historico, evento)
end

function Auditavel:descrever()
  return "auditavel"
end

-- Fábrica de classes compostas: __index como função de busca na lista.
local function criarClasse(...)
  local mixins = { ... }
  local Classe = {}
  Classe.__index = function(_, chave)
    for _, mixin in ipairs(mixins) do -- na ORDEM da lista
      local valor = mixin[chave]
      if valor ~= nil then return valor end
    end
    return nil -- nenhum mixin tem a chave: o acesso resulta nil, como sempre
  end
  function Classe.nova(campos)
    return setmetatable(campos or {}, Classe)
  end
  return Classe
end

--------------------------------------------------------------------------------
-- #1. A classe composta responde pelos DOIS mixins:

local Colaborador = criarClasse(Nomeavel, Auditavel)

local ana = Colaborador.nova { nome = "ana" }
print(ana:apresentar()) --> eu sou ana
assert(ana:apresentar() == "eu sou ana")

ana:registrar("admitida")
ana:registrar("promovida")
assert(#ana.historico == 2 and ana.historico[2] == "promovida")

-- Os métodos vêm dos mixins via __index; NÃO existem na instância:
assert(rawget(ana, "apresentar") == nil and rawget(ana, "registrar") == nil)
-- ...mas o estado criado por eles existe nela:
assert(rawget(ana, "historico") ~= nil)

--------------------------------------------------------------------------------
-- #2. Precedência: descrever() existe nos DOIS mixins. Vence o PRIMEIRO
-- da lista — em Colaborador, o Nomeavel:

print(ana:descrever()) --> nomeavel: ana
assert(ana:descrever() == "nomeavel: ana")

-- Invertida a lista, inverte a precedência (mesmos mixins!):
local Servico = criarClasse(Auditavel, Nomeavel)
local backup = Servico.nova { nome = "backup" }
assert(backup:descrever() == "auditavel")
-- o que só um mixin oferece continua acessível, em qualquer ordem:
assert(backup:apresentar() == "eu sou backup")

--------------------------------------------------------------------------------
-- #3. Estado por instância: duas instâncias, históricos independentes.

local bob = Colaborador.nova { nome = "bob" }
bob:registrar("contratado")
assert(#bob.historico == 1)
assert(#ana.historico == 2)            -- o histórico da ana não mudou
assert(ana.historico ~= bob.historico) -- tabelas distintas, não compartilhadas

print("mixins com __index-função verificados!")
