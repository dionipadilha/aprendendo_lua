local CarrinhoDeCompras = require "carrinho_de_compras"
local CartaoDeCredito = require "cartao_de_credito"
local PayPal = require "paypal"

local function principal()
  -- Instancia um CarrinhoDeCompras:
  local carrinho = CarrinhoDeCompras:novo()

  -- Adiciona itens ao carrinho:
  carrinho:adicionarItem({ nome = "Item1", preco = 50 })
  carrinho:adicionarItem({ nome = "Item2", preco = 50 })

  -- Define a estratégia de pagamento como CartaoDeCredito:
  carrinho:definirPagamento(CartaoDeCredito:novo {
    numeroDoCartao = "1234 5678 9876 5432",
    dataDeValidade = "01/25",
    cvv = "456"
  })
  assert(carrinho:finalizarCompra() == "CartaoDeCredito pagou $100.00")

  -- Altera a estratégia de pagamento para PayPal:
  carrinho:definirPagamento(PayPal:novo {
    email = "joao@exemplo.com",
    senha = "asdf1234"
  })
  assert(carrinho:finalizarCompra() == "PayPal pagou $100.10")
end

principal()
