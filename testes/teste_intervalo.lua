local intervalo = require "intervalo"

local function sequencia(iteradorDeIntervalo)
  local t = {}
  for n in iteradorDeIntervalo do table.insert(t, n) end
  return table.concat(t, ", ")
end

local function casosNormais()
  assert(sequencia(intervalo(3)) == "1, 2, 3", "teste #1")
  assert(sequencia(intervalo(3, 6)) == "3, 4, 5, 6", "teste #2")
  assert(sequencia(intervalo(3, 9, 2)) == "3, 5, 7, 9", "teste #3")
  assert(sequencia(intervalo(-6, -3, 1)) == "-6, -5, -4, -3", "teste #4")
  assert(sequencia(intervalo(6, 3, -1)) == "6, 5, 4, 3", "teste #5")
end

local function casosLimite()
  assert(sequencia(intervalo(0)) == "", "teste #6")
  assert(sequencia(intervalo(-3)) == "", "teste #7")
  assert(sequencia(intervalo(9, 6)) == "", "teste #8")
  assert(sequencia(intervalo(9, 6, 2)) == "", "teste #9")
  assert(sequencia(intervalo(6, 9, -2)) == "", "teste #10")
end

local function testeUnitario()
  casosNormais()
  casosLimite()
  print("O TesteUnitario lida corretamente com diferentes cenários!")
  return true
end

local function tratadorDeErro(msgDeErro)
  print("Falha: ", msgDeErro)
end

xpcall(testeUnitario, tratadorDeErro)
