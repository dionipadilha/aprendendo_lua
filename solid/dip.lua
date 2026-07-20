-- dip.lua

-- Princípio da Inversão de Dependência:
-- Dependa de abstrações, não de concretizações.

-- #1. Interface de Abstração:
local Registrador = {}

function Registrador:novo(instancia)
  self.__index = self
  instancia = instancia or {}
  return setmetatable(instancia, self)
end

function Registrador:registrar(mensagem)
  error("Este método deve ser sobrescrito")
end

-- #2. Implementações Concretas:
local RegistradorDeArquivo = Registrador:novo {}
function RegistradorDeArquivo:registrar(mensagem)
  local arquivo, erro = io.open(self.nomeDoArquivo, "a")
  assert(arquivo, erro)
  arquivo:write(mensagem .. "\n")
  arquivo:close()
  return mensagem
end

local RegistradorDeConsole = Registrador:novo {}
function RegistradorDeConsole:registrar(mensagem)
  print(mensagem)
  return mensagem
end

-- Módulo de Alto Nível:
-- (`local` evita vazar a classe como variável global)
local Aplicacao = {}

function Aplicacao:novo(instancia)
  -- valida em duas etapas para que a ausência do registrador falhe com a
  -- mensagem do assert, e não com "attempt to index a nil value":
  assert(type(instancia) == "table" and type(instancia.registrador) == "table",
    "obrigatório: um registrador")
  assert(instancia.registrador.registrar, "obrigatório: registrador.registrar")
  self.__index = self
  return setmetatable(instancia, self)
end

function Aplicacao:trabalhar()
  return self.registrador:registrar("trabalhando ...")
end

-- Exemplo de Uso:
local registradorDeArquivo = RegistradorDeArquivo:novo { nomeDoArquivo = "log.txt" }
local registradorDeConsole = RegistradorDeConsole:novo {}

local aplicacao1 = Aplicacao:novo { registrador = registradorDeArquivo }
local aplicacao2 = Aplicacao:novo { registrador = registradorDeConsole }

-- A Aplicacao depende só da abstração `registrador.registrar`; qualquer
-- implementação concreta serve, e o resultado observável é o mesmo:
assert(aplicacao1:trabalhar() == "trabalhando ...") -- Registra em um arquivo
assert(aplicacao2:trabalhar() == "trabalhando ...") -- Registra no console

-- Construir a Aplicacao sem um registrador válido deve falhar:
local ok = pcall(function() return Aplicacao:novo { registrador = {} } end)
assert(not ok, "Aplicacao sem registrador.registrar deveria ser rejeitada")
