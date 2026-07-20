local JSON = require "json"

local function principal(tabelaLua)
  local json = JSON:codificar(tabelaLua)
  print(json)
  local tabelaDecodificada = JSON:decodificar(json)
  print(tabelaDecodificada.nome) --> Bob
  for _, passatempo in ipairs(tabelaDecodificada.passatempos) do print(passatempo) end
end

local tabelaLua = {
  nome = "Bob",
  idade = 42,
  ehEstudante = false,
  passatempos = { "leitura", "jogos", "programação" },
  endereco = {
    rua = "123 Lua Lane",
    cidade = "Scripttown",
    cep = "12345"
  }
}

principal(tabelaLua)
