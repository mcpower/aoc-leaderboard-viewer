module View.Plot.Type.OneForEachMember exposing (oneForEachMember)

import Types exposing (..)
import Html as H exposing (Html)
import View.Name as View
import DayStar
import Colors exposing (colorsList)
import View.Plot.Series exposing (series)
import View.Plot.PlotCustomizations exposing (plotCustomizations)
import View.Plot.Junk.Title as Junk
import Plot as P
    exposing
        ( Series
        , JunkCustomizations
        , PlotSummary
        )


oneForEachMember : Model -> Data -> List (Html Msg)
oneForEachMember model data =
    List.map2 (onePlot model data)
        (colorsList (List.length data))
        (data |> List.sortBy (.localScore >> negate))


onePlot : Model -> Data -> String -> Member -> Html Msg
onePlot model data color member =
    P.viewSeriesCustom
        (plotCustomizations model data (junk data member))
        (seriesList model data color member)
        data


seriesList : Model -> Data -> String -> Member -> List (Series Data Msg)
seriesList model data color member =
    data
        |> List.filter (\m -> m.id == member.id)
        |> List.map (series model data color)


junk : Data -> Member -> PlotSummary -> List (JunkCustomizations Msg)
junk data member _ =
    [ Junk.title (title member) (DayStar.max data) ]


title : Member -> String
title member =
    View.name member
        ++ (" (stars: " ++ toString member.stars)
        ++ (", local score: " ++ toString member.localScore)
        ++ ")"
