-- crew.lua

--------------------------------------------------------------------------------
-- Step #1: Classes

local Class = {}

function Class:new(object)
  object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end

local Tool = Class:new {
  description = "",
  state = ""
}

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

Process = Class:new {
  hierarchical = function(self)
    return "not yet implemented"
  end
}

local Crew = Class:new {
  agents = {},
  tasks = {},
  process = {}
}

--------------------------------------------------------------------------------
-- Step #2: Creating Tools

local Ship = Tool:new {
  attackForce = 0,
  speed = 0,

  turnOn = function(self)
    self.state = "activatedSystems"
    return true
  end,

  attack = function(self)
    self.state = "attacking"
    return self.attackForce
  end,

  turnOff = function(self)
    self.state = "disabledSystems"
    return true
  end
}

local xWing = Tool:new {
  description = "designed to destroy the DeathStar",
  attackForce = 0.7,
  speed = 0.9,
  state = "stopped"
}

local millenniumFalcon = Ship:new {
  description = "designed for cargo transport, but has been heavily modified",
  attackForce = 0.9,
  speed = 0.5,
  state = "stopped"
}

--------------------------------------------------------------------------------
-- Step #3: Assemble Agents

local leia = Agent:new {
  role = "coordinator",
  goal = "coordinate the attack to the DeathStar",
  backstory = "princess leader of the rebellion",
  tools = {}
}

local luke = Agent:new {
  role = "attacker",
  goal = "Destroy the DeathStar",
  backstory = "Young pilot, destined to be a Jedi",
  tools = { Ship.xWing }
}

local han = Agent:new {
  role = "protector",
  goal = "protect the attacker",
  backstory = "Daring smuggler who becomes a hero",
  tools = { Ship.millenniumFalcon }
}

--------------------------------------------------------------------------------
-- Step #4: Define the Tasks

local attackCoordinator = Task:new {
  agent = leia,
  allow_delegation = true,
  description = "Coordinate protector and attacker",
  expected_output = "Attack mission successfully completed"
}

local protectionForPilotAttack = Task:new {
  agent = han,
  allow_delegation = false,
  description = "Attack enemyShips with to protect the attackPilot.",
  expected_output = "attackPilot safe"
}

local destroyDeathStar = Task:new {
  agent = luke,
  allow_delegation = false,
  description = "attack to destroy DeathStar.",
  expected_output = "deathStar destroyed"
}

--------------------------------------------------------------------------------
-- Step #5: Form the Crew

local rebelAlliance = Crew:new {
  agents = { leia, han, luke },
  tasks = { attackCoordinator, protectionForPilotAttack, destroyDeathStar },
  process = { Process.hierarchical }
}

--------------------------------------------------------------------------------
-- Step #6: Kick It Off

function rebelAlliance:Kickoff()
  -- Basic Task Execution
  for _, task in pairs(self.tasks) do
    print(task.agent.role .. ": " .. task.description)

    -- Simulate task execution (replace with actual logic)
    if task.agent.tools[1] then
      print("  Using " .. task.agent.tools[1].description)
    end

    if task == self.tasks[3] then
      local attackPower = task.agent.tools[1]:attack()
      print("DeathStar receives an attack of:", attackPower)
      print("Result:", task.expected_output)
    else
      print("Result:", task.expected_output)
    end
  end
end

rebelAlliance:Kickoff()
