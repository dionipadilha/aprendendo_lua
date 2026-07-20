-- cartao_de_credito.lua

local Pagamento = require "pagamento"

local CartaoDeCredito = Pagamento:novo {
  numeroDoCartao = "0000 0000 0000 0000",
  dataDeValidade = "00/00",
  cvv = "000"
}

function CartaoDeCredito:pagar(valor)
  valor = valor or 0
  local resultado = string.format("CartaoDeCredito pagou $%.2f", valor)
  return resultado
end

return CartaoDeCredito
