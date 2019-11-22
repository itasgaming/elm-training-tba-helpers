module TBAHelpers exposing (Model, Msg)

import Browser
import Debug
import Html exposing (pre, text)
import Http exposing (emptyBody, header)


main : Program () Model Msg
main =
    Browser.element
        { init = always init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


type Msg
    = GotTeam (Result Http.Error String)


type Model
    = Failure String
    | Loading
    | Success String


getBook : Int -> Cmd Msg
getBook teamNumber =
    Http.request
        { method = "GET"
        , headers = [ header "Authorization" "FAVANHtFY9QC76GCqaK72tovzMpP1aiZqaj0hXHzOKg22km2rTQ3QPbHGEupI4E9" ]
        , url = "https://www.thebluealliance.com/api/v3/team/frc" ++ String.fromInt teamNumber
        , body = emptyBody
        , expect = Http.expectString GotTeam
        , timeout = Nothing
        , tracker = Nothing
        }


init : ( Model, Cmd Msg )
init =
    ( Loading, getBook 1690 )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotTeam result ->
            case result of
                Ok fullTaxt ->
                    ( Success fullTaxt, Cmd.none )

                Err message ->
                    ( Failure <| Debug.toString message, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html.Html Msg
view model =
    case model of
        Failure message ->
            text message

        Loading ->
            text "Loding..."

        Success fullTaxt ->
            pre [] [ text fullTaxt ]
