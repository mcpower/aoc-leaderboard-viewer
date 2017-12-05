module Update exposing (initModel, update)

import Json.Decode as JD
import Types exposing (..)
import Json exposing (..)


initJson : String
initJson =
    """{"owner_id":"201025","event":"2017","members":{"201076":{"completion_day_level":{"2":{"2":{"get_star_ts":"2017-12-05T10:17:24-0500"},"1":{"get_star_ts":"2017-12-05T09:53:14-0500"}},"1":{"1":{"get_star_ts":"2017-12-01T02:26:43-0500"},"2":{"get_star_ts":"2017-12-05T09:29:03-0500"}}},"local_score":7,"name":"schod","last_star_ts":"2017-12-05T10:17:24-0500","id":"201076","stars":4,"global_score":0},"201735":{"stars":8,"global_score":0,"completion_day_level":{"3":{"2":{"get_star_ts":"2017-12-03T13:48:26-0500"},"1":{"get_star_ts":"2017-12-03T11:13:04-0500"}},"1":{"1":{"get_star_ts":"2017-12-01T15:07:25-0500"},"2":{"get_star_ts":"2017-12-01T15:25:55-0500"}},"2":{"2":{"get_star_ts":"2017-12-02T13:35:20-0500"},"1":{"get_star_ts":"2017-12-02T12:53:19-0500"}},"4":{"1":{"get_star_ts":"2017-12-04T04:26:53-0500"},"2":{"get_star_ts":"2017-12-04T04:29:41-0500"}}},"local_score":23,"last_star_ts":"2017-12-04T04:29:41-0500","name":"Jaroslav Bazala","id":"201735"},"1114":{"stars":10,"global_score":0,"local_score":46,"completion_day_level":{"5":{"1":{"get_star_ts":"2017-12-05T00:18:25-0500"},"2":{"get_star_ts":"2017-12-05T00:20:50-0500"}},"3":{"1":{"get_star_ts":"2017-12-03T00:50:52-0500"},"2":{"get_star_ts":"2017-12-03T01:33:07-0500"}},"1":{"1":{"get_star_ts":"2017-12-01T00:17:23-0500"},"2":{"get_star_ts":"2017-12-01T00:30:53-0500"}},"4":{"1":{"get_star_ts":"2017-12-04T00:38:41-0500"},"2":{"get_star_ts":"2017-12-04T00:43:56-0500"}},"2":{"2":{"get_star_ts":"2017-12-02T00:26:01-0500"},"1":{"get_star_ts":"2017-12-02T00:10:38-0500"}}},"last_star_ts":"2017-12-05T00:20:50-0500","id":"1114","name":"Martin Janiczek"},"247429":{"stars":10,"global_score":0,"local_score":25,"completion_day_level":{"5":{"2":{"get_star_ts":"2017-12-05T00:18:38-0500"},"1":{"get_star_ts":"2017-12-05T00:15:57-0500"}},"3":{"1":{"get_star_ts":"2017-12-04T05:58:16-0500"},"2":{"get_star_ts":"2017-12-04T05:58:37-0500"}},"1":{"2":{"get_star_ts":"2017-12-04T05:56:03-0500"},"1":{"get_star_ts":"2017-12-04T04:22:15-0500"}},"2":{"2":{"get_star_ts":"2017-12-04T04:48:28-0500"},"1":{"get_star_ts":"2017-12-04T04:36:47-0500"}},"4":{"2":{"get_star_ts":"2017-12-04T05:54:28-0500"},"1":{"get_star_ts":"2017-12-04T05:51:38-0500"}}},"last_star_ts":"2017-12-05T00:18:38-0500","id":"247429","name":"porubsky"},"201025":{"stars":10,"global_score":0,"local_score":39,"completion_day_level":{"4":{"2":{"get_star_ts":"2017-12-04T00:36:09-0500"},"1":{"get_star_ts":"2017-12-04T00:29:11-0500"}},"2":{"2":{"get_star_ts":"2017-12-02T12:15:29-0500"},"1":{"get_star_ts":"2017-12-02T11:11:56-0500"}},"3":{"1":{"get_star_ts":"2017-12-03T10:04:18-0500"},"2":{"get_star_ts":"2017-12-03T10:50:54-0500"}},"5":{"2":{"get_star_ts":"2017-12-05T01:50:50-0500"},"1":{"get_star_ts":"2017-12-05T01:45:35-0500"}},"1":{"2":{"get_star_ts":"2017-12-01T02:51:31-0500"},"1":{"get_star_ts":"2017-12-01T02:44:40-0500"}}},"name":"Martin Stříž","last_star_ts":"2017-12-05T01:50:50-0500","id":"201025"}}}"""


initModel : Model
initModel =
    { json = initJson
    , data = decode initJson
    , hover = Nothing
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetJson json ->
            { model
                | json = json
                , data = decode json
            }

        Hover hover ->
            { model | hover = hover }


decode : String -> Result String Data
decode json =
    JD.decodeString dataDecoder json
