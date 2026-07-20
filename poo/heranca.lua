-- heranca.lua

-- Definindo as tabelas Pai e Filha:
local tabela_pai = { chave_pai = "valor_pai" }
local tabela_filha = { chave_filha = "valor_filho" }

-- Configurando a herança:
setmetatable(tabela_filha, { __index = tabela_pai })

-- Acessando a chave herdada:
print(tabela_filha.chave_filha) --> valor_filho
print(tabela_filha.chave_pai)   --> valor_pai

assert(tabela_filha.chave_filha == "valor_filho")
assert(tabela_filha.chave_pai == "valor_pai")   -- herdada via __index
assert(rawget(tabela_filha, "chave_pai") == nil) -- não existe na filha
