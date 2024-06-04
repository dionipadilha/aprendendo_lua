--  weakkeys.lua

--------------------------------------------------------------------------------
-- weakkeys: allow garbage collection of weakly referenced objects.

-- #1. Create a weak table with weak keys for caching:
local weaktable = setmetatable({}, { __mode = "k" })

-- #2. Adding weak keys:
local key = {}
weaktable[key] = "x"
for k, v in pairs(weaktable) do print(k, v) end
--> table: 00000000001f9e20	x

-- #3. Replacing the previous reference:
key = {}
weaktable[key] = "y"
for k, v in pairs(weaktable) do print(k, v) end
--> table: 00000000001f9e20	x
--> table: 00000000001f9e20	y

-- #4. Collecting the weak keys:
collectgarbage()
for k, v in pairs(weaktable) do print(k, v) end
--> table: 00000000001fa2e0	y

--------------------------------------------------------------------------------
-- Implementation: User Session Caching

-- #1. Create a weak table with weak keys for caching user sessions:
local sessionCache = setmetatable({}, { __mode = "k" })

-- #2. Defining the User class:
local User = {name = "" }

function User:new(object)
  self.__index = self
  object = object or {}
  return setmetatable(object, self)
end

-- #2. Defining the Session class:
local Session = {}

function Session:new(object)
  self.__index = self
  object = object or {}
  return setmetatable(object, self)
end

-- #4. Adding user sessions to the cache:
local user1 = User:new { name = "Ana" }
local user2 = User:new { name = "Bob" }

sessionCache[user1] = Session:new { data = "data for user #1" }
sessionCache[user2] = Session:new { data = "data for user #2" }

print("Sessions after adding users:")
for k, v in pairs(sessionCache) do print(k.name, v.data) end
--> Ana	data for user #1
--> Bob	data for user #2

-- #5. Simulating the session expiration:
user1 = nil
collectgarbage()
print("Sessions after garbage collection:")
for k, v in pairs(sessionCache) do print(k.name, v.data) end
--> Bob	data for user #2
