-- prototipo.lua

-- #1. Definindo uma tabela protótipo:
local ClassePai = {}
ClassePai.chave_pai = "valor_pai"

-- #2. Criando um método fábrica:
function ClassePai:novo(objeto)
  objeto = objeto or {}
  self.__index = self
  return setmetatable(objeto, self)
end

-- #3. Criando uma classe filha:
local ClasseFilha = ClassePai:novo()
ClasseFilha.chave_filha = "valor_filho"

-- #4. Criando uma instância de objeto:
local objeto = ClasseFilha:novo()
objeto.chave_propria = "valor_proprio"

-- #5. Acessar propriedades em diferentes níveis:
print(objeto.chave_pai)     --> valor_pai
print(objeto.chave_filha)   --> valor_filho
print(objeto.chave_propria) --> valor_proprio
