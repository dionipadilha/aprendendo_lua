local App = {
  try = function(a, b)
    assert(a + b == 7)
  end,

  excpet = function(excption)
    print(excption)
  end
}

local result = xpcall(App.try, App.excpet, 6, 3)
print("finaly ...")
