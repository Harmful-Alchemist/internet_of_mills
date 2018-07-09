defmodule  InternetOfMills.Peripheral.MillIO do
  @moduledoc """
  Turn mills on and off and see if they're on or off
  """

  alias ElixirALE.GPIO
  alias InternetOfMills.PinSupervisor

  def start_link do
    Agent.start_link fn -> %{} end, name: __MODULE__
  end

  @doc """
   Add a mill so we can interact with it's pin.
  """
  def add(mill) do
    spec_old = %{id: GPIO, start: {GPIO, :start_link, [mill.io_pin, :output]}}
    case DynamicSupervisor.start_child(PinSupervisor, spec_old)  do
        {:ok, pid} ->
          Agent.update __MODULE__, &Map.put(&1, mill, pid)
          {:ok, pid}
        {:error, msg} ->
          {:error, msg}
    end


  end

  @doc """
   Remove a mill, freeing it's pin.
  """
  def remove(mill) do
    pid = find(mill)
    DynamicSupervisor.terminate_child(PinSupervisor, pid)
    Agent.get_and_update  __MODULE__, &Map.pop(&1, mill)
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
    pid = find(mill)
    GPIO.write(pid, true)
  end

  @doc """
  Turn off a mill.
  """
  def off(mill) do
    pid = find(mill)
    GPIO.write(pid, false)
  end

  @doc """
   See if a mill is turned on.
  """
  def on?(mill) do
    :timer.sleep(100)
    case find(mill) do
      pid ->
        GPIO.read(pid) == 1
      nil ->
        false
    end
  end

  @doc """
    See if a mill is already there. Returns nil if it's not there. Otherwise returns the PID of the GPIO process.
  """
  def find(mill) do
    Agent.get  __MODULE__, &Map.get(&1, mill)
  end

end
