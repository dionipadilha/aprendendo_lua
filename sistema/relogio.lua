-- relogio.lua

-- Relógio de PAREDE: os.time devolve o horário do sistema (época/epoch,
-- em segundos inteiros) e os.difftime calcula a diferença entre dois
-- instantes. Para esperar sem ocupar a CPU, delegamos ao sistema (sleep):
-- uma espera ociosa que o relógio de parede enxerga — e os.clock (tempo
-- de CPU) não enxergaria. Veja cpu_vs_parede.lua.

local inicio = os.time()
os.execute("sleep 1") -- espera ociosa de 1 segundo
local fim = os.time()

local decorrido = os.difftime(fim, inicio)
print(decorrido) --> 1.0 (às vezes 2.0: os.time tem resolução de 1 segundo)
assert(decorrido >= 1 and decorrido <= 2)
