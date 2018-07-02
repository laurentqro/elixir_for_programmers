defmodule HangmanTest do
  use ExUnit.Case
  alias Hangman.Game

  test "new_game returns structure" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "state isn't changed for :won or :lost game" do
    for state <- [:won, :lost] do
      game = Game.new_game() |> Map.put(:game_state, state)
      assert { ^game, _tally } = Game.make_move(game, "x")
    end
  end

  test "first occurence of letter is not already used" do
    game = Game.new_game()
    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state != :already_used
  end

  test "second occurence of letter is already used" do
    game = Game.new_game()
    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state != :already_used

    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "a good guess is recognized" do
    game = Game.new_game("wibble")
    { game, _tally } = Game.make_move(game, "w")

    assert game.game_state == :good_guess
    assert game.turns_left == 7
  end

  test "a guessed word is a won game" do
    game = Game.new_game("wibble")
    { game, _tally } = Game.make_move(game, "w")
    { game, _tally } = Game.make_move(game, "i")
    { game, _tally } = Game.make_move(game, "b")
    { game, _tally } = Game.make_move(game, "b")
    { game, _tally } = Game.make_move(game, "l")
    { game, _tally } = Game.make_move(game, "e")

    assert game.game_state == :won
  end

  test "a bad guess is recognized" do
    game = Game.new_game("foo")
    { game, _tally } = Game.make_move(game, "a")

    assert game.turns_left == 6
    assert game.game_state == :bad_guess
  end

  test "no turns left is a lost game" do
    game = Game.new_game("foo")
    { game, _tally } = Game.make_move(game, "a")
    { game, _tally } = Game.make_move(game, "b")
    { game, _tally } = Game.make_move(game, "c")
    { game, _tally } = Game.make_move(game, "d")
    { game, _tally } = Game.make_move(game, "e")
    { game, _tally } = Game.make_move(game, "g")
    { game, _tally } = Game.make_move(game, "h")

    assert game.game_state == :lost
  end
end
