# An object of type Card represents a playing card from a
 #standard Poker deck, including Jokers.  The card has a suit, which
 #can be spades, hearts, diamonds, clubs, or joker.  A spade, heart,
 #diamond, or club has one of the 13 values: ace, 2, 3, 4, 5, 6, 7,
 #8, 9, 10, jack, queen, or king.  Note that "ace" is considered to be
 #the smallest value.  A joker can also have an associated value; 
 #this value can be anything and can be used to keep track of several
 #different jokers.
# Original taken from Card.java form javanotes

class Card

	@@SPADES = 0 # Codes for the 4 suits, plus Joker
	@@HEARTS = 1
	@@DIAMONDS = 2
	@@CLUBS = 3
	@@JOKER = 4

	@@ACE = 1 	 # Codes for the non-numeric cards.
	@@JACK = 11  # Cards 2 through 10 have their
	@@QUEEN = 12 # numerical values for their codes
	@@KING = 13

	# This card's suit, one of the constants SPADES, HEARTS, DIAMONDS,
	# CLUBS, OR JOKER. The suit cannot be changed after the card is
	# constructed.
	
	attr_reader :suit

	# The card's value. For a normal card, this is one of the values
	# 1 through 13, with 1 representing ACE. For a JOKER, the value
	# can be anything. The value cannot be changed after the card
	# is constructed
	
	attr_reader :value

	# Creates a Joker, with 1 as the associated value.
	# (Note that "Card.new" is equivalent to "Card.new(1,Card.JOKER)".)
	
	def initialize()
		@suit = @@JOKER
		@value = 1
	end

	# Creates a card with a specified suit and value
	# @param value is the value of the new card. For a regular card (non-joker),
	# the value must be in the range 1 through 13, with 1 representing an Ace.
	# You can use the constants Card.ACE, Card.JACK, Card.QUEEN, and Card.KING.
	# For a Joker, the value can be anything.
	# @param suit is the suit of the new card. This must be one of the values
	# Card.SPADES, Card.HEARTS, Card.DIAMONDS, Card.CLUBS, or Card.JOKER.
	# @raises IllegalArgumentException if the parrameter values are not in the
	# permissible ranges
	
	def initialize(value, suit)
		if(suit != @@SPADES and suit != @@HEARTS and suit != @@DIAMONDS and
			suit != @@CLUBS and suit != @@JOKER) then
				raise ArgumentError.new("Illegal playing card suit: #{suit}")
		end
		if(suit != @@JOKER and (value < 1 or value > 13)) then
			raise ArgumentError.new("Illegal playing card value: #{value}")
		end	
		@value = value
		@suit = suit
	end


	# Returns a string representation of the card's suit
	# return one of the strings "Spades", "Hearts", "Diamonds", "Clubs"
	# or "Joker".
	def get_suit_as_string()
		case @suit
		when @@SPADES
			return "Spades"
		when @@HEARTS
			return "Hearts"
		when @@DIAMONDS
			return "Diamonds"
		when @@CLUBS
			return "Clubs"
		else
			return "Joker"
		end
	end

	# Returns a string representation of the card's value
	# return for a regularcard, one of the strings "Ace", "2",
	# "3", ..., "10", "Jack", "Queen", or "King". For a Joker, the
	# string is always numerical.
	def get_value_as_string()
		if(@suit == @@JOKER) then
			return @value.to_s
		else
			case @value
			when 1
				return "Ace"
			when 2..10
				return @value.to_s
			when 11
				return "Jack"
			when 12
				return "Queen"
			when 13
				return "King"
			end
		end
	end

	# Returns a string representation of this card, including both
	# its suit and its value (except that for a Joker with value 1,
	# the return value is just "Joker"). Sample return values
	# are: "Queen of Hearts", "10 of Diamonds", "Ace of Spades",
	# "Joker", "Joker #2"
	def to_s()
		if(@suit == @@JOKER) then
			if(@value == 1) then
				return "Joker"
			else
				return "Joker ##{@value}"
			end
		else
			return "#{get_value_as_string} of #{get_suit_as_string}"
		end
	end
end
