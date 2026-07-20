-- pilha.lua

-------------------------------------------
-- Estrutura de dados básica de pilha

-- Cria uma classe de pilha:
-- (os métodos usam a forma com ponto e `self` explícito —
-- function Pilha.metodo(self, ...) — que é equivalente à forma com
-- dois-pontos, function Pilha:metodo(...), usada no resto do repositório)
local Pilha = {}

-- Construtor:
function Pilha.novo(self, objeto)
  objeto = objeto or {}
  -- Estado mutável inicializado POR INSTÂNCIA:
  -- se `elementos` ficasse na tabela da classe, todas as pilhas
  -- compartilhariam a mesma tabela de elementos.
  objeto.elementos = objeto.elementos or {}
  self.__index = self
  return setmetatable(objeto, self)
end

-- Adiciona um elemento ao topo da pilha:
function Pilha.empilhar(self, valor)
  table.insert(self.elementos, valor) -- table.insert não devolve valor
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
assert(pilha:espiar() == "bob")

-- Desempilha valores da pilha:
local topo = pilha:desempilhar()
print(topo) --> bob
assert(topo == "bob")

topo = pilha:desempilhar()
print(topo) --> ana
assert(topo == "ana")

-- Tenta obter valores da pilha vazia:
print(pilha:desempilhar()) --> nil
print(pilha:espiar()) --> nil
assert(pilha:desempilhar() == nil and pilha:espiar() == nil)

-- Limpando a pilha:
pilha:empilhar("bob")
pilha:limpar()
print(pilha:espiar()) --> nil
assert(pilha:espiar() == nil)

-------------------------------------------
-- Duas pilhas são independentes: cada instância tem seus próprios elementos

local pilhaA = Pilha:novo()
local pilhaB = Pilha:novo()

pilhaA:empilhar("x")
assert(pilhaA:espiar() == "x")               -- pilhaA recebeu o elemento...
assert(pilhaB:espiar() == nil)               -- ...e pilhaB continua vazia
assert(pilhaA.elementos ~= pilhaB.elementos) -- tabelas de elementos distintas

pilhaB:empilhar("y")
assert(pilhaA:desempilhar() == "x")
assert(pilhaB:desempilhar() == "y")

print("Instâncias de Pilha independentes: ok")
