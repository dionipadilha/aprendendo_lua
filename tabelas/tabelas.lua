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
print(valor) --> "valor1"

-- Acessando elementos fora do intervalo:
local naoExistente = tabela["naoExistente"]
print(naoExistente) --> nil

-- Percorrendo os elementos usando ipairs:
for chave, valor in pairs(tabela) do
  print(chave, valor) --> chave1 valor1, --> chave2 valor2
end

-- Número de elementos:
local contador = 0
for _ in pairs(tabela) do contador = contador + 1 end
print(contador) --> 2

-- Iterando com a função next:
local chave, valor = next(tabela, nil)
while chave do
    print(chave, valor) --> chave1 valor1, --> chave2 valor2
    chave, valor = next(tabela, chave)
end

--------------------------------------------------------------------------------
-- Manipulação

-- Modificando elementos pelo índice:
tabela["chave1"] = "novoValor1"

-- Adicionando novos elementos:
tabela["novaChave"] = "novoValor"

-- Removendo um elemento pela chave:
tabela["chave1"] = nil

--------------------------------------------------------------------------------
-- Mesclando tabelas

-- Mescla tabelas usando pairs:
local tabela1 = {a = 1, b = 2}
local tabela2 = {c = 3, d = 4}
for k, v in pairs(tabela2) do
    tabela1[k] = v
end
print(tabela1.a, tabela1.b, tabela1.c, tabela1.d) --> 1 2 3 4

--------------------------------------------------------------------------------
-- Introdução às tabelas multidimensionais

-- Cria uma tabela multidimensional:
local tabelaMultidimensional = { primeira = {a = 1, b = 2}, segunda = {c = 3, d = 4} }

-- Acessando elementos em tabelas multidimensionais:
local elemento = tabelaMultidimensional["primeira"]["a"] -- 1

-- Manipulando elementos em tabelas multidimensionais:
tabelaMultidimensional["segunda"]["d"] = 5

-- Adicionando novos elementos em tabelas multidimensionais:
tabelaMultidimensional["terceira"] = {e = 6, f = 7}

-- Removendo um elemento em tabelas multidimensionais:
tabelaMultidimensional["primeira"]["a"] = nil

-- Percorrendo os elementos em tabelas multidimensionais:
for chave, valor in pairs(tabelaMultidimensional) do
    for k, v in pairs(valor) do
        print(k, v)
    end
end
--------------------------------------------------------------------------------
