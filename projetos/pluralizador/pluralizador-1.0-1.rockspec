-- Rockspec REAL e funcional do pluralizador — a CI o instala com
-- `luarocks make` e usa o módulo de fora desta pasta.
-- A anatomia deste arquivo é explicada em ../../modulos/empacotamento.md.

rockspec_format = "3.0"
package = "pluralizador"
version = "1.0-1"

source = {
  -- Para publicar num servidor de rocks, esta URL precisa apontar para
  -- um código obtível (git ou tarball). Para instalar a partir do
  -- código local — o que a CI faz — usa-se `luarocks make`, que ignora
  -- a URL e usa os arquivos ao lado do rockspec.
  url = "git+https://github.com/dionipadilha/aprendendo_lua.git"
}

description = {
  summary = "Pluralizador de substantivos do inglês (projeto didático)",
  detailed = [[
Pluralizador de substantivos do inglês por regras de sufixo, com
exceções e irregulares em listas separadas. Projeto didático do
repositório aprendendo_lua; as limitações estão no README do projeto.]],
  homepage = "https://github.com/dionipadilha/aprendendo_lua",
  license = "MIT"
}

dependencies = {
  "lua >= 5.4"
}

build = {
  type = "builtin",
  modules = {
    -- Módulo principal: require "pluralizador" devolve a função plural.
    pluralizador = "principal.lua",

    -- Módulos internos com nomes de topo (regulares, excecoes,
    -- irregulares) porque é assim que principal.lua os requer.
    -- Numa biblioteca publicada de verdade, todos usariam o
    -- prefixo do pacote (pluralizador.regulares etc.) para não
    -- disputar nomes globais com outras rocks — ver empacotamento.md.
    regulares = "regulares.lua",
    excecoes = "excecoes.lua",
    irregulares = "irregulares.lua"

    -- teste.lua e validacao.lua ficam de fora: são material de teste
    -- do repositório, não parte da biblioteca instalada.
  }
}
