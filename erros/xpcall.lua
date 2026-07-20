local App = {
  tentar = function(a, b)
    assert(a + b == 7)
  end,

  capturar = function(excecao)
    print(excecao)
  end
}

local resultado = xpcall(App.tentar, App.capturar, 6, 3)
print("finalmente ...")
