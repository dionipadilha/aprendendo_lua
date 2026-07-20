local IPagamento = require "ipagamento"

-- Definição da classe Pix
local Pix = {
  classe = "Pix",

  -- implementa as propriedades de IPagamento
  dadosDoMetodo = "Pix",
  data = "",

  -- propriedades adicionais de Pix
  tipoDeChave = "CPF", -- CPF ou CNPJ
  chave = "000.000.000-00"
}

-- Construtor de Pix
function Pix:novo(pix)
  pix = pix or {}
  setmetatable(pix, self)
  self.__index = self
  return pix
end

-- Método de IPagamento: podeRealizarPagamento
function Pix:podeRealizarPagamento()
  local log = "falha: O pagamento não pode ser realizado"
  local resposta = true -- #simulação
  assert(resposta, log)
  return self
end

-- Método de IPagamento: processarPagamento
function Pix:processarPagamento(valor)
  local log = "processarPagamento: O processamento do pagamento falhou"
  local resposta = true -- -- #simulação
  assert(resposta, log)
  return resposta
end

-- Método de IPagamento: pagar
function Pix:pagar(valor)
  local log = {
    "\nfalha: O valor deve ser um número não negativo",
    "\nProcessar pagamento: falha",
    "Processar pagamento: sucesso"
  }
  -- Garantir que o valor é um número não negativo
  assert(type(valor) == "number" and valor >= 0, log[1])
  -- Verificar se o pagamento pode ser realizado e então processá-lo
  assert(self:podeRealizarPagamento():processarPagamento(valor), log[2])
  return true, log[3], valor
end

-- Método para verificar a implementação da interface IPagamento
function Pix:implementa(interface)
  local log = "\nfalha: a classe Pix implementa IPagamento %s"
  for nomeDaPropriedade, tipoDaPropriedade in pairs(interface) do
    assert(
      tipoDaPropriedade == type(self[nomeDaPropriedade]),
      log:format(nomeDaPropriedade)
    )
  end
  return true
end

-- Assinar o contrato de IPagamento
assert(Pix:implementa(IPagamento))

return Pix
