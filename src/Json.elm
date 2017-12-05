module Json exposing (dataDecoder)

import Date exposing (Date)
import Json.Decode as JD exposing (Decoder)
import Json.Decode.Extra as JDE
import Types exposing (..)


dataDecoder : Decoder Data
dataDecoder =
    JD.field "members" (JD.keyValuePairs memberDecoder)
        |> JD.map (List.map Tuple.second)


memberDecoder : Decoder Member
memberDecoder =
    JD.map6 Member
        (JD.field "name" (JD.maybe JD.string))
        (JD.field "id" JD.string)
        (JD.field "local_score" JD.int)
        (JD.field "global_score" JD.int)
        (JD.field "stars" JD.int)
        (JD.field "completion_day_level" completionTimesDecoder)


completionTimesDecoder : Decoder (List ( Day, Star, Date ))
completionTimesDecoder =
    JD.keyValuePairs (JD.keyValuePairs (JD.field "get_star_ts" JDE.date))
        |> JD.map
            (\days ->
                days
                    |> List.concatMap
                        (\( day, stars ) ->
                            List.filterMap
                                (\( star, date ) ->
                                    Result.map2 (\d s -> ( d, s, date ))
                                        (String.toInt day)
                                        (String.toInt star)
                                        |> Result.toMaybe
                                )
                                stars
                        )
            )
