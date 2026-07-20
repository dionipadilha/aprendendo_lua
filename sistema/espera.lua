-- espera.lua

-- Espera OCUPADA (busy-wait): prende a CPU em um laço até o tempo passar.
-- Usa os.clock porque o laço consome CPU — exatamente o que os.clock mede.
-- Para uma espera OCIOSA (sem gastar CPU), delegue ao sistema — veja
-- dormir.lua. Em cpu_vs_parede.lua as duas aparecem lado a lado.

-- Define uma função:
local function espera(n)
  assert(type(n) == "number" and n > 0, "a duração deve ser um número positivo")
  local tempoInicial = os.clock()
  while os.clock() - tempoInicial < n do
    -- nada: o laço ocupa a CPU de propósito
  end
end

-- Uso: espera curta, com medição de CPU.
local antes = os.clock()
espera(0.1)
local decorrido = os.clock() - antes

print(("esperou %.3f s de CPU"):format(decorrido)) --> esperou 0.100 s de CPU
assert(decorrido >= 0.1, "espera(0.1) deve consumir ao menos 0.1 s de CPU")
