-- fizzbuzz.lua

--[[
  imprime os números de 1 a n, mas:
    - para múltiplos de 3, imprime "Fizz",
    - para múltiplos de 5, imprime "Buzz",
    - para números múltiplos de ambos, imprime "FizzBuzz".
--]]

for i = 1, 100 do
  if i % 15 == 0 then
      print("FizzBuzz")
  elseif i % 3 == 0 then
      print("Fizz")
  elseif i % 5 == 0 then
      print("Buzz")
  else
      print(i)
  end
end
--> 1, 2, Fizz, 4, Buzz, Fizz, 7, 8, Fizz, Buzz,
--> 11, Fizz, 13, 14, FizzBuzz, ...
