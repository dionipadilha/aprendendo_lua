local function busyWaitDelay(n)
  assert(n > 0)
  local startTime = os.clock()
  while os.clock() - startTime < n do
    -- nothing
  end
end

return busyWaitDelay
