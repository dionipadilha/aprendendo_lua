local function json_decode(value)
  local position = 1

  local function decodeValue()
    local function skipWhitespace()
      while string.match(value:sub(position, position), "%s") do
        position = position + 1
      end
    end

    local function decodeString()
      local start = position + 1
      position = start
      while position <= #value do
        local char = value:sub(position, position)
        if char == '"' then
          local str = value:sub(start, position - 1)
          position = position + 1
          return str
        elseif char == "\\" then
          position = position + 1
        end
        position = position + 1
      end
      error("Unterminated string")
    end

    local function decodeNumber()
      local start = position
      while string.match(value:sub(position, position), "[%d%.%-eE+]") do
        position = position + 1
      end
      local numStr = value:sub(start, position - 1)
      local number = tonumber(numStr)
      if number then
        return number
      else
        error("Invalid number: " .. numStr)
      end
    end

    local function decodeLiteral(literal, result)
      if value:sub(position, position + #literal - 1) == literal then
        position = position + #literal
        return result
      end
      error("Invalid literal: " .. literal)
    end

    skipWhitespace()

    local char = value:sub(position, position)
    if char == '"' then
      return decodeString()
    elseif char == '{' then
      position = position + 1
      local obj = {}
      skipWhitespace()
      while value:sub(position, position) ~= '}' do
        skipWhitespace()
        local key = decodeString()
        skipWhitespace()
        if value:sub(position, position) ~= ':' then
          error("Expected ':' after key")
        end
        position = position + 1
        local val = decodeValue()
        obj[key] = val
        skipWhitespace()
        if value:sub(position, position) == ',' then
          position = position + 1
        elseif value:sub(position, position) ~= '}' then
          error("Expected ',' or '}'")
        end
        skipWhitespace()
      end
      position = position + 1
      return obj
    elseif char == '[' then
      position = position + 1
      local arr = {}
      skipWhitespace()
      while value:sub(position, position) ~= ']' do
        local val = decodeValue()
        table.insert(arr, val)
        skipWhitespace()
        if value:sub(position, position) == ',' then
          position = position + 1
        elseif value:sub(position, position) ~= ']' then
          error("Expected ',' or ']'")
        end
        skipWhitespace()
      end
      position = position + 1
      return arr
    elseif string.match(char, "[%d%-]") then
      return decodeNumber()
    elseif char == 't' then
      return decodeLiteral("true", true)
    elseif char == 'f' then
      return decodeLiteral("false", false)
    elseif char == 'n' then
      return decodeLiteral("null", nil)
    else
      error("Unexpected character: " .. char)
    end
  end

  return decodeValue()
end

return json_decode
