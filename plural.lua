-- plural.lua

-- plural of english words based on their endings.

--------------------------------------------------------------------------------
-- #1. Takes a word and pluralizes it based on its ending:

local function plural(word)
  assert(word and type(word) == "string", "Invalid word")

  -- words ending in "y" after a consonant
  if word:sub(-1) == "y" and
      not word:sub(-2, -2):match("[aeiou]") then
    return word:sub(1, -2) .. "ies"
  end

  -- words ending in "x", "ss", "ch", or "sh"
  if word:sub(-1) == "x" or
      word:sub(-2) == "ss" or
      word:sub(-2) == "ch" or
      word:sub(-2) == "sh" then
    return word .. "es"
  end

  -- regular plurals
  return word .. "s"
end

--------------------------------------------------------------------------------
-- #2: Basic unit test:

local try = function(test, inputs, expected)
  print("[Running] basic unit test ...")
  -- Measure execution time
  local startTime = os.clock()
  --
  local log = [[assertion failed!
  input='%s', expected='%s', got='%s']]
  for i, case in ipairs(inputs) do
    local got = test(case)
    local check = expected[i]
    assert(got == check, log:format(case, check, got))
  end
  --
  local endTime = os.clock()
  print(string.format("[Done] exited in %.3f seconds", endTime - startTime))
end

local except = function(exception)
  local log = "[Exception] %s"
  print(log:format(exception))
end

--------------------------------------------------------------------------------
-- #3: Perform the tests:

xpcall(
  try,
  except,
  plural,                                           -- test
  { "dog", "dish", "city", "box", "kiss" },         -- inputs
  { "dogs", "dishes", "cities", "boxes", "kisses" } -- expected
)

--------------------------------------------------------------------------------
