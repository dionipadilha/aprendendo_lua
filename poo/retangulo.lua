-- retangulo.lua

--------------------------------------------------------------------------------
-- Classe Retangulo:

local Retangulo = {}

-- Construtor:
function Retangulo:novo(cantoInferiorEsquerdo, cantoSuperiorDireito)
  -- Validar a entrada:
  assert(
    type(cantoInferiorEsquerdo) == "table" and #cantoInferiorEsquerdo == 2,
    "Canto inferior esquerdo inválido"
  )

  assert(
    type(cantoSuperiorDireito) == "table" and #cantoSuperiorDireito == 2,
    "Canto superior direito inválido"
  )

  -- Criar um novo objeto retângulo:
  local ret = {}
  setmetatable(ret, self)
  self.__index = self

  -- Extrair as coordenadas, NORMALIZANDO os cantos com min/max:
  -- contem() e intersecta() assumem x1 <= x2 e y1 <= y2, então cantos
  -- invertidos precisam ser reordenados aqui. (Um math.abs só nas
  -- dimensões mascararia a inversão: largura/altura sairiam "certas",
  -- mas os invariantes ficariam corrompidos em silêncio.)
  local x1, y1 = cantoInferiorEsquerdo[1], cantoInferiorEsquerdo[2]
  local x2, y2 = cantoSuperiorDireito[1], cantoSuperiorDireito[2]
  ret.x1, ret.x2 = math.min(x1, x2), math.max(x1, x2)
  ret.y1, ret.y2 = math.min(y1, y2), math.max(y1, y2)

  -- Calcular as dimensões (após a normalização, x2 >= x1 e y2 >= y1):
  ret.largura = ret.x2 - ret.x1
  ret.altura = ret.y2 - ret.y1

  return ret
end

-- Representação em texto:
function Retangulo:__tostring()
  local log = "Retangulo({%f, %f}, {%f, %f})"
  return log:format(self.x1, self.y1, self.x2, self.y2)
end

--------------------------------------------------------------------------------
-- Calcular propriedades acessadas com frequência:

-- Calcular o perímetro:
function Retangulo:perimetro()
  return 2 * (self.largura + self.altura)
end

-- Calcular a área:
function Retangulo:area()
  return self.largura * self.altura
end

-- Calcular o centroide:
function Retangulo:centroideDaRegiao()
  local x = (self.x1 + self.x2) / 2
  local y = (self.y1 + self.y2) / 2
  return { x, y }
end

-- Verificar se um ponto está dentro do retângulo:
function Retangulo:contem(ponto)
  local px, py = ponto[1], ponto[2]
  return px >= self.x1 and px <= self.x2 and py >= self.y1 and py <= self.y2
end

-- Verificar se outro retângulo intersecta este retângulo:
function Retangulo:intersecta(regiao)
  return not (
    regiao.x1 > self.x2
    or regiao.x2 < self.x1
    or regiao.y1 > self.y2
    or regiao.y2 < self.y1
  )
end

-- Escalar o retângulo por um dado fator:
function Retangulo:escalar(fator)
  local cx, cy = table.unpack(self:centroideDaRegiao())
  local meiaLargura = (self.largura * fator) / 2
  local meiaAltura = (self.altura * fator) / 2
  local cantoInferiorEsquerdo = { cx - meiaLargura, cy - meiaAltura }
  local cantoSuperiorDireito = { cx + meiaLargura, cy + meiaAltura }
  -- getmetatable(self) é a CLASSE da instância: numa subclasse de
  -- Retangulo, as fábricas internas devolvem instâncias da subclasse
  -- ("Retangulo:novo" fixo aqui quebraria esse polimorfismo):
  return getmetatable(self):novo(cantoInferiorEsquerdo, cantoSuperiorDireito)
end

-- Mover o retângulo por um dado deslocamento:
function Retangulo:mover(dx, dy)
  local cantoInferiorEsquerdo = { self.x1 + dx, self.y1 + dy }
  local cantoSuperiorDireito = { self.x2 + dx, self.y2 + dy }
  -- getmetatable(self): preserva a classe da instância (ver escalar)
  return getmetatable(self):novo(cantoInferiorEsquerdo, cantoSuperiorDireito)
end

-- Redimensionar o retângulo para novas dimensões:
function Retangulo:redimensionar(novaLargura, novaAltura)
  assert(novaLargura > 0 and novaAltura > 0, "Dimensões inválidas")
  local cantoInferiorEsquerdo = { self.x1, self.y1 }
  local cantoSuperiorDireito = { self.x1 + novaLargura, self.y1 + novaAltura }
  -- getmetatable(self): preserva a classe da instância (ver escalar)
  return getmetatable(self):novo(cantoInferiorEsquerdo, cantoSuperiorDireito)
end

--------------------------------------------------------------------------------
-- Exemplo de uso:

-- criar uma instância de retângulo:
local ret1 = Retangulo:novo({ 0, 0 }, { 1, 3 })
print(ret1) --> Retangulo({0.000000, 0.000000}, {1.000000, 3.000000})
assert(tostring(ret1) == "Retangulo({0.000000, 0.000000}, {1.000000, 3.000000})")

-- obter a geometria básica:
print(ret1:perimetro()) --> 8
print(ret1:area())      --> 3
assert(ret1:perimetro() == 8)
assert(ret1:area() == 3)

-- obter o centroide do retângulo:
local centroide = ret1:centroideDaRegiao()
print(table.unpack(centroide)) --> 0.5	1.5
print(ret1:contem(centroide))  --> true
print(ret1:contem({ 1, 4 }))   --> false
assert(centroide[1] == 0.5 and centroide[2] == 1.5)
assert(ret1:contem(centroide) == true)
assert(ret1:contem({ 1, 4 }) == false)

-- Verificar se outro retângulo intersecta este retângulo:
local ret2 = Retangulo:novo({ 0.5, 0.5 }, { 2, 4 })
print(ret1:intersecta(ret2)) --> true
assert(ret1:intersecta(ret2) == true)

-- obter o retângulo escalado (ret1 permanece intacto):
local retEscalado = ret1:escalar(2)
print(ret1)        --> Retangulo({0.000000, 0.000000}, {1.000000, 3.000000})
print(retEscalado) --> Retangulo({-0.500000, -1.500000}, {1.500000, 4.500000})
assert(tostring(ret1) == "Retangulo({0.000000, 0.000000}, {1.000000, 3.000000})")
assert(tostring(retEscalado) == "Retangulo({-0.500000, -1.500000}, {1.500000, 4.500000})")

-- mover o retângulo:
local retMovido = ret1:mover(1, 1)
print(retMovido) --> Retangulo({1.000000, 1.000000}, {2.000000, 4.000000})
assert(tostring(retMovido) == "Retangulo({1.000000, 1.000000}, {2.000000, 4.000000})")

-- redimensionar o retângulo:
local retRedimensionado = ret1:redimensionar(2, 4)
print(retRedimensionado) --> Retangulo({0.000000, 0.000000}, {2.000000, 4.000000})
assert(tostring(retRedimensionado) == "Retangulo({0.000000, 0.000000}, {2.000000, 4.000000})")

-- cantos invertidos são aceitos: o construtor normaliza e produz o
-- MESMO retângulo de ret1 — e os invariantes de contem() se mantêm:
local retInvertido = Retangulo:novo({ 1, 3 }, { 0, 0 })
assert(tostring(retInvertido) == tostring(ret1))
assert(retInvertido:contem(retInvertido:centroideDaRegiao()))

--------------------------------------------------------------------------------
-- Retornar a classe Retangulo:

return Retangulo

--------------------------------------------------------------------------------
