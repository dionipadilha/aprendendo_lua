# Princípios SOLID

Os cinco princípios de desenho aplicados em Lua, um por arquivo, na
ordem da sigla. Os exemplos são executáveis e terminam em asserts; onde
faz diferença, o arquivo mostra a violação antes do redesenho.

| Arquivo | Tema |
|---------|------|
| `srp.lua` | Responsabilidade Única: separar validar, calcular e apresentar |
| `ocp.lua` | Aberto-Fechado: o `if`/`elseif` por tipo que nunca "fecha" vs um desenho extensível |
| `lsp.lua` | Substituição de Liskov: a violação executada de verdade e o redesenho validado pelo MESMO cliente |
| `isp.lua` | Segregação de Interface: mixins pequenos em vez de uma interface gorda (e a armadilha do mixin com `__index`) |
| `dip.lua` | Inversão de Dependência: depender de abstrações injetadas, não de concretizações |
