-- ferramentas_basicas.lua

local Ferramenta = require "ferramenta"

local somador = Ferramenta:novo {
  nome = "somador",
  descricao = "soma dois números",
  executar = function(self, primeiro_numero, segundo_numero)
    assert(type(primeiro_numero) == "number", "As entradas devem ser números.")
    assert(type(segundo_numero) == "number", "As entradas devem ser números.")
    return primeiro_numero + segundo_numero
  end
}

local subtrator = Ferramenta:novo {
  nome = "subtrator",
  descricao = "Subtrai o segundo número do primeiro número",
  executar = function(self, primeiro_numero, segundo_numero)
    assert(type(primeiro_numero) == "number", "As entradas devem ser números.")
    assert(type(segundo_numero) == "number", "As entradas devem ser números.")
    return primeiro_numero - segundo_numero
  end
}

local multiplicador = Ferramenta:novo {
  nome = "multiplicador",
  descricao = "multiplica dois números",
  executar = function(self, primeiro_numero, segundo_numero)
    assert(type(primeiro_numero) == "number", "As entradas devem ser números.")
    assert(type(segundo_numero) == "number", "As entradas devem ser números.")
    return primeiro_numero * segundo_numero
  end
}

local divisor = Ferramenta:novo {
  nome = "divisor",
  descricao = "Divide o primeiro número pelo segundo número",
  executar = function(self, primeiro_numero, segundo_numero)
    assert(type(primeiro_numero) == "number", "As entradas devem ser números.")
    assert(type(segundo_numero) == "number", "As entradas devem ser números.")
    assert(type(segundo_numero) ~= 0, "Divisão por zero não é permitida.")
    return primeiro_numero / segundo_numero
  end
}

-- asserções básicas:
assert(multiplicador:executar(2, 3) == 6)
assert(somador:executar(2, 3) == 5)
assert(subtrator:executar(5, 3) == 2)
assert(divisor:executar(6, 3) == 2)

return {
  somador = somador,
  subtrator = subtrator,
  multiplicador = multiplicador,
  divisor = divisor
}

--------------------------------------------------------------------------------
