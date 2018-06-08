defmodule  InternetOfMills.Peripheral.MillIO do
  @moduledoc """
  Turn mills on and off and see if they're on or off
  """

  def start_link do
    Agent.start_link fn -> [] end, name: __MODULE__
  end

  @doc """
   Add a mill so we can interact with it's pin.
  """
  def add(mill) do
    case GPIO.start_link(mill.io_pin, :output)  do
        {:ok, pid} ->
          Agent.update __MODULE__, fn mills -> [{mill, pid} | mills] end
          {:ok, pid}
        error ->
          error
    end


  end

  @doc """
   Remove a mill, freeing it's pin.
  """
  def remove(mill) do
    GPIO.release(mill.io_pin)
    Agent.update  __MODULE__, fn mills -> List.delete(mills, find(mill)) end
  end

  @doc """
   Update a mill.
  """
  def update(old_mill, new_mill) do
    remove(old_mill)
    add(new_mill)
  end

  @doc """
  Turn on a mill.
  """
  def on(mill) do
    {mill, pid} = find(mill)
    GPIO.write(pid, true)
  end

  @doc """
  Turn off a mill.
  """
  def off(mill) do
    {mill, pid} = find(mill)
    GPIO.write(pid, false)
  end

  @doc """
   See if a mill is turned on.
  """
  def on?(mill) do
    case find(mill) do
      {mill, pid} ->
        GPIO.read(pid) == 1
      nil ->
        false
    end
  end

  def find(mill) do
    Agent.get  __MODULE__, fn mills -> Enum.find(mills, fn(element) -> match?({mill, _}, element) end) end
  end

end
