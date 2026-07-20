local CarrinhoDeCompras = {}

function CarrinhoDeCompras:novo()
  local carrinho = {}
  setmetatable(carrinho, self)
  self.__index = self
  return carrinho
end

function CarrinhoDeCompras:definirPagamento(metodoDePagamento)
  self.pagamento = metodoDePagamento
  return self
end

function CarrinhoDeCompras:finalizarCompra(valor)
  assert(self.pagamento,
    "defina um método de pagamento antes de finalizar a compra")
  return self.pagamento:pagar(valor)
end

return CarrinhoDeCompras
