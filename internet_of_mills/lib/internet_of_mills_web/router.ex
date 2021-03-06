defmodule InternetOfMillsWeb.Router do
  use InternetOfMillsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", InternetOfMillsWeb do
    pipe_through :browser # Use the default browser stack

    forward "/cam", PicamStreamer
    get "/", PageController, :index
  end


  scope "/api", InternetOfMillsWeb do
    pipe_through :api

    resources "/mills", MillController, except: [:new, :edit] do
      post "/on", MillController, :on
      post "/off", MillController, :off
  end
  end
end
