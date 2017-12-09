module View.Plot.Type.AllInOne exposing (allInOne)

import Types exposing (..)
import Html as H exposing (Html)
import View.Plot.Series exposing (series)
import Colors exposing (colorsList)
import View.Plot.PlotCustomizations exposing (plotCustomizations)
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
        (plotCustomizations model data junk)
        (seriesList model data)
        data
    ]


seriesList : Model -> Data -> List (Series Data Msg)
seriesList model data =
    List.map3 (series model data dotOptions)
        (data |> List.indexedMap (\i _ -> i == 0))
        (colorsList (List.length data))
        (data |> List.sortBy .localScore)


junk : PlotSummary -> List (JunkCustomizations Msg)
junk _ =
    []


dotOptions : DotOptions
dotOptions =
    { xLine = True
    , yLine = False
    , xTick = True
    , yTick = False
    , stripedHint = True
    }
