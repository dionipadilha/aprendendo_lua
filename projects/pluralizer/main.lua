-- Requirements:

local irregulars = require "irregulars"
local exceptions = require "exceptions"
local regular = require "regular"

-- Define your main function:
local function plural(word)
  -- Input Validation
  assert(word and type(word) == "string", "Invalid word")

  -- Preprocessing
  word = word:lower()

  -- Check irregulars
  local irregularPlural = irregulars(word)
  if irregularPlural then return irregularPlural end

  -- Check exceptions
  local exceptionPlural = exceptions(word)
  if exceptionPlural then return exceptionPlural end

  -- Default apply patterns
  local regularPlural = regular(word)
  return regularPlural
end

return plural
