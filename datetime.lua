-- datetime.lua

-- os.time:
print(os.time())                                                --> 1715105554
print(os.time({ year = 2024, month = 05, day = 07, hour = 0 })) --> 1715050800
print(os.time({ year = 2024, month = 05, day = 08, hour = 0 })) --> 1715137200

-- os.date:
print(os.date())                 --> 05/07/24 15:12:34
print(os.date("%c", 1715050800)) --> 05/07/24 00:00:00
print(os.date("%c", 1715105554)) --> 05/07/24 15:12:34
print(os.date("%c", 1715137200)) --> 05/08/24 00:00:00

-- Produce a datetime table:
local datetime = os.date("*t", 1715100459)
print(datetime.year) --> 2024
print(datetime.day)  --> 7

-- Formats the date as a string:
print(os.date())     --> 05/07/24 15:12:34
print(os.date("%c")) --> 05/07/24 15:12:34
print(os.date("%x")) --> 05/07/24
print(os.date("%X")) --> 15:12:34

-- Customizing date and time output formats:
print(os.date("%d/%m/%Y %X"))        --> 07/05/2024 15:12:34
print(os.date("%A, %d in %B in %Y")) --> Tuesday, 07 in May in 2024
