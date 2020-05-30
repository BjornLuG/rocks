# frozen_string_literal: true

# Saves the top 10 highscore in a hash
class HighscoreManager
  attr_reader :score_list

  def initialize
    read_score_list
  end

  def highscore?(score)
    score.positive? && score_list_insert_index(score) < 10
  end

  # Add highscore and saves result
  def add_highscore(name, score)
    return if score <= 0

    insert_index = score_list_insert_index(score)

    return if insert_index >= 10

    @score_list = @score_list
                  .insert(
                    insert_index,
                    # Return this this sort of hash because JSON.parse will
                    # return something like this too (for consistency)
                    {
                      'name' => name,
                      'score' => score
                    }
                  )
                  .slice(0, 10)

    save_score_list
  end

  private

  def save_score_list
    File.open(Constant::HIGHSCORE_FILE_NAME, 'w+') do |f|
      f.write(JSON.generate(@score_list))
    end
  end

  # Get the score's index if it were to be inserted into the score list
  def score_list_insert_index(score)
    @score_list.each_with_index do |item, index|
      return index if score > item['score']
    end

    @score_list.count
  end

  # Creates highscore file.
  # Overwrite true will clear file create new file even if already exist.
  def create_file(override = false)
    dir = File.dirname(Constant::HIGHSCORE_FILE_NAME)

    # Create directory if not exist
    FileUtils.mkdir_p(dir) unless File.directory?(dir)

    # Fake open a file to create
    File.open(Constant::HIGHSCORE_FILE_NAME, override ? 'w' : 'a') {}
  end

  def read_score_list
    create_file unless File.file?(Constant::HIGHSCORE_FILE_NAME)

    data = File.read(Constant::HIGHSCORE_FILE_NAME)

    if data.empty?
      # If empty, set empty array
      @score_list = []
    else
      parsed_data = JSON.parse(data)

      # If data is not array (tampered), set empty array
      @score_list = parsed_data.is_a?(Array) ? parsed_data : []
    end
  end
end
