require_relative 'hangman_driver'

dictionary = File.open("../5desk.txt", "r")
words = []
dictionary.each_line do |word|
  words << word
end

def play_game(word, words, player)
  hash = initialize_game(player)
  puts word

  until player.correct == word.length
    print_word(word, hash)

    guess = receive_guess(word, hash)

    if check_full_word(word, guess, player) then next end

    check_single_letter(word, guess, player, hash)

    if player.lives ==0
      puts "Game over! Word was #{word}"
      play_again(player, words)
      return
    end
  end
  puts "The word was #{word}. You win!"
  player.score += 5
  play_again(player, words)
end

player = Player.new
player = check_save(player)
play_game(pick_word(words), words, player)