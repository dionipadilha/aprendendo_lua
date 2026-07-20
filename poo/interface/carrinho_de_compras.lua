local CarrinhoDeCompras = {}

function CarrinhoDeCompras:novo()
  local carrinho = {}
  setmetatable(carrinho, self)
  self.__index = self
  return carrinho
end

function CarrinhoDeCompras:definirPagamento(classePagamento)
  self.classe = classePagamento
  return self
end

function CarrinhoDeCompras:finalizarCompra(valor)
  return self.classe:pagar(valor)
end

return CarrinhoDeCompras
