# This program displays a card from cards.png

require 'Qt4'

class CardWindow < Qt::Widget
	def initialize(parent = nil)
		super

		# Create a quit button
		quit = Qt::PushButton.new(tr('Quit'))
		quit.setFont(Qt::Font.new('Times', 18, Qt::Font::Bold))

		connect(quit, SIGNAL('clicked()'), $qApp, SLOT('quit()')) # Make the quit button quit the program

		# Create the view to display the card
		card_view = Qt::GraphicsView.new
		card_scene = Qt::GraphicsScene.new
		card_view.setScene(card_scene)

		# Import the whole cards image
		card_item = card_scene.addPixmap(Qt::Pixmap::fromImage(Qt::Image.new("cards.png")))
		# Set the dimensions of the scene
		card_scene.setSceneRect(0,120,80,120)
		
		gridLayout = Qt::GridLayout.new
		gridLayout.addWidget(quit)
		gridLayout.addWidget(card_view)
		setLayout(gridLayout)
	end
end

app = Qt::Application.new(ARGV)

widget = CardWindow.new

widget.resize(500, 500)

widget.show

app.exec

