-- crew.lua

--------------------------------------------------------------------------------
-- Step #1: Creating tools
-- Define any tools or utilities that agents will need.


--------------------------------------------------------------------------------
-- Step #2: Assemble Agents
-- Define the agents of our crew, giving them attributes and abilities.

Agent = {
  role = "",
  goal = "",
  verbose = false,
  memory = false,
  backstory = "",
  tools = {},
  allow_delegation = true
}

function Agent.new(self, agent)
  agent = agent or {}
  self.__index = self
  setmetatable(agent, self)
  return agent
end

--------------------------------------------------------------------------------
-- Step 3: Define the Tasks
-- Define the tasks or objectives that the crew will need to accomplish.


--------------------------------------------------------------------------------
-- Step 4: Form the Crew
-- Assemble the crew by assigning agents to tasks.

--------------------------------------------------------------------------------
-- Step 5: Kick It Off
-- Execute the tasks and manage the crew.

--------------------------------------------------------------------------------

