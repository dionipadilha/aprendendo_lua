local Class = require "class"

-- Agents are the building blocks of the Crew:
local Agent = Class:new {
  ---------------------------------- Required ----------------------------------
  -- propertie: role
  --- Defines the agent's function within the crew.
  --- It determines the kind of tasks the agent is best suited for.
  role = "",

  -- propertie: goal
  --- The individual objective that the agent aims to achieve.
  --- It guides the agent's decision-making process.
  goal = "",

  -- propertie: backstory
  --- Provides context to the agent's role and goal,
  --- enriching the interaction and collaboration dynamics.
  backstory = [[]],

  ---------------------------------- Optional ----------------------------------
  -- propertie: tools
  --- Set of capabilities or functions that the agent can use to perform tasks.
  --- Expected to be instances of custom classes compatible with the agent's
  --- execution environment.
  tools = {},

  -- propertie: max_iter
  --- Maximum number of iterations the agent can perform before being forced to
  --- give its best answer.
  max_iter = 25,

  -- propertie: max_rpm
  --- The maximum number of requests per minute the agent can perform to avoid
  --- rate limits.
  max_rpm = nil,

  -- propertie: max_execution_time
  --- Maximum execution time for an agent to execute a task.
  --- With a default value of nil menaning no max execution time.
  max_execution_time = nil,

  -- propertie: verbose
  --- Provide detailed execution logs, aiding in debugging and monitoring logs.
  verbose = true,

  -- propertie: allow_delegation
  --- Delegate tasks or questions to one another,
  --- ensuring that each task is handled by the most suitable agent.
  allow_delegation = true,

  -- propertie: step_callback
  --- A function that is called after each step of the agent.
  --- This can be used to log the agent's actions or to perform other operations.
  --- It will overwrite the crew step_callback.
  step_callback = nil,

  -- propertie: cache
  --- Indicates if the agent should use a cache for tool usage.
  cache = true,

  ------------------------------ LLM Integration -------------------------------
  -- propertie: llm
  --- Represents the language model that will run the agent.
  llm = nil,

  -- propertie: function_calling_llm
  --- Language model that will handle the tool calling for this agent,
  --- overriding the crew function calling LLM if passed.
  function_calling_llm = nil
}

function Agent:use(tool, ...)
  -- Check if the tool exists in the tools table
  for _, _tool in ipairs(self.tools) do
    if _tool == tool then
      -- Call the tool function with arguments
      return tool:run(...)
    end
  end
  return nil
end

return Agent
