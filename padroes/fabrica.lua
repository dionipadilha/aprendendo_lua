-- fabrica.lua

-- construindo objetos complexos com partes intercambiáveis.

--------------------------------------------------------------------------------
-- Classe Base Fábrica:

local Fabrica = {}

function Fabrica:novo(instancia)
  instancia = instancia or {}
  setmetatable(instancia, self)
  self.__index = self
  return instancia
end

--------------------------------------------------------------------------------
-- Fábrica de Chassi e Tipos:

local FabricaDeChassi = Fabrica:novo {}

function FabricaDeChassi:sustentar()
  error("Este método deve ser sobrescrito")
end

local chassiTipo1 = FabricaDeChassi:novo {}

function chassiTipo1:sustentar()
  return "ChassiTipo1 ok"
end

local chassiTipo2 = FabricaDeChassi:novo {}

function chassiTipo2:sustentar()
  return "ChassiTipo2 ok"
end

--------------------------------------------------------------------------------
-- Fábrica de Motor e Tipos:

local FabricaDeMotor = Fabrica:novo {}

function FabricaDeMotor:ligar()
  error("Este método deve ser sobrescrito")
end

local motorTipo1 = FabricaDeMotor:novo {}

function motorTipo1:ligar()
  return "MotorTipo1 está roncando"
end

local motorTipo2 = FabricaDeMotor:novo {}

function motorTipo2:ligar()
  return "MotorTipo2 está roncando"
end

--------------------------------------------------------------------------------
-- Fábrica de Transmissão e Tipos:

local FabricaDeTransmissao = Fabrica:novo {}

function FabricaDeTransmissao:trocarMarcha()
  error("Este método deve ser sobrescrito")
end

local transmissaoTipo1 = FabricaDeTransmissao:novo {}

function transmissaoTipo1:trocarMarcha()
  return "TransmissaoTipo1 está trocando de marcha"
end

local transmissaoTipo2 = FabricaDeTransmissao:novo {}

function transmissaoTipo2:trocarMarcha()
  return "TransmissaoTipo2 está trocando de marcha"
end

--------------------------------------------------------------------------------
-- Fábrica de Roda e Tipos:

local FabricaDeRoda = Fabrica:novo {}

function FabricaDeRoda:girar()
  error("Este método deve ser sobrescrito")
end

local rodaTipo1 = FabricaDeRoda:novo {}

function rodaTipo1:girar()
  return "RodaTipo1 está girando"
end

local rodaTipo2 = FabricaDeRoda:novo {}

function rodaTipo2:girar()
  return "RodaTipo2 está girando"
end

--------------------------------------------------------------------------------
-- Montagem do Carro e Tipos:

local FabricaDeCarro = Fabrica:novo {}

function FabricaDeCarro:verificar()
  error("Este método deve ser sobrescrito")
end

function FabricaDeCarro:ligar()
  local status, resultado = pcall(self.verificar, self)
  print("self.verificar: ", status, resultado)
end

function FabricaDeCarro:dirigir(motorista)
  print("Carro sendo dirigido por: " .. motorista)
end

--------------------------------------------------------------------------------
-- Tipo de Carro Ford:

local Ford = FabricaDeCarro:novo {
  chassi = chassiTipo1:novo {},
  motor = motorTipo1:novo {},
  transmissao = transmissaoTipo1:novo {},
  roda = rodaTipo1:novo {}
}

function Ford:verificar()
  assert(self.chassi and self.motor and self.transmissao and self.roda)
  assert(self.chassi:sustentar() == "ChassiTipo1 ok")
  assert(self.motor:ligar() == "MotorTipo1 está roncando")
  assert(self.transmissao:trocarMarcha() == "TransmissaoTipo1 está trocando de marcha")
  assert(self.roda:girar() == "RodaTipo1 está girando")
  return "Todos os componentes estão funcionais"
end

--------------------------------------------------------------------------------
-- Tipo de Carro Tesla:

local Tesla = FabricaDeCarro:novo {
  chassi = chassiTipo2:novo {},
  motor = motorTipo2:novo {},
  transmissao = transmissaoTipo2:novo {},
  roda = rodaTipo2:novo {}
}

function Tesla:verificar()
  assert(self.chassi and self.motor and self.transmissao and self.roda)
  assert(self.chassi:sustentar() == "ChassiTipo2 ok")
  assert(self.motor:ligar() == "MotorTipo2 está roncando")
  assert(self.transmissao:trocarMarcha() == "TransmissaoTipo2 está trocando de marcha")
  assert(self.roda:girar() == "RodaTipo2 está girando")
  return "Todos os componentes estão funcionais"
end

--------------------------------------------------------------------------------
-- Usando as Fábricas

Ford:ligar()         --> self.verificar: 	true	Todos os componentes estão funcionais
Ford:dirigir("ana")  --> Carro sendo dirigido por: ana

Tesla:ligar()        --> self.verificar: 	true	Todos os componentes estão funcionais
Tesla:dirigir("bob") --> Carro sendo dirigido por: bob

--------------------------------------------------------------------------------
