module View.Plot.Grid exposing (gridAlignedOnMidnightEST)

import Plot as P exposing (Grid)
import Svg.Attributes as SA
import Colors exposing (colors)
import Day exposing (day)


gridAlignedOnMidnightEST : Float -> Grid
gridAlignedOnMidnightEST maxDate =
    -- TODO refactor
    P.customGrid
        (\summary ->
            Day.findTicks (maxDate - day)
                |> List.map
                    (\tick ->
                        { attributes = [ SA.stroke colors.grey ]
                        , position = tick
                        }
                    )
        )
