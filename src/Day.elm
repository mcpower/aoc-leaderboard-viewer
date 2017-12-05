module Day exposing (..)

import List.Extra


startOfAoC : Float
startOfAoC =
    -- 2017/12/01, 05:00 GMT
    -- in milliseconds
    1512104400000


endOfAoC : Float
endOfAoC =
    startOfAoC + day * 26


day : Float
day =
    -- in milliseconds
    86400000


comfortableRange : Float -> ( Float, Float )
comfortableRange dataMax =
    ( startOfAoC
    , findComfortableRange (dataMax + day) startOfAoC
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


findTicks : Float -> List Float
findTicks dataMax =
    List.Extra.iterate
        (\time ->
            let
                newTime =
                    time + day
            in
                if newTime < (dataMax + day) then
                    Just newTime
                else
                    Nothing
        )
        startOfAoC
