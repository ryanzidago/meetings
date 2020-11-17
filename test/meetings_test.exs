defmodule MeetingsTest do
  use ExUnit.Case
  doctest Meetings

  test "greets the world" do
    assert Meetings.hello() == :world
  end
end
