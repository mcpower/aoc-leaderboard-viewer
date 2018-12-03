module Types exposing (..)

import Plot
    exposing
        ( Point
        , DataPoint
        )
import RemoteData exposing (WebData)
import Time exposing (Time)


type alias Snapshot =
    { url : String
    , cookie : String
    , plot : String
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
    , plot : Plot
    }


type Msg
    = SetUrl String
    | SetCookie String
    | Fetch String String
    | SetJson String
    | FetchResult (WebData Data)
    | CurrentTime Time
    | Hover (Maybe Point)
    | ShowPlot Plot


type alias Data =
    { members : List Member
    , event : String
    }


type alias Member =
    { name : Maybe String
    , id : String
    , localScore : Int
    , globalScore : Int
    , stars : Int
    , completionTimes : List CompletionTime
    }


type alias CompletionTime =
    ( Day, Star, Time )


type alias Day =
    Int


type alias Star =
    Int


type Plot
    = OneForEachMember
    | AllInOne


type alias DotOptions =
    { xLine : Bool
    , yLine : Bool
    , xTick : Bool
    , yTick : Bool
    , stripedHint : Bool
    }
