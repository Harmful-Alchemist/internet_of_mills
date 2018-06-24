defmodule InternetOfMills.PeripheralTest do
  use InternetOfMills.DataCase

  alias InternetOfMills.Peripheral

  describe "mills" do
    alias InternetOfMills.Peripheral.Mill

    @valid_attrs %{io_pin: 18, name: "some name", type: "some type"}
    @update_attrs %{io_pin: 23, name: "some updated name", type: "some updated type"}
    @invalid_attrs %{io_pin: nil, name: nil, type: nil}
    @millIO Application.get_env(:internet_of_mills, :mill_io)

    def mill_fixture(attrs \\ %{}) do
      {:ok, mill} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Peripheral.create_mill()

      mill
    end

    test "list_mills/0 returns all mills" do
      mill = mill_fixture()
      assert Peripheral.list_mills() == [mill]
    end

    test "get_mill!/1 returns the mill with given id" do
      mill = mill_fixture()
      assert Peripheral.get_mill!(mill.id) == mill
    end

    test "create_mill/1 with valid data creates a mill" do
      assert {:ok, %Mill{} = mill} = Peripheral.create_mill(@valid_attrs)
      assert mill.io_pin == 18
      assert mill.name == "some name"
      assert mill.type == "some type"
    end

    test "create_mill/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Peripheral.create_mill(@invalid_attrs)
    end

    test "update_mill/2 with valid data updates the mill" do
      mill = mill_fixture()
      assert {:ok, mill} = Peripheral.update_mill(mill, @update_attrs)
      assert %Mill{} = mill
      assert mill.io_pin == 23
      assert mill.name == "some updated name"
      assert mill.type == "some updated type"
    end

    test "update_mill/2 with invalid data returns error changeset" do
      mill = mill_fixture()
      assert {:error, %Ecto.Changeset{}} = Peripheral.update_mill(mill, @invalid_attrs)
      assert mill == Peripheral.get_mill!(mill.id)
    end

    test "delete_mill/1 deletes the mill" do
      mill = mill_fixture()
      assert {:ok, %Mill{}} = Peripheral.delete_mill(mill)
      assert_raise Ecto.NoResultsError, fn -> Peripheral.get_mill!(mill.id) end
    end

    test "change_mill/1 returns a mill changeset" do
      mill = mill_fixture()
      assert %Ecto.Changeset{} = Peripheral.change_mill(mill)
    end

    test "turn_on/1 turns on a mill" do
      mill = mill_fixture()
      Peripheral.turn_on(mill)
      assert @millIO.on?(mill)
    end

    test "turn_off/1 turns off a mill" do
      mill = mill_fixture()
      Peripheral.turn_on(mill)
      Peripheral.turn_off(mill)
      assert not @millIO.on?(mill)
    end
  end
end
