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
end

local RegistradorDeConsole = Registrador:novo {}
function RegistradorDeConsole:registrar(mensagem)
  print(mensagem)
end

-- Módulo de Alto Nível:
Aplicacao = {}

function Aplicacao:novo(instancia)
  assert(instancia.registrador.registrar, "obrigatório: registrador.registrar")
  self.__index = self
  return setmetatable(instancia, self)
end

function Aplicacao:trabalhar()
  self.registrador:registrar("trabalhando ...")
end

-- Exemplo de Uso:
local registradorDeArquivo = RegistradorDeArquivo:novo { nomeDoArquivo = "log.txt" }
local registradorDeConsole = RegistradorDeConsole:novo {}

local aplicacao1 = Aplicacao:novo { registrador = registradorDeArquivo }
local aplicacao2 = Aplicacao:novo { registrador = registradorDeConsole }

aplicacao1:trabalhar() -- Registra em um arquivo
aplicacao2:trabalhar() -- Registra no console
