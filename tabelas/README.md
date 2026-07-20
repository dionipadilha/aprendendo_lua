# Tabelas

Tabelas são a única estrutura de dados de Lua: listas, dicionários,
objetos e módulos são todos tabelas. Os arquivos abaixo vão do essencial
aos detalhes que costumam surpreender (a fronteira do `#`, a ordem não
especificada de `pairs`/`next`, atribuição como referência) e terminam
em estruturas e aplicações construídas sobre tabelas.

| Arquivo | Tema |
|---------|------|
| `tabelas.lua` | Aspectos essenciais: inicialização, acesso, percurso e mistura de lista com dicionário |
| `vetores.lua` | Operações básicas de array: criação, acesso por índice, percurso e matrizes |
| `biblioteca_de_tabelas.lua` | Tour da biblioteca `table`: pack/unpack, insert, remove, move, sort e concat |
| `table_move.lua` | `table.move` em detalhe: copiar faixas de elementos entre tabelas |
| `buracos_e_comprimento.lua` | `#` devolve uma FRONTEIRA: só é comprimento confiável em sequências sem buracos |
| `next.lua` | `next` par a par e a ordem NÃO especificada da enumeração |
| `iteradores.lua` | Iteradores próprios (clausuras) para o `for` genérico |
| `referencias_e_copias.lua` | Atribuição cria apelido; cópia rasa vs cópia profunda |
| `lista.lua` | A lista como TAD: operações nomeadas escondendo a tabela |
| `pilha.lua` | Pilha como classe, com estado por instância |
| `crud.lua` | Um "banco de dados" em memória: criar, ler, atualizar e excluir registros |
| `selecionar_onde.lua` | Filtrar os elementos de uma lista por um critério (função predicado) |
| `escolher_ferramenta.lua` | Um agente escolhe a ferramenta certa para cada tarefa (tabela como despacho) |
| `serializacao.lua` | Serializar uma tabela para texto Lua e reconstruí-la com `load` |

Os três arquivos de listas dividem papéis declarados nos próprios
cabeçalhos: `vetores.lua` (operações básicas), `biblioteca_de_tabelas.lua`
(a API `table.*`) e `lista.lua` (a lista como tipo abstrato).
