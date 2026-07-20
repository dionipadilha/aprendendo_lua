-- verificar_trilha.lua

-- O guarda ANTI-DERIVA da organização do repositório: confere que as
-- três fontes que descrevem as pastas continuam sincronizadas:
--   (a) tudo que trilha.lua declara existe no disco;
--   (b) toda lição do disco (.lua e .md das pastas de conteúdo) está
--       registrada em trilha.lua — inclusive os README.md de pasta,
--       que contam como lição de abertura;
--   (c) a tabela "Organização do repositório" do README.md tem
--       exatamente as pastas de trilha.lua, na mesma ordem e com os
--       mesmos temas.
--
-- Roda pela suíte (executar_testes.sh) a partir de site/: termina com
-- código 0 quando tudo bate e falha alto (código 1) na dessincronia.

-- A listagem do disco usa `find` (POSIX); no Windows a verificação é
-- pulada, como em gerar.lua — a CI Linux a executa sempre.
if package.config:sub(1, 1) == "\\" then
  print("Aviso: verificar_trilha.lua usa `find` (POSIX); no Windows a verificação é pulada.")
  return
end

local trilha = require "trilha"

local falhas = 0
local function falhar(mensagem)
  falhas = falhas + 1
  print("DESSINCRONIA: " .. mensagem)
end

local function existeArquivo(caminho)
  local arquivo = io.open(caminho, "rb")
  if arquivo then arquivo:close() end
  return arquivo ~= nil
end

--------------------------------------------------------------------------------
-- (a) tudo que a trilha declara existe no disco (e sem duplicatas)

local naTrilha = {}
for _, pasta in ipairs(trilha) do
  if not os.execute(("test -d '../%s'"):format(pasta.nome)) then
    falhar(("a pasta '%s/' da trilha não existe no disco"):format(pasta.nome))
  end
  assert(type(pasta.tema) == "string" and pasta.tema ~= "",
    "pasta sem tema na trilha: " .. pasta.nome)
  for _, item in ipairs(pasta.arquivos) do
    local caminho = pasta.nome .. "/" .. item[1]
    assert(type(item[2]) == "string" and item[2] ~= "",
      "lição sem descrição na trilha: " .. caminho)
    if naTrilha[caminho] then
      falhar("lição duplicada na trilha: " .. caminho)
    end
    naTrilha[caminho] = true
    if not existeArquivo("../" .. caminho) then
      falhar(("a lição '%s' da trilha não existe no disco"):format(caminho))
    end
  end
end

--------------------------------------------------------------------------------
-- (b) toda lição do disco está na trilha (site/_saida, que é saída
-- gerada e gitignorada, fica de fora)

for _, pasta in ipairs(trilha) do
  local comando = ("find '../%s' -type f \\( -name '*.lua' -o -name '*.md' \\)"
    .. " -not -path '*/_saida/*' | sort"):format(pasta.nome)
  local processo = assert(io.popen(comando))
  for caminho in processo:lines() do
    local relativo = caminho:gsub("^%.%./", "")
    if not naTrilha[relativo] then
      falhar(("lição no disco fora da trilha: %s (registre-a em site/trilha.lua)")
        :format(relativo))
    end
  end
  processo:close()
end

--------------------------------------------------------------------------------
-- (c) a tabela do README bate com a trilha: mesmas pastas, mesma
-- ordem, mesmos temas

local arquivoReadme = assert(io.open("../README.md", "rb"), "não achei ../README.md")
local readme = arquivoReadme:read("a")
arquivoReadme:close()

local pastasDoReadme = {}
for nome, tema in readme:gmatch("|%s*`([%w_]+)/`%s*|%s*(.-)%s*|") do
  table.insert(pastasDoReadme, { nome = nome, tema = tema })
end

if #pastasDoReadme ~= #trilha then
  falhar(("a tabela do README tem %d pastas; a trilha tem %d")
    :format(#pastasDoReadme, #trilha))
end
for indice = 1, math.max(#pastasDoReadme, #trilha) do
  local doReadme, daTrilha = pastasDoReadme[indice], trilha[indice]
  if doReadme and daTrilha then
    if doReadme.nome ~= daTrilha.nome then
      falhar(("posição %d: README tem '%s/', trilha tem '%s/'")
        :format(indice, doReadme.nome, daTrilha.nome))
    elseif doReadme.tema ~= daTrilha.tema then
      falhar(("tema de '%s/' divergiu:\n  README: %s\n  trilha: %s")
        :format(daTrilha.nome, doReadme.tema, daTrilha.tema))
    end
  end
end

--------------------------------------------------------------------------------

if falhas > 0 then
  print(("verificar_trilha: %d dessincronia(s) entre trilha.lua, disco e README.")
    :format(falhas))
  os.exit(1)
end
print(("trilha verificada: %d pastas em sincronia entre trilha.lua, disco e README.")
  :format(#trilha))
