-- random.lua

-- purpose: demonstrate the usage of math.randomseed and math.random

--------------------------------------------------------------------------------
-- math.randomseed:

-- sets the seed for the pseudo-random number generator.

-- no arguments: Generates a seed with a weak attempt for randomness.
print("weak seed: ", math.randomseed()) --> 1715878877	15471192

-- one argument: sets the seed.
math.randomseed(1715878000)

-- two arguments: combine args into a single 128-bit seed.
math.randomseed(1715878877, 15471192)

-- avoid using math.randomseed without arguments:
-- using the same seed will always produce the same sequence of random numbers.
-- for better randomness try:
print(math.randomseed(os.time())) --> 1715880897	0
--------------------------------------------------------------------------------
-- math.random:

-- provides functions to generate pseudo-random numbers.

-- no arguments:
print(math.random()) --> 0.63586923496496

-- only one argument:
print(math.random(6))              --> 3
print(math.random(os.time()))      --> 1396479473
print(math.random(math.random(6))) --> 5

-- interval (m, n):
print(math.random(3, 6)) --> 4

--------------------------------------------------------------------------------
-- example #1: randomly select an item from a list

local function randomChoice(list)
  local index = math.random(1, #list)
  return list[index]
end

local colors = { "red", "green", "blue" }

math.randomseed(os.time())
print(randomChoice(colors)) --> blue
print(randomChoice(colors)) --> green

--------------------------------------------------------------------------------
-- example #2: generate a random alphanumeric string of a specified length


local function randomString(n)
  local charset = "abcdefghijklmnopqrstuvwxyz0123456789"
  local result = {}
  for i = 1, n do
    local rand = math.random(1, #charset)
    table.insert(result, charset:sub(rand, rand))
  end
  return table.concat(result)
end

math.randomseed(os.time())
print(randomString(8))  --> ap8dh2ds
print(randomString(10)) --> md27chy7b0

--------------------------------------------------------------------------------
-- example #3: random time generator over a period of one day


local function randomTimeGenerator()
  local now = os.time()
  local day = 86400              -- 24h * 60 min * 60s = 86400
  local datetime = "%d/%m/%Y %X" -- dd/mm/yyyy hh:mm:ss
  local rand = math.random(now - day, now + day)
  return (os.date(datetime, rand))
end

math.randomseed(os.time())
print(randomTimeGenerator()) --> 16/05/2024 19:17:51
print(randomTimeGenerator()) --> 16/05/2024 05:04:51

--------------------------------------------------------------------------------
