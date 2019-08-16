# This program lays out three columns of cards in front of the player
# The player is asked to pick a card and point at the column that contains it
# The cards are then picked up and laid down again
# The player is asked to point at the column that contains the card again
# This is repeated three times. The program determines the player's card after three rounds

require_relative 'hand.rb'
require_relative 'deck.rb'
require 'Qt4'

class CardField < Qt::Widget
	slots 'columnOnePressed()', 'columnTwoPressed()', 'columnThreePressed()', 'startGame()'

	def initialize()
		super

		@round = 1 # The number of times the player has selected a column
		@deck = Deck.new
		@main_hand = Hand.new
		@column_one = Hand.new
		@column_two = Hand.new
		@column_three = Hand.new
		@reveal = false # True when the program knows the player's card
		@playing = false # True when a game is playing
		@player_card = nil
		@message = "Three columns of cards will be displayed before the player.\n Select a card then point to the column that contains it!\n Click Deal to start playing."
		@image = Qt::Image.new("cards.png")
		@default_font = Qt::Font.new("Times", 13, Qt::Font::Bold)
	end

	def startGame()
		if(@playing) then
			@message = "Select the column that your card is in!"
		else
			@playing = true
			first_deal
			deal_cards
			@round = 1
		end
	end

	# Take 21 cards from the deck and place them into the main hand
	def first_deal()
		@deck.shuffle
		for i in 1..21 do
			@main_hand.add_card(@deck.deal_card)
		end
		@column_one.clear
		@column_two.clear
		@column_three.clear
	end

	# Deal the 21 cards in the main hand to the three columns
	def deal_cards()
		while(@main_hand.get_card_count > 0) do
			@column_one.add_card(@main_hand.take_last_card)
			@column_two.add_card(@main_hand.take_last_card)
			@column_three.add_card(@main_hand.take_last_card)
		end
		@message = "Choose the column that contains your card!"
		update
	end

	# The player has selected column one
	def columnOnePressed()
		if(not(@playing)) then
			@message = "Click Deal to start playing!"
			update
		elsif(@round < 3) then
			pick_up_cards(1)
		else
			reveal_card(1)
		end
	end

	# The player has selected column two
	def columnTwoPressed()
		if(not(@playing)) then
			@message = "Click Deal to start playing!"
			update
		elsif(@round < 3) then
			pick_up_cards(2)
		else
			reveal_card(2)
		end
	end

	# The player has selected column three
	def columnThreePressed()
		if(not(@playing)) then
			@message = "Click Deal to start playing!"
			update	
		elsif(@round < 3) then
			pick_up_cards(3)
		else
			reveal_card(3)
		end
	end

	# Pick up the three columns of cards and place them in the main hand making sure to
	# pick up the selected column second
	def pick_up_cards(column)
		@round += 1
		case column
		when 1
			take_column(2)
			take_column(1)
			take_column(3)
		when 2
			take_column(1)
			take_column(2)
			take_column(3)
		when 3
			take_column(1)
			take_column(3)
			take_column(2)
		end
		deal_cards
	end

	# Pick up the selected column and place it into the main hand
	def take_column(column)
		case column
		when 1
			while(@column_one.get_card_count > 0) do
				@main_hand.add_card(@column_one.remove_card_at(0))
			end
		when 2
			while(@column_two.get_card_count > 0) do
				@main_hand.add_card(@column_two.remove_card_at(0))
			end
		when 3
			while(@column_three.get_card_count > 0) do
				@main_hand.add_card(@column_three.remove_card_at(0))
			end
		end
	end

	# Reveals the player's card in the selected column
	def reveal_card(column)
		case column
		when 1
			@player_card = @column_one.get_card(3)
		when 2
			@player_card = @column_two.get_card(3)
		when 3
			@player_card = @column_three.get_card(3)
		end
		@message = "Your card is #{@player_card}!"
		update
		@playing = false
	end

	def paintEvent(event)
		painter = Qt::Painter.new(self)
		if(@playing) then
			draw_cards(painter)
		else
			if(@player_card != nil) then # If the program knows the player's card, display it
				source_x = (@player_card.value - 1) * 79
				source_y = @player_card.suit * 123
				target_x = 200
				target_y = 130
				target = Qt::Rect.new(target_x.to_i, target_y.to_i, 79, 123)
				source = Qt::Rect.new(source_x.to_i, source_y.to_i, 79, 123)
				painter.drawImage(target, @image, source)
			else # If no game has been played yet
				painter.setFont(Qt::Font.new("Elephant", 26))
				painter.drawText(Qt::Rect.new(100,10,300,100), Qt::AlignCenter, tr("21 Card Trick!"))
			end
			painter.setFont(@default_font)
			painter.drawText(Qt::Rect.new(0,50,500,500), Qt::AlignCenter, @message)
		end
		painter.end
	end

	def draw_cards(painter)
		# Draw the first column
		target = Qt::Rect.new # The area where the card will be drawn
		source = Qt::Rect.new # the area of cards.png that contains the card to be drawn
		target_x = 40
		target_y = 0
		for i in 0..6 do
			source_x = (@column_one.get_card(i).value - 1) * 79
			source_y = @column_one.get_card(i).suit * 123
			target.setRect(target_x.to_i, target_y.to_i, 79, 123)
			source.setRect(source_x.to_i, source_y.to_i, 79, 123)
			painter.drawImage(target, @image, source)
			target_y += 50
		end

		# Draw the second column
		target_x += 150
		target_y = 0
		for i in 0..6 do
			source_x = (@column_two.get_card(i).value - 1) * 79
			source_y = @column_two.get_card(i).suit * 123
			target.setRect(target_x.to_i, target_y.to_i, 79, 123)
			source.setRect(source_x.to_i, source_y.to_i, 79, 123)
			painter.drawImage(target, @image, source)		
			target_y += 50
		end

		# Draw the third column
		target_x += 150 
		target_y = 0
		for i in 0..6
			source_x = (@column_three.get_card(i).value - 1) * 79
			source_y = @column_three.get_card(i).suit * 123
			target.setRect(target_x.to_i, target_y.to_i, 79, 123)
			source.setRect(source_x.to_i, source_y.to_i, 79, 123)
			painter.drawImage(target, @image, source)
			target_y += 50
		end

		painter.drawText(Qt::Rect.new(100,400,250,100), Qt::AlignCenter, tr(@message))
	end
end

class CardTrickWidget < Qt::Widget
	def initialize(parent = nil)
		super
		setWindowTitle("21 Card Trick!")

		one = Qt::PushButton.new(tr("One"))
		two = Qt::PushButton.new(tr("Two"))
		three = Qt::PushButton.new(tr("Three"))
		font = Qt::Font.new("Times", 18, Qt::Font::Bold)
		one.setFont(font)
		two.setFont(font)
		three.setFont(font)

		deal = Qt::PushButton.new(tr("Deal"))
		deal.setFont(font)

		card_field = CardField.new

		connect(one, SIGNAL("clicked()"), card_field, SLOT("columnOnePressed()"))
		connect(two, SIGNAL("clicked()"), card_field, SLOT("columnTwoPressed()"))
		connect(three, SIGNAL("clicked()"), card_field, SLOT("columnThreePressed()"))
		connect(deal, SIGNAL("clicked()"), card_field, SLOT("startGame()"))

		buttonLayout = Qt::HBoxLayout.new
		buttonLayout.addWidget(one)
		buttonLayout.addWidget(two)
		buttonLayout.addWidget(three)

		cardLayout = Qt::VBoxLayout.new
		cardLayout.addWidget(card_field)
		cardLayout.addLayout(buttonLayout)
		cardLayout.addWidget(deal)
		setLayout(cardLayout)
		resize(500,600)
	end
end

app = Qt::Application.new(ARGV)

widget = CardTrickWidget.new
widget.show()
app.exec
