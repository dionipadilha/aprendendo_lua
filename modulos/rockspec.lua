-- rockspec.lua

-- TRECHO ILUSTRATIVO de um arquivo .rockspec (o manifesto de pacote do
-- LuaRocks) — não é um módulo para require. Um rockspec define campos
-- globais por natureza (dependencies etc.); é por isso que este arquivo
-- tem uma exceção no .luacheckrc.

-- arquivo.rockspec:

-- ...

dependencies = {
   "luasocket",
   "lua2json",
   "luafilesystem"
}

-- ./luarocks build --only-deps

-- ./luarocks make --pin
