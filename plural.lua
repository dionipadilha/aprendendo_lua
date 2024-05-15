-- plural.lua

-- plural of english words based on their endings.

--------------------------------------------------------------------------------
local function endswith(word, case)
  --
  assert(word and type(word) == "string", "Invalid word")
  assert(case and type(case) == "string", "Invalid case")
  --
  return word:sub(- #case) == case
end

--------------------------------------------------------------------------------
local function getSuffix(word, specialCases)
  local defaultCases = { "ss", "x", "ch", "sh" }
  specialCases = specialCases or defaultCases
  --
  assert(word and type(word) == "string", "Invalid word")
  assert(specialCases)
  assert(specialCases and type(specialCases) == "table", "Invalid special cases")
  --
  for _, case in ipairs(specialCases) do
    if endswith(word, case) then return "es" end
  end
  return "s"
end

--------------------------------------------------------------------------------
local function regularPlural(word)
  return word .. getSuffix(word)
end

--------------------------------------------------------------------------------
-- unit test

local words = { "dog", "dish" }

for _, word in ipairs(words) do
  print(regularPlural(word))
end

--------------------------------------------------------------------------------
