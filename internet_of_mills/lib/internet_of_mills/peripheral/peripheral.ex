defmodule InternetOfMills.Peripheral do
  @moduledoc """
  The Peripheral context.
  """

  import Ecto.Query, warn: false
  alias InternetOfMills.Repo

  alias InternetOfMills.Peripheral.Mill
  @millIO Application.get_env(:internet_of_mills, :mill_io)


  @doc """
  Returns the list of mills.

  ## Examples

      iex> list_mills()
      [%Mill{}, ...]

  """
  def list_mills do
    Repo.all(Mill)
  end

  @doc """
  Gets a single mill.

  Raises `Ecto.NoResultsError` if the Mill does not exist.

  ## Examples

      iex> get_mill!(123)
      %Mill{}

      iex> get_mill!(456)
      ** (Ecto.NoResultsError)

  """
  def get_mill!(id), do: Repo.get!(Mill, id)

  @doc """
  Creates a mill.

  ## Examples

      iex> create_mill(%{field: value})
      {:ok, %Mill{}}

      iex> create_mill(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_mill(attrs \\ %{}) do
    %Mill{}
    |> Mill.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a mill.

  ## Examples

      iex> update_mill(mill, %{field: new_value})
      {:ok, %Mill{}}

      iex> update_mill(mill, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_mill(%Mill{} = mill, attrs) do
    @millIO.remove(mill)
    mill
    |> Mill.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Mill.

  ## Examples

      iex> delete_mill(mill)
      {:ok, %Mill{}}

      iex> delete_mill(mill)
      {:error, %Ecto.Changeset{}}

  """
  def delete_mill(%Mill{} = mill) do
    @millIO.remove(mill)
    Repo.delete(mill)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking mill changes.

  ## Examples

      iex> change_mill(mill)
      %Ecto.Changeset{source: %Mill{}}

  """
  def change_mill(%Mill{} = mill) do
    Mill.changeset(mill, %{})
  end

  def turn_on(%Mill{} = mill) do
    mill_ready(mill)
    @millIO.on(mill)
  end

  def turn_off(%Mill{} = mill) do
    mill_ready(mill)
    @millIO.off(mill)
  end

  defp mill_ready(mill) do
    if @millIO.find(mill) == nil do
      @millIO.add(mill)
    end
  end

end
