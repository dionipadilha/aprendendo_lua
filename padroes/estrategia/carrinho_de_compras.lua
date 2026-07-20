-- carrinho_de_compras.lua

local CarrinhoDeCompras = {
  pagamento = nil
}

function CarrinhoDeCompras:novo(objeto)
  objeto = objeto or {}
  -- Campos mutáveis são inicializados POR INSTÂNCIA. Se `itens = {}`
  -- ficasse na tabela da classe, todos os carrinhos compartilhariam a
  -- MESMA tabela de itens (estado de classe vazando entre instâncias).
  objeto.itens = objeto.itens or {}
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
  assert(self.pagamento,
    "defina uma estratégia de pagamento antes de finalizar a compra")
  local valorTotal = 0
  for _, item in ipairs(self.itens) do
    valorTotal = valorTotal + item.preco
  end
  return self.pagamento:pagar(valorTotal)
end

return CarrinhoDeCompras
