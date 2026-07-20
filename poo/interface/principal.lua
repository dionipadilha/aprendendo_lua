-- principal.lua

local CarrinhoDeCompras = require "carrinho_de_compras"
local CartaoDeCredito = require "cartao_de_credito"
local Pix = require "pix"

local carrinho = CarrinhoDeCompras:novo()
local cartaoDeCredito = CartaoDeCredito:novo {}
local pix = Pix:novo {}

-- Pagamento com cartão de crédito:
local okCartao, mensagemCartao, valorCartao =
    carrinho:definirPagamento(cartaoDeCredito):finalizarCompra(100)
print(okCartao, mensagemCartao, valorCartao) --> true	Processar pagamento: sucesso	100
assert(okCartao == true and valorCartao == 100)

-- Pagamento com Pix:
local okPix, mensagemPix, valorPix =
    carrinho:definirPagamento(pix):finalizarCompra(50)
print(okPix, mensagemPix, valorPix) --> true	Processar pagamento: sucesso	50
assert(okPix == true and valorPix == 50)

-- Valor negativo falha; capturamos o erro com pcall:
local okNegativo = pcall(function()
  carrinho:definirPagamento(pix):finalizarCompra(-50)
end)
assert(okNegativo == false)
print("pagamento com valor negativo foi rejeitado") --> pagamento com valor negativo foi rejeitado
