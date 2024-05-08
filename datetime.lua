-- datetime.lua

-- Getting the epoch timestamps:
local now = os.time()
local today = os.time({ year = 2024, month = 05, day = 07, hour = 00 })
local tomorrow = os.time({ year = 2024, month = 05, day = 08, hour = 00 })
print(now)      --> 1715136403
print(today)    --> 1715050800
print(tomorrow) --> 1715137200

-- Calculates the difference between two timestamps:
local one_day = os.difftime(tomorrow, today)
print(one_day) --> 86400.0 (24*60*60 = 86400 seconds)

-- Formats a timestamp into a datetime string:
local datetime = "%d/%m/%Y %X"
print(os.date(datetime, now))           --> 07/05/2024 23:46:43
print(os.date(datetime, now + one_day)) --> 08/05/2024 23:46:43
print(os.date(datetime, today))         --> 07/05/2024 00:00:00
print(os.date(datetime, tomorrow))      --> 08/05/2024 00:00:00

-- Formats a timestamp into a custom date string:
local customdate = "%A, %d in %B in %Y"
print(os.date(customdate, today))    --> Tuesday, 07 in May in 2024
print(os.date(customdate, tomorrow)) --> Wednesday, 08 in May in 2024

-- Extracting datetime components:
local datetime = os.date("*t", now)
print(datetime.year)  --> 2024
print(datetime.month) --> 5
print(datetime.day)   --> 7
print(datetime.hour)  --> 23
print(datetime.min)   --> 46
print(datetime.sec)   --> 43
