-- datetime_linux.lua

-- os.time:
print(os.time())                                                --> 1715127666
print(os.time({ year = 2024, month = 05, day = 07, hour = 0 })) --> 1715050800
print(os.time({ year = 2024, month = 05, day = 08, hour = 0 })) --> 1715137200
print(os.difftime(1715137200, 1715050800))                      --> 86400.0

-- os.date:
print(os.date())                 --> Tue May  7 21:21:06 2024
print(os.date("%c", 1715050800)) --> Tue May  7 00:00:00 2024
print(os.date("%c", 1715127666)) --> Tue May  7 21:21:06 2024
print(os.date("%c", 1715137200)) --> Wed May  8 00:00:00 2024

-- Produce a datetime table:
local datetime = os.date("*t", 1715100459)
print(datetime.year) --> 2024
print(datetime.day)  --> 7

-- Formats the date as a string:
print(os.date())     --> Tue May  7 21:21:06 2024
print(os.date("%c")) --> Tue May  7 21:21:06 2024
print(os.date("%x")) --> 05/07/24
print(os.date("%X")) --> 21:21:06

-- Customizing date output formats:
print(os.date("%d/%m/%Y %X"))        --> 07/05/2024 21:21:06
print(os.date("%A, %d in %B in %Y")) --> Tuesday, 07 in May in 2024

-- os.clock
local function delay(interval)
  local stop = os.clock() + interval
  while os.clock() < stop do end
end

local start = os.clock()
delay(5)            -- seconds
local stop = os.clock()
print(stop - start) --> 5.000007
