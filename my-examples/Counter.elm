module Counter where

import Html
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)

-- Model

type alias Model = { count : Int }

-- Update

type Action = Increment | Decrement

update : Action -> Model -> Model
update action model =
  case action of
    Increment ->
      { model | count = model.count + 1 }
    Decrement ->
      { model | count = model.count - 1 }

-- View

view : Signal.Address Action -> Model -> Html.Html
view address model =
  Html.div []
   [ Html.button [ onClick address Decrement ] [ Html.text "-" ]
   , Html.div [ countStyle ] [ Html.text (toString model.count) ]
   , Html.button [ onClick address Increment ] [ Html.text "+" ]
   ]

countStyle : Html.Attribute
countStyle =
  style
    [ ("font-size", "20px")
    , ("font-family", "monospace")
    , ("display", "inline-block")
    , ("width", "50px")
    , ("text-align", "center")
    ]
