module View.OnePlot exposing (onePlot)

import Html as H exposing (Html)
import Html.Attributes as HA
import View.TextStyle as Text
import Date exposing (Date)
import Dict exposing (Dict)
import Dict.Extra
import Colors exposing (colors)
import Day exposing (..)
import Svg as S exposing (Svg)
import Svg.Attributes as SA
import Plot as P
    exposing
        ( Point
        , Series
        , Interpolation(..)
        , PlotCustomizations
        , DataPoint
        , defaultSeriesPlotCustomizations
        )
import Types exposing (..)
import View.Axis exposing (axis)
import View.Dot exposing (dot)
import View.Date exposing (formatDate)
import View.DayStar
    exposing
        ( dayStarToFloat
        , dayStarFromFloat
        , formatDayStar
        )
import View.Name as View


onePlot : Maybe Point -> Float -> Float -> Data -> String -> Member -> Html Msg
onePlot hover maxDate maxDayStar data color member =
    H.div
        [ HA.class "plot" ]
        [ P.viewSeriesCustom
            (customizations member maxDate maxDayStar hover)
            [ makeSeries hover color data member ]
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


title : Member -> Svg msg
title member =
    P.viewLabel
        (Text.italic :: Text.attributes)
        (View.name member ++ " (stars: " ++ toString member.stars ++ ", local score: " ++ toString member.localScore ++ ")")


makeSeries : Maybe Point -> String -> Data -> Member -> Series Member Msg
makeSeries hover color data member =
    { axis = axis hover .y (dayStarFromFloat >> formatDayStar) (P.interval 0 0.5)
    , interpolation = Linear Nothing [ SA.stroke color ]
    , toDataPoints = makeDataPoints hover color data
    }


points : Data -> Dict ( Day, Star ) (List ( String, Date ))
points data =
    data
        |> List.map (\member -> ( View.name member, member.completionTimes ))
        |> List.concatMap
            (\( name, times ) ->
                List.map
                    (\( day, star, date ) -> ( name, day, star, date ))
                    times
            )
        |> Dict.Extra.groupBy (\( name, day, star, date ) -> ( day, star ))
        |> Dict.map
            (\_ list ->
                List.map
                    (\( name, day, star, date ) -> ( name, date ))
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
            |> List.sortBy (Tuple.second >> Date.toTime)
            |> List.indexedMap (,)
            |> List.filter (\( i, ( name, date ) ) -> name == wantedName)
            |> List.head
            -- first one gets (length) points, second (length - 1), ...
            |> Maybe.map (\( i, ( name, date ) ) -> maxSolutionPoints - i)


makeDataPoints : Maybe Point -> String -> Data -> Member -> List (DataPoint Msg)
makeDataPoints hover color data member =
    member.completionTimes
        |> List.map
            (\( day, star, date ) ->
                let
                    x =
                        date |> Date.toTime

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
