module Screens.ScheduledRideAcceptedScreen.View where

import Animation
import Debug
import Prelude
import PrestoDOM.List
import Screens.ScheduledRideAcceptedScreen.Controller
import Screens.ScheduledRideAcceptedScreen.ScreenData
import Animation as Anim
import Common.Types.App (LazyCheck(..), CategoryListType)
import Data.Array as DA
import Data.Either (Either(..))
import Data.Function.Uncurried (runFn1)
import Data.Int (ceil, fromString, round, toNumber)
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Aff (launchAff)
import Effect.Class (liftEffect)
import Engineering.Helpers.Commons (getNewIDWithTag, screenWidth, os, safeMarginBottom, getFutureDate)
import Engineering.Helpers.Commons (screenWidth)
import Engineering.Helpers.Commons as EHC
import Font.Size as FontSize
import Font.Style as FontStyle
import Helpers.Utils (toStringJSON, fetchImage, FetchImageFrom(..))
import JBridge as JB
import Language.Strings (getString)
import Language.Types (STR(..))
import Mobility.Prelude (boolToVisibility)
import Presto.Core.Types.Language.Flow (Flow, doAff)
import PrestoDOM.Animation as PrestoAnim
import PrestoDOM.Elements.Keyed as Keyed
import PrestoDOM.Events (globalOnScroll)
import PrestoDOM.Properties (alpha, cornerRadii, lineHeight, minWidth)
import PrestoDOM.Types.Core (class Loggable, toPropValue)
import PrestoDOM.Types.DomAttributes (Corners(..))
import Screens.Types as ST
import Services.API (ScheduledBookingListResponse(..))
import Services.Backend as Remote
import Styles.Colors as Color
import Types.App (FlowBT, GlobalState(..))
import Types.App (defaultGlobalState)
import PrestoDOM 

screen :: ScheduleRideAcceptedScreenState -> Screen Action ScheduleRideAcceptedScreenState ScreenOutput
screen initialState =  
  { initialState
  , view : view
  , name: "ScheduleRideAcceptScreen"
  , globalEvents : [] 
  , eval : (\action state -> do
    let _ = spy "ScheduleRideAcceptScreen state -----" state
    let _ = spy "ScheduleRideAcceptScreen action --------" action
    eval action state)
  }

view :: forall w. (Action -> Effect Unit) -> ScheduleRideAcceptedScreenState -> PrestoDOM (Effect Unit) w 
view state push  = 
  linearLayout [
        height MATCH_PARENT
    ,   width MATCH_PARENT
    ,   background Color.grey700
     ][

     linearLayout[
        height MATCH_PARENT
        ,width MATCH_PARENT
        ,orientation VERTICAL
        ]
        [linearLayout[
            weight 1.0
            ,width MATCH_PARENT
            , orientation VERTICAL
            , gravity CENTER
            ][
            linearLayout[weight 1.0][]
            ,imageView [
             width $ V 180
             ,height $ V 150
             ,margin $ Margin 0 0 0 30
             ,imageWithFallback $ fetchImage FF_COMMON_ASSET "ny_ic_ride_accepted_symbol"
             ]
             , textView $ [
                height WRAP_CONTENT
               ,width WRAP_CONTENT
               ,text $ getString SCHEDULED_RIDE_ACCEPTED
               , color Color.black900
             ]<>FontStyle.h1 TypoGraphy
            , instructionView state push
            ,linearLayout[
              weight 1.0
            ][]
            ,buttonView state push
        ]
        ]
    ]

buttonView :: forall w. (Action -> Effect Unit) -> ScheduleRideAcceptedScreenState -> PrestoDOM (Effect Unit) w 
buttonView push state  = 
   linearLayout [
        height $ V 50 
        , width MATCH_PARENT
        , background Color.black900
        , margin $ Margin 10 0 10 10 
        , cornerRadius  10.0
        , gravity CENTER
        ,  onClick push (const  OnClick)
        , rippleColor Color.rippleShade
     
    ][
        textView $ [
            width WRAP_CONTENT
            , height $ V 40
            , text $ getString CONTINUE
            , color Color.yellow900
            , gravity CENTER
        ]<>FontStyle.h3 TypoGraphy
    ]

instructionView :: forall w. (Action -> Effect Unit) -> ScheduleRideAcceptedScreenState -> PrestoDOM (Effect Unit) w 
instructionView  push state  = 
  linearLayout[
    height WRAP_CONTENT
   ,width MATCH_PARENT
   ,orientation VERTICAL
   ,background Color.verySoftOrange
   , margin $ Margin 14 10 14 20
   , padding $ Padding 15 15 15 5
   , cornerRadius 12.0
   , gravity CENTER_VERTICAL
  ][
    linearLayout[
      height WRAP_CONTENT
     ,width WRAP_CONTENT
     ,orientation HORIZONTAL
    ][
      imageView[
        height $ V 40
      , width $ V 40
      ,imageWithFallback $ fetchImage FF_COMMON_ASSET "ny_ic_exclamation_triangle"
      , margin $Margin 0 4 4 4 
      
      ]
      , textView $[
        height WRAP_CONTENT
        ,width WRAP_CONTENT
        ,color Color.black900
        ,margin $ MarginHorizontal 10 4 
        ,textFromHtml $ getString FOLLOW_INSTRUCTIONS_TO_AVOID_REASSIGNMENT_OF_RIDE
      ]<>FontStyle.h3 TypoGraphy
    ]
    ,linearLayout[
      height WRAP_CONTENT
     ,width WRAP_CONTENT
     ,orientation HORIZONTAL
     , gravity CENTER_VERTICAL
    ][
      imageView[
        height $ V 10
      , width $ V 10
      ,imageWithFallback $ fetchImage FF_COMMON_ASSET "ny_ic_circle"
      , margin $Margin 4 4 4 4 
      
      ]
      ,linearLayout[
        height WRAP_CONTENT
       ,width WRAP_CONTENT
       ,orientation VERTICAL
       , margin $ MarginHorizontal 12 4 
      ][
       textView $[
        height WRAP_CONTENT
        ,width WRAP_CONTENT
        ,textFromHtml $ getString $ PLEASE_BE_ONLINE "45"
        , color Color.black900
      ]<>FontStyle.h3 TypoGraphy
      , textView $[
        height WRAP_CONTENT
        ,width WRAP_CONTENT
        ,color Color.black900
        ,textFromHtml $ getString BEFORE_THE_RIDE_STARTS
      ]<>FontStyle.h3 TypoGraphy
    ]
    ]
    ,linearLayout[
      height WRAP_CONTENT
     ,width WRAP_CONTENT
     ,orientation HORIZONTAL
     , gravity CENTER_VERTICAL
    ][
      imageView[
        height $ V 10
      , width $ V 10
      ,imageWithFallback $ fetchImage FF_COMMON_ASSET "ny_ic_circle"
      , margin $Margin 4 4 4 4 
      
      ]
      ,linearLayout[
        height WRAP_CONTENT
       ,width WRAP_CONTENT
       ,orientation VERTICAL
       , margin $ MarginHorizontal 12 4 
      ][
       textView $[
        height WRAP_CONTENT
        ,width WRAP_CONTENT
        ,color Color.black900
        ,textFromHtml $ getString BE_WITHIN_10KM_OF_PICKUP
      
      ]<>FontStyle.h3 TypoGraphy
      , textView $[
        height WRAP_CONTENT
        ,width WRAP_CONTENT
        , color Color.black900
        ,textFromHtml $ getString BEFORE_THE_RIDE_STARTS
      ]<>FontStyle.h3 TypoGraphy
    ]
    ]
    
  ]
