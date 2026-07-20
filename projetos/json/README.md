# Codificação/decodificação de JSON

Este projeto cobre a codificação e a decodificação básicas de JSON sem a
necessidade de bibliotecas externas.

O codificador escapa `\`, `"` e os caracteres de controle (`\n`, `\t`, `\r`,
`\b`, `\f`; os demais controles viram `\u00XX`). O decodificador interpreta as
sequências de escape básicas (`\"`, `\\`, `\/`, `\n`, `\t`, `\r`, `\b`, `\f`).
Os testes de roundtrip estão em `principal.lua`.

O decodificador rejeita sobras após o valor (`123abc`), vírgulas finais
(`[1,2,]`, `{"a":1,}`) e chaves de objeto que não sejam strings; o
codificador lança erro para NaN e ±infinito (sem representação em JSON)
e para tabelas cíclicas (que referenciam a si mesmas). O rigor do
decodificador tem limites conhecidos — veja abaixo.

## Limitações conhecidas

Esta implementação é didática e simplificada. As limitações abaixo permanecem
de propósito — para uso em produção prefira uma biblioteca madura (ex.:
dkjson, lua-cjson):

- **`\uXXXX`/Unicode:** o decodificador não interpreta escapes `\uXXXX`
  (lança erro ao encontrá-los). O codificador emite `\u00XX` apenas para
  caracteres de controle raros; texto UTF-8 é copiado byte a byte, sem
  validação.
- **`null` é perdido:** `null` decodifica para `nil`. Em arrays,
  inserir `nil` numa tabela Lua não cria posição — `[1, null, 3]` vira
  `{1, 3}`, deslocando os elementos seguintes. Em objetos, a chave some:
  `{"a": null}` vira uma tabela sem a chave `"a"`.
- **Decodificador mais tolerante que o RFC 8259:** aceita números fora
  da gramática (`007`, `5.`) e caracteres de controle crus dentro de
  strings (o RFC exige que sejam escapados).
- **Tabela vazia sempre vira `[]`:** Lua não distingue "objeto vazio" de
  "array vazio", então `{}` é sempre codificada como `[]`, nunca como `{}`.
- **Chaves numéricas e strings podem colidir:** `{[1] = "a", ["1"] = "b"}`
  gera `{"1":"a","1":"b"}` — JSON gramaticalmente válido, porém com chave
  duplicada (chaves não-string são convertidas com `tostring`).
