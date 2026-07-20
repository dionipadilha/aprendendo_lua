-- goto.lua

local a = 0

::inicio::
a = a + 1
if a < 10 then
  goto inicio
else
  goto parada
end

::salto::
print("Código pulado")


::parada::
print("Código de parada")
