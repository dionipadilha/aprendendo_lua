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

-- Duas instâncias devem ser independentes. Quando `itens = {}` morava na
-- tabela da CLASSE, os itens de um carrinho vazavam para o outro e cada
-- carrinho abaixo somava $30.10 (15 + 15 + taxa) em vez de $15.10.
local function doisCarrinhosIndependentes()
  local paypal = PayPal:novo { email = "ana@exemplo.com", senha = "qwer5678" }

  local carrinho1 = CarrinhoDeCompras:novo()
  local carrinho2 = CarrinhoDeCompras:novo()

  carrinho1:adicionarItem({ nome = "Item1", preco = 15 })
  carrinho2:adicionarItem({ nome = "Item2", preco = 15 })

  carrinho1:definirPagamento(paypal)
  carrinho2:definirPagamento(paypal)

  assert(#carrinho1.itens == 1 and #carrinho2.itens == 1,
    "os carrinhos não podem compartilhar a tabela de itens")
  assert(carrinho1:finalizarCompra() == "PayPal pagou $15.10")
  assert(carrinho2:finalizarCompra() == "PayPal pagou $15.10") -- e não $30.10
end

principal()
doisCarrinhosIndependentes()
print("Estratégias de pagamento e independência dos carrinhos: ok")
