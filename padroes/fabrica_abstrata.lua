-- fabrica_abstrata.lua

-- Padrão Fábrica Abstrata: criar FAMÍLIAS de componentes compatíveis.
-- Cada fábrica concreta (Ford, Tesla) implementa TODOS os métodos
-- criadores da sua família (criarChassi, criarMotor, ...), e a montagem
-- do carro é a mesma para qualquer fábrica — o que garante que os
-- componentes de famílias diferentes nunca se misturem.
--
-- Para a decisão de UM produto por nome, veja fabrica.lua.

--------------------------------------------------------------------------------
-- Classe base:

local Classe = {}

function Classe:novo(instancia)
  instancia = instancia or {}
  setmetatable(instancia, self)
  self.__index = self
  return instancia
end

--------------------------------------------------------------------------------
-- Componentes: dois tipos de cada, um por família.

local ChassiTipo1 = Classe:novo {}
function ChassiTipo1:sustentar() return "ChassiTipo1 ok" end

local ChassiTipo2 = Classe:novo {}
function ChassiTipo2:sustentar() return "ChassiTipo2 ok" end

local MotorTipo1 = Classe:novo {}
function MotorTipo1:ligar() return "MotorTipo1 está roncando" end

local MotorTipo2 = Classe:novo {}
function MotorTipo2:ligar() return "MotorTipo2 está roncando" end

local TransmissaoTipo1 = Classe:novo {}
function TransmissaoTipo1:trocarMarcha() return "TransmissaoTipo1 está trocando de marcha" end

local TransmissaoTipo2 = Classe:novo {}
function TransmissaoTipo2:trocarMarcha() return "TransmissaoTipo2 está trocando de marcha" end

local RodaTipo1 = Classe:novo {}
function RodaTipo1:girar() return "RodaTipo1 está girando" end

local RodaTipo2 = Classe:novo {}
function RodaTipo2:girar() return "RodaTipo2 está girando" end

--------------------------------------------------------------------------------
-- A fábrica abstrata define o contrato dos métodos criadores:

local FabricaDeCarro = Classe:novo {}

function FabricaDeCarro:criarChassi() error("Este método deve ser sobrescrito") end

function FabricaDeCarro:criarMotor() error("Este método deve ser sobrescrito") end

function FabricaDeCarro:criarTransmissao() error("Este método deve ser sobrescrito") end

function FabricaDeCarro:criarRoda() error("Este método deve ser sobrescrito") end

-- A montagem é GENÉRICA: funciona com qualquer fábrica concreta e só
-- usa componentes criados pela própria fábrica — é isso que garante a
-- compatibilidade da família.
function FabricaDeCarro:montarCarro()
  return {
    chassi = self:criarChassi(),
    motor = self:criarMotor(),
    transmissao = self:criarTransmissao(),
    roda = self:criarRoda()
  }
end

--------------------------------------------------------------------------------
-- Fábricas concretas: uma por família de componentes.

local FabricaFord = FabricaDeCarro:novo {}
function FabricaFord:criarChassi() return ChassiTipo1:novo {} end

function FabricaFord:criarMotor() return MotorTipo1:novo {} end

function FabricaFord:criarTransmissao() return TransmissaoTipo1:novo {} end

function FabricaFord:criarRoda() return RodaTipo1:novo {} end

local FabricaTesla = FabricaDeCarro:novo {}
function FabricaTesla:criarChassi() return ChassiTipo2:novo {} end

function FabricaTesla:criarMotor() return MotorTipo2:novo {} end

function FabricaTesla:criarTransmissao() return TransmissaoTipo2:novo {} end

function FabricaTesla:criarRoda() return RodaTipo2:novo {} end

--------------------------------------------------------------------------------
-- Uso: o mesmo código de montagem produz famílias coerentes.

local ford = FabricaFord:montarCarro()
assert(ford.chassi:sustentar() == "ChassiTipo1 ok")
assert(ford.motor:ligar() == "MotorTipo1 está roncando")
assert(ford.transmissao:trocarMarcha() == "TransmissaoTipo1 está trocando de marcha")
assert(ford.roda:girar() == "RodaTipo1 está girando")

local tesla = FabricaTesla:montarCarro()
assert(tesla.chassi:sustentar() == "ChassiTipo2 ok")
assert(tesla.motor:ligar() == "MotorTipo2 está roncando")
assert(tesla.transmissao:trocarMarcha() == "TransmissaoTipo2 está trocando de marcha")
assert(tesla.roda:girar() == "RodaTipo2 está girando")

-- a fábrica abstrata continua abstrata: os criadores exigem sobrescrita.
local ok = pcall(function() return FabricaDeCarro:montarCarro() end)
assert(not ok, "montarCarro na fábrica abstrata deveria exigir os criadores")

print("Fábrica Abstrata: Ford e Tesla montados com famílias coerentes.")
