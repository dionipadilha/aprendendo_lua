-- principal.lua

--------------------------------------------------------------------------------
-- nº 1: Criar ferramentas

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
assert(somador:executar(2, 3) == 5)

local subtrator = Ferramenta:novo {
  nome = "subtrator",
  descricao = "Subtrai o segundo número do primeiro número",
  executar = function(self, primeiro_numero, segundo_numero)
    assert(type(primeiro_numero) == "number", "As entradas devem ser números.")
    assert(type(segundo_numero) == "number", "As entradas devem ser números.")
    return primeiro_numero - segundo_numero
  end
}
assert(subtrator:executar(2, 3) == -1)

local multiplicador = Ferramenta:novo {
  nome = "multiplicador",
  descricao = "multiplica dois números",
  executar = function(self, primeiro_numero, segundo_numero)
    assert(type(primeiro_numero) == "number", "As entradas devem ser números.")
    assert(type(segundo_numero) == "number", "As entradas devem ser números.")
    return primeiro_numero * segundo_numero
  end
}
assert(multiplicador:executar(2, 3) == 6)

--------------------------------------------------------------------------------
-- nº 2: Criar Agentes

local Agente = require "agente"

local Ana = Agente:novo {
  papel = "Exploradora Generalista",
  objetivo = "Descobrir novas fórmulas matemáticas",
  historia = [[Outrora matemática em uma universidade renomada,
  Ana agora explora territórios inexplorados de números e equações.]],
  ferramentas = { somador, multiplicador }
}
assert(Ana.papel == "Exploradora Generalista")

local Bob = Agente:novo {
  papel = "Explorador Especialista em Subtração",
  objetivo = "Manipular números negativos",
  historia = [[Outrora matemático em uma universidade renomada,
  Bob agora explora territórios inexplorados de números negativos.]],
  ferramentas = { subtrator }
}
assert(Bob.papel == "Explorador Especialista em Subtração")

--------------------------------------------------------------------------------
-- nº 3: Agentes usando Ferramentas

local Aplicativo = {
  tentar = function()
    assert(Ana:usar(somador, 2, 3) == 5)
    assert(Ana:usar(multiplicador, 2, 3) == 6)
    assert(Bob:usar(subtrator, 2, 3) == -1)
  end,

  capturar = function(excecao)
    print("Erro: " .. excecao)
  end
}

local finalmente = xpcall(Aplicativo.tentar, Aplicativo.capturar)
print(finalmente and "Todas as ações foram executadas com sucesso!")

--------------------------------------------------------------------------------
-- nº 4: alguma sugestão?
