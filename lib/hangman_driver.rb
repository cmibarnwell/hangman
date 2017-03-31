require 'yaml'

class Player
  def initialize
    @lives = 7
    @correct = 0
    @score = 0
  end

  attr_accessor :lives
  attr_accessor :correct
  attr_accessor :score

  def self.deserialize
    YAML.load_file("hangman_save.yml")
  end
  def serialize
    File.open("hangman_save.yml", "w") do |file|
      file.write(self.to_yaml)
    end
  end
  def to_s
    "Player: [lives = #{@lives}, score = #{@score}]"
  end
  def reset
    @lives = 7
    @correct = 0
  end
end

def check_save(player)
  print "Would you like to load a save?\n(y/n)"
  while true
    ans = gets.chomp
    ans.downcase!
    case ans.ord
      when 'y'.ord
        player = Player.deserialize
        return player
      when 'n'.ord
        break
      else
        puts "Not understood. Please type y or n."
        next
    end
  end
  return player
end

def pick_word(words)
  loop do
    i = rand(0..(words.size-1))
    chosen = words[i]
    chosen.chop!
    chosen.downcase!
    if chosen.length > 4 and chosen.length < 12 then return chosen end
  end
end

def initialize_game(player)
  puts "Hangman Start!"
  puts "You have #{player.lives} lives to guess the word.\nEnter a letter or guess for the entire word. Your Score is: #{player.score}."
  hash = Hash.new(false)
  return hash
end

def print_word(word, hash)
  word.each_char do |char|
    if hash[char] == true
      print "#{char} "
    else
      print "_ "
    end
  end
  puts "\n\nWhat is your guess?"
end

def check_full_word(word, guess, player)
  if guess != word and guess.length > 1
    player.lives -= 1
    puts "#{guess} is not the word. You have #{player.lives} lives left."
    return true
  elsif guess == word and guess.length > 1
    player.correct = word.length
    puts "You are right!"
    return true
  else
    return false
  end
end

def check_single_letter(word, guess, player, hash)
  instances = word.count guess
  if !(instances == 0)
    player.correct += instances
    puts "You are right!"
    hash[guess] = true
  else
    player.lives -= 1
    hash[guess] = 0
    puts "#{guess} not found. You have #{player.lives} lives left."
  end
end

def receive_guess(word, hash)
  while(true)
    guess = gets.chomp
    guess.downcase!
    if guess.length >1
      print "You have entered more than one character. Is this a guess attempt for the full word?\n(y/n): "
      while true
        ans = gets.chomp
        ans.downcase!
        case ans.ord
          when 'y'.ord
            if guess == word
              return word
            elsif guess.length > 1
              return guess
            end
          when 'n'.ord
            puts "In that case, Please try again: "
            break
          else
            puts "Not understood. Please type y or n."
            next
        end
      end
      next
    end
    if !((guess.ord >= 'a'.ord and guess.ord <= 'z'.ord))
      puts "#{guess} is not a valid guess. Please Try again:"
    elsif hash[guess] == 0
      puts "You have already guessed #{guess}. Please Try again:"
    else
      return guess
    end
  end
end

def play_again(player, words)
  print "Would you like to save your data?\n(y/n): "
    while true
      ans = gets.chomp
      ans.downcase!
      case ans.ord
        when 'y'.ord
          player.serialize
          break
        when 'n'.ord
          break
        else
          puts "Not understood. Please type y or n."
          next
      end
    end
  print "Would you like to play again?\n(y/n): "
  while true
    ans = gets.chomp
    ans.downcase!
    case ans.ord
      when 'y'.ord
        player.reset
        puts "Time for a new word!"
        play_game(pick_word(words), words, player)
        break
      when 'n'.ord
        puts "Thanks for playing!"
        break
      else
        puts "Not understood. Please type y or n."
        next
    end
  end
end