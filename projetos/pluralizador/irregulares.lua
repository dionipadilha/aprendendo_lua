-- irregulares.lua

local irregulares = {
  man = "men",
  woman = "women",
  child = "children",
  person = "people",
  tooth = "teeth",
  foot = "feet",
  mouse = "mice",
  louse = "lice",
  goose = "geese",
  ox = "oxen",
  sheep = "sheep",
  deer = "deer",
  aircraft = "aircraft"
  -- ... mais conforme necessário
}

return function(palavra) return irregulares[palavra] end
