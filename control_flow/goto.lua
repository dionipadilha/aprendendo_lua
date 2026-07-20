-- goto.lua

local a = 0

::start::
a = a + 1
if a < 10 then
  goto start
else
  goto stop
end

::jump::
print("Jumped code")


::stop::
print("Stop code")
