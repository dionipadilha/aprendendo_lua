--  chaves_fracas.lua

--------------------------------------------------------------------------------
-- chaves fracas: permitem a coleta de lixo de objetos referenciados fracamente.

-- #1. Cria uma tabela fraca com chaves fracas para cache:
local tabelaFraca = setmetatable({}, { __mode = "k" })

-- #2. Adicionando chaves fracas:
local chave = {}
tabelaFraca[chave] = "x"
for k, v in pairs(tabelaFraca) do print(k, v) end
--> table: 0x557a8f50ae70	x

-- #3. Substituindo a referência anterior:
chave = {}
tabelaFraca[chave] = "y"
for k, v in pairs(tabelaFraca) do print(k, v) end
--> table: 0x557a8f50ae70	x
--> table: 0x557a8f50aef0	y

-- #4. Coletando as chaves fracas:
collectgarbage()
for k, v in pairs(tabelaFraca) do print(k, v) end
--> table: 0x557a8f50aef0	y

--------------------------------------------------------------------------------
-- Implementação: cache de sessões de usuário

-- #1. Cria uma tabela fraca com chaves fracas para o cache de sessões de usuário:
local cacheDeSessoes = setmetatable({}, { __mode = "k" })

-- #2. Definindo a classe Usuario:
local Usuario = {nome = "" }

function Usuario:novo(objeto)
  self.__index = self
  objeto = objeto or {}
  return setmetatable(objeto, self)
end

-- #2. Definindo a classe Sessao:
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

-- #5. Simulando a expiração da sessão:
usuario1 = nil
collectgarbage()
print("Sessões após a coleta de lixo:")
for k, v in pairs(cacheDeSessoes) do print(k.nome, v.dados) end
--> Bob	dados do usuário #2
