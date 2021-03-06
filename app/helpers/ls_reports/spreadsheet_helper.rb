module LsReports::SpreadsheetHelper
    def hf_flatten_response_sets lime_survey 
        result = []
        lime_survey.lime_questions.select do |lq|
            if (filters.empty? || filters.include?(lq.qid)) && lq.response_set.data.present?
                if lq.response_set.data.first.respond_to? :data
                    result += lq.response_set.data

                else
                    result.push pquestion.response_set
                end
              end
            end
        end
        return result
    end

    def hf_transpose_response_sets response_sets
        result = []
        response_sets.each do |dt|
            result.push dt.data
        end
        return result.transpose
    end


end

