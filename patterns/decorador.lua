-- Define a função decoradora
local function meu_decorador(funcao)
  return function()
    print("Algo acontece antes de a função ser chamada.")
    funcao()
    print("Algo acontece depois de a função ser chamada.")
  end
end

-- Define a função a ser decorada
local function dizer_ola()
  print("Olá!")
end

-- Aplica o decorador
dizer_ola = meu_decorador(dizer_ola)

-- Chama a função decorada
dizer_ola()
