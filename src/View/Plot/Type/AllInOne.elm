module View.Plot.Type.AllInOne exposing (allInOne)

import Types exposing (..)
import Html as H exposing (Html)
import View.Plot.Series exposing (series)
import Colors exposing (colorsList)
import View.Plot.PlotCustomizations exposing (plotCustomizations)
import View.Plot.Junk.Legend as Junk
import Plot as P
    exposing
        ( Series
        , JunkCustomizations
        , PlotSummary
        , DataPoint
        )


allInOne : Model -> Data -> List (Html Msg)
allInOne model data =
    [ P.viewSeriesCustom
        (plotCustomizations model data (junk data))
        (seriesList model data)
        data
    ]


seriesList : Model -> Data -> List (Series Data Msg)
seriesList model data =
    List.map3 (series model data dotOptions)
        (data.members |> List.indexedMap (\i _ -> i == 0))
        (colorsList (List.length data.members))
        (data.members |> List.sortBy (.localScore >> negate))


junk : Data -> PlotSummary -> List (JunkCustomizations Msg)
junk data _ =
    [ Junk.legend data ]


dotOptions : DotOptions
dotOptions =
    { xLine = True
    , yLine = True
    , xTick = True
    , yTick = True
    , stripedHint = True
    }
