dictionary = File.open("../5desk.txt", "r")
words = []
dictionary.each_line do |word|
  words << word
end

def pick_word(words)
  loop do
    i = rand(0..(words.size-1))
    chosen = words[i]
    chosen.chop!
    if (chosen.length > 4 and chosen.length < 12) then return chosen end
  end
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


def play_game(word)
  lives = 7
  correct = 0
  puts "Hangman Start!"
  puts "You have #{lives} lives to guess the word.\nEnter a letter or guess for the entire word."
  hash = Hash.new(false)
  puts word

  until correct == word.length
    print_word(word, hash)

    guess = receive_guess(word, hash)

    if guess != word and guess.length > 1
      lives -= 1
      puts "#{guess} is not the word. You have #{lives} lives left."
      next
    end

    instances = word.count guess
    if !(instances == 0)
      correct += instances
      puts "You are right!"
      hash[guess] = true
    else
      lives -= 1
      hash[guess] = 0
      puts "#{guess} not found. You have #{lives} lives left."
    end
    if lives ==0
      puts "Game over! Word was #{word}"
      return
    end
  end
  puts "The word was #{word}. You win!"
end

play_game(pick_word(words))