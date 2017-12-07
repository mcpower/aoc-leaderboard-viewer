module View.AllPlots exposing (allPlots)

import Colors exposing (..)
import Html as H exposing (Html)
import Html.Attributes as HA
import View.OnePlot exposing (onePlot)
import Plot as P exposing (Point)
import Types exposing (..)
import Day exposing (endOfAoC, comfortableRange)
import View.DayStar exposing (dayStarToFloat)
import Example
import RemoteData exposing (RemoteData(..))
import Http


allPlots : Model -> Html Msg
allPlots ({ data, hover } as model) =
    case data of
        NotAsked ->
            if Example.shouldShow model then
                justAllPlots hover Example.data
            else
                H.text ""

        Loading ->
            viewLoading

        Failure err ->
            viewFailure err

        Success realData ->
            justAllPlots hover realData


viewLoading : Html Msg
viewLoading =
    H.text "Loading from the AoC site..."


viewFailure : Http.Error -> Html Msg
viewFailure err =
    H.text <| "Error: " ++ toString err


justAllPlots : Maybe Point -> Data -> Html Msg
justAllPlots hover data =
    let
        allCompletions =
            data
                |> List.concatMap .completionTimes

        maxDate =
            allCompletions
                |> List.map (\( _, _, time ) -> time)
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
            (List.map2 (onePlot hover maxDate maxDayStar data)
                (colorsList (List.length data))
                (data |> List.sortBy (.localScore >> negate))
            )
