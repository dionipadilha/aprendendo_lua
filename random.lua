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

--------------------------------------------------------------------------------
-- enhanced math.randomseed:

-- avoid using math.randomseed without arguments
-- using the same seed will always produce the same sequence of random numbers.

-- for better randomness try:
print(math.randomseed(os.time())) --> 1715880897	0

-- using multiple entropy sources

local sources = {
  tostring(os.time()):reverse():sub(1, 6),
  tostring(os.clock()):reverse():sub(1, 6)
}
local seed = tonumber(table.concat(sources))
print(math.randomseed(seed)) --> 485588220	0
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


local function randomPassword(charset, n)
  local result = {}
  for i = 1, n do
    local rand = math.random(1, #charset)
    table.insert(result, charset:sub(rand, rand))
  end
  return table.concat(result)
end

math.randomseed(os.time())
local charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
print(randomPassword(charset, 8))  --> AHWWxNVo
print(randomPassword(charset, 10)) --> C8MrMpBG1g

--------------------------------------------------------------------------------
-- example #3: random time generator with customizable range

local function randomTimeGenerator(min, max)
  local datetime = "%d/%m/%Y %X" -- dd/mm/yyyy hh:mm:ss
  local rand = math.random(min, max)
  return (os.date(datetime, rand))
end

local now = os.time()
local day = 86400 -- 24 * 60 * 60s = 86400s
local min = now - day
local max = now + day

math.randomseed(now)

print(randomTimeGenerator(min, max)) --> 16/05/2024 19:17:51
print(randomTimeGenerator(min, max)) --> 16/05/2024 05:04:51

--------------------------------------------------------------------------------
