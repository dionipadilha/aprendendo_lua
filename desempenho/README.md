# Desempenho

Desempenho se mede, não se afirma: antes de trocar código claro por
código "otimizado", cronometre as duas versões no **seu** caso — a maior
parte do programa não é gargalo, e otimização sem medição só compra
complexidade.

| Arquivo | Tema |
|---------|------|
| `medicao.lua` | Benchmark com `os.clock`: concatenação em laço vs `table.concat` e acesso global vs local em laço quente |

Notas:

- Os tempos impressos **variam** por máquina, carga e versão de Lua —
  por isso os asserts verificam apenas a igualdade dos resultados, nunca
  os tempos. O que se transfere entre máquinas é a ordem de grandeza
  (linear vence quadrático).
- `os.clock` mede tempo de CPU, a medida certa para benchmark; a
  diferença para o relógio de parede está em
  [`../sistema/cpu_vs_parede.lua`](../sistema/cpu_vs_parede.lua).
