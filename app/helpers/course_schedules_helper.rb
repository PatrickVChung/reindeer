module CourseSchedulesHelper

  def hf_process_4_week_schedule (course_schedules)

    temp_schedules = []

    i = 0
    while i < course_schedules.count-1 do
      puts "no of seats: " + course_schedules[i].no_of_seats.to_s
      if course_schedules[i].no_of_seats == 777
        course_schedules[i-1].block = course_schedules[i-1].block + " - " + course_schedules[i].block
        course_schedules[i-1].end_date = course_schedules[i].end_date
        course_schedules[i-1].comment = course_schedules[i].comment
        temp_schedules.push course_schedules[i-1]
        i += 1
      else
        i += 1
      end
    end
    if course_schedules[i].no_of_seats == 777
      course_schedules[i-1].block = course_schedules[i-1].block + " - " + course_schedules[i].block
      course_schedules[i-1].end_date = course_schedules[i].end_date
      course_schedules[i-1].comment = course_schedules[i].comment
      temp_schedules.push course_schedules[i-1]
    end

    return temp_schedules
  end
  def hf_find_attach(in_pattern)
    catalog_dir = Rails.root.join("public", "course_catalog")
    if in_pattern == 'INTS 771'
      search_pattern = 'Cancer INTS 771*'
    else
      search_pattern = "*#{in_pattern}*"
    end
    # 3. Find matching files (returns an array of absolute paths)
    matching_files = Dir.glob(File.join(catalog_dir, search_pattern))
    if matching_files.any?
      filename = File.basename(matching_files.first)
      filename = "/course_catalog/#{filename}"
    end
    return filename
  end
end
