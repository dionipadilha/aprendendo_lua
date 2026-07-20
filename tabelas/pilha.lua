-- pilha.lua

-------------------------------------------
-- Estrutura de dados básica de pilha

-- Cria uma classe de pilha:
local Pilha = {
  elementos = {}
}

-- Construtor:
function Pilha.novo(self, objeto)
  objeto = objeto or {}
  self.__index = self
  return setmetatable(objeto, self)
end

-- Adiciona um elemento ao topo da pilha:
function Pilha.empilhar(self, valor)
  return table.insert(self.elementos, valor)
end

-- Remove o elemento no topo da pilha:
function Pilha.desempilhar(self)
  return table.remove(self.elementos)
end

-- Retorna o elemento no topo sem removê-lo:
function Pilha.espiar(self)
  return self.elementos[#self.elementos]
end

-- Limpa a pilha:
function Pilha.limpar(self)
  self.elementos = {}
  return true
end

-------------------------------------------
-- Uso da pilha LIFO (Last In, First Out — último a entrar, primeiro a sair)

-- Cria um objeto pilha:
local pilha = Pilha:novo()

-- Empilha alguns valores na pilha:
pilha:empilhar("ana")
pilha:empilhar("bob")

-- Espia o valor no topo da pilha:
print(pilha:espiar()) --> bob

-- Desempilha valores da pilha:
print(pilha:desempilhar()) --> bob
print(pilha:desempilhar()) --> ana

-- Tenta obter valores da pilha vazia:
print(pilha:desempilhar())  --> nil
print(pilha:espiar()) --> nil

-- Limpando a pilha:
pilha:empilhar("bob")
pilha:limpar()
print(pilha:espiar()) --> nil
