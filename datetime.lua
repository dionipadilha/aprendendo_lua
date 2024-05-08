-- datetime.lua

-- Getting Epoch Timestamps:
local now = os.time()
print(now) --> 1715136403

-- Calculates epoch timestamps for specific datetimes:
local today = os.time({ year = 2024, month = 05, day = 07, hour = 00 })
local tomorrow = os.time({ year = 2024, month = 05, day = 08, hour = 00 })
print(today)    --> 1715050800
print(tomorrow) --> 1715137200

-- calculates the difference between two timestamps in seconds:
local one_day = os.difftime(tomorrow, today)
print(one_day) --> 86400.0 (seconds)

-- Formats a timestamp into a human-readable datetime string.
local traditional_form = "%d/%m/%Y %X"
print(os.date(traditional_form, now))           --> 07/05/2024 23:46:43
print(os.date(traditional_form, now + one_day)) --> 08/05/2024 23:46:43
print(os.date(traditional_form, today))         --> 07/05/2024 00:00:00
print(os.date(traditional_form, tomorrow))      --> 08/05/2024 00:00:00

-- Customizing date output formats:
local customized_form = "%A, %d in %B in %Y"
print(os.date(customized_form, today))    --> Tuesday, 07 in May in 2024
print(os.date(customized_form, tomorrow)) --> Wednesday, 08 in May in 2024

-- Converts a timestamp into a table with datetime components:
local datetime = os.date("*t", now)
print(datetime.year)  --> 2024
print(datetime.month) --> 5
print(datetime.day)   --> 7
print(datetime.hour)  --> 23
print(datetime.min)   --> 46
print(datetime.sec)   --> 43
