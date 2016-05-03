module Model exposing (..)

-- where

import Array exposing (Array)
import Json.Encode as Encode
import Json.Decode as Decode


type Instrument
  = Kick
  | Snare
  | Clap
  | OpenHat
  | ClosedHat


instruments : List Instrument
instruments =
  [ Kick
  , Snare
  , Clap
  , OpenHat
  , ClosedHat
  ]


decodeInstrument : Decode.Decoder Instrument
decodeInstrument =
  let
    parse value =
      case value of
        "Kick" ->
          Ok Kick

        "Snare" ->
          Ok Snare

        "Clap" ->
          Ok Clap

        "OpenHat" ->
          Ok OpenHat

        "ClosedHat" ->
          Ok ClosedHat

        _ ->
          Err "Unknown instrument"
  in
    Decode.customDecoder Decode.string parse


encodeInstrument : Instrument -> Encode.Value
encodeInstrument =
  toString >> Encode.string


instrumentToString : Instrument -> String
instrumentToString =
  toString


type alias Slot =
  { enabled : Bool
  , volume : Float
  }


encodeSlot : Slot -> Encode.Value
encodeSlot slot =
  Encode.object
    [ ( "enabled", Encode.bool slot.enabled )
    , ( "volumne", Encode.float slot.volume )
    ]


type alias Track =
  { instrument : Instrument
  , slots : Array Slot
  }


encodeTrack : Track -> Encode.Value
encodeTrack track =
  Encode.object
    [ ( "instrument", encodeInstrument track.instrument )
    , ( "slots", Encode.list <| List.map encodeSlot <| Array.toList track.slots )
    ]


type alias LoadState =
  { loading : Bool
  , progress : Float
  , failed : Bool
  }


type alias Model =
  { tempo : Int
  , isPlaying : Bool
  , currentSlotIndex : Int
  , tracks : Array Track
  , maxSlots : Int
  , loadState : LoadState
  }


encodeModel : Model -> Encode.Value
encodeModel model =
  Encode.object
    [ ( "tempo", Encode.int model.tempo )
    , ( "isPlaying", Encode.bool model.isPlaying )
    , ( "currentSlotIndex", Encode.int model.currentSlotIndex )
    , ( "tracks", Encode.list <| List.map encodeTrack <| Array.toList model.tracks )
    , ( "maxSlots", Encode.int model.maxSlots )
    ]


maxSlots : Int
maxSlots =
  32


model : Model
model =
  { tempo = 128
  , isPlaying = False
  , currentSlotIndex = 0
  , tracks = Array.empty
  , maxSlots = maxSlots
  , loadState =
      { loading = True
      , progress = 0
      , failed = False
      }
  }


track : Instrument -> Track
track instrument =
  { instrument = instrument
  , slots = Array.repeat maxSlots (Slot False 1)
  }
