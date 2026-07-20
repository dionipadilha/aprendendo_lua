local CarrinhoDeCompras = require "carrinho_de_compras"
local CartaoDeCredito = require "cartao_de_credito"
local Pix = require "pix"

local carrinho = CarrinhoDeCompras:novo()
local cartaoDeCredito = CartaoDeCredito:novo {}
local pix = Pix:novo {}

local function principal()
  print(carrinho:definirPagamento(cartaoDeCredito):finalizarCompra(100)) --> true
  print(carrinho:definirPagamento(pix):finalizarCompra(50))              --> true
  --carrinho:definirPagamento(Pix):finalizarCompra(-50)                  --> falha
end

principal()
