defmodule InternetOfMillsWeb.MillController do
  use InternetOfMillsWeb, :controller

  alias InternetOfMills.Peripheral
  alias InternetOfMills.Peripheral.Mill

  action_fallback InternetOfMillsWeb.FallbackController

  def index(conn, _params) do
    mills = Peripheral.list_mills()
    render(conn, "index.json", mills: mills)
  end

  def create(conn, %{"mill" => mill_params}) do
    with {:ok, %Mill{} = mill} <- Peripheral.create_mill(mill_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", mill_path(conn, :show, mill))
      |> render("show.json", mill: mill)
    end
  end

  def show(conn, %{"id" => id}) do
    mill = Peripheral.get_mill!(id)
    render(conn, "show.json", mill: mill)
  end

  def update(conn, %{"id" => id, "mill" => mill_params}) do
    mill = Peripheral.get_mill!(id)

    with {:ok, %Mill{} = mill} <- Peripheral.update_mill(mill, mill_params) do
      render(conn, "show.json", mill: mill)
    end
  end

  def delete(conn, %{"id" => id}) do
    mill = Peripheral.get_mill!(id)
    with {:ok, %Mill{}} <- Peripheral.delete_mill(mill) do
      send_resp(conn, :no_content, "")
    end
  end

  def on(conn,  %{"mill_id" => id}) do
    Peripheral.get_mill!(id) |> Peripheral.turn_on
    send_resp(conn, :no_content, "placeholder") #place holder resp, turn_on needs a return and error response
  end

  def off(conn,  %{"mill_id" => id}) do
    Peripheral.get_mill!(id) |> Peripheral.turn_off
    send_resp(conn, :no_content, "placeholder") #place holder resp, turn_off needs a return and error response
  end

end
