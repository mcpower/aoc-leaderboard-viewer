module View.Plot.Series exposing (series)

import Types exposing (..)
import Svg.Attributes as SA
import DayStar
import Score exposing (score, maxScore)
import View.Plot.Axis exposing (verticalAxis)
import View.Name as View
import View.Plot.Dot exposing (dot)
import Plot as P
    exposing
        ( Series
        , Point
        , DataPoint
        , Interpolation(..)
        )


series : Model -> Data -> String -> Member -> Series Data Msg
series model data color member =
    { axis = verticalAxis model.hover
    , interpolation = interpolation color
    , toDataPoints = dataPoints model.hover color member
    }


interpolation : String -> Interpolation
interpolation color =
    Linear Nothing [ SA.stroke color ]


dataPoints : Maybe Point -> String -> Member -> Data -> List (DataPoint Msg)
dataPoints hover color member data =
    member.completionTimes
        |> List.map (toDataPoint hover color member data)


toDataPoint : Maybe Point -> String -> Member -> Data -> CompletionTime -> DataPoint Msg
toDataPoint hover color member data (( day, star, time ) as completionTime) =
    let
        name =
            View.name member
    in
        dot
            hover
            name
            color
            (toXY completionTime)
            (score data ( day, star ) name)
            (maxScore data)


toXY : CompletionTime -> ( Float, Float )
toXY ( day, star, time ) =
    ( time
    , DayStar.toFloat day star
    )
