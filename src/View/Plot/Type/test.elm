onePlot : Maybe Point -> Float -> Float -> Data -> String -> Member -> Html Msg
onePlot hover maxDate maxDayStar data color member =
    H.div
        [ HA.class "plot" ]
        [ P.viewSeriesCustom
            (customizations member maxDate maxDayStar hover)
            [ makeSeries hover color data member
            , makeInvisibleSeries hover data member
            ]
            member
        ]


customizations : Member -> Float -> Float -> Maybe Point -> PlotCustomizations Msg
customizations member maxDate maxDayStar hover =
    { defaultSeriesPlotCustomizations
        | hintContainer = P.flyingHintContainer P.normalHintContainerInner hover
        , height = 200
        , junk = \summary -> [ P.junk (title member) (startOfAoC + day / 8) maxDayStar ]
        , grid =
            { horizontal = P.decentGrid
            , vertical =
                P.customGrid
                    (\summary ->
                        findTicks (maxDate - day)
                            |> List.map
                                (\tick ->
                                    { attributes = [ SA.stroke colors.grey ]
                                    , position = tick
                                    }
                                )
                    )
            }
        , horizontalAxis =
            axis
                hover
                .x
                (Date.fromTime >> formatDate)
                (always (findTicks maxDate))
        , margin =
            { top = 10
            , bottom = 30
            , left = 60
            , right = 30
            }
        , toRangeLowest = always startOfAoC
        , toRangeHighest = always maxDate
        , toDomainLowest = always 1.0
        , toDomainHighest = always maxDayStar
    }


makeSeries : Maybe Point -> String -> Data -> Member -> Series Member Msg
makeSeries hover color data member =
    { axis = axis hover .y (dayStarFromFloat >> formatDayStar) (P.interval 0 0.5)
    , interpolation = Linear Nothing [ SA.stroke color ]
    , toDataPoints = makeDataPoints hover color data
    }


makeInvisibleSeries : Maybe Point -> Data -> Member -> Series Member Msg
makeInvisibleSeries hover data member =
    { axis = axis hover .y (dayStarFromFloat >> formatDayStar) (P.interval 0 0.5)
    , interpolation = None
    , toDataPoints = makeInvisibleDataPoints hover data
    }


points : Data -> Dict ( Day, Star ) (List ( String, Time ))
points data =
    data
        |> List.map (\member -> ( View.name member, member.completionTimes ))
        |> List.concatMap
            (\( name, times ) ->
                List.map
                    (\( day, star, time ) -> ( name, day, star, time ))
                    times
            )
        |> Dict.Extra.groupBy (\( name, day, star, time ) -> ( day, star ))
        |> Dict.map
            (\_ list ->
                List.map
                    (\( name, day, star, time ) -> ( name, time ))
                    list
            )


getPointFor : Data -> ( Day, Star ) -> String -> Maybe Int
getPointFor data ( day, star ) wantedName =
    let
        allSolutions =
            points data
                |> Dict.get ( day, star )
                |> Maybe.withDefault []

        maxSolutionPoints =
            List.length data
    in
        allSolutions
            |> List.sortBy Tuple.second
            |> List.indexedMap (,)
            |> List.filter (\( i, ( name, date ) ) -> name == wantedName)
            |> List.head
            -- first one gets (length) points, second (length - 1), ...
            |> Maybe.map (\( i, ( name, date ) ) -> maxSolutionPoints - i)


makeInvisibleDataPoints : Maybe Point -> Data -> Member -> List (DataPoint Msg)
makeInvisibleDataPoints hover data member =
    data
        |> List.filter (\m -> m.id /= member.id)
        |> List.concatMap .completionTimes
        |> List.map
            (\( day, star, time ) ->
                let
                    x =
                        time

                    y =
                        dayStarToFloat day star
                in
                    invisibleDot
                        hover
                        ( x, y )
            )


makeDataPoints : Maybe Point -> String -> Data -> Member -> List (DataPoint Msg)
makeDataPoints hover color data member =
    member.completionTimes
        |> List.map
            (\( day, star, time ) ->
                let
                    x =
                        time

                    y =
                        dayStarToFloat day star

                    name =
                        View.name member
                in
                    dot
                        hover
                        name
                        color
                        ( x, y )
                        (getPointFor data ( day, star ) name)
            )


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

