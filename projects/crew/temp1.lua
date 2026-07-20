--------------------------------------------------------------------------------
-- Step #1: Creating tools
-- Define any tools or utilities that agents will need.
--------------------------------------------------------------------------------

-- Tool: Logger
local Logger = {
  log = function(message)
      print("[LOG] " .. message)
  end
}

-- Tool: Inventory
Inventory = {
  new = function(self)
      local inventory = { items = {} }
      setmetatable(inventory, self)
      self.__index = self
      return inventory
  end,
  addItem = function(self, item)
      table.insert(self.items, item)
  end,
  listItems = function(self)
      for _, item in ipairs(self.items) do
          Logger.log("Item: " .. item)
      end
  end
}

--------------------------------------------------------------------------------
-- Step #2: Assemble Agents
-- Define the agents of our crew, giving them attributes and abilities.
--------------------------------------------------------------------------------

local Agent = {
  new = function(self, name, role, abilities)
      local agent = {
          name = name,
          role = role,
          abilities = abilities,
          inventory = Inventory:new()
      }
      setmetatable(agent, self)
      self.__index = self
      return agent
  end,
  performTask = function(self, task)
      if self.abilities[task] then
          Logger.log(self.name .. " is performing task: " .. task)
          self.abilities[task]()
      else
          Logger.log(self.name .. " cannot perform task: " .. task)
      end
  end,
  addItemToInventory = function(self, item)
      self.inventory:addItem(item)
  end,
  listInventory = function(self)
      self.inventory:listItems()
  end
}

--------------------------------------------------------------------------------
-- Step #3: Define the Tasks
-- Define the tasks or objectives that the crew will need to accomplish.
--------------------------------------------------------------------------------

local Tasks = {
  gatherResources = function()
      Logger.log("Gathering resources...")
  end,
  buildShelter = function()
      Logger.log("Building shelter...")
  end,
  scoutArea = function()
      Logger.log("Scouting the area...")
  end
}

--------------------------------------------------------------------------------
-- Step #4: Form the Crew
-- Assemble the crew by assigning agents to tasks.
--------------------------------------------------------------------------------

Crew = {
  new = function(self)
      local crew = { agents = {} }
      setmetatable(crew, self)
      self.__index = self
      return crew
  end,
  addAgent = function(self, agent)
      table.insert(self.agents, agent)
  end,
  assignTasks = function(self, taskAssignments)
      for agentName, task in pairs(taskAssignments) do
          for _, agent in ipairs(self.agents) do
              if agent.name == agentName then
                  agent:performTask(task)
              end
          end
      end
  end
}


-- Create agents
local john = Agent:new("John", "Builder", {buildShelter = Tasks.buildShelter})
local sarah = Agent:new("Sarah", "Scout", {scoutArea = Tasks.scoutArea})
local alex = Agent:new("Alex", "Gatherer", {gatherResources = Tasks.gatherResources})

-- Form the crew
local crew = Crew:new()
crew:addAgent(john)
crew:addAgent(sarah)
crew:addAgent(alex)

--------------------------------------------------------------------------------
-- Step #5: Kick It Off
-- Execute the tasks and manage the crew.
--------------------------------------------------------------------------------

local taskAssignments = {
  John = "buildShelter",
  Sarah = "scoutArea",
  Alex = "gatherResources"
}

crew:assignTasks(taskAssignments)

-- Adding items to agents' inventory
john:addItemToInventory("Hammer")
sarah:addItemToInventory("Binoculars")
alex:addItemToInventory("Backpack")

-- List inventory for each agent
john:listInventory()
sarah:listInventory()
alex:listInventory()
