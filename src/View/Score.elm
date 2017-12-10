module View.Score exposing (format, style)


format : Maybe Int -> Int -> String
format maybeScore maxScore =
    maybeScore
        |> Maybe.map
            (\score ->
                toString score
                    ++ " "
                    ++ pts score
                    ++ " out of "
                    ++ toString maxScore
            )
        |> Maybe.withDefault ""


pts : Int -> String
pts score =
    if score > 1 then
        "pts"
    else
        "pt"


style : Bool -> Maybe Int -> Int -> List ( String, String )
style striped maybeScore maxScore =
    maybeScore
        |> Maybe.map (\score -> maxScore - score + 1)
        |> Maybe.map
            (\score ->
                ( "order", toString score )
                    :: if striped && score % 2 == 1 then
                        [ ( "background-color", "rgba(0,0,0,.05)" ) ]
                       else
                        []
            )
        |> Maybe.withDefault []
