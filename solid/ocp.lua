-- ocp.lua

-- Princípio Aberto-Fechado:
-- Entidades devem estar abertas para extensão, mas fechadas para modificação.

--------------------------------------------------------------------------------
-- A VIOLAÇÃO: decidir o desconto com if/elseif por tipo. Cada tipo novo
-- de cliente exige EDITAR esta função — ela nunca "fecha".

local function calcularDescontoPorTipo(tipo)
  if tipo == "regular" then
    return 0.1
  elseif tipo == "premium" then
    return 0.2
  else
    error("tipo de cliente desconhecido: " .. tostring(tipo))
  end
end

assert(calcularDescontoPorTipo("regular") == 0.1)

-- um tipo "vip" ainda não existe: em vez de se estender, a função quebra —
-- e a única saída seria modificá-la (violando o princípio):
local okVip = pcall(calcularDescontoPorTipo, "vip")
assert(not okVip, "o tipo novo exigiria modificar a função")

--------------------------------------------------------------------------------
-- O REDESENHO em conformidade: cada tipo de cliente é uma classe com o
-- próprio obterDesconto; o cálculo genérico nunca mais precisa mudar.

-- #1. Classe Abstrata de Cliente:
local Cliente = {
  obterDesconto = function(self) return error("não implementado") end
}

function Cliente:novo(tipoDeCliente)
  self.__index = self
  tipoDeCliente = tipoDeCliente or {}
  return setmetatable(tipoDeCliente, self)
end

-- #2. Tipos Concretos de Cliente:
local ClienteRegular = Cliente:novo {
  obterDesconto = function(self) return 0.1 end
}

local ClientePremium = Cliente:novo {
  obterDesconto = function(self) return 0.2 end
}

-- #3. Cálculo Genérico de Desconto:
local pagamento = {}

function pagamento.calcularDesconto(cliente)
  assert(cliente.obterDesconto, "Objeto de cliente inválido.")
  return cliente:obterDesconto()
end

local Roberto = ClienteRegular:novo {}
local Paulo = ClientePremium:novo {}

assert(pagamento.calcularDesconto(Roberto) == 0.1)
assert(pagamento.calcularDesconto(Paulo) == 0.2)

-- #4. Extensão SEM modificação: o tipo "vip" que quebrava a versão com
-- if/elseif agora é só uma classe nova — pagamento.calcularDesconto
-- permanece intocado (fechado para modificação, aberto para extensão).
local ClienteVip = Cliente:novo {
  obterDesconto = function(self) return 0.3 end
}

assert(pagamento.calcularDesconto(ClienteVip:novo {}) == 0.3)
