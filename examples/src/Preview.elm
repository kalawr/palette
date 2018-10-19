module Preview exposing (Model, Msg, init, update, view)

import Color exposing (Color)
import Color.Generator as Generator
import Comparison
import Html exposing (Html)
import Html.Attributes exposing (style)
import Html.Events
import Json.Decode


type alias Model =
    { generators : List Generator
    , selectedGenerator : Generator
    }


type Generator
    = Generator String (Color -> List Color)
    | WithDegrees String (Float -> Color -> List Color) Editable
    | WithStep String (Float -> Color -> List Color) Editable


type Editable
    = Editing (Maybe Float)
    | Confirmed Float


generatorName : Generator -> String
generatorName generator =
    case generator of
        Generator name _ ->
            name

        WithDegrees name _ _ ->
            name

        WithStep name _ _ ->
            name


generatorList : ( Generator, List Generator )
generatorList =
    ( Generator "complementary"
        (normalizeSingularFunction Generator.complementary)
    , [ Generator "triadic"
            (normalizeTupleFunction Generator.triadic)
      , WithDegrees "splitComplementary"
            (\degrees -> normalizeTupleFunction (Generator.splitComplementary degrees))
            (Editing Nothing)
      , Generator "square"
            (normalizeTripleFunction Generator.square)
      , WithDegrees "tetratic"
            (\degrees -> normalizeTripleFunction (Generator.tetratic degrees))
            (Editing Nothing)
      , WithStep "monochromatic" Generator.monochromatic (Editing Nothing)
      ]
    )


normalizeSingularFunction : (a -> a) -> a -> List a
normalizeSingularFunction func color =
    [ func color ]


normalizeTupleFunction : (a -> ( a, a )) -> a -> List a
normalizeTupleFunction func color =
    let
        ( one, two ) =
            func color
    in
    [ one, two ]


normalizeTripleFunction : (a -> ( a, a, a )) -> a -> List a
normalizeTripleFunction func color =
    let
        ( one, two, three ) =
            func color
    in
    [ one, two, three ]


init : Model
init =
    { generators = Tuple.first generatorList :: Tuple.second generatorList
    , selectedGenerator = Tuple.first generatorList
    }


view : Color -> Model -> Html Msg
view selectedColor model =
    Html.div [ style "margin-left" "20px" ]
        [ Html.h3 [] [ Html.text "Generate additional colors" ]
        , Html.div []
            [ generatorOptions model
            , case model.selectedGenerator of
                Generator name generate ->
                    viewPalette selectedColor generate

                WithDegrees name generate degrees ->
                    Html.div []
                        [ customValueEditor "degrees" degrees
                        , viewEditablePalette selectedColor generate degrees
                        ]
                        |> Html.map (WithDegrees name generate >> SetStep)

                WithStep name generate steps ->
                    Html.div []
                        [ customValueEditor "steps" steps
                        , viewEditablePalette selectedColor generate steps
                        ]
                        |> Html.map (WithStep name generate >> SetStep)
            ]
        ]


generatorOptions : Model -> Html Msg
generatorOptions model =
    Html.div [ style "margin-bottom" "8px" ]
        [ Html.label [ Html.Attributes.for "generator-select" ]
            [ Html.text "Color.Generator." ]
        , Html.select
            [ Html.Attributes.id "generator-select"
            , Html.Events.onInput SetGenerator
            ]
            (List.map (generatorOption (generatorName model.selectedGenerator)) model.generators)
        ]


generatorOption : String -> Generator -> Html Msg
generatorOption selectedGenerator generator =
    let
        name =
            generatorName generator
    in
    Html.option
        [ Html.Attributes.value name
        , Html.Attributes.selected (name == selectedGenerator)
        ]
        [ Html.text name ]


customValueEditor : String -> Editable -> Html Editable
customValueEditor unit editable =
    case editable of
        Editing currentValue ->
            Html.div []
                [ customValueInput unit currentValue
                , customValueConfirmation currentValue
                ]

        Confirmed value ->
            Html.div []
                [ Html.text (String.fromFloat value ++ " " ++ unit)
                , Html.button
                    [ Html.Events.onClick (Editing (Just value))
                    ]
                    [ Html.text "Edit"
                    ]
                ]


customValueInput : String -> Maybe Float -> Html Editable
customValueInput label currentValue =
    Html.label []
        [ Html.input
            [ Maybe.map String.fromFloat currentValue
                |> Maybe.withDefault ""
                |> Html.Attributes.value
            , Html.Events.onInput (String.toFloat >> Editing)
            ]
            []
        , Html.text label
        ]


customValueConfirmation : Maybe Float -> Html Editable
customValueConfirmation currentValue =
    Html.button
        (case currentValue of
            Just value ->
                [ Html.Events.onClick (Confirmed value)
                , Html.Attributes.disabled False
                ]

            Nothing ->
                [ Html.Attributes.disabled True ]
        )
        [ Html.text "Generate!" ]


viewEditablePalette selectedColor generate editable =
    case editable of
        Editing (Just value) ->
            viewPalette selectedColor (generate value)

        Editing Nothing ->
            Html.text ""

        Confirmed value ->
            viewPalette selectedColor (generate value)


viewPalette : Color -> (Color -> List Color) -> Html msg
viewPalette selectedColor generate =
    Comparison.viewPalette selectedColor (generate selectedColor)


type Msg
    = SetGenerator String
    | SetStep Generator


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetGenerator generator ->
            { model
                | selectedGenerator =
                    model.generators
                        |> List.filter (\g -> generatorName g == generator)
                        |> List.head
                        |> Maybe.withDefault model.selectedGenerator
            }

        SetStep generator ->
            { model | selectedGenerator = generator }
