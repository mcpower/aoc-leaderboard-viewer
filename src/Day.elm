module Day exposing (..)

import Date
import Date.Extra as DE
import List.Extra
import Types exposing (..)

-- 2017/12/01, 05:00 GMT
-- in milliseconds
-- 1512104400000
-- TODO: rewrite Data to keep track of the event name
startOfAoC : Data -> Float
startOfAoC data =
    List.concatMap (.completionTimes) data
        |> List.map (\(x, y, time) -> time |> Date.fromTime |> Date.year)
        |> List.minimum
        |> Maybe.withDefault 2017
        |>
            (\year -> DE.fromSpec
                DE.utc
                (DE.atTime 5 0 0 0)
                (DE.calendarDate year Date.Dec 1)
            )
        |> Date.toTime
            


endOfAoC : Data -> Float
endOfAoC data =
    startOfAoC data + day * 26


day : Float
day =
    -- in milliseconds
    86400000


comfortableRange : Data -> Float -> ( Float, Float )
comfortableRange members dataMax =
    let
        start = startOfAoC members
    in
        ( start
        , findComfortableRange (dataMax + day) start
        )


findComfortableRange : Float -> Float -> Float
findComfortableRange dataMax current =
    let
        newTime =
            current + day
    in
        if newTime < dataMax then
            findComfortableRange dataMax newTime
        else
            current


findTicks : Float -> Float -> Float -> List Float
findTicks min max delta =
    (List.Extra.iterate
        (\val ->
            let
                newVal =
                    val + delta
            in
                if newVal < max then
                    Just newVal
                else
                    Nothing
        )
        min
    )
        ++ [ max ]
