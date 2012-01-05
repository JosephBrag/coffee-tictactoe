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
    if not@isEmpty(row, col) then throw 'field is not empty'
    @array[@index(row, col)] = value

  get:(row, col) ->
    @array[@index(row, col)]

  reset:->
    for i in [0..@array.length]
      @array[i] = BLANK

  index:(row, col) ->
    if 3 > row >= 0 and 3 > col >= 0
      row * 3 + col
    else
      throw "wrong dimension: row=#{row}, col=#{col}"

  isEmpty:(row, col) ->
    @array[@index(row, col)] is BLANK

  print:->
    for i in [0..6] by 3
      row = "|"
    for j in [0..3 - 1]
      row += " #{@array[i + j]} |"
      console.log row


class Game
  constructor:->
    @field = new Field()
    @player1 = new Player(CROSS, new SimpleStrategy())
    @player2 = new Player(CIRCLE, new SimpleStrategy())
    @round = 1

  set:(player, row, col) ->
    @field.set(player.symbol, row, col)

  isFinished:->
    @round > 9

  print:->
    console.log ""
    console.log "-- Round #{@round} --"
    @field.print()

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
  makeTurn:(field) ->
    [row, col] = @strategy.makeTurn(field)
    field.set(@symbol, row, col)


class SimpleStrategy
  constructor:->
  makeTurn:(field) ->
    for row in [0..2]
      for col in [0..2]
        val = field.get row, col
        if val is BLANK
          return [row, col]


game = new Game()
game.start()
