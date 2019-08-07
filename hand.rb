# An object of type Hand represents a hand of cards. The
# cards belong to the class Card. A hand is empty when it is
# created, and any number of cards can be added to it

require_relative "card.rb"

class Hand

	def initialize()
		@hand = Array.new # The cards in the hand
	end

	# Remove all cards from the hand, leaving it empty
	
	def clear()
		@hand.clear
	end

	# Add a card to the hand. It is added at the end of the current hand.
	# param card is the non-nil card to be added
	# raises NilError if the parameter card is nil

	def add_card(card)
		if(card.class != Card) then
			raise NilError
		end
		@hand.push(card)
	end

	# Remove a card from the hand, if present
	# param card is the card to be removed. If card is nil or if the card is not in
	# the hand, then nothing happens

	def remove_card(card)
		return @hand.delete(card)
	end

	# Remove the card in a specified position from the hand
	# param position is the position of the card that is to be removed
	# where positions are number starting from zero.
	# or equal to the number of cards in the hand
	def remove_card_at(position)
		return @hand.delete_at(position)
	end

	def take_last_card()
		return @hand.pop
	end

	# Returns the number of cards in the hand

	def get_card_count()
		return @hand.length
	end

	# Returns the card in a specified position in the hand.
	# param position is the position of the card that is to be returned
	# raises ArgumentError if position does not exist in the hand

	def get_card(position)
		return @hand[position]
	end

	# Sorts the cards in the hand so that cards of the same suit are
	# grouped together, and within a suit the cards are sorted by value.
	# Note that aces are considered to have the lowest value, 1.

	def sort_by_suit()
		new_hand = Array.new
		while(@hand.length > 0) do
			pos = 0 # Position of the minimal card
			card = @hand[0] # Minimal card
			for i in (@hand.length)..1
				card1 = @hand[i]
				if(card1.suit < card.suit or (card1.suit == card.suit and card1.value < card.value)) then
					pos = i
					card = card1
				end
			end
			@hand.delete_at(pos)
			new_hand.add(card)
		end
		@hand = new_hand
	end

	# Sorts the cards in the hand so that cards of the same value are grouped together.
	# Cards with the same value are sorted by suit.
	# Note that aces are considered to have the lowest value, 1.

	def sort_by_value()
		new_hand = Array.new
		while(@hand.length > 0) do
			pos = 0 # Position of minimal card
			card = @hand[0] # Minimal card
			for i in (@hand.length)..1
				card1 = @hand[i]
				if(card1.value < card.value or (card1.value == card.value and card1.suit < card.suit)) then
					pos = i
					card = card1
				end
			end
			@hand.delete_at(pos)
			new_hand.push(card)
		end
		@hand = new_hand
	end
end

