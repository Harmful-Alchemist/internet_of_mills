defmodule InternetOfMills.Peripheral.Mill do
  use Ecto.Schema
  import Ecto.Changeset
  alias InternetOfMills.Repo

  schema "mills" do
    field :io_pin, :integer
    field :name, :string
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(mill, attrs) do
    mill
    |> cast(attrs, [:name, :type, :io_pin])
    |> validate_required([:name, :type, :io_pin])
    |> validate_number(:io_pin, greater_than: 1, message: "The pins on the raspberry pi 3 are 2 through 26, so please use a number greater than 1")
    |> validate_number(:io_pin, less_than: 27, message: "The pins on the raspberry pi 3 are 2 through 26, so please use a number less than 27")
    |> unsafe_validate_unique(:io_pin, Repo)
  end
end
