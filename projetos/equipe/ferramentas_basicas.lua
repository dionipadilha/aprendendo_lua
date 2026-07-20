-- ferramentas_basicas.lua

local Ferramenta = require "ferramenta"

local somador = Ferramenta:novo {
  nome = "somador",
  descricao = "soma dois números",
  executar = function(self, primeiroNumero, segundoNumero)
    assert(type(primeiroNumero) == "number", "As entradas devem ser números.")
    assert(type(segundoNumero) == "number", "As entradas devem ser números.")
    return primeiroNumero + segundoNumero
  end
}

local subtrator = Ferramenta:novo {
  nome = "subtrator",
  descricao = "Subtrai o segundo número do primeiro número",
  executar = function(self, primeiroNumero, segundoNumero)
    assert(type(primeiroNumero) == "number", "As entradas devem ser números.")
    assert(type(segundoNumero) == "number", "As entradas devem ser números.")
    return primeiroNumero - segundoNumero
  end
}

local multiplicador = Ferramenta:novo {
  nome = "multiplicador",
  descricao = "multiplica dois números",
  executar = function(self, primeiroNumero, segundoNumero)
    assert(type(primeiroNumero) == "number", "As entradas devem ser números.")
    assert(type(segundoNumero) == "number", "As entradas devem ser números.")
    return primeiroNumero * segundoNumero
  end
}

local divisor = Ferramenta:novo {
  nome = "divisor",
  descricao = "Divide o primeiro número pelo segundo número",
  executar = function(self, primeiroNumero, segundoNumero)
    assert(type(primeiroNumero) == "number", "As entradas devem ser números.")
    assert(type(segundoNumero) == "number", "As entradas devem ser números.")
    -- Compare o VALOR com zero (comparar type() com 0 nunca dispara,
    -- pois type() sempre devolve uma string).
    assert(segundoNumero ~= 0, "Divisão por zero não é permitida.")
    return primeiroNumero / segundoNumero
  end
}

-- asserções básicas:
assert(multiplicador:executar(2, 3) == 6)
assert(somador:executar(2, 3) == 5)
assert(subtrator:executar(5, 3) == 2)
assert(divisor:executar(6, 3) == 2)

-- dividir por zero deve falhar com a mensagem prevista:
local ok, erro = pcall(function() return divisor:executar(6, 0) end)
assert(not ok, "dividir por zero deveria lançar um erro")
assert(tostring(erro):find("Divisão por zero não é permitida."),
  "mensagem de erro inesperada: " .. tostring(erro))

return {
  somador = somador,
  subtrator = subtrator,
  multiplicador = multiplicador,
  divisor = divisor
}

--------------------------------------------------------------------------------
