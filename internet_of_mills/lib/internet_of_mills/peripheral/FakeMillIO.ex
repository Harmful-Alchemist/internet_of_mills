defmodule  InternetOfMills.Peripheral.FakeMillIO do
  @moduledoc """
  Turn mills on and off and see if they're on or off. But fake for developping.
  """

  def start_link do
    Agent.start_link fn -> [] end, name: __MODULE__
  end

  @doc """
   Add a mill so we can interact with it's pin.
  """
  def add(mill) do
    IO.puts("adding mill #{mill.name}")
    Agent.update __MODULE__, fn mills -> [{mill, false} | mills] end
  end

  @doc """
   Remove a mill, freeing it's pin.
  """
  def remove(mill) do
  IO.puts("Removing mill #{mill.name}")
  found = find(mill)
  Agent.update  __MODULE__, fn mills -> List.delete(mills, found) end
  end

  @doc """
   Update a mill.
  """
  def update(new_mill, old_mill) do
    remove(old_mill)
    add(new_mill)
    new_mill
  end

  @doc """
  Turn on a mill.
  """
  def on(mill) do
    IO.puts("turning on mill #{mill.name}")
    remove(mill)
    Agent.update __MODULE__, fn mills -> [{mill, true} | mills] end
  end

  @doc """
  Turn off a mill.
  """
  def off(mill) do
    IO.puts("turning off mill #{mill.name}")
    remove(mill)
    Agent.update __MODULE__, fn mills -> [{mill, false} | mills] end
  end

  @doc """
   See if a mill is turned on.
  """
  def on?(mill) do
    IO.puts("Checking if mill #{mill.name} is on")
    case find(mill) do
    {_, status} ->
      IO.puts("Found status for mill #{mill.name} it was #{status}")
      status
    nil ->
      IO.puts("Did not find mill #{mill.name}")
      false
    end
  end

  def find(mill) do
    IO.puts("Finding mill #{mill.name}")
    Agent.get  __MODULE__, fn mills -> Enum.find(mills, fn(element) -> match?({^mill, _}, element) end) end
  end

end
