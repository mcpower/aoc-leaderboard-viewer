module View.Date exposing (..)

import Date exposing (Date, Month(..))
import Html as H exposing (Html)


parseDate : Date -> { day : String, hour : String, minute : String }
parseDate date =
    { day = date |> Date.day |> toString
    , hour = date |> Date.hour |> toString |> String.pad 2 '0'
    , minute = date |> Date.minute |> toString |> String.pad 2 '0'
    }


formatDate : Date -> String
formatDate date =
    let
        { day, hour, minute } =
            parseDate date
    in
        "Dec " ++ day ++ ", " ++ hour ++ ":" ++ minute


formatDateForHint : Float -> Html msg
formatDateForHint dateFloat =
    let
        { day, hour, minute } =
            parseDate (Date.fromTime dateFloat)
    in
        ("Solved on Dec " ++ day ++ ", " ++ hour ++ ":" ++ minute)
            |> H.text
