# Para instalar Lua no Windows (10 ou 11), siga estas etapas:

Os exemplos deste repositório têm como alvo o **Lua 5.4** — prefira uma
versão 5.4.x ao baixar.

1. **Download do Arquivo**:
   - O site oficial do Lua (lua.org) distribui apenas o código-fonte. Para binários Windows, use o projeto **LuaBinaries** (hospedado no SourceForge, com link a partir de lua.org) e baixe o arquivo `lua-5.4.x_Win64_bin.zip`. Alternativa: instalar pela linha de comando com o winget (`winget install DEVCOM.Lua`).

2. **Descompacte o Arquivo**:
   - Após o download, clique com o botão direito no arquivo `.zip` e escolha a opção para descompactar ou extrair os arquivos. Você pode usar ferramentas como WinRAR ou 7-Zip.

3. **Mova a Pasta Descompactada**:
   - Recorte a pasta resultante da descompactação e cole-a em `C:\Program Files\` (a pasta que o Windows em português exibe como "Arquivos de Programas" — o nome real no disco é sempre `Program Files`). Esta ação pode exigir permissões de administrador.

4. **Renomeie o Arquivo Executável**:
   - Entre na pasta que você acabou de mover. Localize o arquivo executável (por exemplo, `lua54.exe`) e renomeie-o para `lua.exe`. Isso facilitará a execução do Lua a partir da linha de comando. (Os exemplos do README usam o comando `lua5.4`, comum no Linux; no Windows, após renomear, use `lua` no lugar.)

5. **Copie o Caminho da Pasta**:
   - Copie o caminho completo da pasta onde o Lua está instalado. Deve ser algo como `C:\Program Files\lua-5.4.x_Win64_bin`.

6. **Edite as Variáveis de Ambiente**:
   - No menu Iniciar, digite “Editar as variáveis de ambiente do sistema” e abra a opção correspondente.
   - Na janela do Sistema, clique em “Variáveis de Ambiente”.

7. **Atualize o Path**:
   - Na seção Variáveis de Sistema, encontre e selecione a variável `Path`. Clique em “Editar”.
   - Na janela de edição, clique em “Novo” e cole o caminho da pasta do Lua que você copiou anteriormente.
   - Clique em “OK” para fechar as janelas de edição.

8. **Teste a Instalação**:
   - Abra o Prompt de Comando (cmd).
   - Digite `lua` e pressione Enter.
   - Se a instalação foi bem-sucedida, você deverá ver o cabeçalho do interpretador (`Lua 5.4.x ...`) e o prompt `>`.
