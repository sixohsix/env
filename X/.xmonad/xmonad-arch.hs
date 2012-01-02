import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeysP)
import XMonad.Prompt
import XMonad.Prompt.RunOrRaise
import XMonad.Prompt.XMonad
import System.IO

main = do
  xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmobarrc"
  xmonad $ defaultConfig
    { manageHook = manageDocks <+> manageHook defaultConfig
    , layoutHook = avoidStruts  $  layoutHook defaultConfig
    , modMask = mod4Mask
    , terminal = "urxvt"
    , logHook = dynamicLogWithPP xmobarPP
      { ppOutput = hPutStrLn xmproc
      , ppTitle = xmobarColor "green" "" . shorten 50
      }
    }
    `additionalKeysP`
    [ ("C-<Print>", spawn "sleep 0.2; scrot -s")
    , ("M-x r", runOrRaisePrompt defaultXPConfig)
    , ("M-x x", xmonadPrompt defaultXPConfig)
    ]
