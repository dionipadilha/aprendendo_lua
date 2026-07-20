-- choosetool.lua

--------------------------------------------------------------------------------
-- Define a list of tasks
local tasks = {
  "clean window",
  "dust floor",
  "write report",
  "research data"
}

--------------------------------------------------------------------------------
-- Define a list of tools
local tools = {
  "squeegee",
  "vacuum",
  "computer",
  "internet"
}

--------------------------------------------------------------------------------
-- Define the Agent class
local Agent = {}

function Agent:new(agent)
  agent = agent or {}
  self.__index = self
  return setmetatable(agent, self)
end

-- choose the tools based on the current task:
function Agent:chooseTool(task)
  return self.taskToolMap[task]
end

-- use the selected tool:
function Agent:execute(task, tool)
  local log = "Agent execute %s using %s"
  print(log:format(task, tool))
end

--------------------------------------------------------------------------------
-- Create an agent with a set of tools

local agent = Agent:new {
  tools = tools,
  taskToolMap = {
    ["clean window"] = "squeegee",
    ["dust floor"] = "vacuum",
    ["write report"] = "computer",
    ["research data"] = "internet"
  }
}

-- Execute tasks
for _, task in ipairs(tasks) do
  print("task: " .. task)

  -- Select a tool for each task
  local tool = agent:chooseTool(task)
  print("tool: " .. tool)

  -- Use the tool for each task
  agent:execute(task, tool)

  print("Completed task: " .. task)
end
