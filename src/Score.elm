module Score exposing (score, maxScore)

import Types exposing (..)
import Dict exposing (Dict)
import Dict.Extra
import View.Name as View
import Time exposing (Time)


score : Data -> ( Day, Star ) -> String -> Maybe Int
score data ( day, star ) wantedName =
    let
        allSolutions =
            groupedTimes data
                |> Dict.get ( day, star )
                |> Maybe.withDefault []

        maxSolutionPoints =
            List.length data
    in
        allSolutions
            |> List.sortBy Tuple.second
            |> List.indexedMap (,)
            |> List.filter (\( i, ( name, date ) ) -> name == wantedName)
            |> List.head
            -- first one gets (length) points, second (length - 1), ...
            |> Maybe.map (\( i, ( name, date ) ) -> maxSolutionPoints - i)


maxScore : Data -> Int
maxScore data =
    List.length data


groupedTimes : Data -> Dict ( Day, Star ) (List ( String, Time ))
groupedTimes data =
    -- TODO refactor
    data
        |> List.map (\member -> ( View.name member, member.completionTimes ))
        |> List.concatMap
            (\( name, times ) ->
                List.map
                    (\( day, star, time ) -> ( name, day, star, time ))
                    times
            )
        |> Dict.Extra.groupBy (\( name, day, star, time ) -> ( day, star ))
        |> Dict.map
            (\_ list ->
                List.map
                    (\( name, day, star, time ) -> ( name, time ))
                    list
            )
