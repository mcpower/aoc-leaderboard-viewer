module View.Name exposing (name)

import Types exposing (..)


name : Member -> String
name member =
    member.name
        |> Maybe.withDefault ("Anonymous #" ++ member.id)
