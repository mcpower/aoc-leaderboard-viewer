module View.Date exposing (..)

import Date exposing (Date, Month(..))
import Day exposing (endOfAoC, comfortableRange)
import Types exposing (..)


parseDate :
    Date
    ->
        { day : String
        , hour : String
        , minute : String
        , second : String
        }
parseDate date =
    { day = date |> Date.day |> toString
    , hour = date |> Date.hour |> toString |> String.pad 2 '0'
    , minute = date |> Date.minute |> toString |> String.pad 2 '0'
    , second = date |> Date.second |> toString |> String.pad 2 '0'
    }


format : Date -> String
format date =
    let
        { day, hour, minute } =
            parseDate date
    in
        "Dec " ++ day ++ ", " ++ hour ++ ":" ++ minute


formatWithSeconds : Date -> String
formatWithSeconds date =
    let
        { day, hour, minute, second } =
            parseDate date
    in
        "Dec " ++ day ++ ", " ++ hour ++ ":" ++ minute ++ ":" ++ second


max : Data -> Float
max data =
    data
        |> List.concatMap .completionTimes
        |> List.map (\( _, _, time ) -> time)
        |> List.maximum
        |> Maybe.withDefault (endOfAoC data)
        |> comfortableRange data
        |> Tuple.second
