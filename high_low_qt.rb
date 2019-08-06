# This program allows you to play the famed high_low card game you know and love
# only now with a GUI!
# A card is dealt from a @deck of cards.
# You have to predict whether the next card will be higher or lower

require 'Qt4'
require_relative 'deck.rb'

class HighLowField < Qt::Widget
	signals 'averageScoreChanged(double)', 'scoreChanged(int)'
	slots 'lowPressed()', 'highPressed()', 'startGame()', 'dealCard()'

	def initialize(parent = nil)
		super

		@current_card = nil
		@next_card = nil
		@guess = nil
		@playing = false # True when a game is currently playing
		@average_score = 0.0
		@total_score = 0
		@games_played = 0
		@correct_guesses = 0
		@deck = Deck.new
		@reveal = false # True when the next card should be revealed
		@message = "Click play to start!" # Message sent to the player
		@image = Qt::Image.new("cards.png")
	end
	
	def highPressed()
		@guess = 'H'
		if(@playing and not(@reveal)) then
			checkPrediction
		else
			@message = "Press Deal to continue playing!"
			update
		end
	end

	def lowPressed()
		@guess = 'L'
		if(@playing and not(@reveal)) then
			checkPrediction
		else
			@message = "Press Deal to continue playing!"
			update
		end
	end

	def paintEvent(event)
		painter = Qt::Painter.new(self)
		draw_cards(painter)
		painter.end
	end

	def draw_cards(painter)
		puts("drawing cards")
		# Draw the current card
		if(@current_card == nil) then # If there is no current card, draw a face down card
			source_y = 4 * 123
			source_x = 2 * 79
		else
			source_y = @current_card.suit * 123
			puts("source_y = #{source_y}")
			source_x = (@current_card.value-1) * 79
		end
		target_y = 1
		target_x = 30
		
		target = Qt::Rect.new(target_x.to_i, target_y.to_i, 79, 123)
		source = Qt::Rect.new(source_x.to_i, source_y.to_i, 79, 123)
		puts("drawing first card")
		painter.drawImage(target, @image, source)

		# Draw the next card
		if(@next_card != nil and @reveal == true) then
			source_y = @next_card.suit * 123
			source_x = (@next_card.value-1) * 79
		else # If the card should not be revealed, draw it face down
			source_y = 4 * 123
			source_x = 2 * 79
		end
		target_x = 180

		target.setRect(target_x.to_i, target_y.to_i, 79, 123)
		source.setRect(source_x.to_i, source_y.to_i, 79, 123)
		painter.drawImage(target, @image, source)

		painter.drawText(Qt::Rect.new(0,100,300,100), Qt::AlignCenter, tr(@message))
		puts("drawcards finished")
	end

	def startGame()
		if(@playing) then
			@message = "You are already playing a game!"
			update
		else
			@playing = true
			@games_played += 1
			@correct_guesses = 0

			emit scoreChanged(@correct_guesses)

			@deck.shuffle

			@current_card = @deck.deal_card
			
			@next_card = @deck.deal_card
			@reveal = false
			@message = "Is the next card higher or lower?"
			update
		end
	end

	def dealCard()
		if(@playing and @reveal) then
			@current_card = @next_card
			@next_card = @deck.deal_card
			@reveal = false
			@message = "Is the next card higher or lower?"
		elsif(not(@playing) and @reveal) then
			startGame
		end
		update
	end

	def endGame()
		@total_score += @correct_guesses
		@average_score = @total_score.fdiv(@games_played)
		emit averageScoreChanged(@average_score)
		update
		@playing = false
	end

	def checkPrediction()
		@reveal = true # Reveal the card to the player

		if(@next_card.value == @current_card.value) then
			puts("Next card is equal")
			@message = "You lose on ties. Sorry!"
			endGame
		end	
	
		if(@next_card.value > @current_card.value) then
			if(@guess == 'H') then
				@message = "Your prediction is correct!"
				@correct_guesses += 1
				emit scoreChanged(@correct_guesses)
				update
			else
				@message = "Your prediction is incorrect!"
				endGame
			end
		else
			if(@guess == 'L') then
				@message = "Your prediction is correct!"
				@correct_guesses += 1
				emit scoreChanged(@correct_guesses)
				update
			else
				@message = "Your prediction is incorrect!"
				endGame
			end
		end
	end
end



class HighLowWidget < Qt::Widget
	def initialize(parent = nil)
		puts("Initializing HighLowWidget")
		super

		higher = Qt::PushButton.new(tr("Higher"))
		font = Qt::Font.new('Times', 18, Qt::Font::Bold)
		higher.setFont(font)
		lower = Qt::PushButton.new(tr("Lower"))
		lower.setFont(font)
		play = Qt::PushButton.new(tr("Play"))
		play.setFont(font)
		deal = Qt::PushButton.new(tr("Deal"))
		deal.setFont(font)
		@highLowField = HighLowField.new

		connect(higher, SIGNAL("clicked()"), @highLowField, SLOT("highPressed()")) 

		connect(lower, SIGNAL("clicked()"), @highLowField, SLOT("lowPressed()"))

		connect(play, SIGNAL("clicked()"), @highLowField, SLOT("startGame()"))

		connect(deal, SIGNAL("clicked()"), @highLowField, SLOT("dealCard()"))

		current_score = Qt::LCDNumber.new
		connect(@highLowField, SIGNAL("scoreChanged(int)"), current_score, SLOT("display(int)"))

		average_score = Qt::LCDNumber.new
		connect(@highLowField, SIGNAL("averageScoreChanged(double)"), average_score, SLOT("display(double)"))

		bottomLayout = Qt::HBoxLayout.new
		bottomLayout.addWidget(play)
		bottomLayout.addWidget(deal)

		gridLayout = Qt::GridLayout.new
		gridLayout.addWidget(@highLowField, 0, 1)
		gridLayout.addWidget(current_score, 0, 0)
		gridLayout.addWidget(average_score, 1, 0)
		gridLayout.addWidget(higher, 1, 1)
		gridLayout.addWidget(lower, 2, 1)
		gridLayout.addLayout(bottomLayout, 3, 1)
		gridLayout.setColumnMinimumWidth(1, 300)
		setLayout(gridLayout)
	end
end

app = Qt::Application.new(ARGV)

widget = HighLowWidget.new
p(widget)
puts("HighLowWidget should be ready by now.")
widget.resize(500, 300)
widget.show()
app.exec

