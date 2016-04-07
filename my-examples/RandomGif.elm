module RandomGif where

import Effects exposing(Effects, Never)
import Html
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Json
import Task

-- Model

type alias Model = { topic : String,
                     gifUrl : String }

init : String -> (Model, Effects Action)
init topic =
  (Model topic "assets/waiting.gif",
   getRandomGif topic)

-- Update

type Action = RequestMore | NewGif (Maybe String)

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    RequestMore ->
      (model, getRandomGif model.topic)
    NewGif maybeUrl ->
      (Model model.topic (Maybe.withDefault model.gifUrl maybeUrl),
       Effects.none)

-- View

(=>) = (,)

view : Signal.Address Action -> Model -> Html.Html
view address model =
  Html.div [ style [ "width" => "200px"] ] [
    Html.h2 [ headerStyle ] [ Html.text model.topic ],
    Html.div [ imageStyle model.gifUrl ] [],
    Html.button [ onClick address RequestMore ] [ Html.text "Moar Gif" ] ]

headerStyle : Html.Attribute
headerStyle =
  style [
    "width" => "200px",
    "text-align" => "center"]

imageStyle : String -> Html.Attribute
imageStyle url =
  style [
    "display" => "inline-block",
    "width" => "200px",
    "height" => "200px",
    "background-position" => "center center",
    "background-size" => "cover",
    "background-image" => ("url('" ++ url ++ "')") ]


-- Effects
getRandomGif : String -> Effects Action
getRandomGif topic =
  Http.get decodeUrl (randomUrl topic)
    |> Task.toMaybe
    |> Task.map NewGif
    |> Effects.task

randomUrl : String -> String
randomUrl topic =
  Http.url "http://api.giphy.com/v1/gifs/random" [
    "api_key" => "dc6zaTOxFJmzC",
    "tag" => topic ]

decodeUrl : Json.Decoder String
decodeUrl =
  Json.at ["data", "image_url"] Json.string
