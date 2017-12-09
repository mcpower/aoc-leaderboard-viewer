module View.Plot.Series exposing (series)

import Types exposing (..)
import Svg.Attributes as SA
import DayStar
import Score exposing (score, maxScore)
import View.Plot.Axis exposing (verticalAxis)
import View.Date as Date
import View.Plot.Dot exposing (dot)
import View.Name as View
import Plot as P
    exposing
        ( Series
        , DataPoint
        , Point
        , Interpolation(..)
        )


series : Model -> Data -> DotOptions -> Bool -> String -> Member -> Series Data Msg
series model data dotOptions hasAxis color member =
    { axis =
        if hasAxis then
            verticalAxis dotOptions.yTick model.hover (Date.max data)
        else
            P.sometimesYouDoNotHaveAnAxis
    , interpolation = interpolation color
    , toDataPoints = dataPoints model.hover color member dotOptions
    }


interpolation : String -> Interpolation
interpolation color =
    Linear Nothing [ SA.stroke color ]


dataPoints :
    Maybe Point
    -> String
    -> Member
    -> DotOptions
    -> Data
    -> List (DataPoint Msg)
dataPoints hover color member dotOptions data =
    member.completionTimes
        |> List.map (toDataPoint hover color member data dotOptions)


toDataPoint :
    Maybe Point
    -> String
    -> Member
    -> Data
    -> DotOptions
    -> CompletionTime
    -> DataPoint Msg
toDataPoint hover color member data dotOptions (( day, star, time ) as completionTime) =
    let
        name =
            View.name member
    in
        dot
            dotOptions
            hover
            name
            color
            (toXY completionTime)
            (score data ( day, star ) name)
            (maxScore data)


toXY : CompletionTime -> ( Float, Float )
toXY ( day, star, time ) =
    ( DayStar.toFloat day star
    , time
    )
