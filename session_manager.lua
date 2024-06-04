--------------------------------------------------------------------------------
-- Model

-- Define the Abstrct class:
local Class = {
  new = function(self, object)
    self.__index = self
    object = object or {}
    return setmetatable(object, self)
  end
}

-- Define the Concrete classes:
local User = Class:new { id = 0, name = "" }
local Session = Class:new {}
local Cache = Class:new { __mode = "k" }

--------------------------------------------------------------------------------
-- View

local SessionView = Class:new {}

function SessionView:printSessions(sessionCache)
  for k, v in pairs(sessionCache) do
    print(k.name, v.data)
  end
end

--------------------------------------------------------------------------------
-- Controller

local SessionManager = Class:new {
  cache = {},
  view = {}
}

function SessionManager:addSession(user, sessionData)
  self.cache[user] = Session:new { data = sessionData }
end

function SessionManager:displaySessions()
  self.view:printSessions(self.cache)
end

--------------------------------------------------------------------------------
-- Main

local manager = SessionManager:new {
  cache = Cache:new(),
  view = SessionView:new()
}

local user1 = User:new { id = 1, name = "Ana" }
local user2 = User:new { id = 2, name = "Bob" }

manager:addSession(user1, "data for user #1")
manager:addSession(user2, "data for user #2")

print("Sessions after adding users:")
manager:displaySessions()

user1 = nil
collectgarbage()
print("Sessions after garbage collection:")
manager:displaySessions()
--------------------------------------------------------------------------------
