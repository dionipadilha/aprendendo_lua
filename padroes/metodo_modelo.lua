-- metodo_modelo.lua

-- Padrão Método Modelo (Template Method): a classe base define o
-- ESQUELETO de um algoritmo — a ordem fixa dos passos — e as subclasses
-- preenchem os passos variáveis. Em Lua, a busca de métodos via
-- metatabela faz o trabalho: cada passo é procurado primeiro na
-- subclasse e só depois na base.

local Relatorio = {}

function Relatorio:novo(instancia)
  instancia = instancia or {}
  setmetatable(instancia, self)
  self.__index = self
  return instancia
end

-- O MÉTODO MODELO: a ordem dos passos é fixa e mora só na base.
-- Subclasses nunca reescrevem gerar — apenas os passos.
function Relatorio:gerar(dados)
  return table.concat({
    self:cabecalho(),
    self:formatarCorpo(dados),
    self:rodape()
  }, "\n")
end

-- passos com implementação padrão (ganchos opcionais):
function Relatorio:cabecalho() return "== relatório ==" end

function Relatorio:rodape() return "== fim ==" end

-- passo obrigatório: a base exige a sobrescrita.
function Relatorio:formatarCorpo()
  error("formatarCorpo deve ser implementado pela subclasse")
end

--------------------------------------------------------------------------------
-- Subclasses preenchem apenas os passos:

local RelatorioDeLista = Relatorio:novo {}
function RelatorioDeLista:formatarCorpo(dados)
  return "- " .. table.concat(dados, "\n- ")
end

local RelatorioCsv = Relatorio:novo {}
function RelatorioCsv:cabecalho() return "valores" end

function RelatorioCsv:formatarCorpo(dados)
  return table.concat(dados, ",")
end

function RelatorioCsv:rodape() return "" end

--------------------------------------------------------------------------------

local dados = { "ana", "bob" }

assert(RelatorioDeLista:novo {}:gerar(dados) ==
  "== relatório ==\n- ana\n- bob\n== fim ==")

assert(RelatorioCsv:novo {}:gerar(dados) == "valores\nana,bob\n")

-- o passo obrigatório continua protegido na base:
local SemCorpo = Relatorio:novo {}
local ok = pcall(function() return SemCorpo:novo {}:gerar(dados) end)
assert(not ok, "gerar sem formatarCorpo deveria falhar")

print("Método Modelo: esqueleto fixo na base, passos nas subclasses.")
