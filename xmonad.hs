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
import XMonad.Layout.WindowNavigation (windowNavigation, Direction2D (..), Navigate (..) , navigateColor, configurableNavigation)
import XMonad.Layout.IndependentScreens

-- import qualified XMonad.Util.XRandRUtils as UXRR
import qualified XMonad.StackSet as W
import qualified Data.Map as M

laptopScreen = "eDP-1"
workScreen   = "HDMI-1"

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

main = xmonad . ewmh $ mateConfig
         { modMask            = mod4Mask
         , workspaces         = withScreens 2 (map show [1..9])
         , terminal           = "termite"
         , focusFollowsMouse  = False
         , handleEventHook    = fullscreenEventHook
         , startupHook        = setWMName "LG3D"
         , borderWidth        = 5
         , normalBorderColor  = colorBlackAlt
         , focusedBorderColor = colorWhiteAlt
         , layoutHook         = spacing 4
                              $ gaps [(U, 26), (R, 4), (L, 4), (D, 8)]
                              $ configurableNavigation (navigateColor colorBlackAlt)
                              $ layoutHook
                              $ mateConfig
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
--                   , ((modm, xK_q), windows (onCurrentScreen W.greedyView "6"))
--                   , ((modm, xK_w), windows (onCurrentScreen W.greedyView "7"))
--                   , ((modm, xK_e), windows (onCurrentScreen W.greedyView "8"))
--                   , ((modm, xK_r), windows (onCurrentScreen W.greedyView "9"))
                     -- window handling
                 --  , ((modm, xK_h), sendMessage $ Go L)
                 --  , ((modm, xK_l), sendMessage $ Go R)
                 --  , ((modm, xK_j), sendMessage $ Go D)
                 --  , ((modm, xK_k), sendMessage $ Go U)
                   , ((modm, xK_a), sendMessage $ Go L)
                   , ((modm, xK_d), sendMessage $ Go R)
                   , ((modm, xK_s), sendMessage $ Go D)
                   , ((modm, xK_w), sendMessage $ Go U)

                   , ((modm, xK_o), spawn "/home/tobias/layoutswitcher.sh")

                   , ((modm, xK_q), sendMessage $ Shrink)
                   , ((modm, xK_e), sendMessage $ Expand)
                   , ((modm, xK_g ), withFocused toggleBorder)
                     -- Find empty workspace
                   , ((modm,               xK_m    ), viewEmptyWorkspace)
                   , ((modm .|. shiftMask, xK_m    ), tagToEmptyWorkspace)
                   , ((modm,               xK_Down),  CWS.nextWS)
                   , ((modm,               xK_Up),    CWS.prevWS)
                     -- screen handling
                   , ((modm, xK_space),               CWS.nextScreen)
                   , ((modm .|. shiftMask, xK_space), CWS.shiftNextScreen)
                     -- xmonad handling
                   , ((modm,               xK_l), spawn "mate-screensaver-command -l")
                   , ((modm .|. shiftMask, xK_l), broadcastMessage ReleaseResources >> restart "xmonad" True)
                   , ((modm,               xK_v), sendMessage NextLayout)
                   , ((modm .|. shiftMask, xK_v), setLayout $ XMonad.layoutHook conf)
                   , ((modm,               xK_p), spawn "synapse")
                     --take a screenshot of entire display
                   --, ((modm , xK_Print ), spawn "scrot screen_%Y-%m-%d-%H-%M-%S.png -d 1")
                     --take a screenshot of focused window
                   , ((modm .|. controlMask, xK_Print ), spawn "scrot window_%Y-%m-%d-%H-%M-%S.png -d 1-u")
--                   , ((modm, xK_z .|. shiftMask),     toggleDisplay workScreen)
--                   , ((modm, xK_x .|. shiftMask),     toggleDisplay laptopScreen)
                   ]
             in \c -> myKeys c `M.union` keys mateConfig c
         }
--   where
--     toggledisplay d = do
--         UXRR.getXRRConnStatus d >>= \ case
--             Nothing               -> pure ()  -- no such output
--             Just (UXRR.XCSOff   ) -> pure ()  -- nothing there to turn on
--             Just (UXRR.XCSDiscon) -> off
--             Just (UXRR.XCSConn  ) -> spawn $ "xrandr --output " ++ d ++ " --auto --right-of " ++ laptopScreen
--             Just (UXRR.XCSEna   ) -> off
--     off = spawn $ "xrandr --output " ++ d ++ " --off"


-- onOtherScreen f vws = W.screen . W.current >>= f . flip marshall vws

-- onLaptopScreen f vws = W.screen . (!!0) . W.screens >>= f. flip marshall vws
-- onBigScreen f vws = W.screen . (!!1) . W.screens >>= f. flip marshall vws


-- onLaptopScreen = CWS.screenBy 1
