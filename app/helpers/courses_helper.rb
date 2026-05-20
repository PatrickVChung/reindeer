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
    sorted_data = offerings.sort_by do |item|
      # Parse out the fields: "2026", "Summer", and "1A"
      match = item.match(/(\d{4}):\s+(\w+)\s+(.+)/)
      next [0, 0, 0, 0, ""] unless match # Safety fallback for non-matching strings

      year   = match[1].to_i
      season = match[2]
      group  = match[3] # e.g., "1A", "1", "1+2"

      # Extract the base block number (e.g., from "1A" or "1+2" -> 1)
      base_num = group.to_i

      # Calculate a specific structural layout weight to match your exact pattern:
      # Pattern priority:
      #   - Sub-blocks with letters (1A, 1B) come first -> weight 0
      #   - Standalone blocks (1) come second         -> weight 1
      #   - Combined blocks (1+2) come third          -> weight 2
      structure_weight = if group.include?("+")
                           2
                         elsif group =~ /[A-Za-z]/
                           0
                         else
                           1
                         end

      # Return a sorting array layout. Ruby compares elements sequentially:
      # Year -> Season Chronology -> Base Block -> Group Pattern Weight -> Alphabetical (for A vs B)
      [year, SEASON_ORDER[season] || 99, base_num, structure_weight, group]
    end
  end

  def hf_custom_sort(durations)
    sorted = durations.sort_by do |str|
      SORT_ORDER.index { |prefix| str.start_with?(prefix) } || 999
    end
    return sorted
  end

end
