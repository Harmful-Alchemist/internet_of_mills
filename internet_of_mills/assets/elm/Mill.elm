module Mill exposing (..)

import Json.Encode
import Json.Decode exposing (field)

type alias Something =
    { mill_type : String
    , name : String
    , ioPin : Int
    , id : Int
    }

decodeSomething : Json.Decode.Decoder Something
decodeSomething =
    Json.Decode.map4 Something
        (field "type" Json.Decode.string)
        (field "name" Json.Decode.string)
        (field "ioPin" Json.Decode.int)
        (field "id" Json.Decode.int)

encodeSomething : Something -> Json.Encode.Value
encodeSomething record =
    Json.Encode.object
        [ ("type",  Json.Encode.string <| record.mill_type)
        , ("name",  Json.Encode.string <| record.name)
        , ("ioPin",  Json.Encode.int <| record.ioPin)
        , ("id",  Json.Encode.int <| record.id)
        ]
