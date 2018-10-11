import XMonad

import XMonad.Config.Mate

import qualified XMonad.Actions.CycleWS as CWS
import XMonad.Actions.NoBorders (toggleBorder)
import XMonad.Actions.FindEmptyWorkspace (viewEmptyWorkspace, tagToEmptyWorkspace)

import XMonad.Hooks.SetWMName
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.ManageHelpers (isFullscreen,doFullFloat, isInProperty)

import XMonad.Layout.Spacing
import XMonad.Layout.Gaps
import XMonad.Layout.Fullscreen
import XMonad.Layout.LayoutHints
import XMonad.Layout.WindowNavigation (Direction2D (..), Navigate (..) , configurableNavigation, navigateColor)
import XMonad.Layout.IndependentScreens
import XMonad.Layout.Minimize

-- import qualified XMonad.Util.XRandRUtils as UXRR
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

myLayout = minimize tiled ||| minimize(Mirror tiled) ||| minimize Full
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio
     -- The default number of windows in the master pane
     nmaster = 1
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

main = xmonad . ewmh $ mateConfig
         { modMask            = mod4Mask
         , workspaces         = withScreens 2 (map show [1..9])
         , terminal           = "termite"
         , focusFollowsMouse  = False
         , handleEventHook    = fullscreenEventHook
         , borderWidth        = 4
         , normalBorderColor  = "#75715e"
         , focusedBorderColor = "#f4bf75"
         , layoutHook         = spacing 4
                              $ gaps [(U, 30), (R, 4), (L, 4), (D, 4)]
                              $ configurableNavigation (navigateColor "#75715e")
                              $ myLayout
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
             let myKeys conf@(XConfig {modMask = modm}) = M.fromList $
                   [ -- workspaces
                     ((modm, xK_1), windows (onCurrentScreen W.greedyView "1"))
                   , ((modm, xK_2), windows (onCurrentScreen W.greedyView "2"))
                   , ((modm, xK_3), windows (onCurrentScreen W.greedyView "3"))
                   , ((modm, xK_4), windows (onCurrentScreen W.greedyView "4"))
                   , ((modm, xK_5), windows (onCurrentScreen W.greedyView "5"))
                     -- window handling
                   , ((modm, xK_a), sendMessage $ Go L)
                   , ((modm, xK_d), sendMessage $ Go R)
                   , ((modm, xK_s), sendMessage $ Go D)
                   , ((modm, xK_w), sendMessage $ Go U)
                   , ((modm, xK_q), sendMessage $ Shrink)
                   , ((modm, xK_e), sendMessage $ Expand)
                   , ((modm, xK_g ), withFocused toggleBorder)
                   , ((modm .|. shiftMask, xK_q), setLayout $ XMonad.layoutHook conf)
                     -- Find empty workspace
                   , ((modm,               xK_m    ), viewEmptyWorkspace)
                   , ((modm .|. shiftMask, xK_m    ), tagToEmptyWorkspace)
                   , ((modm,               xK_n    ), withFocused minimizeWindow)
                   , ((modm .|. shiftMask, xK_n    ), sendMessage RestoreNextMinimizedWin)
                   , ((modm,               xK_Down ), CWS.nextWS)
                   , ((modm,               xK_Up   ), CWS.prevWS)
                     -- Handle floating windows.
                   , ((modm,               xK_r    ), withFocused $ windows . (flip W.float) (W.RationalRect (1/10) (1/10) (8/10) (8/10)))
                   , ((modm,               xK_f    ), windows (actionCurrentFloating W.focusWindow))
                   , ((modm,               xK_t    ), withFocused $ windows . W.sink)
                   , ((modm .|. shiftMask, xK_t    ), windows (actionCurrentFloating W.sink))
                     -- screen handling
                   , ((modm, xK_space),               CWS.nextScreen)
                   , ((modm .|. shiftMask, xK_space), CWS.shiftNextScreen)
                     -- xmonad handling
                   , ((modm,               xK_c), spawn "cmus-remote -u")
                   , ((modm,               xK_l), spawn "amixer set Master mute" >> spawn "mate-screensaver-command -l")
                   , ((modm .|. shiftMask, xK_l), broadcastMessage ReleaseResources >> restart "xmonad" True)
                   , ((modm,               xK_v), sendMessage NextLayout)
                   , ((modm .|. shiftMask, xK_v), setLayout $ XMonad.layoutHook conf)
                   , ((modm,               xK_p), spawn "synapse")
                   , ((modm,               xK_o), spawn "~/.xinitrc")
                     --take a screenshot of entire display
                   --, ((modm , xK_Print ), spawn "scrot screen_%Y-%m-%d-%H-%M-%S.png -d 1")
                     --take a screenshot of focused window
                   , ((modm .|. controlMask, xK_Print ), spawn "scrot window_%Y-%m-%d-%H-%M-%S.png -d 1-u")
                   ]
             in \c -> myKeys c `M.union` keys mateConfig c
         }

actionCurrentFloating :: (Eq s, Eq a, Eq i, Ord a) => (a -> W.StackSet i l a s sd -> W.StackSet i l a s sd) -> W.StackSet i l a s sd -> W.StackSet i l a s sd
actionCurrentFloating f s = findFloatingInCurrentStack (W.index s) (W.floating s)
  where
    findFloatingInCurrentStack ([]) fm = s
    findFloatingInCurrentStack (c:cs) fm =
      if (M.member (c) fm) then f c s else findFloatingInCurrentStack cs fm
