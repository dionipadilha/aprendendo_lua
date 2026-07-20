-- cpu_vs_parede.lua

-- Duas medidas de tempo bem diferentes:
--   * os.clock → tempo de CPU consumido pelo processo (ideal para benchmark);
--   * os.time  → tempo de PAREDE (o relógio real; resolução de 1 segundo).
-- Confundir as duas é um erro clássico: um "cronômetro" feito com os.clock
-- só parece funcionar quando o programa ocupa a CPU o tempo todo.

--------------------------------------------------------------------------------
-- #1: durante uma espera OCIOSA (sleep), a CPU quase não trabalha:
-- os.clock quase não avança, mas os.time avança.

local dormir = require "dormir"

local cpuInicio, paredeInicio = os.clock(), os.time()
dormir(1) -- o processo fica ocioso por 1 segundo
local cpuDecorrido = os.clock() - cpuInicio
local paredeDecorrida = os.difftime(os.time(), paredeInicio)

print(("espera ociosa  | CPU: %.3f s | parede: %d s"):format(cpuDecorrido, paredeDecorrida))
--> espera ociosa  | CPU: 0.000 s | parede: 1 s

assert(cpuDecorrido < 0.5, "uma espera ociosa não deveria consumir CPU")
assert(paredeDecorrida >= 1, "o relógio de parede deve avançar durante o sleep")

--------------------------------------------------------------------------------
-- #2: durante um busy-wait (laço que ocupa a CPU), os.clock avança:

local cpuInicio2 = os.clock()
while os.clock() - cpuInicio2 < 0.2 do end -- trabalho de CPU por 0.2 s
local cpuDecorrido2 = os.clock() - cpuInicio2

print(("busy-wait      | CPU: %.3f s"):format(cpuDecorrido2))
--> busy-wait      | CPU: 0.200 s

assert(cpuDecorrido2 >= 0.2, "o busy-wait deve consumir tempo de CPU")

print("resumo: os.clock mede CPU; os.time mede o relógio de parede.")
