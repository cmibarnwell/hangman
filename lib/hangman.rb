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

def receive_guess(hash)
  while(true)
    guess = gets.chomp
    guess.downcase!
    if guess.length >1
      puts "More than one letter entered. Please Try again:"
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
  lives = 5
  correct = 0
  puts "Hangman Start!"
  puts "You have 5 lives to guess the word."
  hash = Hash.new(false)

  until correct == word.length
    print_word(word, hash)

    guess = receive_guess(hash)

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
  puts "You win!"
end

play_game(pick_word(words))