-- fizzbuzz.lua

--[[
  prints the numbers 1 to n, but:
    - for multiples of 3, it prints "Fizz",
    - for multiples of 5, it prints "Buzz",
    - for numbers which are multiples of both, it prints "FizzBuzz".
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
