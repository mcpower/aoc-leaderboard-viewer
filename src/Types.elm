module Types exposing (..)

import Plot exposing (Point)
import RemoteData exposing (WebData)
import Time exposing (Time)


type alias Snapshot =
    { url : String
    , cookie : String
    }


type alias Flags =
    { currentTime : Time
    , snapshot : Maybe Snapshot
    }


type alias Model =
    { url : String
    , cookie : String
    , data : WebData Data
    , timeOfFetch : Time
    , hover : Maybe Point
    }


type Msg
    = SetUrl String
    | SetCookie String
    | Fetch String String
    | FetchResult (WebData Data)
    | CurrentTime Time
    | Hover (Maybe Point)


type alias Data =
    List Member


type alias Member =
    { name : Maybe String
    , id : String
    , localScore : Int
    , globalScore : Int
    , stars : Int
    , completionTimes : List ( Day, Star, Time )
    }


type alias Day =
    Int


type alias Star =
    Int
