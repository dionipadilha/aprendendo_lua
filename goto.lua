-- A simple example using goto

-- Function to demonstrate goto
local function exampleGoto()
  local count = 1

  ::start:: -- Label named 'start'
  print("Count: " .. count)
  count = count + 1

  if count <= 5 then
    goto start -- Jump back to the 'start' label
  end

  print("Finished looping.")
end

exampleGoto()
