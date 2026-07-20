-- Configuração do luacheck para este repositório (material didático).
std = "lua54"

-- Avisos silenciados de propósito — são padrões intencionais dos exemplos:
ignore = {
  "211", -- variável definida e não usada (demonstrações de sintaxe)
  "212", -- argumento não usado (interfaces e assinaturas de exemplo)
  "213", -- variável de laço não usada
  "311", -- valor atribuído e não usado (demonstrações passo a passo)
  "41.", -- redefinição de variável: cada seção redefine seus exemplos
  "42.", -- shadowing entre seções do mesmo arquivo
  "43.", -- shadowing de upvalue em exemplos de clausura
}

files["modulos/rockspec.lua"] = {
  -- um rockspec define campos globais por natureza (dependencies etc.)
  ignore = { "111" },
}
