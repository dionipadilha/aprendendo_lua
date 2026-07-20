local IPagamento = require "ipagamento"

-- a classe CartaoDeCredito implementa as propriedades de IPagamento
local CartaoDeCredito = {
  classe = "CartaoDeCredito",

  -- implementa as propriedades de IPagamento
  dadosDoMetodo = "CartaoDeCredito",
  data = "",

  -- propriedades adicionais de CartaoDeCredito
  numeroDoCartao = "0000 0000 0000 0000",
  dataDeValidade = "00/00",
  cvv = "000"
}

-- Construtor de CartaoDeCredito
function CartaoDeCredito:novo(cartao)
  cartao = cartao or {}
  setmetatable(cartao, self)
  self.__index = self
  return cartao
end

-- implementa o método de IPagamento: podeRealizarPagamento
function CartaoDeCredito:podeRealizarPagamento()
  local log = "falha: O pagamento não pode ser realizado"
  local resposta = true -- #simulação
  assert(resposta, log)
  return self
end

-- implementa o método de IPagamento: processarPagamento
function CartaoDeCredito:processarPagamento(valor)
  local log = "processarPagamento: O processamento do pagamento falhou"
  local resposta = true -- #simulação
  assert(resposta, log)
  return resposta
end

-- implementa o método de IPagamento: pagar
function CartaoDeCredito:pagar(valor)
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

-- implementa o contrato de IPagamento
function CartaoDeCredito:implementa(interface)
  local log = "\nfalha: a classe CartaoDeCredito implementa IPagamento %s"
  for nomeDaPropriedade, tipoDaPropriedade in pairs(interface) do
    assert(
      tipoDaPropriedade == type(self[nomeDaPropriedade]),
      log:format(nomeDaPropriedade)
    )
  end
  return true
end

-- assina o contrato de IPagamento
assert(CartaoDeCredito:implementa(IPagamento))

return CartaoDeCredito
