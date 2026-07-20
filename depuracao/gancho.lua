-- gancho.lua

-- debug.sethook instala uma função-gancho que o interpretador chama em
-- eventos da execução: "count" (a cada N instruções), "l" (a cada linha
-- nova), "c"/"r" (chamada/retorno de função). É o alicerce de depuradores,
-- profilers e cobertura — e um freio de emergência para código alheio.

--------------------------------------------------------------------------------
-- #1: gancho "count" — freio de segurança para laço infinito

-- O sandbox de ambiente (../modulos/ambientes.lua) controla o que o código
-- enxerga, mas não impede `while true do end`. O gancho "count" interrompe
-- QUALQUER código Lua depois de um orçamento de instruções da máquina
-- virtual — inclusive um laço que não toca em variável nenhuma.

local function executarComFreio(funcao, limiteDeInstrucoes)
  debug.sethook(function()
    debug.sethook() -- desliga ANTES de lançar (senão o gancho redispararia)
    error("freio: orçamento de instruções esgotado", 0) -- 0 = sem prefixo de posição
  end, "", limiteDeInstrucoes)
  local ok, resultado = pcall(funcao)
  debug.sethook() -- garante o desligamento também no caminho de sucesso
  return ok, resultado
end

-- o mesmo sandbox de ambientes.lua: modo "t" e ambiente vazio
local lacoInfinito = assert(load("while true do end", "=laco-infinito", "t", {}))

local ok, mensagem = executarComFreio(lacoInfinito, 10000)
assert(not ok) -- o pcall FALHOU: o laço infinito foi interrompido
assert(mensagem == "freio: orçamento de instruções esgotado")
print("laço infinito interrompido após 10000 instruções")

-- código comportado termina antes do orçamento e passa ileso:
local educado = assert(load("return 2 + 3", "=educado", "t", {}))
local okEducado, valor = executarComFreio(educado, 10000)
assert(okEducado and valor == 5)

--------------------------------------------------------------------------------
-- #2: gancho "l" — uma mini-cobertura de linhas

-- O gancho "l" dispara a cada linha nova executada: é o coração das
-- ferramentas de cobertura. Registramos as linhas RELATIVAS ao início da
-- função (linedefined), para o teste não depender da posição absoluta
-- deste arquivo.

local function classificar(n) -- linha relativa 0 (a definição)
  local dobro = n * 2         -- linha relativa 1
  if dobro > 10 then          -- linha relativa 2
    return "grande"           -- linha relativa 3
  end                         -- linha relativa 4
  return "pequeno"            -- linha relativa 5
end

local function medirCobertura(funcao, argumento)
  local inicio = debug.getinfo(funcao, "S").linedefined
  local linhasVisitadas = {}
  debug.sethook(function(_, linha)
    -- o gancho dispara para TODO o programa; filtramos só a função-alvo
    -- (nível 2 = o código interrompido; nível 1 é o próprio gancho)
    if debug.getinfo(2, "f").func == funcao then
      linhasVisitadas[#linhasVisitadas + 1] = linha - inicio
    end
  end, "l")
  local resultado = funcao(argumento)
  debug.sethook()
  return resultado, table.concat(linhasVisitadas, ",")
end

local resultado1, cobertura1 = medirCobertura(classificar, 3)
assert(resultado1 == "pequeno")
assert(cobertura1 == "1,2,5") -- o ramo do if (linha 3) NÃO executou

local resultado2, cobertura2 = medirCobertura(classificar, 6)
assert(resultado2 == "grande")
assert(cobertura2 == "1,2,3") -- agora executou; o return da linha 5, não

print("cobertura de classificar(3): linhas " .. cobertura1)
print("cobertura de classificar(6): linhas " .. cobertura2)
--> cobertura de classificar(3): linhas 1,2,5
--> cobertura de classificar(6): linhas 1,2,3

--------------------------------------------------------------------------------
-- #3: desligar — e o preço de manter ligado

-- debug.sethook() sem argumentos remove o gancho; debug.gethook() confirma:
assert(debug.gethook() == nil)

-- Custo: com um gancho "l" ou "count" ativo, o interpretador chama uma
-- função Lua a cada linha (ou lote de instruções) — a execução fica ordens
-- de grandeza mais lenta. Em produção, ligue o gancho em volta do trecho
-- investigado e desligue em seguida, como os dois exemplos acima fizeram.

print("ganchos \"count\" e \"l\" verificados e desligados!")
