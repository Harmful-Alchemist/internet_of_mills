defmodule InternetOfMillsWeb.MillView do
  use InternetOfMillsWeb, :view
  alias InternetOfMillsWeb.MillView

  def render("index.json", %{mills: mills}) do
    %{data: render_many(mills, MillView, "mill.json")}
  end

  def render("show.json", %{mill: mill}) do
    %{data: render_one(mill, MillView, "mill.json")}
  end

  def render("mill.json", %{mill: mill}) do
    %{id: mill.id,
      name: mill.name,
      type: mill.type,
      io_pin: mill.io_pin}
  end
end
