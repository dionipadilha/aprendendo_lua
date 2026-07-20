--  chaves_fracas.lua

--------------------------------------------------------------------------------
-- chaves fracas: permitem a coleta de lixo de objetos referenciados fracamente.

-- utilitário para contar as entradas de uma tabela:
local function contarEntradas(t)
  local quantidade = 0
  for _ in pairs(t) do quantidade = quantidade + 1 end
  return quantidade
end

-- #1. Cria uma tabela fraca com chaves fracas para cache:
local tabelaFraca = setmetatable({}, { __mode = "k" })

-- #2. Adicionando chaves fracas:
local chave = {}
tabelaFraca[chave] = "x"
for k, v in pairs(tabelaFraca) do print(k, v) end
--> table: 0x...	x
assert(contarEntradas(tabelaFraca) == 1)

-- (os asserts de contagem antes do collectgarbage assumem que nenhum
-- ciclo automático do GC rodou no meio-tempo — determinístico num
-- script pequeno como este)

-- #3. Substituindo a referência anterior:
chave = {}
tabelaFraca[chave] = "y"
for k, v in pairs(tabelaFraca) do print(k, v) end
--> table: 0x...	x
--> table: 0x...	y
assert(contarEntradas(tabelaFraca) == 2)

-- #4. Coletando as chaves fracas (a chave "x" ficou sem referência forte):
collectgarbage()
for k, v in pairs(tabelaFraca) do print(k, v) end
--> table: 0x...	y
assert(contarEntradas(tabelaFraca) == 1)
assert(tabelaFraca[chave] == "y")

--------------------------------------------------------------------------------
-- Implementação: cache de sessões de usuário

-- #1. Cria uma tabela fraca com chaves fracas para o cache de sessões de usuário:
local cacheDeSessoes = setmetatable({}, { __mode = "k" })

-- #2. Definindo a classe Usuario:
local Usuario = { nome = "" }

function Usuario:novo(objeto)
  self.__index = self
  objeto = objeto or {}
  return setmetatable(objeto, self)
end

-- #3. Definindo a classe Sessao:
local Sessao = {}

function Sessao:novo(objeto)
  self.__index = self
  objeto = objeto or {}
  return setmetatable(objeto, self)
end

-- #4. Adicionando sessões de usuário ao cache:
local usuario1 = Usuario:novo { nome = "Ana" }
local usuario2 = Usuario:novo { nome = "Bob" }

cacheDeSessoes[usuario1] = Sessao:novo { dados = "dados do usuário #1" }
cacheDeSessoes[usuario2] = Sessao:novo { dados = "dados do usuário #2" }

print("Sessões após adicionar os usuários:")
for k, v in pairs(cacheDeSessoes) do print(k.nome, v.dados) end
--> Ana	dados do usuário #1
--> Bob	dados do usuário #2
assert(contarEntradas(cacheDeSessoes) == 2)

-- #5. Simulando a expiração da sessão:
usuario1 = nil
collectgarbage()
print("Sessões após a coleta de lixo:")
for k, v in pairs(cacheDeSessoes) do print(k.nome, v.dados) end
--> Bob	dados do usuário #2
assert(contarEntradas(cacheDeSessoes) == 1)
assert(cacheDeSessoes[usuario2] ~= nil)
