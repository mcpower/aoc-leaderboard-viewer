module View.OnePlot exposing (onePlot)

import Html as H exposing (Html)
import Html.Attributes as HA
import View.TextStyle as Text
import Date
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


onePlot : Maybe Point -> Float -> Float -> String -> Member -> Html Msg
onePlot hover maxDate maxDayStar color member =
    H.div
        [ HA.class "plot" ]
        [ P.viewSeriesCustom
            (customizations member maxDate maxDayStar hover)
            [ makeSeries hover color member ]
            member
        ]


customizations : Member -> Float -> Float -> Maybe Point -> PlotCustomizations Msg
customizations member maxDate maxDayStar hover =
    { defaultSeriesPlotCustomizations
        | hintContainer = P.flyingHintContainer P.normalHintContainerInner hover
        , height = 200
        , junk = \summary -> [ P.junk (title (View.name member) member.stars) (startOfAoC + day / 8) maxDayStar ]
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


title : String -> Int -> Svg msg
title memberName stars =
    P.viewLabel
        (Text.italic :: Text.attributes)
        (memberName ++ " (stars: " ++ toString stars ++ ")")


makeSeries : Maybe Point -> String -> Member -> Series Member Msg
makeSeries hover color member =
    { axis = axis hover .y (dayStarFromFloat >> formatDayStar) (P.interval 0 0.5)
    , interpolation = Linear Nothing [ SA.stroke color ]
    , toDataPoints = makeDataPoints hover color
    }


makeDataPoints : Maybe Point -> String -> Member -> List (DataPoint Msg)
makeDataPoints hover color member =
    member.completionTimes
        |> List.map
            (\( day, star, date ) ->
                let
                    x =
                        date |> Date.toTime

                    y =
                        dayStarToFloat day star
                in
                    dot
                        hover
                        (View.name member)
                        color
                        ( x, y )
            )
