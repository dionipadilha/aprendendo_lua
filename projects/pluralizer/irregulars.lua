local irregulars = {
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
  -- ... more as needed
}

return function(word) return irregulars[word] end
