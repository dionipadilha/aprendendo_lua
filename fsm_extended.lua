-- fsm.lua

------------------------------------------------------------------------
-- FSM Context

local fsm = {}

------------------------------------------------------------------------
-- FSM Setup

fsm.states = { "yellow", "red", "green" }

fsm.transitions = {
  yellow = { red = "time_expired" },
  red    = { green = "car_passed" },
  green  = { yellow = "time_expired" }
}

fsm.triggers = {
  time_expired = function(params)
    print("Time expired...")
    return true
  end,
  car_passed = function(params)
    print("Car passed...")
    return true
  end
}

------------------------------------------------------------------------
-- FSM Loop

function fsm:update(current_state, params)
  local possible_transitions = self.transitions[current_state]
  if possible_transitions then
    for next_state, trigger in pairs(possible_transitions) do
      print("Transition from", current_state, "to", next_state)
      if self.triggers[trigger](params) then
        current_state = next_state
        -- Perform state exit actions here
        return current_state
      end
    end
  else
    print("No possible transitions from state:", current_state)
  end
  return current_state
end

------------------------------------------------------------------------
-- FSM Main

function fsm:run()
  local current_state = self.states[1] -- Initial state
  local params = {}                    -- Parameters for trigger functions
  for _, state in ipairs(self.states) do
    current_state = self:update(current_state, params)
  end
end

------------------------------------------------------------------------
-- Additional Suggestions Applied:

-- Error Handling
function fsm:validate()
  for state, transitions in pairs(self.transitions) do
    for next_state, trigger in pairs(transitions) do
      if not self.triggers[trigger] then
        error("Invalid trigger for transition from " .. state .. " to " .. next_state)
      end
    end
  end
end

-- State Entry and Exit Actions
function fsm:on_state_enter(state)
  print("Entering state:", state)
  -- Add entry actions here
end

function fsm:on_state_exit(state)
  print("Exiting state:", state)
  -- Add exit actions here
end

-- Hierarchical States
-- Implement as needed

-- State History
function fsm:update_state_history(current_state, history)
  table.insert(history, current_state)
end

function fsm:run_with_history()
  local current_state = self.states[1] -- Initial state
  local params = {}                    -- Parameters for trigger functions
  local history = {}                   -- Track history of states
  for _, state in ipairs(self.states) do
    self:on_state_enter(state)
    current_state = self:update(current_state, params)
    self:on_state_exit(state)
    self:update_state_history(current_state, history)
  end
  return history
end

-- Asynchronous Transitions
-- Implement as needed

-- External Configuration
-- Implement loading FSM configuration from external source

-- Visualization
-- Create a visual representation of the FSM

-- Unit Tests
-- Write unit tests for FSM functionality

-- Documentation
-- Document functions, parameters, and usage

------------------------------------------------------------------------

-- Validate FSM setup
fsm:validate()

-- Run FSM
fsm:run()

-- Run FSM with history tracking
local history = fsm:run_with_history()
print("State history:", table.concat(history, " -> "))
