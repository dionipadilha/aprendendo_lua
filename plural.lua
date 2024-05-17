-- Function to get the plural form of irregular words
local function getIrregularPlural(word)
  local irregulars = {
    man = "men",
    woman = "women",
    child = "children",
    person = "people",
    tooth = "teeth",
    foot = "feet",
    mouse = "mice",
    louse = "lice",
    goose = "geese",
    ox = "oxen",
    sheep = "sheep",
    fish = "fish",
    deer = "deer",
    species = "species",
    series = "series",
    -- ... more as needed
  }
  return irregulars[word] or ""
end

-- Function to get the plural form of exception words ending with 'f' or 'fe'
local function getExceptionPlural(word)
  local exceptions = {
    roof = "roofs",
    chef = "chefs",
    chief = "chiefs",
    belief = "beliefs",
    -- ... more as needed
  }
  return exceptions[word] or ""
end

-- Function to apply specific pluralization rules
local function applyPluralizationRules(word)
  if word:match("is$") then
    return word:sub(1, -3) .. "es"
  elseif word:match("on$") then
    return word:sub(1, -3) .. "a"
  elseif word:match("f$") and not word:match("ff$") then
    return word:sub(1, -2) .. "ves"
  elseif word:match("fe$") then
    return word:sub(1, -3) .. "ves"
  elseif word:match("[aeiou]y$") then
    return word .. "s"
  elseif word:match("y$") then
    return word:sub(1, -2) .. "ies"
  elseif word:match("[xs]$") then
    return word .. "es"
  elseif word:match("[chshz]$") then
    if word == "quiz" then
      return word .. "zes"
    else
      return word .. "es"
    end
  elseif word:match("o$") then
    if word == "potato" or word == "tomato" or word == "hero" then
      return word .. "es"
    else
      return word .. "s"
    end
  end
  return ""
end

-- Main plural function
local function plural(word)
  assert(word and type(word) == "string", "Invalid word")
  word = word:lower()

  -- Check for irregular plurals
  local pluralForm = getIrregularPlural(word)
  if pluralForm ~= "" then return pluralForm end

  -- Check for specific exceptions
  pluralForm = getExceptionPlural(word)
  if pluralForm ~= "" then return pluralForm end

  -- Apply specific pluralization rules
  pluralForm = applyPluralizationRules(word)
  if pluralForm ~= "" then return pluralForm end

  -- Default rule (add 's')
  return word .. "s"
end

--------------------------------------------------------------------------------
-- Test cases
local testCases = {
  book = "books",
  car = "cars",
  house = "houses",
  apple = "apples",
  cat = "cats",
  man = "men",
  woman = "women",
  child = "children",
  person = "people",
  tooth = "teeth",
  foot = "feet",
  mouse = "mice",
  louse = "lice",
  goose = "geese",
  ox = "oxen",
  sheep = "sheep",
  fish = "fish",
  deer = "deer",
  species = "species",
  series = "series",
  knife = "knives",
  life = "lives",
  elf = "elves",
  wolf = "wolves",
  calf = "calves",
  roof = "roofs",
  chef = "chefs",
  chief = "chiefs",
  belief = "beliefs",
  city = "cities",
  boy = "boys",
  day = "days",
  baby = "babies",
  potato = "potatoes",
  tomato = "tomatoes",
  hero = "heroes",
  box = "boxes",
  bus = "buses",
  dress = "dresses",
  church = "churches",
  brush = "brushes",
  quiz = "quizzes",
  photo = "photos",
  piano = "pianos",
  halo = "halos",
}

-- Run tests
local allTestsPassed = true
local log = "Error: '%s' -> expected '%s', got '%s'"
for word, expectedPlural in pairs(testCases) do
  local result = plural(word)
  if result ~= expectedPlural then
    print(log:format(word, expectedPlural, result))
    allTestsPassed = false
  end
end

if allTestsPassed then
  print("All tests passed!")
else
  print("Some tests failed.")
end
