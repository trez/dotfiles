{-# LANGUAGE FlexibleContexts #-}
--
-- Xmonad config
--
-- TODO:
--  * Only show tabs and not top bar when group of windows
--

import XMonad as X

import XMonad.Config.Mate

import qualified XMonad.Actions.CycleWS as CWS
import XMonad.Actions.NoBorders (toggleBorder)
import XMonad.Actions.FindEmptyWorkspace (viewEmptyWorkspace, tagToEmptyWorkspace)
import XMonad.Actions.Minimize (minimizeWindow, withLastMinimized, maximizeWindowAndFocus)
import XMonad.Actions.Navigation2D
import XMonad.Actions.GridSelect

import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat, isInProperty)
import XMonad.Hooks.ManageDocks (avoidStruts)

import XMonad.Layout.Spacing        -- Space around windows.
import XMonad.Layout.Gaps           -- Space around edge of screen.
import XMonad.Layout.SubLayouts
import XMonad.Layout.Simplest
import XMonad.Layout.Accordion
import XMonad.Layout.ThreeColumns  -- Three columns make better sense for a wide screen.
import XMonad.Layout.SimpleDecoration
import XMonad.Layout.NoFrillsDecoration (noFrillsDeco)
import XMonad.Layout.Tabbed (addTabs, tabbed)
import XMonad.Layout.Fullscreen (fullscreenEventHook)
import XMonad.Layout.WindowNavigation (Direction2D(..), Navigate(..) , configurableNavigation, navigateColor, windowNavigation)
import XMonad.Layout.IndependentScreens (onCurrentScreen, withScreens, countScreens)
import XMonad.Layout.Minimize (minimize)

import qualified XMonad.StackSet as W
import qualified Data.Map as M

colorBlack     = "#020202" --Background
colorBlackAlt  = "#1c1c1c" --Black Xdefaults
colorGray      = "#444444" --Gray
colorGrayAlt   = "#101010" --Gray dark
colorGrayAlt2  = "#404040"
colorGrayAlt3  = "#252525"
colorWhite     = "#a9a6af" --Foreground
colorWhiteAlt  = "#9d9d9d" --White dark
colorWhiteAlt2 = "#b5b3b3"
colorWhiteAlt3 = "#707070"
colorMagenta   = "#8e82a2"
colorBlue      = "#44aacc"
colorBlueAlt   = "#3955c4"
colorRed       = "#f7a16e"
colorRedAlt    = "#e0105f"
colorGreen     = "#66ff66"
colorGreenAlt  = "#558965"

-- monokai-ish colors.
myInactiveColor = "#100e23"
myActiveColor = "#91ddff"

myFont = "-*-terminus-medium-*-*-*-*-160-*-*-*-*-*-*"

myTabTheme = def
    { fontName            = myFont
    , activeColor         = myActiveColor
    , activeBorderColor   = myActiveColor
    , activeTextColor     = myInactiveColor
    , inactiveColor       = myInactiveColor
    , inactiveBorderColor = colorBlack
    , inactiveTextColor   = myActiveColor
    }

myTopBarTheme = def
    { fontName            = myFont
    , activeColor         = myActiveColor
    , activeBorderColor   = myActiveColor
    , activeTextColor     = myInactiveColor
    , inactiveColor       = myInactiveColor
    , inactiveBorderColor = colorBlack
    , inactiveTextColor   = myActiveColor
    , decoHeight          = 20
    }

gsconfig = def { gs_cellheight = 30, gs_cellwidth = 100 }


myLayout = id
    $ tiledLayout threeColumn ||| tiledLayout (Mirror threeColumn) ||| tiledLayout twoColumn ||| tiledLayout (Mirror twoColumn) ||| tabsLayout
  where
    addTopBar = noFrillsDeco shrinkText myTopBarTheme
    tabsLayout
      = avoidStruts
      $ minimize
      $ addTabs shrinkText myTabTheme
      $ Simplest

    tiledLayout w
      = avoidStruts
      $ minimize
      $ windowNavigation
      $ addTopBar
      $ addTabs shrinkText myTabTheme
      $ subLayout [] (Simplest ||| Accordion)
      $ w

    twoColumn   = Tall 1 (3/100) (1/2)
    threeColumn = ThreeColMid 1 (3/100) (1/2)


main = do
    numScreens <- countScreens
    -- let numScreens = 2
    xmonad . ewmh . withNavigation2DConfig def $ mateConfig
      { modMask            = mod4Mask
      , workspaces         = withScreens numScreens (map show [1..9])
      , terminal           = "termite"
      , focusFollowsMouse  = False
      , handleEventHook    = fullscreenEventHook
      , borderWidth        = 2
      , normalBorderColor  = myInactiveColor
      , focusedBorderColor = myActiveColor
      , layoutHook         = myLayout
      , manageHook         =
          let isSplash = isInProperty "_NET_WM_WINDOW_TYPE"
                                      "_NET_WM_WINDOW_TYPE_SPLASH"
          in manageHook mateConfig <+> composeAll
               [ resource  =? "Do"  --> doIgnore
               , className =? "Do"  --> doIgnore
               , isFullscreen       --> doFullFloat
               , isSplash           --> doIgnore
               ]

      , keys =
          let myKeys conf@(X.XConfig {modMask = modkey}) = M.fromList $
                [ -- workspaces
                  ((modkey, xK_1 ), X.windows (onCurrentScreen W.greedyView "1"))
                , ((modkey, xK_2 ), X.windows (onCurrentScreen W.greedyView "2"))
                , ((modkey, xK_3 ), X.windows (onCurrentScreen W.greedyView "3"))
                , ((modkey, xK_4 ), X.windows (onCurrentScreen W.greedyView "4"))
                , ((modkey, xK_5 ), X.windows (onCurrentScreen W.greedyView "5"))

                  -- window handling
                , ((modkey, xK_w ), X.sendMessage $ Go U)
                , ((modkey, xK_a ), X.sendMessage $ Go L)
                , ((modkey, xK_s ), X.sendMessage $ Go D)
                , ((modkey, xK_d ), X.sendMessage $ Go R)
                , ((modkey, xK_z ), X.sendMessage $ Shrink)
                , ((modkey, xK_x ), X.sendMessage $ Expand)
                , ((modkey, xK_q ), windows W.focusUp)
                , ((modkey, xK_e ), windows W.focusDown)
             --   , ((modkey, xK_g ), withFocused toggleBorder)
                , ((modkey, xK_g ), bringSelected gsconfig)
                , ((shfted, xK_q ), setLayout $ X.layoutHook conf)

                , ((ctrled, xK_a      ), sendMessage $ pullGroup L)
                , ((ctrled, xK_d      ), sendMessage $ pullGroup R)
                , ((ctrled, xK_w      ), sendMessage $ pullGroup U)
                , ((ctrled, xK_s      ), sendMessage $ pullGroup D)
                , ((ctrled, xK_m      ), withFocused (sendMessage . MergeAll))
                , ((ctrled, xK_e      ), withFocused (sendMessage . UnMerge))
                , ((ctrled, xK_period ), onGroup W.focusUp')
                , ((ctrled, xK_comma  ), onGroup W.focusDown')

                  -- Find empty workspace
                , ((modkey, xK_m    ), viewEmptyWorkspace)
                , ((shfted, xK_m    ), tagToEmptyWorkspace)
                , ((modkey, xK_n    ), withFocused minimizeWindow)
                , ((shfted, xK_n    ), withLastMinimized maximizeWindowAndFocus)
                , ((modkey, xK_Down ), CWS.nextWS)
                , ((modkey, xK_Up   ), CWS.prevWS)

                  -- Handle floating windows.
                , ((modkey, xK_r ), withFocused $ windows . (flip W.float) centerRect)
                , ((modkey, xK_t ), withFocused $ windows . W.sink)
                , ((modkey, xK_f ), windows (actionCurrentFloating W.focusWindow))
                , ((shfted, xK_t ), windows (actionCurrentFloating W.sink))

                  -- screen handling
                , ((modkey, xK_space     ), CWS.nextScreen)
                , ((modkey, xK_BackSpace ), CWS.prevScreen)
                , ((shfted, xK_space     ), CWS.shiftNextScreen)
                , ((shfted, xK_BackSpace ), CWS.shiftPrevScreen)

                  -- xmonad handling
                , ((modkey, xK_l ), spawn "mate-screensaver-command -l")
                , ((shfted, xK_l ), broadcastMessage ReleaseResources >> restart "xmonad" True)
                , ((modkey, xK_v ), sendMessage NextLayout)
                , ((shfted, xK_v ), setLayout $ X.layoutHook conf)
                , ((modkey, xK_p ), spawn "synapse")
                , ((shfted, xK_p ), spawn "termite -e 'nvim -c \":VimwikiIndex\"'")
                , ((ctrled, xK_p ), spawn "termite -e 'bash -c \"TERM=xterm-256color ssh worker\"'")

                  --take a screenshot of entire display.
                , ((modkey, xK_Print ), spawn "scrot screen_%Y-%m-%d-%H-%M-%S.png -d 1 -e 'mv $f ~/Screenshots'")
                  --take a screenshot of focused window.
                , ((ctrled, xK_Print ), spawn "scrot window_%Y-%m-%d-%H-%M-%S.png -d 1 -u -e 'mv $f ~/Screenshots'")
                , ((modkey, xK_o     ), spawn "passmenu --type")
                , ((shfted, xK_o     ), spawn "sudo_pass_open")
                ]
                where
                  shfted = modkey .|. shiftMask
                  ctrled = modkey .|. controlMask
                  centerRect = (W.RationalRect (1/10) (1/10) (8/10) (8/10))

          in \c -> myKeys c `M.union` keys mateConfig c
      }

actionCurrentFloating :: (Eq s, Eq a, Eq i, Ord a) => (a -> W.StackSet i l a s sd -> W.StackSet i l a s sd) -> W.StackSet i l a s sd -> W.StackSet i l a s sd
actionCurrentFloating f s = findFloatingInCurrentStack (W.index s) (W.floating s)
  where
    findFloatingInCurrentStack ([]) fm = s
    findFloatingInCurrentStack (c:cs) fm =
      if (M.member (c) fm) then f c s else findFloatingInCurrentStack cs fm
