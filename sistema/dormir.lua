-- dormir.lua

-- Espera OCIOSA portátil: delega ao sistema operacional, deixando a CPU
-- livre (diferente do busy-wait de espera.lua, que ocupa a CPU).
-- O comando muda por plataforma: "sleep" existe no POSIX (Linux/macOS),
-- mas não no Windows — lá, o idioma clássico é o ping no loopback, que
-- aguarda cerca de 1 segundo entre as tentativas.

local function dormir(segundos)
  assert(type(segundos) == "number" and segundos > 0 and segundos % 1 == 0,
    "a duração deve ser um número inteiro positivo de segundos")
  -- package.config começa com o separador de caminhos: "\" indica Windows.
  local ehWindows = package.config:sub(1, 1) == "\\"
  local comando = ehWindows
      and ("ping -n %d 127.0.0.1 > nul"):format(segundos + 1)
      or ("sleep %d"):format(segundos)
  assert(os.execute(comando), "a espera ociosa falhou: " .. comando)
end

-- autoteste: dormir por 1 segundo avança o relógio de parede.
local antes = os.time()
dormir(1)
assert(os.difftime(os.time(), antes) >= 1, "dormir(1) deveria levar ao menos 1 s")

return dormir
