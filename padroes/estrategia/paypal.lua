local Pagamento = require "pagamento"

local PayPal = Pagamento:novo {
  email = "indefinido@email.com",
  senha = "1234"
}

function PayPal:pagar(valor)
  local transacao = 0.10
  valor = valor or 0
  local total = valor + transacao
  local resultado = string.format("PayPal pagou $%.2f", total)
  return resultado
end

return PayPal
