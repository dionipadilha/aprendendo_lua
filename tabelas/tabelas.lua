-- tabelas.lua

--------------------------------------------------------------------------------
-- Aspectos essenciais sobre as tabelas de Lua
--------------------------------------------------------------------------------
-- Inicialização

-- Inicializa uma tabela vazia:
local tabelaVazia = {}

-- Inicializa uma tabela com elementos predefinidos:
local tabela = {chave1 = "valor1", chave2 = "valor2"}

--------------------------------------------------------------------------------
-- Acesso aos Elementos

-- Acessando elementos:
local valor = tabela["chave1"]
print(valor) --> valor1
assert(valor == "valor1")

-- Acessando elementos fora do intervalo:
local naoExistente = tabela["naoExistente"]
print(naoExistente) --> nil
assert(naoExistente == nil)

-- Percorrendo os elementos usando pairs:
-- Atenção: a ordem em que pairs visita as chaves NÃO é garantida.
for chave, valor in pairs(tabela) do
  print(chave, valor) --> imprime os pares chave1/valor1 e chave2/valor2 (em ordem não garantida)
end

-- Número de elementos:
local contador = 0
for _ in pairs(tabela) do contador = contador + 1 end
print(contador) --> 2
assert(contador == 2)

-- Iterando com a função next (mesma observação: ordem não garantida).
-- A parada compara com nil: false é chave válida de tabela e um
-- `while chave do` terminaria cedo — veja next.lua:
local chave, valor = next(tabela, nil)
while chave ~= nil do
  print(chave, valor) --> imprime os pares chave1/valor1 e chave2/valor2 (em ordem não garantida)
  chave, valor = next(tabela, chave)
end

--------------------------------------------------------------------------------
-- Manipulação

-- Modificando elementos pelo índice:
tabela["chave1"] = "novoValor1"
assert(tabela.chave1 == "novoValor1")

-- Adicionando novos elementos:
tabela["novaChave"] = "novoValor"
assert(tabela.novaChave == "novoValor")

-- Removendo um elemento pela chave:
tabela["chave1"] = nil
assert(tabela.chave1 == nil)

--------------------------------------------------------------------------------
-- Mesclando tabelas

-- Mescla tabelas usando pairs:
local tabela1 = {a = 1, b = 2}
local tabela2 = {c = 3, d = 4}
for k, v in pairs(tabela2) do
  tabela1[k] = v
end
print(tabela1.a, tabela1.b, tabela1.c, tabela1.d) --> 1	2	3	4
assert(tabela1.a == 1 and tabela1.b == 2 and tabela1.c == 3 and tabela1.d == 4)

--------------------------------------------------------------------------------
-- Introdução às tabelas multidimensionais

-- Cria uma tabela multidimensional:
local tabelaMultidimensional = { primeira = {a = 1, b = 2}, segunda = {c = 3, d = 4} }

-- Acessando elementos em tabelas multidimensionais:
local elemento = tabelaMultidimensional["primeira"]["a"] -- 1
assert(elemento == 1)

-- Manipulando elementos em tabelas multidimensionais:
tabelaMultidimensional["segunda"]["d"] = 5
assert(tabelaMultidimensional.segunda.d == 5)

-- Adicionando novos elementos em tabelas multidimensionais:
tabelaMultidimensional["terceira"] = {e = 6, f = 7}
assert(tabelaMultidimensional.terceira.e == 6)

-- Removendo um elemento em tabelas multidimensionais:
tabelaMultidimensional["primeira"]["a"] = nil
assert(tabelaMultidimensional.primeira.a == nil)

-- Percorrendo os elementos em tabelas multidimensionais:
-- (a ordem de pairs não é garantida em nenhum dos dois níveis)
for chave, valor in pairs(tabelaMultidimensional) do
  for k, v in pairs(valor) do
    print(k, v)
  end
end
--------------------------------------------------------------------------------
