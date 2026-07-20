# Coleta de lixo (GC)

Lua gerencia a memória automaticamente: objetos que não são mais
alcançáveis a partir do programa são recolhidos pelo coletor. A função
`collectgarbage` controla e mede o coletor; tabelas com `__mode`
enfraquecem referências, permitindo caches que não seguram os objetos.

| Arquivo | Tema |
|---------|------|
| `coleta_de_lixo.lua` | Alcançabilidade, `collectgarbage` e um cache com chaves fracas |
| `chaves_fracas.lua` | `__mode = "k"`: sessões que expiram junto com o usuário |
| `memoizacao_fraca.lua` | Memoização com chaves fracas e ephemerons |
| `modos_do_coletor.lua` | Modos incremental/geracional, `count`, `collect` e `__mode = "v"`/`"kv"` |

Pontos que os exemplos demonstram:

- A coleta é por **alcançabilidade**: `t = nil` não "apaga" a tabela,
  apenas remove uma referência — a memória só é recolhida quando não
  resta nenhuma.
- `collectgarbage("count")` mede a memória em KB;
  `collectgarbage("collect")` força um ciclo completo (útil em testes e
  demonstrações; raramente necessário em produção).
- Tabelas fracas via `__mode`: `"k"` (chaves), `"v"` (valores) ou
  `"kv"` (ambos).
- Finalizadores (`__gc`) e a alternativa determinística `<close>` estão
  em [`../metatabelas/finalizadores.lua`](../metatabelas/finalizadores.lua).
