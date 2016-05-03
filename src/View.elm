module View exposing (..)

-- where

import String
import Array exposing (Array)
import Json.Encode as Encode
import Json.Decode as Decode
import Html exposing (Html, div, text, node, button, input, select, option)
import Html.Attributes exposing (style, class, attribute, href, type', value, property)
import Html.Events exposing (on, onClick, onInput, targetValue)
import Model exposing (Model, Track, Slot, Instrument(..))
import Update exposing (Msg(..))
import Styles


view : Model -> Html Msg
view model =
  div
    [ class "fullscreen" ]
    [ Styles.styles
    , viewInner model
    ]


viewInner : Model -> Html Msg
viewInner model =
  if model.loadState.loading then
    div
      [ class "appContainer" ]
      [ viewLoading model.loadState.progress ]
  else if model.loadState.failed then
    div
      [ class "appContainer" ]
      [ viewLoadFailed ]
  else
    div
      [ class "appContainer" ]
      [ viewControls model.isPlaying model.tempo
      , viewTracks model.tracks
      ]


viewLoadFailed : Html Msg
viewLoadFailed =
  div [] [ text "Couldn't load instrument samples :(" ]


viewLoading : Float -> Html Msg
viewLoading progress =
  div [] [ text <| toString <| progress * 100 ]


viewControls : Bool -> Int -> Html Msg
viewControls isPlaying tempo =
  let
    ( playStopText, playStopAction ) =
      if isPlaying then
        ( "Stop", Stop )
      else
        ( "Play", Play )
  in
    div
      [ class "controlsContainer" ]
      [ button [ onClick playStopAction ] [ text playStopText ]
      , input
          [ type' "number"
          , value (toString tempo)
          , onInput <| String.toInt >> Result.map UpdateTempo >> Result.withDefault NoOp
          ]
          []
      ]


viewTracks : Array Track -> Html Msg
viewTracks tracks =
  let
    tracksViews =
      tracks
        |> Array.indexedMap viewTrack
        |> Array.toList
  in
    div
      [ class "tracksContainer" ]
      [ div [] tracksViews
      , div [] [ viewAddTrack ]
      ]


viewTrack : Int -> Track -> Html Msg
viewTrack trackIndex track =
  let
    slotsViews =
      track.slots
        |> Array.indexedMap (viewSlot trackIndex)
        |> Array.toList
  in
    div
      [ class "trackContainer" ]
      [ div
          [ class "instrumentType" ]
          [ viewInstrumentSelector (UpdateTrackInstrument trackIndex) track.instrument
          ]
      , div
          [ class "slotsContainer" ]
          slotsViews
      , div
          [ class "removeTrack"
          , onClick <| RemoveTrack trackIndex
          ]
          [ text "Remove" ]
      ]


viewInstrumentSelector : (Instrument -> Msg) -> Instrument -> Html Msg
viewInstrumentSelector onSelect current =
  let
    selected instrument =
      property "selected" <| Encode.bool (instrument == current)

    toOption instrument =
      option
        [ property "value" <| Model.encodeInstrument instrument
        , selected instrument
        ]
        [ text <| Model.instrumentToString instrument ]
  in
    select
      [ on "input" <| Decode.map onSelect (Decode.at [ "target", "value" ] Model.decodeInstrument) ]
      (List.map toOption Model.instruments)


viewSlot : Int -> Int -> Slot -> Html Msg
viewSlot trackIndex slotIndex slot =
  let
    color =
      if slot.enabled then
        "green"
      else
        "red"
  in
    div
      [ class "slotOuter" ]
      [ div
          [ class "slotInner" ]
          [ div
              [ class "slotFill"
              , style [ ( "background-color", color ) ]
              , onClick <| ToggleSlotEnabled trackIndex slotIndex
              ]
              []
          ]
      ]


viewAddTrack : Html Msg
viewAddTrack =
  div
    [ class "addTrackButton"
    , onClick <| AddTrack Kick
    ]
    [ text "Add Track" ]
