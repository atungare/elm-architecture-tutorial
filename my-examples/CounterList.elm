module CounterList where

import Counter
import Html
import Html.Events exposing (onClick)

-- Model

type alias Model = { counters : List (ID, Counter.Model),
                     nextId : ID }
type alias ID = Int

init : Model
init = { counters = [],
         nextId = 0 }

-- Update
type Action = Insert | Remove ID | Modify ID Counter.Action

update : Action -> Model -> Model
update action model =
  case action of
    Insert ->
      { model |
          counters = ( model.nextId, Counter.init 0 ) :: model.counters,
          nextId = model.nextId + 1 }
    Remove id ->
      { model |
          counters = List.filter (\(counterId, _) -> id /= counterId ) model.counters }
    Modify id act ->
      let updateCounter (counterId, counterModel) =
        if counterId == id
          then (counterId, Counter.update act counterModel)
          else (counterId, counterModel)
      in
        { model | counters = List.map updateCounter model.counters }

-- View
view : Signal.Address Action -> Model -> Html.Html
view address model =
  let
    add = Html.button [ onClick address Insert ] [ Html.text "Add" ]
    counters = List.map (viewCounter address) model.counters
  in
    Html.div [] (add :: counters)

viewCounter : Signal.Address Action -> (ID, Counter.Model) -> Html.Html
viewCounter address (id, model) =
  let
    context = Counter.Context
                (Signal.forwardTo address (Modify id))
                (Signal.forwardTo address (always (Remove id)))
  in
    Counter.viewWithRemove context model

