module Main exposing (..)

import Http
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Mill exposing (..)
import Json.Decode as Decode

main : Program Never Model Msg
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

--Model
type alias Model = {
  mills : List Mill
  , newMill : Maybe Mill
  , error : Maybe String
}

--Init
init : (Model, Cmd Msg)
init =
  (Model [] Nothing Nothing,allMills)

--Update
type Msg = GetMills
 | NewMills (Result Http.Error (List Mill))
 | Delete Mill
 | Deleted (Result Http.Error String)
 | NewMill
 | NewName Mill String
 | NewType Mill String
 | NewPin Mill String
 | SubmitNewMill Mill
 | SubmittedNewMill (Result Http.Error String)
 | UpdateMill Mill
 | SubmitUpdatedMill Mill
 | SubmittedUpdatedMill (Result Http.Error String)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GetMills ->
      ({model | error = Nothing}, allMills)

    NewMills (Ok mills) ->
      ({model | mills = mills}, Cmd.none)

    NewMills (Err error) ->
      ({model | error = Just (toString error)}, Cmd.none)

    Delete mill ->
      (model, deleteMill mill)

    Deleted (Ok _) ->
      (model, allMills)

    Deleted (Err error) ->
      ({model | error = Just (toString error)}, Cmd.none)

    NewMill ->
      ({ model | newMill = Just emptyMill }, Cmd.none)

    NewName mill name ->
      ({model | newMill = (Just {mill | name = name})} , Cmd.none)

    NewType mill mill_type ->
      ({model | newMill = (Just {mill | mill_type = mill_type})}, Cmd.none)

    NewPin mill pin ->
      ({model | newMill = (Just {mill | io_pin = Result.withDefault -1 (String.toInt pin)})}, Cmd.none)

    SubmitNewMill  mill ->
      (model, (postNewMill model mill))

    SubmittedNewMill (Ok _) ->
      ({model | newMill = Nothing},  allMills)

    SubmittedNewMill (Err error) ->
      ({model | newMill = Nothing
      , error = Just (toString error)}, Cmd.none)

    UpdateMill mill ->
      ({ model | newMill = Just mill }, Cmd.none)

    SubmitUpdatedMill mill ->
      (model, (putUpdatedMill model mill))

    SubmittedUpdatedMill (Ok _) ->
      ({model | newMill = Nothing},  allMills)

    SubmittedUpdatedMill (Err error) ->
        ({model | newMill = Nothing
        , error = Just (toString error)}, Cmd.none)

emptyMill : Mill
emptyMill =
  {
  mill_type = ""
  , name = ""
  , io_pin = -1
  , id = -1
 }

--View
view : Model -> Html Msg
view model =
  case model.error of
    Nothing ->
      normalView model
    Just error ->
      errorView model error

errorView : Model -> String -> Html Msg
errorView model error =
  div [class "error"][text ("An error occured! " ++ error)
   , button [onClick GetMills][text "Oh no!"]
  ]

normalView : Model -> Html Msg
normalView model =
  case model.newMill of
    Just newMill ->
      div[class "new_mill"] [newMillForm model newMill]
    Nothing ->
      div [class "mills"] [
       viewMills model.mills
       , button [onClick NewMill] [text "New mill"]
  ]

viewMills : List Mill -> Html Msg
viewMills mills =
  div [class "mills"] (List.map viewMill mills)

viewMill : Mill -> Html Msg
viewMill mill =
  div [class "mill"] [
   div [class "name"] [text mill.name]
   , div [class "mill_type"] [text mill.mill_type]
   , div [class "io_pin"] [text (toString mill.io_pin)]
   , button [onClick (Delete mill)] [text "Delete" ]
   , button [onClick (UpdateMill mill)] [text "Update"]
  ]

newMillForm : Model -> Mill -> Html Msg
newMillForm model mill = --TODO update for editing mills so name etc are alright and you can edit, make sure same pin is ok
  let
    (namePh, typePh, pinPh) =
      case mill.id of
        -1 ->
          ("name", "type", "io pin number")
        _ ->
          (mill.name, mill.mill_type, (toString mill.io_pin))
  in
    div [class "mill_form"] [
    input [placeholder namePh, onInput (NewName mill)][]
    , input [placeholder typePh, onInput (NewType mill)][]
    , select [placeholder pinPh, onInput (NewPin mill)] (pinOptions model)
    , validateMill model mill
    ]

pinOptions : Model -> List (Html Msg)
pinOptions model =
  let
    possiblePiPins = List.filter (unusedPin (usedPins model)) (List.range 2 26)
  in
    List.map pinToOption (-1 :: possiblePiPins)

usedPins : Model -> List Int
usedPins model =
  List.map .io_pin model.mills

unusedPin : List Int -> Int -> Bool
unusedPin  usedPins pin=
  not (List.member pin usedPins)

pinToOption : Int -> Html Msg
pinToOption pin =
  let
    pinString = toString pin
  in
    option [value pinString][text pinString]


validateMill : Model -> Mill -> Html Msg
validateMill model mill =
  let
    (color, message) =
          if mill.name == "" then
            ("red", "Please enter a name")

          else if mill.mill_type == "" then
            ("red", "Please enter a type")

          else if mill.io_pin == -1 then
            ("red", "Please enter a pin number")

          else
            ("green", "Looking good!")
  in
    div [ style [("color", color)] ] (validationResult color message mill)


validationResult : String -> String -> Mill -> List (Html Msg)
validationResult color message mill =
  case color of
    "green" ->
      [text message, (correctButton mill)]
    _ ->
      [text message]

correctButton : Mill -> Html Msg
correctButton mill =
  case mill.id of
    -1 ->
      button [onClick (SubmitNewMill mill)][text "Submit"]
    _ ->
      button [onClick (SubmitUpdatedMill mill)][text "Submit"]

--http
allMills : Cmd Msg
allMills =
  let
   url = "/api/mills"
  in
   Http.send NewMills (Http.get url decodeMills)

decodeMills : Decode.Decoder (List Mill)
decodeMills =
  Decode.field "data" (Decode.list Mill.decodeMill)

deleteMill : Mill -> Cmd Msg
deleteMill mill =
  let
   url = "/api/mills/" ++ toString mill.id
  in
    Http.request { method = "DELETE"
    , headers = []
    , url = url
    , body = Http.emptyBody
    , expect = Http.expectString
    , timeout = Nothing
    , withCredentials = False
    } |> Http.send Deleted

postNewMill : Model -> Mill -> Cmd Msg
postNewMill model mill =
  let
    (url, encodedMill) =
    ("/api/mills", Mill.encodeMill mill)
  in
    Http.send SubmittedNewMill (Http.post url (Http.jsonBody encodedMill) (Decode.succeed ""))

putUpdatedMill : Model -> Mill -> Cmd Msg
putUpdatedMill model mill =
    let
     url = "/api/mills/" ++ toString mill.id
    in
      Http.request { method = "PUT"
      , headers = []
      , url = url
      , body = (Http.jsonBody (Mill.encodeMill mill))
      , expect = Http.expectString
      , timeout = Nothing
      , withCredentials = False
      } |> Http.send SubmittedUpdatedMill

--Subscriptions
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
