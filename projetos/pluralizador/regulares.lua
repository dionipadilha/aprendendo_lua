-- regulares.lua

-- retorna a regra de pluralização com base na terminação da palavra
-- as exceções são tratadas em excecoes.lua
-- os irregulares são tratados em irregulares.lua

--------------------------------------------------------------------------------
-- caso nº 1: palavras de origem grega terminadas em "on"
-- criterion --> criteria
-- Uma regra genérica "on$ --> a" super-generalizava (lion --> lia,
-- lemon --> lema); por isso a regra usa uma lista fechada de palavras
-- que de fato seguem o plural grego.
local pluraisGregosEmOn = {
    criterion = "criteria",
    phenomenon = "phenomena"
}

local function pluralizarOn(palavra)
    return pluraisGregosEmOn[palavra]
end

-- caso nº 2: palavras terminadas em "y" precedido de consoante
-- city --> cities
local function pluralizarConsoanteY(palavra)
    if palavra:match("[^aeiou]y$") then
        return palavra:sub(1, -2) .. "ies"
    end
end

-- caso nº 3: palavras terminadas em "f" precedido de consoante
-- wolf --> wolves
local function pluralizarConsoanteF(palavra)
    if palavra:match("[^aeiou]f$") then
        return palavra:sub(1, -2) .. "ves"
    end
end

-- caso nº 4: palavras terminadas em "fe"
-- knife --> knives
local function pluralizarFe(palavra)
    if palavra:match("fe$") then
        return palavra:sub(1, -3) .. "ves"
    end
end

-- caso nº 5: palavras terminadas em "is"
-- thesis --> theses
local function pluralizarIs(palavra)
    if palavra:match("is$") then
        return palavra:sub(1, -3) .. "es"
    end
end

-- caso nº 6: palavras terminadas em "x", "s", "z", "ch", "sh"
-- box --> boxes, bus --> buses, church --> churches
local function pluralizarTerminacoesEspeciais(palavra)
    if palavra:match("[xsz]$") or palavra:match("ch$") or palavra:match("sh$") then
        return palavra .. "es"
    end
end

-- caso nº 7: palavras terminadas em "o" precedido de consoante
-- potato --> potatoes
local function pluralizarConsoanteO(palavra)
    if palavra:match("[^aeiou]o$") then
        return palavra .. "es"
    end
end

-- Observação: não há regra "us --> i" (focus --> foci). Ela existia aqui,
-- mas era inalcançável: o caso nº 6 ("[xsz]$") captura antes qualquer
-- palavra terminada em "s". Escolhemos manter o plural anglicizado
-- (focus --> focuses, bus --> buses) e removemos a regra morta.
-- Plurais latinos (focus --> foci) podem ser tratados em irregulares.lua.

-- regra padrão
-- dog --> dogs
local function pluralizarPadrao(palavra)
    return palavra .. "s"
end

--------------------------------------------------------------------------------
local regrasDePluralizacao = {
    pluralizarOn,
    pluralizarConsoanteY,
    pluralizarConsoanteF,
    pluralizarFe,
    pluralizarIs,
    pluralizarTerminacoesEspeciais,
    pluralizarConsoanteO,
    pluralizarPadrao
}

return function(palavra)
    assert(palavra and type(palavra) == "string", "A entrada deve ser uma string")
    for _, regra in ipairs(regrasDePluralizacao) do
        local formaPlural = regra(palavra)
        if formaPlural then return formaPlural end
    end
end
