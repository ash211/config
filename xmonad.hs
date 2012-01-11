import System.IO
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Replace
import XMonad.Util.Run(spawnPipe)

import qualified XMonad.StackSet as W

xF86AudioRaiseVolume,xF86AudioLowerVolume,xF86AudioMute :: KeySym
xF86AudioRaiseVolume = 0x1008ff13
xF86AudioLowerVolume = 0x1008ff11
xF86AudioMute = 0x1008ff12

myLayout = avoidStruts $ smartBorders $ tiled ||| Mirror tiled ||| Full
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled   = Tall nmaster delta ratio
    -- The default number of windows in the master pane
    nmaster = 1
    -- Default proportion of screen occupied by master pane
    ratio   = 1/2
    -- Percent of screen to increment by when resizing panes
    delta   = 3/100

myManageHook = composeAll
    [ isFullscreen --> (doF W.focusDown <+> doFullFloat)
    , manageDocks
    , manageHook defaultConfig
    ]

main = do
  replace
  xmproc <- spawnPipe "xmobar ~/.xmobarrc"
  xmonad $ defaultConfig
    { terminal = "terminal"
    , modMask = mod1Mask
    , focusFollowsMouse = True
    , borderWidth = 1
    , manageHook = myManageHook
    , layoutHook = myLayout
    , logHook = dynamicLogWithPP xmobarPP
                  { ppOutput = hPutStrLn xmproc
                  , ppTitle = xmobarColor "green" "" . shorten 100
                  }
    } `additionalKeys`
    [ ((mod4Mask, xK_l), spawn "xscreensaver-command -lock")
    , ((0, xF86AudioMute), spawn "amixer -q set Master toggle")
    , ((0, xF86AudioLowerVolume), spawn "amixer -q set Master 5%-")
    , ((0, xF86AudioRaiseVolume), spawn "amixer -q set Master 5%+")
    , ((mod1Mask, xK_p), spawn "dmenu_run")
    , ((mod1Mask .|. shiftMask, xK_p), spawn "dmenu_run")
    ]
