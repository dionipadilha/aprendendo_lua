-- ocp.lua

-- Princípio Aberto-Fechado:
-- Entidades devem estar abertas para extensão, mas fechadas para modificação.

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
