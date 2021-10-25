defmodule ExPoll.PollsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ExPoll.Polls` context.
  """

  @doc """
  Generate a poll.
  """
  def poll_fixture(attrs \\ %{}) do
    {:ok, poll} =
      attrs
      |> Enum.into(%{
        question: "some question"
      })
      |> ExPoll.Polls.create_poll()

    poll
  end

  @doc """
  Generate a option.
  """
  def option_fixture(attrs \\ %{}) do
    {:ok, option} =
      attrs
      |> Enum.into(%{
        value: "some value"
      })
      |> ExPoll.Polls.create_option()

    option
  end
end
