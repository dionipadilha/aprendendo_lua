-- crew.lua

--------------------------------------------------------------------------------
-- Step #0: Creating Classes
--------------------------------------------------------------------------------
local Class = {}

function Class:new(object)
  object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end

local Agent = Class:new {
  role = "",
  goal = "",
  backstory = "",
  tools = {},
  allow_delegation = true
}

local Task = Class:new {
  description = "",
  expected_output = "",
  agent = nil,
  allow_delegation = true
}

--------------------------------------------------------------------------------
-- Step #1: Creating Tools
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- Step #2: Assemble Agents
--------------------------------------------------------------------------------


local luke = Agent:new {
  role = "Piloto de ataque",
  goal = "Destruir a Estrela da Morte",
  backstory = "Jovem piloto, destinado a ser um Jedi."
}

print(luke.role)

local han = Agent:new {
  role = "Piloto de proteção",
  goal = "Proteger pilotos em missão",
  backstory = "Contrabandista ousado que se torna um herói."
}

local leia = Agent:new {
  role = "Coordenadora",
  goal = "Coordenar ataque a Estrela da Morte",
  backstory = "Princesa lider da rebelião."
}

--------------------------------------------------------------------------------
-- Step #3: Define the Tasks
--------------------------------------------------------------------------------

local coordenar_ataque = Task:new {

}


--------------------------------------------------------------------------------
-- Step #4: Form the Crew
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Step #5: Kick It Off
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
