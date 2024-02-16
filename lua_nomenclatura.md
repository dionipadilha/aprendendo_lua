# Guia Rápido para Nomenclatura em Lua

Este guia visa auxiliar programadores Lua na criação de nomes eficazes para variáveis, funções, classes e outros elementos.

## Criando Nomes

Investir tempo na escolha de nomes adequados para as variáveis e funções é crucial para a qualidade e legibilidade do código, tornando-o mais fácil de entender, manter e reutilizar.

## Clareza

Nomes devem comunicar imediatamente sua funcionalidade.

```lua
-- Calcular a média de um conjunto de notas
local function calcularMedia(notas)
  local soma = 0
  for _, nota in ipairs(notas) do
    soma = soma + nota
  end
  return soma / #notas
end

-- Conjuntos de notas semestrais
notasPrimeiroSemestre = {10, 8, 7, 9}
notasSegundoSemestre = {6, 8, 8, 7}

-- Imprimir a média do primeiro semestre
media = calcularMedia(notasPrimeiroSemestre)
print("Média do primeiro semestre: " .. media) --> 8.5
```

### Precisão

Evitar ambiguidades e diferenciar nomes com propósitos semelhantes.

```lua
calcularAreaCirculo(raio)
calcularAreaQuadrado(lado)
calcularAreaTriangulo(base, altura)
```

### Consistência

Utilize as convenções de nomenclatura.

```lua
CalcularMedia(NotasParciais) -- PascalCase
calcularMedia(notasParciais) -- camelCase
calcular_media(notas_parciais) -- snake_case
```

### Iteradores Simples

Utilize nomes curtos, desde que permaneçam significativos.

```lua
-- Iteradores indexados
for i=1, #list do print(list[i]) end

-- Iteradores descritivos
for _, item in ipairs(list) do print(item) end
```

### Comentários

Comentar o propósito, evitar o óbvio.

```lua
-- comentários desnecessário
  local soma = 0 -- Variável para armazenar a soma dos números

-- comentários descritivo
  -- Conjuntos de notas da turma do bob:
  notasPrimeiroSemestre = {10, 8, 7, 9}
  notasSegundoSemestre = {6, 8, 8, 7}
```

### Constantes

Letras maiúsculas em muitas linguagens.

```lua
GOLDEN_RATIO = 1.61803
PI = 3.14
```

### Verbos no infinitivo e imperativo

Descrever a ação principal da função.

```lua
gerarRelatorioTrimestral()
fazerAlgumaCoisa()
imprimirDadosFormatados()
```

### Advérbios

Enfatizar como a função realiza sua ação.

```lua
ordenarListaPorNomes(listaUsuarios)
ordenarListaPorIdades(listaUsuarios)
```

### Substantivos

Representar claramente o objeto da função.

```lua
ordenarLista(listaUsuarios)
lerArquivo(user.txt)
```

### Adjetivos

Enfatizar características do substantivo.

```lua
ordenarLista(listaUsuariosNovos)
ordenarLista(listaUsuariosAntigos)
```

### Prefixos e Sufixos

Informar propósito, escopo ou tipo de retorno.

```lua
salvarArquivoXML()
processarDadosCSV()
validarUsuarioAdmin()
```

### Siglas

Usar para conceitos técnicos bem conhecidos.

```lua
calcularROI()
parseJSON()
criarPDF()
```

## Números em Nomes

- Evite o uso de números em nomes de variáveis e funções.

```lua
--  Nomes que não fornecem informações sobre o propósito da variável ou função.
variavel1
funcao2()

-- Não use números para diferenciar variáveis ou funções semelhantes
processarDados1()
processarDados2()
```

- Use números em nomes quando eles tiverem um significado claro e justificado.

```lua
-- Casos onde o número é uma parte integral e bem conhecida do item
HTTPStatus404()
UTF8Encoding()

-- Contextos matemáticos ou científicos
EixoX1()
EixoY2()
```

## Nomenclatura de Classes e Objetos

### Classes

- Use substantivos ou frases nominais.
- Use a convenção PascalCase.

```lua
PedidoDeVenda = {}
```

### Objetos

- Use CamelCase.
- Use nomes descritivos.
- O nome do objeto geralmente deve ter uma relação clara com o nome da classe.

```lua
pedidoDeVenda = PedidoDeVenda:new()
```

## Exemplos de Nomes em diferentes contextos

### Manipulação de Strings

```lua
converterParaMaiusculas(string)
removerEspacosEmBranco(string)
substituirSubstrings(original, antigo, novo)
```

### Operações Matemáticas

```lua
calcularFatorial(numero)
verificarNumeroPrimo(numero)
calcularMediaPonderada(notas, pesos)
```

### Trabalhando com Listas

```lua
filtrarElementos(lista, condicao)
encontrarMaiorElemento(lista)
mesclarListas(lista1, lista2)
```

### Interações com Banco de Dados

```lua
buscarUsuarioPorID(id)
atualizarRegistro(registro)
inserirNovoUsuario(dados)
```

### Manipulação de Arquivos

```lua
lerConteudoArquivo(caminho)
escreverArquivo(caminho, dados)
copiarArquivo(origem, destino)
```

### Validações

```lua
validarEmail(email)
validarData(data)
verificarPermissaoAcesso(usuario, recurso)
```

### Gráficos e Visualizações

```lua
gerarGraficoBarras(dados)
criarMapaCalor(dados)
exibirGraficoPizza(dados)
```

## Armadilhas ao Criar Nomes

### Nomes Muito Longos

Priorize clareza sem tornar os nomes excessivamente longos, encontrando um equilíbrio entre clareza e concisão.

### Abreviações Excessivas

Use abreviações com moderação, escolhendo aquelas amplamente reconhecidas na comunidade de desenvolvimento.

### Sinônimos

Evite sinônimos para a mesma ação ou entidade, a menos que haja uma razão específica para a variação.

### Nomes Genéricos

Evite nomes genéricos como `funcao1()` ou `temp_func()`, pois não fornecem informações sobre a finalidade da função.

### Prefixos/Sufixos Redundantes

Evite partes que não agregam valor ao nome.

```lua
calcularMediaTotal(notas_lista)` -- redundante
calcularMedia(notas)` -- suficiente
```
