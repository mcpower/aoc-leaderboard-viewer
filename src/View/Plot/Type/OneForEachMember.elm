module View.Plot.Type.OneForEachMember exposing (oneForEachMember)

import Types exposing (..)
import Html as H exposing (Html)
import View.Name as View


oneForEachMember : Model -> Data -> List (Html Msg)
oneForEachMember model data =
    -- TODO
    []


title : Member -> String
title member =
    View.name member
        ++ (" (stars: " ++ toString member.stars)
        ++ (", local score: " ++ toString member.localScore)
        ++ ")"
