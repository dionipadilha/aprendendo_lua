-- adaptador.lua

-- Padrão Adapter (Adaptador): converter a interface de uma classe
-- existente para a interface que o cliente espera, sem modificar
-- nenhuma das duas.
--
-- Cenário: nosso sistema espera tomadas com `conectar()`, mas um
-- equipamento importado só oferece `plug()` com outra semântica.

--------------------------------------------------------------------------------
-- Interface esperada pelo cliente: qualquer aparelho com `conectar()`
-- que devolva a tensão em volts.

local function ligarNaRede(aparelho)
  local tensao = aparelho:conectar()
  assert(type(tensao) == "number", "conectar() deve devolver a tensão em volts")
  return ("aparelho ligado em %d V"):format(tensao)
end

--------------------------------------------------------------------------------
-- Classe existente (adaptada): interface incompatível — método com outro
-- nome e resposta em texto.

local EquipamentoImportado = {}
EquipamentoImportado.__index = EquipamentoImportado

function EquipamentoImportado.novo()
  return setmetatable({}, EquipamentoImportado)
end

function EquipamentoImportado:plug()
  return "127v"
end

--------------------------------------------------------------------------------
-- O Adaptador: implementa a interface esperada (`conectar`) e traduz a
-- chamada para a interface existente (`plug`), convertendo a resposta.

local AdaptadorDeTomada = {}
AdaptadorDeTomada.__index = AdaptadorDeTomada

function AdaptadorDeTomada.novo(equipamento)
  return setmetatable({ equipamento = equipamento }, AdaptadorDeTomada)
end

function AdaptadorDeTomada:conectar()
  local resposta = self.equipamento:plug() -- delega ao objeto adaptado
  return tonumber(resposta:match("%d+"))   -- e traduz a resposta
end

--------------------------------------------------------------------------------
-- Uso: o cliente não muda; o equipamento incompatível entra na rede
-- através do adaptador.

local equipamento = EquipamentoImportado.novo()

-- sem o adaptador, o cliente não consegue usar o equipamento:
local ok = pcall(ligarNaRede, equipamento)
assert(not ok, "o equipamento sem adaptador deveria ser incompatível")

-- com o adaptador, tudo se encaixa:
assert(ligarNaRede(AdaptadorDeTomada.novo(equipamento)) == "aparelho ligado em 127 V")

print("Adapter: interface incompatível traduzida para o que o cliente espera.")
