defmodule Checkeyatex do
  @moduledoc """
  Documentation for `Checkeyatex`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Checkeyatex.hello()
      :world

  """

  def start(_, _) do
    start_link()
  end
  @yata_key :yatapp_translations
  @name :yata_key_checker
  def start_link() do
    initial_value =
      :ets.match(:yatapp_translations, :"$1")
      |> List.flatten()
      |> Enum.reduce([], fn
        {"fr."<>key, _value}, acc ->
          acc ++ [key]
        {"en."<>key, _value}, acc ->
          acc ++ [key]
        {key, _value}, acc ->
          acc ++ [key]
        end
      )
      |> Enum.uniq()
    Agent.start_link(fn -> initial_value end, name: @name)
  end

  def delete_key(key) do
    Agent.update(@name, fn list -> list -- [key] end)
  end

  def show_list() do
    Agent.get(@name, & &1)
  end
end
