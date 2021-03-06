module Main exposing (main)

import Browser
import Color exposing (Color)
import Color.Blend
import Color.Contrast
import Color.Generator
import ColorModes
import Comparison
import Html exposing (Html)
import Html.Attributes exposing (style)
import Html.Events
import Palette.X11 exposing (..)
import Platform


main : Platform.Program () Model Msg
main =
    Browser.sandbox
        { init = { colorModesModel = ColorModes.init }
        , update = \msg model -> { model | colorModesModel = ColorModes.update msg model.colorModesModel }
        , view = view
        }


type alias Model =
    { colorModesModel : ColorModes.Model }


type alias Msg =
    ColorModes.Msg


view : Model -> Html Msg
view model =
    Html.main_ []
        [ Html.h1 [] [ Html.text "Examples" ]
        , exampleSection "Contrast"
            (ColorModes.view model.colorModesModel)
        , exampleSection "Color Schemes"
            (Html.div []
                [ exampleSubsection "Complementary"
                    (exampleList rainbow viewComplementary)
                , exampleSubsection "Triadic"
                    (exampleList rainbow viewTriadic)
                , exampleSubsection "Split Complementary"
                    (exampleList (List.map (\color -> ( 30, color )) rainbow)
                        viewSplitComplementary
                    )
                , exampleSubsection "Square"
                    (exampleList rainbow viewSquare)
                , exampleSubsection "Tetratic"
                    (exampleList (List.map (\color -> ( 30, color )) rainbow)
                        viewRectangle
                    )
                , exampleSubsection "Grayscale"
                    (exampleList rainbow viewGrayscale)
                , exampleSubsection "Invert"
                    (exampleList rainbow viewInverse)
                , exampleSubsection "Monochromatic"
                    (Html.div []
                        [ Html.h4 [] [ Html.text "Monochromatic Palette" ]
                        , exampleList (List.map (\color -> ( 10, color )) rainbow)
                            viewMonochromaticGenerator
                        , Html.h4 [] [ Html.text "Shades" ]
                        , exampleList rainbow viewMonochromaticShades
                        , Html.h4 [] [ Html.text "Tints" ]
                        , exampleList rainbow viewMonochromaticTints
                        , Html.h4 [] [ Html.text "Tones" ]
                        , exampleList rainbow viewMonochromaticTones
                        ]
                    )
                , exampleSubsection "Blending"
                    (Html.div []
                        [ Html.h4 [] [ Html.text "Add" ]
                        , exampleList (List.map (\color -> ( color, lightSeaGreen )) rainbow)
                            (Comparison.viewOverlapping Color.Blend.add)
                        , Html.h4 [] [ Html.text "Subtract" ]
                        , exampleList (List.map (\color -> ( color, lightSeaGreen )) rainbow)
                            (Comparison.viewOverlapping Color.Blend.subtract)
                        , Html.h4 [] [ Html.text "Multiply" ]
                        , exampleList (List.map (\color -> ( color, lightSeaGreen )) rainbow)
                            (Comparison.viewOverlapping Color.Blend.multiply)
                        , Html.h4 [] [ Html.text "Divide" ]
                        , exampleList (List.map (\color -> ( color, lightSeaGreen )) rainbow)
                            (Comparison.viewOverlapping Color.Blend.divide)
                        ]
                    )
                ]
            )
        , exampleSection "Palette"
            (Html.div []
                [ exampleSubsection "X11"
                    (Html.div []
                        [ Html.h4 [] [ Html.text "Pinks" ]
                        , exampleList
                            [ ( pink, "pink" )
                            , ( lightPink, "lightPink" )
                            , ( hotPink, "hotPink" )
                            , ( deepPink, "deepPink" )
                            , ( paleVioletRed, "paleVioletRed" )
                            , ( mediumVioletRed, "mediumVioletRed" )
                            ]
                            Comparison.viewWithName
                        , Html.h4 [] [ Html.text "Reds" ]
                        , exampleList
                            [ ( lightSalmon, "lightSalmon" )
                            , ( salmon, "salmon" )
                            , ( darkSalmon, "darkSalmon" )
                            , ( lightCoral, "lightCoral" )
                            , ( indianRed, "indianRed" )
                            , ( crimson, "crimson" )
                            , ( firebrick, "firebrick" )
                            , ( darkRed, "darkRed" )
                            , ( red, "red" )
                            ]
                            Comparison.viewWithName
                        , Html.h4 [] [ Html.text "Orange-Reds" ]
                        , exampleList
                            [ ( orangeRed, "orangeRed" )
                            , ( tomato, "tomato" )
                            , ( coral, "coral" )
                            , ( darkOrange, "darkOrange" )
                            , ( orange, "orange" )
                            ]
                            Comparison.viewWithName
                        , Html.h4 [] [ Html.text "Yellows" ]
                        , exampleList
                            [ ( yellow, "yellow" )
                            , ( lightYellow, "lightYellow" )
                            , ( lemonChiffon, "lemonChiffon" )
                            , ( lightGoldenrodYellow, "lightGoldenrodYellow" )
                            , ( papayaWhip, "papayaWhip" )
                            , ( moccasin, "moccasin" )
                            , ( peachPuff, "peachPuff" )
                            , ( paleGoldenrod, "paleGoldenrod" )
                            , ( khaki, "khaki" )
                            , ( darkKhaki, "darkKhaki" )
                            , ( gold, "gold" )
                            ]
                            Comparison.viewWithName
                        , Html.h4 [] [ Html.text "Browns" ]
                        , exampleList
                            [ ( cornsilk, "cornsilk" )
                            , ( blanchedAlmond, "blanchedAlmond" )
                            , ( bisque, "bisque" )
                            , ( navajoWhite, "navajoWhite" )
                            , ( wheat, "wheat" )
                            , ( burlywood, "burlywood" )
                            , ( Palette.X11.tan, "tan" )
                            , ( rosyBrown, "rosyBrown" )
                            , ( sandyBrown, "sandyBrown" )
                            , ( goldenrod, "goldenrod" )
                            , ( darkGoldenrod, "darkGoldenrod" )
                            , ( peru, "peru" )
                            , ( chocolate, "chocolate" )
                            , ( saddleBrown, "saddleBrown" )
                            , ( sienna, "sienna" )
                            , ( brown, "brown" )
                            , ( maroon, "maroon" )
                            ]
                            Comparison.viewWithName
                        , Html.h4 [] [ Html.text "Greens" ]
                        , exampleList
                            [ ( darkOliveGreen, "darkOliveGreen" )
                            , ( olive, "olive" )
                            , ( oliveDrab, "oliveDrab" )
                            , ( yellowGreen, "yellowGreen" )
                            , ( limeGreen, "limeGreen" )
                            , ( lime, "lime" )
                            , ( lawnGreen, "lawnGreen" )
                            , ( chartreuse, "chartreuse" )
                            , ( greenYellow, "greenYellow" )
                            , ( springGreen, "springGreen" )
                            , ( mediumSpringGreen, "mediumSpringGreen" )
                            , ( lightGreen, "lightGreen" )
                            , ( paleGreen, "paleGreen" )
                            , ( darkSeaGreen, "darkSeaGreen" )
                            , ( mediumAquamarine, "mediumAquamarine" )
                            , ( mediumSeaGreen, "mediumSeaGreen" )
                            , ( seaGreen, "seaGreen" )
                            , ( forestGreen, "forestGreen" )
                            , ( green, "green" )
                            , ( darkGreen, "darkGreen" )
                            ]
                            Comparison.viewWithName
                        , Html.h4 [] [ Html.text "Cyans" ]
                        , exampleList
                            [ ( aqua, "aqua" )
                            , ( cyan, "cyan" )
                            , ( lightCyan, "lightCyan" )
                            , ( paleTurquoise, "paleTurquoise" )
                            , ( aquamarine, "aquamarine" )
                            , ( turquoise, "turquoise" )
                            , ( mediumTurquoise, "mediumTurquoise" )
                            , ( darkTurquoise, "darkTurquoise" )
                            , ( lightSeaGreen, "lightSeaGreen" )
                            , ( cadetBlue, "cadetBlue" )
                            , ( darkCyan, "darkCyan" )
                            , ( teal, "teal" )
                            ]
                            Comparison.viewWithName
                        , Html.h4 [] [ Html.text "Blues" ]
                        , exampleList
                            [ ( lightSteelBlue, "lightSteelBlue" )
                            , ( powderBlue, "powderBlue" )
                            , ( lightBlue, "lightBlue" )
                            , ( skyBlue, "skyBlue" )
                            , ( lightSkyBlue, "lightSkyBlue" )
                            , ( deepSkyBlue, "deepSkyBlue" )
                            , ( dodgerBlue, "dodgerBlue" )
                            , ( cornflowerBlue, "cornflowerBlue" )
                            , ( steelBlue, "steelBlue" )
                            , ( royalBlue, "royalBlue" )
                            , ( blue, "blue" )
                            , ( mediumBlue, "mediumBlue" )
                            , ( darkBlue, "darkBlue" )
                            , ( navy, "navy" )
                            , ( midnightBlue, "midnightBlue" )
                            ]
                            Comparison.viewWithName
                        , Html.h4 [] [ Html.text "Purples" ]
                        , exampleList
                            [ ( lavender, "lavender" )
                            , ( thistle, "thistle" )
                            , ( plum, "plum" )
                            , ( violet, "violet" )
                            , ( orchid, "orchid" )
                            , ( fuchsia, "fuchsia" )
                            , ( magenta, "magenta" )
                            , ( mediumOrchid, "mediumOrchid" )
                            , ( mediumPurple, "mediumPurple" )
                            , ( blueViolet, "blueViolet" )
                            , ( darkViolet, "darkViolet" )
                            , ( darkOrchid, "darkOrchid" )
                            , ( darkMagenta, "darkMagenta" )
                            , ( purple, "purple" )
                            , ( indigo, "indigo" )
                            , ( darkSlateBlue, "darkSlateBlue" )
                            , ( slateBlue, "slateBlue" )
                            , ( mediumSlateBlue, "mediumSlateBlue" )
                            ]
                            Comparison.viewWithName
                        , Html.h4 [] [ Html.text "Whites" ]
                        , exampleList
                            [ ( white, "white" )
                            , ( snow, "snow" )
                            , ( honeydew, "honeydew" )
                            , ( mintCream, "mintCream" )
                            , ( azure, "azure" )
                            , ( aliceBlue, "aliceBlue" )
                            , ( ghostWhite, "ghostWhite" )
                            , ( whiteSmoke, "whiteSmoke" )
                            , ( seashell, "seashell" )
                            , ( beige, "beige" )
                            , ( oldLace, "oldLace" )
                            , ( floralWhite, "floralWhite" )
                            , ( ivory, "ivory" )
                            , ( antiqueWhite, "antiqueWhite" )
                            , ( linen, "linen" )
                            , ( lavenderBlush, "lavenderBlush" )
                            , ( mistyRose, "mistyRose" )
                            ]
                            Comparison.viewWithName
                        , Html.h4 [] [ Html.text "Blacks and Grays" ]
                        , exampleList
                            [ ( gainsboro, "gainsboro" )
                            , ( lightGray, "lightGray" )
                            , ( silver, "silver" )
                            , ( darkGray, "darkGray" )
                            , ( gray, "gray" )
                            , ( dimGray, "dimGray" )
                            , ( lightSlateGray, "lightSlateGray" )
                            , ( slateGray, "slateGray" )
                            , ( darkSlateGray, "darkSlateGray" )
                            , ( black, "black" )
                            ]
                            Comparison.viewWithName
                        ]
                    )
                ]
            )
        ]


exampleSection : String -> Html msg -> Html msg
exampleSection heading examples =
    Html.section []
        [ Html.h2 [] [ Html.text heading ]
        , examples
        ]


exampleSubsection : String -> Html msg -> Html msg
exampleSubsection heading examples =
    Html.div []
        [ Html.h3 [] [ Html.text heading ]
        , examples
        ]


exampleList : List a -> (a -> Html msg) -> Html msg
exampleList examples viewExample =
    Html.ul
        [ style "list-style" "none"
        , style "display" "flex"
        , style "flex-wrap" "wrap"
        , style "margin" "0"
        , style "padding" "0"
        ]
        (List.map
            (\example -> Html.li [] [ viewExample example ])
            examples
        )


viewGrayscale : Color -> Html msg
viewGrayscale color =
    Comparison.viewPalette color [ Color.Generator.grayscale color ]


viewInverse : Color -> Html msg
viewInverse color =
    Comparison.viewPalette color [ Color.Generator.invert color ]


viewComplementary : Color -> Html msg
viewComplementary color =
    Comparison.viewPalette color [ Color.Generator.complementary color ]


viewTriadic : Color -> Html msg
viewTriadic color =
    let
        ( one, two ) =
            Color.Generator.triadic color
    in
    Comparison.viewPalette color [ one, two ]


viewSplitComplementary : ( Float, Color ) -> Html msg
viewSplitComplementary ( degree, color ) =
    let
        ( one, two ) =
            Color.Generator.splitComplementary degree color
    in
    Comparison.viewPalette color [ one, two ]


viewSquare : Color -> Html msg
viewSquare color =
    let
        ( one, two, three ) =
            Color.Generator.square color
    in
    Comparison.viewPalette color [ one, two, three ]


viewRectangle : ( Float, Color ) -> Html msg
viewRectangle ( degree, color ) =
    let
        ( one, two, three ) =
            Color.Generator.tetratic degree color
    in
    Comparison.viewPalette color [ one, two, three ]


viewMonochromaticShades : Color -> Html msg
viewMonochromaticShades color =
    Comparison.viewPalette color
        [ Color.Generator.shade 10 color
        , Color.Generator.shade 20 color
        , Color.Generator.shade 30 color
        , Color.Generator.shade 40 color
        ]


viewMonochromaticTints : Color -> Html msg
viewMonochromaticTints color =
    Comparison.viewPalette color
        [ Color.Generator.tint 10 color
        , Color.Generator.tint 20 color
        , Color.Generator.tint 30 color
        , Color.Generator.tint 40 color
        , Color.Generator.tint 50 color
        ]


viewMonochromaticTones : Color -> Html msg
viewMonochromaticTones color =
    Comparison.viewPalette color
        [ Color.Generator.tone -100 color
        , Color.Generator.tone -80 color
        , Color.Generator.tone -60 color
        , Color.Generator.tone -40 color
        , Color.Generator.tone -20 color
        ]


viewMonochromaticGenerator : ( Float, Color ) -> Html msg
viewMonochromaticGenerator ( stepSize, color ) =
    Comparison.viewPalette color
        (Color.Generator.monochromatic stepSize color)



-- SUPER CONVENIENT COLORS


rainbow : List Color
rainbow =
    [ coral
    , olive
    , gold
    , teal
    , blueViolet
    ]
