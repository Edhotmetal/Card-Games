# Card Games!

## Disclaimer!

card.rb, deck.rb, hand.rb, and high_low.rb are NOT my own creations!
I merely translated them from Java into Ruby with a few minor edits.
The original Java files and much, much more can be found at math.hws.edu/javanotes/index.html

### display_card.rb

This script uses the Qt framework to display a shuffled 54 card deck in columns of five cards.
It doesn't do anything else.

### high_low_qt.rb

This program allows you to play the famed high low card game you know and love, only now with a GUI!
A card is dealt from a deck of cards.
You have to predict whether the next card will be higher or lower.
If the next card is the same, you lose.

The main window is a HighLowWidget. It contains all of the widgets including the HighLowField where the game actually takes place.
On the left side, there are two numbers. The top one is your current score and the bottom is your average score.
Click "Play" to start a new game. Click "Higher" or "Lower" according to your prediction, and then click "Deal" to get a new card.

### 21_cards.rb

Three columns of seven cards are displayed before the player. The player must choose a card and point to the column that contains it.
The cards are picked up and laid out again. The player must point towards the column that contains his card two more times.
After the third round, the computer knows the player's card!
