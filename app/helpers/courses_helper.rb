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
  def hf_custom_sort(durations)
    sorted = durations.sort_by do |str|
      SORT_ORDER.index { |prefix| str.start_with?(prefix) } || 999
    end
    return sorted
  end

end
