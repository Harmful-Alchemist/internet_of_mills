module Mill exposing (..)

import Json.Encode
import Json.Decode exposing (field)

type alias Mill =
    { mill_type : String
    , name : String
    , io_pin : Int
    , id : Int
    , on : Bool
    }

decodeMill : Json.Decode.Decoder Mill
decodeMill =
    Json.Decode.map5 Mill
        (field "type" Json.Decode.string)
        (field "name" Json.Decode.string)
        (field "io_pin" Json.Decode.int)
        (field "id" Json.Decode.int)
        (field "on" Json.Decode.bool)

encodeMill : Mill -> Json.Encode.Value
encodeMill record =
    Json.Encode.object
      [ ("mill", Json.Encode.object <|
        [ ("type",  Json.Encode.string <| record.mill_type)
        , ("name",  Json.Encode.string <| record.name)
        , ("io_pin",  Json.Encode.int <| record.io_pin)
        ]
        )
      ]
