local exceptions = {
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
  -- ... more as needed
}

return function(word) return exceptions[word] end
