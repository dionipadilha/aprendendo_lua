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
  state = "idle",
}

local Task = Class:new {
  description = "",
  expected_output = "",
  agent = nil,
  allow_delegation = true,
  priority = 1,
  dependencies = {}
}

local Process = Class:new {
  hierarchical = function(self, tasks)
    table.sort(tasks, function(a, b)
      if a.priority == b.priority then
        return a.description < b.description
      end
      return a.priority > b.priority
    end)
    return tasks
  end
}

local Crew = Class:new {
  agents = {},
  tasks = {},
  process = {},
  kickoff = function(self)
    return "not yet implemented"
  end
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

local xWing = Ship:new {
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
  tools = { xWing }
}

local han = Agent:new {
  role = "protector",
  goal = "protect the attacker",
  backstory = "Daring smuggler who becomes a hero",
  tools = { millenniumFalcon }
}

--------------------------------------------------------------------------------
-- Step #4: Define the Tasks

local attackCoordinator = Task:new {
  agent = leia,
  allow_delegation = true,
  description = "Coordinate protector and attacker",
  expected_output = "Attack mission successfully completed",
  priority = 3
}

local protectionForPilotAttack = Task:new {
  agent = han,
  allow_delegation = false,
  description = "Attack enemyShips to protect the attackPilot.",
  expected_output = "attackPilot safe",
  priority = 2,
  dependencies = { attackCoordinator }
}

local destroyDeathStar = Task:new {
  agent = luke,
  allow_delegation = false,
  description = "attack to destroy DeathStar.",
  expected_output = "deathStar destroyed",
  priority = 1,
  dependencies = { protectionForPilotAttack }
}

--------------------------------------------------------------------------------
-- Step #5: Form the Crew

local rebelAlliance = Crew:new {
  agents = { leia, han, luke },
  tasks = { attackCoordinator, protectionForPilotAttack, destroyDeathStar },
  process = { Process.hierarchical }
}

-- Dynamic Task Assignment

function rebelAlliance:assignTasks(agents, tasks)
  for _, task in pairs(tasks) do
    for _, agent in pairs(agents) do
      if agent.role == "coordinator" and task.allow_delegation then
        task.agent = agent
        break
      elseif agent.role == "attacker" and task.description:find("destroy Death Star") then
        task.agent = agent
        break
      elseif agent.role == "protector" and task.description:find("protect") then
        task.agent = agent
        break
      end
    end
  end
end

--------------------------------------------------------------------------------
-- Step #6: Kick It Off

function rebelAlliance:kickoff()
  print("Kickoff initiated. Executing tasks...\n")
  for _, task in pairs(self.tasks) do
    -- Check if task dependencies are met
    local dependencies_met = true
    for _, dependency in pairs(task.dependencies) do
      if dependency.agent.state ~= "completed" then
        dependencies_met = false
        break
      end
    end

    if dependencies_met then
      print("Agent: " .. task.agent.role)
      print("Task: " .. task.description)
      print("Goal: " .. task.agent.goal)
      print("Backstory: " .. task.agent.backstory)
      print("Tools: ")
      for _, tool in pairs(task.agent.tools) do
        print("  - " .. tool.description .. " (State: " .. tool.state .. ")")
      end

      -- Simulate task execution with outcomes
      local success = math.random() < 0.8 -- 80% chance of success
      if success then
        print("Result: " .. task.expected_output .. "\n")
        task.agent.state = "completed"
        if task == destroyDeathStar then
          -- Death Star destroyed, game over
          print("The Death Star has been destroyed! The Rebellion triumphs!\n")
          return
        end
      else
        print("Result: Task failed!\n")
        task.agent.state = "failed"
        -- Optionally retry or reassign the task
      end
    else
      print("Task: " .. task.description .. " cannot be executed due to unmet dependencies.\n")
    end
  end
end

rebelAlliance.process = Process:new()
rebelAlliance.tasks = rebelAlliance.process:hierarchical(rebelAlliance.tasks)
rebelAlliance:kickoff()
