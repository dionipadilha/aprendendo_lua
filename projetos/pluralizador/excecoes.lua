-- excecoes.lua

local excecoes = {
  roof = "roofs",
  chef = "chefs",
  chief = "chiefs",
  belief = "beliefs",
  quiz = "quizzes",
  halo = "halos",
  piano = "pianos",
  photo = "photos",
  fish = "fish",
  species = "species",
  series = "series",
  -- ... mais conforme necessário
}

return function(palavra) return excecoes[palavra] end
