-- fizzbuzz.lua

--[[
  imprime os números de 1 a n, mas:
    - para múltiplos de 3, imprime "Fizz",
    - para múltiplos de 5, imprime "Buzz",
    - para números múltiplos de ambos, imprime "FizzBuzz".
--]]

-- Devolve a saída de FizzBuzz para um número:
local function fizzbuzz(i)
  if i % 15 == 0 then
    return "FizzBuzz"
  elseif i % 3 == 0 then
    return "Fizz"
  elseif i % 5 == 0 then
    return "Buzz"
  else
    return i
  end
end

for i = 1, 100 do
  print(fizzbuzz(i))
end
--> 1, 2, Fizz, 4, Buzz, Fizz, 7, 8, Fizz, Buzz,
--> 11, Fizz, 13, 14, FizzBuzz, ...

-- Verificação:
assert(fizzbuzz(1) == 1)
assert(fizzbuzz(3) == "Fizz")
assert(fizzbuzz(5) == "Buzz")
assert(fizzbuzz(15) == "FizzBuzz")
assert(fizzbuzz(98) == 98)
