module CoursesHelper
  SORT_ORDER = [
  "4 Hours",
  "One Week",
  "Two Weeks",
  "Three Weeks",
  "Four Weeks",
  "Eight Weeks",
  "Ten Weeks",
  "Twelve Weeks",
  "12 weeks",
  "Term Long",
  "Term-Base",
  "Winter term"
]

SEASON_ORDER = {
  "Summer" => 1,
  "Fall"   => 2,
  "Winter" => 3,
  "Spring" => 4
}

  def hf_seasonal_sort(offerings)
    sorted = offerings.sort_by do |item|
      year, rest = item.split(": ")
      season, number = rest.split(" ")
      [year.to_i, SEASON_ORDER[season], number.to_i]
    end
  end

  def hf_custom_sort(durations)
    sorted = durations.sort_by do |str|
      SORT_ORDER.index { |prefix| str.start_with?(prefix) } || 999
    end
    return sorted
  end

end
