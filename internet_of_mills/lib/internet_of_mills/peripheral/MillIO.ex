defmodule  InternetOfMills.Peripheral.MillIO do
  @moduledoc """
  Turn mills on and off and see if they're on or off
  """

  alias ElixirALE.GPIO
  alias InternetOfMills.PinSupervisor

  def start_link do
    Agent.start_link fn -> [] end, name: __MODULE__
  end

  @doc """
   Add a mill so we can interact with it's pin.
  """
  def add(mill) do
    IO.puts("adding a mill")
    case DynamicSupervisor.start_child(PinSupervisor, {GPIO, pin: mill.io_pin, pin_direction: :output})  do
        {:ok, pid} ->
          IO.puts("with pid #{pid}")
          Agent.update __MODULE__, fn mills -> [{mill, pid} | mills] end
          {:ok, pid}
        {:error, msg} ->
          IO.puts("Uh oh couldn't a add a mill because: #{msg}")
          {:error, msg}
    end


  end

  @doc """
   Remove a mill, freeing it's pin.
  """
  def remove(mill) do
    GPIO.release(mill.io_pin)
    {_mill, pid} = find(mill)
    DynamicSupervisor.terminate_child(PinSupervisor, pid)
    Agent.update  __MODULE__, fn mills -> List.delete(mills, find(mill)) end
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
    {_mill, pid} = find(mill)
    GPIO.write(pid, true)
  end

  @doc """
  Turn off a mill.
  """
  def off(mill) do
    {_mill, pid} = find(mill)
    GPIO.write(pid, false)
  end

  @doc """
   See if a mill is turned on.
  """
  def on?(mill) do
    :timer.sleep(100)
    case find(mill) do
      {_mill, pid} ->
        GPIO.read(pid) == 1
      nil ->
        false
    end
  end

  def find(mill) do
    Agent.get  __MODULE__, fn mills -> Enum.find(mills, fn(element) -> match?({^mill, _}, element) end) end
  end

end
