# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
purposes = [
  ['簡易的に始めたい', '慢性的痛みの軽減, リラクゼーションとリフレッシュ, 睡眠の質の向上を実感したい方', 4, 5, 8],
  ['効果を実感したい', '集中力と注意力の向上, 感情の安定と気分の改善, 協調性の向上を実感したい方', 6, 20, 16],
  ['本格的に瞑想に取り組みたい（すでに習慣付いてる方専用）', '瞑想を趣味をしたい方', 7, 30, 48],
  ['修行（達観した人専用）', '人生を達観したい方', 7, 60, 96]
]
purposes.each do |title_of_purpose, descrip_of_purpose, frequency_of_purpose, minutes_of_purpose, total_duration_of_purpose|
  PurposeOfMeditation.create!(title: title_of_purpose, description: descrip_of_purpose, frequency_per_week: frequency_of_purpose, minutes_per_session: minutes_of_purpose, total_duration_weeks: total_duration_of_purpose)
end