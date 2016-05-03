module Styles exposing (styles)

-- where

import Html exposing (Html, node, div, text)


customStyles : String
customStyles =
  """
  * {
    box-sizing: border-box;
  }

  html, body {
    font-family: "Noto Sans";
    width: 100%;
    height: 100%;
    margin: 0;
  }

  .fullscreen {
    width: 100%;
    height: 100%;
  }

  .appContainer {
    display: flex;
    width: 100%;
    max-width: 960px;
    margin: 0 auto;
    position: relative;
    min-height: 100%;
    flex-direction: column;
    justify-content: center;
    align-items: center;
  }

  .tracksContainer {
    width: 100%;
  }

  .addTrackButton {
    padding: 20px;
    background-color: #F7F7F7;
    border: 1px solid #A7A7A7;
    text-align: center;
    cursor: pointer;
    transition: all 0.1s;
  }

  .addTrackButton:hover {
    box-shadow: 1px 3px 12px -4px #000;
    transform: translateY(-2px);
  }

  .trackContainer {
    display: flex;
    padding: 10px;
  }

  .instrumentType {
    width: 12%;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .removeTrack {
    width: 12%;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .slotsContainer {
    width: 76%;
    position: relative;
    display: flex;
  }

  .slotOuter {
    width: 6.25%;
    padding-top: 6.25%;
    position: relative;
  }

  .slotInner {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    padding: 6%;
  }

  .slotFill {
    width: 100%;
    height: 100%;
    background-color: red;
  }

  .controlsContainer {
    padding: 20px;
  }
  """


styles : Html a
styles =
  node "style" [] [ text customStyles ]
