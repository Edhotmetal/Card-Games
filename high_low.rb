# This program lets the user play HighLow, a simple card game
# that is described in the output statements at the beginning of
# the script. After the user plays several games,
# the user's average score is reported
# Original version is HighLow.java from javanotes

require_relative "deck.rb"
class HighLow
	def HighLow.play # define method in HighLow's Eigenclass so we don't have to explicitly create a HighLow object
		deck = Deck.new # Get a new deck of cards

		current_card = nil # The current card, which the user sees

		next_card = nil # The next card in the deck
						# The user tries to predict whether this is higher
		 				# or lower than the current card

		correct_guesses = 0 # The number of correct predictions - the user's score

		guess = nil # The user's guess. 'H' if the user predicts that the next card will
					# be higher. 'L' if the user predicts that it will be lower

		deck.shuffle # Shuffle the deck before starting the game

		current_card = deck.deal_card
		puts("\nThe first card is the #{current_card}")

		loop do # The loop ends when the user's prediction is wrong

			# Get the user's prediction, 'H' or 'L'

			print("Will the next card be higher (H) or lower (L)? ")
			loop do
				guess = gets[0].upcase
				if(guess != 'H' and guess != 'L')
					puts("Invalid response.")
				end
			break if(guess == 'H' or guess == 'L')
			end

			# Get the next card and show it to the user

			next_card = deck.deal_card
			puts("The next card is #{next_card}")

			# Check the user's prediciton
			
			if(next_card.value == current_card.value) then
				puts("The value is the same as the previous card.")
				puts("You lose on ties. Sorry!")
				break # End the game
			elsif(next_card.value > current_card.value) then
				if(guess == 'H') then
					puts("Your prediction is correct!")
					correct_guesses += 1
				else
					puts("Your prediction is incorrect!")
					break # End the game
				end
			else # next_card is lower
				if(guess == 'L') then
					puts("Your predition is correct!")
					correct_guesses += 1
				else
					puts("Your prediction is incorrect!")
					break
				end
			end
			# To set up for the next iteration of the loop, the next_card
			# becomes the current_card, since the current_card has to be
			# the card that the user sees, and the next_card will be
			# set to the next card in the deck after the user makes
			# his prediction

			current_card = next_card
			puts("\nThe card is #{current_card}")
		end # End loop

		puts("\nThe game is over.")
		puts("You made #{correct_guesses} correct predictions\n")

		return correct_guesses
	end
end

puts("~~~~~~~~~~~~~~~~~~~high_low.rb~~~~~~~~~~~~~~~~~~~\n")
puts("This program lets you play the simple card game,")
puts("HighLow. A card is dealt from a deck of cards.")
puts("You have to predict whether the next card will be")
puts("Higher of lower. Your score in the game is the")
puts("number of correct predictions you make before")
puts("you guess wrong.\n")

games_played = 0 # The number of games played
sum_of_scores = 0 # The sum of all the scores from all games payed

average_score = 0.0 # The average of all the scores
play_again = false # The user's response when prompted to play again

loop do
	score_this_game = 0 # Score for one game
	score_this_game = HighLow.play
	sum_of_scores += score_this_game
	games_played += 1
	loop do
		puts("Play again? ")
		input = gets.downcase.chop
		if(input == 'y' or input.include?('indeed') or input.include?('yes')) then
			play_again = true
			break
		else
			play_again = false
			break
		end
	end
break if(not(play_again))
end

average_score = sum_of_scores.fdiv(games_played)

puts("\nYou played #{games_played} games")
puts("Your average score was #{average_score}")
