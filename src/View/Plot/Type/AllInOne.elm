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
    List.map2 (series model data)
        (colorsList (List.length data))
        -- smallest first ↓ so that the best scores are most visible
        (data |> List.sortBy .localScore)


junk : PlotSummary -> List (JunkCustomizations Msg)
junk _ =
    []
