module Json exposing (dataDecoder)

import Json.Decode as JD exposing (Decoder)
import Json.Decode.Extra as JDE
import Time exposing (Time)
import String
import Types exposing (..)


dataDecoder : Decoder Data
dataDecoder =
    JD.field "members" (JD.keyValuePairs memberDecoder)
        |> JD.map (List.map Tuple.second)
        |> JD.map (\data -> data |> List.filter (\member -> member.stars > 0))


memberDecoder : Decoder Member
memberDecoder =
    JD.map6 Member
        (JD.field "name" (JD.maybe JD.string))
        (JD.field "id" JD.string)
        (JD.field "local_score" JD.int)
        (JD.field "global_score" JD.int)
        (JD.field "stars" JD.int)
        (JD.field "completion_day_level" completionTimesDecoder)


completionTimesDecoder : Decoder (List ( Day, Star, Time ))
completionTimesDecoder =
    JD.keyValuePairs (JD.keyValuePairs (JD.field "get_star_ts" JD.string))
        |> JD.map
            (\days ->
                days
                    |> List.concatMap
                        (\( day, stars ) ->
                            List.filterMap
                                (\( star, date ) ->
                                    Result.map3 (\d s date -> ( d, s, date * Time.second ))
                                        (String.toInt day)
                                        (String.toInt star)
                                        (String.toFloat date)
                                        |> Result.toMaybe
                                )
                                stars
                        )
            )
