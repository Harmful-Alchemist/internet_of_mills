module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Mill exposing (..)


main : Program Never Model Msg
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


--Init
init : (Model, Cmd Msg)
init =
  (Model "Hello Program World!", Cmd.none)

--Model
type alias Model = {
  text : String
}

--Update
type Msg = NewText

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NewText ->
      (model, Cmd.none)

--View
view : Model -> Html Msg
view model =
  div [class "bg-primary"] [text model.text]

--Subscriptions
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
