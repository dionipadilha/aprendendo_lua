local CarrinhoDeCompras = {
  itens = {},
  pagamento = nil
}

function CarrinhoDeCompras:novo(objeto)
  objeto = objeto or {}
  setmetatable(objeto, self)
  self.__index = self
  return objeto
end

function CarrinhoDeCompras:adicionarItem(item)
  table.insert(self.itens, item)
end

function CarrinhoDeCompras:definirPagamento(estrategia)
  self.pagamento = estrategia
end

function CarrinhoDeCompras:finalizarCompra()
  local valorTotal = 0
  for _, item in ipairs(self.itens) do
    valorTotal = valorTotal + item.preco
  end
  return self.pagamento:pagar(valorTotal)
end

return CarrinhoDeCompras
