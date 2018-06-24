defmodule InternetOfMillsWeb.MillControllerTest do
  use InternetOfMillsWeb.ConnCase

  alias InternetOfMills.Peripheral
  alias InternetOfMills.Peripheral.Mill

  @create_attrs %{io_pin: 18, name: "some name", type: "some type"}
  @update_attrs %{io_pin: 23, name: "some updated name", type: "some updated type"}
  @invalid_attrs %{io_pin: nil, name: nil, type: nil}

  def fixture(:mill) do
    {:ok, mill} = Peripheral.create_mill(@create_attrs)
    mill
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all mills", %{conn: conn} do
      conn = get conn, mill_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create mill" do
    test "renders mill when data is valid", %{conn: conn} do
      conn = post conn, mill_path(conn, :create), mill: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, mill_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "io_pin" => 18,
        "name" => "some name",
        "type" => "some type",
        "on" => false}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, mill_path(conn, :create), mill: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update mill" do
    setup [:create_mill]

    test "renders mill when data is valid", %{conn: conn, mill: %Mill{id: id} = mill} do
      conn = put conn, mill_path(conn, :update, mill), mill: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, mill_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "io_pin" => 23,
        "name" => "some updated name",
        "type" => "some updated type",
        "on" => false}
    end

    test "renders errors when data is invalid", %{conn: conn, mill: mill} do
      conn = put conn, mill_path(conn, :update, mill), mill: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete mill" do
    setup [:create_mill]

    test "deletes chosen mill", %{conn: conn, mill: mill} do
      conn = delete conn, mill_path(conn, :delete, mill)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, mill_path(conn, :show, mill)
      end
    end
  end

  defp create_mill(_) do
    mill = fixture(:mill)
    {:ok, mill: mill}
  end
end
