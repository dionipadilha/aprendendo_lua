local function json_encode(value)
  local function encodeValue(v)
    if type(v) == "table" then
      local isArray = true
      local maxIndex = 0
      for k in pairs(v) do
        if type(k) ~= "number" or k < 1 or math.floor(k) ~= k then
          isArray = false
          break
        end
        if k > maxIndex then maxIndex = k end
      end

      if isArray then
        local items = {}
        for i = 1, maxIndex do
          table.insert(items, encodeValue(v[i]))
        end
        return "[" .. table.concat(items, ",") .. "]"
      else
        local items = {}
        for k, val in pairs(v) do
          table.insert(items, '"' .. k .. '":' .. encodeValue(val))
        end
        return "{" .. table.concat(items, ",") .. "}"
      end
    elseif type(v) == "string" then
      return '"' .. v:gsub('"', '\\"') .. '"'
    elseif type(v) == "number" or type(v) == "boolean" then
      return tostring(v)
    elseif v == nil then
      return "null"
    else
      error("Unsupported value type: " .. type(v))
    end
  end

  return encodeValue(value)
end

return json_encode
