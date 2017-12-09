module View.Member exposing (description)

import View.Name as View
import Types exposing (..)


description : Member -> String
description member =
    View.name member
        ++ (" (stars: " ++ toString member.stars)
        ++ (", local score: " ++ toString member.localScore)
        ++ ")"
