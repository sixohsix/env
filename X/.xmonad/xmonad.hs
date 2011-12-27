import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeysP)
import XMonad.Prompt
import XMonad.Prompt.RunOrRaise
import System.IO

main = do
  xmproc <- spawnPipe "/usr/bin/xmobar /home/miv/.xmobarrc"
  xmonad $ defaultConfig
    { manageHook = manageDocks <+> manageHook defaultConfig
    , layoutHook = avoidStruts  $  layoutHook defaultConfig
    , modMask = mod4Mask     -- Rebind Mod to the Windows key
    , terminal = "gnome-terminal --hide-menubar"
    , logHook = dynamicLogWithPP xmobarPP
      { ppOutput = hPutStrLn xmproc
      , ppTitle = xmobarColor "green" "" . shorten 50
      }
    }
    `additionalKeysP`
    [ ("C-<print>", spawn "sleep 0.2; gnome-screenshot")
    , ("M-o", runOrRaisePrompt defaultXPConfig)
    ]
