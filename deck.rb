# An object of type Deck represents a deck of playing cards. The deck
# is a regular poker deck that contains 52 regular cards and that can
# also optionally inlude two Jokers
# Original version is Deck.java from javanotes
#

require_relative "card.rb"

class Deck
	# @deck is an array of 52 or 54 cards. a 54-card deck contains two Jokers,
	# in addition to the 52 cards of a regular poker deck
	#
	# @card_used keeps track of the number of cards that have been dealt from the deck so far
	attr_accessor :deck, :cards_used

	# Constructs a regular 52-card poker deck. Initially, the cards
	# are in a sorted order. The shuffle() method can be called to
	# randomize the order. (Note that "Deck.new" is equivalent to
	# "Deck.new(false)".)
	# Only one constructor is needed here because we can pass
	# a default parameter of false in Ruby
	def initialize(include_jokers = false)
		if(include_jokers) then
			@deck = Array.new(54) # If the deck will include Jokers, create a deck with 54 cards
		else
			@deck = Array.new(52) # If the deck will not inluce Jokers, create a deck with 52 cards
		end
		card_count = 0 # How many cards have been created so far

		for suit in 0..3
			for value in 1..13
				@deck[card_count] = Card.new(value, suit)
				card_count += 1
			end
		end
		if(include_jokers) then
			@deck[52] = Card.new(1, Card.class_variable_get(:@@JOKER))
			@deck[53] = Card.new(2, Card.class_variable_get(:@@JOKER))
		end
		@cards_used = 0
	end

	# Put all the used cards back into the deck (if any), and
	# shuffle the deck into a random order.
	
	def shuffle()
		range = (@deck.length-1)..0
		(range.first).downto(range.last).each { |i|
			rand = Random.rand(i+1)
			temp_card = @deck[i]
			@deck[i] = @deck[rand]
			@deck[rand] = temp_card
		}
		@cards_used = 0
	end

	# As cards are dealt from the deck, the number of cards left
	# decreases. This function returns the number of cards that
	# are still left in the deck. The return value would be
	# 52 or 54 (depending on whether the deck includes Jokers)
	# when the deck is first created or after the deck has been
	# shuffled. It decreases by 1 each time the deal_card method
	# is called
	
	def cards_left()
		return @deck.length - @cards_used
	end

	# Removes the next card from the deck and returns it. It is illegal
	# to call this method if there are no more cards in the deck. You can
	# check the number of cards remaining by calling the card_left method
	# Return the card which is removed from the deck.
	# Throws StateError if there are no cards left in the deck
	
	def deal_card()
		if(@cards_used == @deck.length) then
			raise ArgumentError.new("No cards are left in the deck")
		end
		@cards_used += 1
		return @deck[@cards_used - 1]
		# Cards are not literally removed from the array
		# that represents the deck. We just keep track of how many cards
		# have been used
	end

	# Test whether the deck contains Jokers
	# Return true, if this is a 54-card deck containing two jokers, or false if
	# this is a 52-card deck that contains no jokers
	
	def has_jokers()
		return (@deck.length == 54)
	end
end
