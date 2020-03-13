# This program creates a deck from deck.rb, shuffles it,
# and displays the cards in columns of five cards

require 'Qt4'
require_relative 'deck.rb'

class CardWidget < Qt::Widget
	def initialize(parent = nil)
		super
		setWindowTitle("Displaying cards!")

		@deck = Deck.new(true)
		@deck.shuffle
	end

	def paintEvent(event)
		painter = Qt::Painter.new(self)

		draw_cards(painter)
		painter.end
	end

	def draw_cards(painter)
		target_x = 50 
		target_y = 0
		# Create the rects and image outside of the loop for greater efficiency
		target = Qt::Rect.new
		source = Qt::Rect.new
		image = Qt::Image.new("cards.png") # Load the image containing all of the cards
		# This loop displays all of the cards in the deck
		@deck.deck.each { |card|
			source_y = card.suit * 123 # Offset y position by a multiple of 123 to get the right suit in cards.png
			source_x = (card.value-1) * 79 # Offset x position by a multiple of 79 to get the right card in cards.png

			# Create a new column every five cards
			if(target_y > 200) then
				target_y = 0
				target_x += 100
			end
			target_y += 50
			# Why do I have to typecast to integer here??
			target.setRect(target_x.to_i, target_y.to_i, 79, 123) # Set where the card will be drawn
			source.setRect(source_x.to_i, source_y.to_i, 79, 123) # Get the right card from cards.png
			painter.drawImage(target, image, source)
		}
	end
end

app = Qt::Application.new(ARGV)

widget = CardWidget.new

widget.resize(1200, 500)

widget.show

app.exec
