###
   tic tac toe
###


BLANK = " "
CIRCLE = "o"
CROSS = "x"

class Field
  constructor:() ->
    @array = []
    for i in [0..9]
      @array[i] = BLANK

  set:(value, row, col) ->
    if not @isEmpty(row, col) then throw 'field is not empty'
    @array[@index(row, col)] = value

  get:(row, col) ->
    return @array[@index(row, col)]

  reset:->
    for i in [0..@array.length]
      @array[i] = BLANK

  index:(row, col) ->
    if 3 > row >= 0 and 3 > col >= 0
      return row * 3 + col
    else
      throw "wrong dimension: row=#{row}, col=#{col}"

  isEmpty:(row, col) ->
    return @array[@index(row, col)] is BLANK

  print:->
    for i in [0..6] by 3
      row = "|"
      for j in [0..3 - 1]
        row += " #{@array[i + j]} |"
      console.log row


class Game
  constructor:->
    @field = new Field()
    @player1 = new Player(CROSS, new RandomStrategy())
    @player2 = new Player(CIRCLE, new RandomStrategy())
    @round = 1

  set:(player, row, col) ->
    @field.set(player.symbol, row, col)

  isFinished:->
    return @player1.hasWon(@field) or @player2.hasWon(@field) or @round > 9

  print:->
    console.log ""
    console.log "-- Round #{@round} --"
    @field.print()
    if @player1.hasWon(@field)
      console.log "player #{@player1.symbol} wins"
    else if @player2.hasWon(@field)
      console.log "player #{@player2.symbol} wins"
    else if @round >= 9
      console.log "game over"

  start:->
    @nextTurn() while not@isFinished()

  nextTurn:->
    @currentPlayer().makeTurn(@field)
    @print()
    @round++

  currentPlayer:->
    if @round % 2 == 1 then @player1 else @player2


class Player
  constructor:(@symbol, @strategy) ->

  hasWon: (field) ->
    ###
      0 1 2
      3 4 5
      6 7 8
    ###

    won = @symbol + @symbol + @symbol

    # check horizontal and vertical
    diagonal1 = ""
    diagonal2 = ""
    for i in [0..2]
      diagonal1 += field.get(i, i)
      diagonal2 += field.get(2 - i, i)

      vertical = ""
      horizontal = ""
      for j in [0..2]
        vertical += field.get(i, j)
        horizontal += field.get(j, i)

      if vertical is won or horizontal is won
        return true

    if diagonal1 is won or diagonal2 is won
        return true

    return false

  makeTurn:(field) ->
    [row, col] = @strategy.makeTurn(field)
    field.set(@symbol, row, col)


###
  This strategy is really simple: just determine next free field.
###
class GoofyStrategy
  makeTurn:(field) ->
    for row in [0..2]
      for col in [0..2]
        val = field.get row, col
        if val is BLANK
          return [row, col]

    throw 'cannot determine blank field'


###
  Randomly determine free field.
###
class RandomStrategy
  rand: ->
    return Math.floor(Math.random() * 3)

  makeTurn:(field) ->
    row = @rand()
    col = @rand()
    val = field.get row, col
    if (val is BLANK)
      return [row, col]
    else
      return @makeTurn(field)



game = new Game()
game.start()