-- fsm.lua

------------------------------------------------------------------------
-- fsm context

local fsm = {}

------------------------------------------------------------------------
-- fsm setup:

fsm.states = { "yellow", "red", "green" }

fsm.transitions = {
  yellow = { red = "time_expired" },
  red    = { green = "car_passed" },
  green  = { yellow = "time_expired" }
}

fsm.triggers = {
  time_expired = function()
    print("Time expired...")
    return true
  end,
  car_passed = function()
    print("Car passed...")
    return true
  end
}

------------------------------------------------------------------------
-- fsm loop:

function fsm:update(current_state)
  local possible_transitions = self.transitions[current_state]
  if possible_transitions then
    for next_state, trigger in pairs(possible_transitions) do
      print("Transition from", current_state, "to", next_state)
      if self.triggers[trigger]() then
        current_state = next_state
        return
      end
    end
  else
    print("No possible transitions from state:", current_state)
  end
end

------------------------------------------------------------------------
-- fsm main:

function fsm:run()
  for _, state in ipairs(self.states) do self:update(state) end
end

fsm:run()
------------------------------------------------------------------------
