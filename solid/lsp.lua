-- lsp.lua

-- Princípio da Substituição de Liskov (LSP):
-- Objetos de um subtipo devem poder substituir objetos do tipo base
-- SEM quebrar as expectativas (invariantes) de quem usa o tipo base.

--------------------------------------------------------------------------------
-- PARTE 1 — A VIOLAÇÃO
--
-- "Quadrado herda de Retangulo" é o contraexemplo clássico do LSP:
-- o quadrado precisa manter os lados iguais, então seus setters quebram
-- o invariante do retângulo (largura e altura independentes).
--------------------------------------------------------------------------------

-- O cliente abaixo foi escrito para a classe BASE: espera que definir a
-- largura NÃO altere a altura. Todo subtipo de Retangulo deveria honrar isso.
local function usarComoRetangulo(retangulo)
  retangulo:definirLargura(4)
  retangulo:definirAltura(5)
  local area = retangulo:area()
  assert(area == 20, "invariante violado: área esperada 20, obtida " .. area)
  return true
end

do
  local Retangulo = {}

  function Retangulo:novo(largura, altura)
    local retangulo = { largura = largura or 1, altura = altura or 1 }
    self.__index = self
    return setmetatable(retangulo, self)
  end

  function Retangulo:definirLargura(largura) self.largura = largura end

  function Retangulo:definirAltura(altura) self.altura = altura end

  function Retangulo:area() return self.largura * self.altura end

  -- Quadrado herda de Retangulo e sobrescreve os setters para manter
  -- os lados iguais — parece razoável, mas muda o comportamento
  -- observável que o cliente da base espera.
  local Quadrado = Retangulo:novo()

  function Quadrado:novo(lado)
    return Retangulo.novo(self, lado, lado)
  end

  function Quadrado:definirLargura(lado)
    self.largura = lado
    self.altura = lado
  end

  function Quadrado:definirAltura(lado)
    self.largura = lado
    self.altura = lado
  end

  -- Com a base, o contrato se sustenta:
  assert(usarComoRetangulo(Retangulo:novo()) == true)

  -- Substituindo o subtipo onde se espera a base, o invariante quebra:
  -- definirAltura(5) também mudou a largura, e a área vira 25, não 20.
  local ok, erro = pcall(usarComoRetangulo, Quadrado:novo(1))
  assert(not ok, "Quadrado deveria ter violado o contrato do Retangulo")
  assert(tostring(erro):find("área esperada 20"), "erro inesperado: " .. tostring(erro))
  print("Violação de LSP demonstrada: " .. erro)
end

--------------------------------------------------------------------------------
-- PARTE 2 — O REDESENHO CONFORME
--
-- Quadrado NÃO é um subtipo comportamental de Retangulo. A solução é
-- torná-los irmãos sob uma abstração cujo contrato ambos conseguem
-- honrar: Forma, que promete apenas `area()`.
--------------------------------------------------------------------------------

do
  local Forma = {}

  function Forma:novo(objeto)
    objeto = objeto or {}
    self.__index = self
    return setmetatable(objeto, self)
  end

  function Forma:area()
    error("Este método deve ser sobrescrito")
  end

  local Retangulo = Forma:novo()

  function Retangulo:novo(largura, altura)
    return Forma.novo(self, { largura = largura or 1, altura = altura or 1 })
  end

  function Retangulo:definirLargura(largura) self.largura = largura end

  function Retangulo:definirAltura(altura) self.altura = altura end

  function Retangulo:area() return self.largura * self.altura end

  -- Quadrado é irmão de Retangulo (ambos herdam só de Forma) e expõe a
  -- operação que consegue honrar: definir o LADO.
  local Quadrado = Forma:novo()

  function Quadrado:novo(lado)
    return Forma.novo(self, { lado = lado or 1 })
  end

  function Quadrado:definirLado(lado) self.lado = lado end

  function Quadrado:area() return self.lado * self.lado end

  -- O mesmo teste do cliente da Parte 1 continua passando para quem é,
  -- de fato, um Retangulo:
  assert(usarComoRetangulo(Retangulo:novo()) == true)

  -- E o contrato da abstração comum (Forma) vale para qualquer subtipo
  -- substituído onde se espera Forma:
  local function somarAreas(formas)
    local total = 0
    for _, forma in ipairs(formas) do
      local area = forma:area()
      assert(type(area) == "number" and area >= 0, "area() deve devolver número não negativo")
      total = total + area
    end
    return total
  end

  assert(somarAreas({ Retangulo:novo(3, 4), Quadrado:novo(5) }) == 12 + 25)
  print("Redesenho conforme o LSP: Retangulo e Quadrado substituem Forma sem surpresas.")
end
