-- delay.lua

--  cross-platform delay:
local function delay(n)
  assert(n > 0)
  isLinux = os.getenv("HOME") or (os.getenv("XDG_SESSION_TYPE") and os.getenv("XDG_SESSION_TYPE") == "tty")
  if isLinux then
    os.execute("sleep " .. tonumber(n))
  else
    os.execute("ping -n " .. tonumber(n) .. " 127.0.0.1 > nul")
  end
  return true
end
