-- lista.lua

-- PAPEL deste arquivo: a lista como TAD (tipo abstrato de dados) — um
-- conjunto de operações NOMEADAS atrás das quais a tabela é detalhe de
-- implementação: quem usa o TAD pensa em "acrescentar" e "buscar", não
-- em índices. Para as operações básicas de array, veja vetores.lua;
-- para o tour da API table.*, veja biblioteca_de_tabelas.lua.

local Lista = {}

function Lista.nova(...)
  return { ... }
end

function Lista.tamanho(lista)
  return #lista
end

function Lista.acrescentar(lista, item)
  table.insert(lista, item)
end

function Lista.inserirEm(lista, posicao, item)
  table.insert(lista, posicao, item)
end

-- as remoções devolvem o item removido (repassando o retorno de
-- table.remove) — o chamador decide se o descarta:
function Lista.removerUltimo(lista)
  return table.remove(lista)
end

function Lista.removerEm(lista, posicao)
  return table.remove(lista, posicao)
end

function Lista.ordenar(lista, comparador)
  table.sort(lista, comparador)
end

function Lista.paraString(lista, separador)
  return table.concat(lista, separador or ", ")
end

-- A busca não existe pronta na API table — é o TAD que a nomeia e
-- implementa, devolvendo TODOS os índices onde o alvo aparece:
function Lista.buscar(lista, alvo)
  local indices = {}
  for i, item in ipairs(lista) do
    if item == alvo then table.insert(indices, i) end
  end
  return indices
end

--------------------------------------------------------------------------------
-- Exemplo de uso (cada operação verificada pelo estado resultante):

local nomes = Lista.nova("ana", "bob", "carlos")
assert(Lista.tamanho(nomes) == 3)

Lista.acrescentar(nomes, "duda")
print(Lista.paraString(nomes)) --> ana, bob, carlos, duda
assert(Lista.paraString(nomes) == "ana, bob, carlos, duda")

Lista.inserirEm(nomes, 3, "edu")
print(Lista.paraString(nomes)) --> ana, bob, edu, carlos, duda
assert(Lista.paraString(nomes) == "ana, bob, edu, carlos, duda")

assert(Lista.removerEm(nomes, 3) == "edu")
assert(Lista.removerUltimo(nomes) == "duda")
assert(Lista.paraString(nomes) == "ana, bob, carlos")

Lista.ordenar(nomes, function(a, b) return a > b end)
print(Lista.paraString(nomes)) --> carlos, bob, ana
assert(Lista.paraString(nomes) == "carlos, bob, ana")

-- busca com alvo presente, repetido e ausente:
Lista.acrescentar(nomes, "bob")
local indicesDeBob = Lista.buscar(nomes, "bob")
assert(#indicesDeBob == 2 and indicesDeBob[1] == 2 and indicesDeBob[2] == 4)
assert(#Lista.buscar(nomes, "zeca") == 0) -- ausente: lista de índices vazia

print("operações do TAD Lista verificadas!")
