module Update exposing (..)

-- where

import Array exposing (Array)
import Model exposing (Model, Instrument, Track)
import Ports


type Msg
  = NoOp
  | LoadProgress Float
  | LoadSuccess
  | LoadFailure
  | UpdateTempo Int
  | AddTrack Instrument
  | RemoveTrack Int
  | UpdateTrackInstrument Int Instrument
  | Play
  | Stop
  | Advance
  | ToggleSlotEnabled Int Int
  | UpdateSlotVolume Int Int Float


removeAt : Int -> Array a -> Array a
removeAt index array =
  array
    |> Array.indexedMap (,)
    |> Array.filter (\( i, v ) -> i /= index)
    |> Array.map snd


updateAt : Int -> (a -> a) -> Array a -> Array a
updateAt index updater array =
  let
    updateAtIndex i v =
      if i == index then
        updater v
      else
        v
  in
    Array.indexedMap updateAtIndex array


singleton : a -> Array a
singleton value =
  Array.fromList [ value ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    UpdateTempo value ->
      ( { model | tempo = value }
      , Cmd.none
      )

    Play ->
      ( { model
          | isPlaying = True
          , currentSlotIndex = 0
        }
      , Ports.playSound ( 0, model.tracks )
      )

    Stop ->
      ( { model
          | isPlaying = False
        }
      , Cmd.none
      )

    Advance ->
      let
        nextSlotIndex =
          (model.currentSlotIndex + 1) % model.maxSlots
      in
        ( { model
            | currentSlotIndex = nextSlotIndex
          }
        , Ports.playSound ( nextSlotIndex, model.tracks )
        )

    AddTrack instrument ->
      ( { model
          | tracks = Array.append model.tracks (singleton (Model.track instrument))
        }
      , Cmd.none
      )

    RemoveTrack trackIndex ->
      let
        model' =
          { model | tracks = removeAt trackIndex model.tracks }
      in
        ( model'
        , Cmd.none
        )

    LoadProgress progress ->
      let
        loadState =
          model.loadState
      in
        ( { model | loadState = { loadState | progress = progress } }
        , Cmd.none
        )

    LoadSuccess ->
      let
        loadState =
          model.loadState
      in
        ( { model | loadState = { loadState | loading = False } }
        , Cmd.none
        )

    LoadFailure ->
      let
        loadState =
          model.loadState
      in
        ( { model | loadState = { loadState | failed = True, loading = False } }
        , Cmd.none
        )

    ToggleSlotEnabled trackIndex slotIndex ->
      let
        updateSlot slot =
          { slot | enabled = not slot.enabled }

        updateTrack track =
          { track | slots = updateAt slotIndex updateSlot track.slots }

        updatedModel =
          { model | tracks = updateAt trackIndex updateTrack model.tracks }
      in
        ( updatedModel, Cmd.none )

    UpdateTrackInstrument trackIndex instrument ->
      let
        updateTrack track =
          { track | instrument = instrument }

        updatedModel =
          { model | tracks = updateAt trackIndex updateTrack model.tracks }
      in
        ( updatedModel, Cmd.none )

    _ ->
      ( model, Cmd.none )
