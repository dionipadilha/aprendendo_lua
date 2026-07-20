# Entrada e saída (io)

A biblioteca `io` abre arquivos com `io.open(nome, modo)` e devolve um
manipulador com métodos como `read`, `write`, `lines` e `close`. Os
exemplos cobrem da manipulação básica ao idioma moderno de liberação de
recursos (`<close>`, Lua 5.4) e a arquivos binários.

| Arquivo | Tema |
|---------|------|
| `arquivo_manipulacao_basica.lua` | `io.open`, modos de abertura, leitura e escrita básicas |
| `arquivo_manipulacao_objeto.lua` | Um manipulador de arquivo orientado a objetos por cima da API `io` |
| `arquivo_acrescentar.lua` | Modo `"a"`: acrescentar conteúdo ao fim de um arquivo |
| `arquivo_crud.lua` | Criar, ler, atualizar e excluir um arquivo do início ao fim |
| `arquivo_com_close.lua` | Variáveis to-be-closed (Lua 5.4): `local f <close>` fecha o arquivo mesmo se um erro interromper o bloco |
| `arquivo_binario.lua` | Arquivos binários com `string.pack`/`unpack` e por que o `"b"` do modo importa no Windows |

Os arquivos `teste.txt` e `arquivo_demo.txt` são artefatos de apoio
criados/sobrescritos pelos próprios exemplos ao executar.
