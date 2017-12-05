module View.AllPlots exposing (allPlots)

import Colors exposing (..)
import Date
import Html as H exposing (Html)
import Html.Attributes as HA
import View.OnePlot exposing (onePlot)
import Plot as P exposing (Point)
import Types exposing (..)
import Day exposing (endOfAoC, comfortableRange)
import View.DayStar exposing (dayStarToFloat)


allPlots : Model -> Html Msg
allPlots { data, hover } =
    data
        |> Result.map (justAllPlots hover)
        |> Result.mapError (Debug.log "JSON decoding error")
        |> Result.withDefault (H.text "Incorrect data!")


justAllPlots : Maybe Point -> Data -> Html Msg
justAllPlots hover data =
    let
        allCompletions =
            data
                |> List.concatMap .completionTimes

        maxDate =
            allCompletions
                |> List.map (\( _, _, date ) -> Date.toTime date)
                |> List.maximum
                |> Maybe.withDefault endOfAoC
                |> comfortableRange
                |> Tuple.second

        maxDayStar =
            allCompletions
                |> List.map (\( day, star, _ ) -> dayStarToFloat day star)
                |> List.maximum
                |> Maybe.withDefault 25.5
    in
        H.div
            [ HA.class "plots" ]
            (List.map2 (onePlot hover maxDate maxDayStar)
                (colorsList (List.length data))
                (data |> List.sortBy (.localScore >> negate))
            )
