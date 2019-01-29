import XMonad as X

import XMonad.Config.Mate

import qualified XMonad.Actions.CycleWS as CWS
import XMonad.Actions.NoBorders (toggleBorder)
import XMonad.Actions.FindEmptyWorkspace (viewEmptyWorkspace, tagToEmptyWorkspace)
import XMonad.Actions.Minimize (minimizeWindow, withLastMinimized, maximizeWindowAndFocus)

import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat, isInProperty)
import XMonad.Hooks.ManageDebug
import XMonad.Hooks.ManageDocks (avoidStruts)

import XMonad.Layout.Spacing        -- Space around windows.
import XMonad.Layout.Gaps           -- Space around edge of screen.

import XMonad.Layout.SubLayouts

import XMonad.Layout.Simplest
-- import XMonad.Layout.Renamed        -- Hmm.

import XMonad.Layout.SimpleDecoration
import XMonad.Layout.NoFrillsDecoration (noFrillsDeco)
import XMonad.Layout.Tabbed (addTabs, tabbed)
-- import XMonad.Layout.ResizableTile
import XMonad.Layout.Fullscreen (fullscreenEventHook)
-- import XMonad.Layout.LayoutHints
import XMonad.Layout.WindowNavigation (Direction2D(..), Navigate(..) , configurableNavigation, navigateColor, windowNavigation)
import XMonad.Layout.IndependentScreens (onCurrentScreen, withScreens)
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
myActiveColor = "#f4bf75"
myInactiveColor = "#75715e"

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

-- myLayout = minimize tiled ||| tabs -- tabbed shrinkText myTabTheme
-- ||| minimize(Mirror tiled) ||| minimize Full
myLayout = id
    $ avoidStruts
--    $ gaps [(U, 4), (R, 4), (L, 4), (D, 4)]
    $ configurableNavigation (navigateColor myInactiveColor)
    $ tiled2 ||| tiledMirror |||tabs
  where
    addTopBar = noFrillsDeco shrinkText myTopBarTheme
--    addTopBar = simpleDeco shrinkText myTopBarTheme
    tiled2 = avoidStruts
           $ minimize
           $ windowNavigation
--           $ spacingRaw False (Border 4 4 4 4) True (Border 0 4 4 4) True
--           $ spacing 4
           $ addTopBar
           $ tiled

    tiledMirror = avoidStruts
                $ minimize
                $ windowNavigation
                $ addTopBar
                $ Mirror tiled

    tabs = avoidStruts
         $ minimize
         $ addTabs shrinkText myTabTheme
--         $ subLayout [] (Simplest ||| tiled2)
--         $ subTabbed
         $ Simplest

    -- default tiling algorithm partitions the screen into two panes
    tiled   = Tall nmaster delta ratio
    -- The default number of windows in the master pane
    nmaster = 1
    -- Default proportion of screen occupied by master pane
    ratio   = 1/2
    -- Percent of screen to increment by when resizing panes
    delta   = 3/100


main = xmonad . debugManageHook . ewmh $ mateConfig
         { modMask            = mod4Mask
         , workspaces         = withScreens 2 (map show [1..9])
         , terminal           = "termite"
         , focusFollowsMouse  = False
         , handleEventHook    = fullscreenEventHook
         , borderWidth        = 1
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
             let myKeys conf@(X.XConfig {modMask = modm}) = M.fromList $
                   [ -- workspaces
                     ((modm,                 xK_1     ), X.windows (onCurrentScreen W.greedyView "1"))
                   , ((modm,                 xK_2     ), X.windows (onCurrentScreen W.greedyView "2"))
                   , ((modm,                 xK_3     ), X.windows (onCurrentScreen W.greedyView "3"))
                   , ((modm,                 xK_4     ), X.windows (onCurrentScreen W.greedyView "4"))
                   , ((modm,                 xK_5     ), X.windows (onCurrentScreen W.greedyView "5"))

                     -- window handling
                   , ((modm,                 xK_w     ), X.sendMessage $ Go U)
                   , ((modm,                 xK_a     ), X.sendMessage $ Go L)
                   , ((modm,                 xK_s     ), X.sendMessage $ Go D)
                   , ((modm,                 xK_d     ), X.sendMessage $ Go R)
                   , ((modm,                 xK_z     ), X.sendMessage $ Shrink)
                   , ((modm,                 xK_x     ), X.sendMessage $ Expand)
                   , ((modm,                 xK_q     ), windows W.focusUp)
                   , ((modm,                 xK_e     ), windows W.focusDown)
                   , ((modm,                 xK_g     ), withFocused toggleBorder)
                   , ((modm .|. shiftMask,   xK_q     ), setLayout $ X.layoutHook conf)

                   , ((modm .|. controlMask, xK_h     ), sendMessage $ pullGroup L)
                   , ((modm .|. controlMask, xK_l     ), sendMessage $ pullGroup R)
                   , ((modm .|. controlMask, xK_k     ), sendMessage $ pullGroup U)
                   , ((modm .|. controlMask, xK_j     ), sendMessage $ pullGroup D)
                   , ((modm .|. controlMask, xK_m     ), withFocused (sendMessage . MergeAll))
                   , ((modm .|. controlMask, xK_u     ), withFocused (sendMessage . UnMerge))
                   , ((modm .|. controlMask, xK_period), onGroup W.focusUp')
                   , ((modm .|. controlMask, xK_comma ), onGroup W.focusDown')

                     -- Find empty workspace
                   , ((modm,                 xK_m     ), viewEmptyWorkspace)
                   , ((modm .|. shiftMask,   xK_m     ), tagToEmptyWorkspace)
                   , ((modm,                 xK_n     ), withFocused minimizeWindow)
                   , ((modm .|. shiftMask,   xK_n     ), withLastMinimized maximizeWindowAndFocus)
                   , ((modm,                 xK_Down  ), CWS.nextWS)
                   , ((modm,                 xK_Up    ), CWS.prevWS)

                     -- Handle floating windows.
                   , ((modm,                 xK_r     ), withFocused $ windows . (flip W.float) centerRect)
                   , ((modm,                 xK_t     ), withFocused $ windows . W.sink)
                   , ((modm,                 xK_f     ), windows (actionCurrentFloating W.focusWindow))
                   , ((modm .|. shiftMask,   xK_t     ), windows (actionCurrentFloating W.sink))

                     -- screen handling
                   , ((modm,                 xK_space ), CWS.nextScreen)
                   , ((modm .|. shiftMask,   xK_space ), CWS.shiftNextScreen)

                     -- xmonad handling
                   , ((modm,                 xK_c     ), spawn "cmus-remote -u")
                   , ((modm,                 xK_l     ), spawn "amixer set Master mute" >> spawn "mate-screensaver-command -l")
                   , ((modm .|. shiftMask,   xK_l     ), broadcastMessage ReleaseResources >> restart "xmonad" True)
                   , ((modm,                 xK_v     ), sendMessage NextLayout)
                   , ((modm .|. shiftMask,   xK_v     ), setLayout $ X.layoutHook conf)
                   , ((modm,                 xK_p     ), spawn "synapse")
                   , ((modm,                 xK_o     ), spawn "~/.xinitrc")
                     --take a screenshot of entire display
                   --, ((modm , xK_Print ), spawn "scrot screen_%Y-%m-%d-%H-%M-%S.png -d 1")
                     --take a screenshot of focused window
                   , ((modm .|. controlMask, xK_Print ), spawn "scrot window_%Y-%m-%d-%H-%M-%S.png -d 1-u")
                   ]
             in \c -> myKeys c `M.union` keys mateConfig c
         }
  where
    centerRect = (W.RationalRect (1/10) (1/10) (8/10) (8/10))

actionCurrentFloating :: (Eq s, Eq a, Eq i, Ord a) => (a -> W.StackSet i l a s sd -> W.StackSet i l a s sd) -> W.StackSet i l a s sd -> W.StackSet i l a s sd
actionCurrentFloating f s = findFloatingInCurrentStack (W.index s) (W.floating s)
  where
    findFloatingInCurrentStack ([]) fm = s
    findFloatingInCurrentStack (c:cs) fm =
      if (M.member (c) fm) then f c s else findFloatingInCurrentStack cs fm
