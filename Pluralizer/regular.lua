-- regular.lua

-- returns the pluralization rule based on the ending of the word
-- exceptions are handled in exceptions.lua
-- irregulars are handled in irregulars.lua

--------------------------------------------------------------------------------
-- case #1: words ending in "on"
-- criterion --> criteria
local function pluralizeOn(word)
    if word:match("on$") then
        return word:sub(1, -3) .. "a"
    end
end

-- case #2: Words ending in "y" preceded by a consonant
-- city --> cities
local function pluralizeConsonantY(word)
    if word:match("[^aeiou]y$") then
        return word:sub(1, -2) .. "ies"
    end
end

-- case #3: words ending in "f" preceded by a consonant
-- wolf --> wolves
local function pluralizeConsonantF(word)
    if word:match("[^aeiou]f$") then
        return word:sub(1, -2) .. "ves"
    end
end

-- case #4: words ending in "fe"
-- knife --> knives
local function pluralizeFe(word)
    if word:match("fe$") then
        return word:sub(1, -3) .. "ves"
    end
end

-- case #5: words ending in "is"
-- thesis --> theses
local function pluralizeIs(word)
    if word:match("is$") then
        return word:sub(1, -3) .. "es"
    end
end

-- case #6: Words ending in "x", "s", "z", "ch", "sh"
-- box --> boxes, bus --> buses, church --> churches
local function pluralizeSpecialEndings(word)
    if word:match("[xsz]$") or word:match("ch$") or word:match("sh$") then
        return word .. "es"
    end
end

-- case #7: Words ending in "o" preceded by a consonant
-- potato --> potatoes
local function pluralizeConsonantO(word)
    if word:match("[^aeiou]o$") then
        return word .. "es"
    end
end

-- Case #8: Words ending in "us"
-- focus --> foci
local function pluralizeUs(word)
    if word:match("us$") then
        return word:sub(1, -3) .. "i"
    end
end

-- default rule
-- dog --> dogs
local function defaultPluralize(word)
    return word .. "s"
end

--------------------------------------------------------------------------------
local pluralizationRules = {
    pluralizeOn,
    pluralizeConsonantY,
    pluralizeConsonantF,
    pluralizeFe,
    pluralizeIs,
    pluralizeSpecialEndings,
    pluralizeConsonantO,
    pluralizeUs,
    defaultPluralize
}

return function(word)
    assert(word and type(word) == "string", "Input must be a string")
    for _, rule in ipairs(pluralizationRules) do
        local pluralForm = rule(word)
        if pluralForm then return pluralForm end
    end
end
