-- pagamento.lua

local Pagamento = {}

function Pagamento:novo(objeto)
  objeto = objeto or {}
  setmetatable(objeto, self)
  self.__index = self
  return objeto
end

function Pagamento:pagar(valor)
  return error("o método pagar deve ser implementado pelas classes concretas")
end

return Pagamento
