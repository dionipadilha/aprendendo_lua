# Testes

Um mini-framework de teste unitário construído do zero e uma suíte que
o usa para testar um módulo real. A convenção do repositório vale aqui
em dobro: os asserts que decidem o resultado ficam no nível principal
dos arquivos, fora de `pcall`, para reprovarem o build de verdade.

| Arquivo | Tema |
|---------|------|
| `teste_unitario_basico.lua` | Mini-framework: `pcall` em volta do código sob teste, contagem de aprovados/reprovados e totais retornados |
| `suite_de_testes.lua` | Suíte que usa o framework — inclusive uma reprovação demonstrativa declarada como expectativa nos totais |
| `intervalo.lua` | Módulo sob teste: gerador de sequências numéricas com validação de argumentos |
| `teste_intervalo.lua` | Testes de `intervalo.lua`: asserts de topo, casos limite (sequências vazias) e mensagens de erro via `pcall` |
| `espera.lua` | Módulo de apoio: espera ocupada usada pela suíte para simular processamento |
