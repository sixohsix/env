import XMonad
import XMonad.Actions.UpdateFocus as UF
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeysP)
import XMonad.Prompt
import XMonad.Prompt.RunOrRaise
import XMonad.Prompt.XMonad
import System.IO

myKeys = [
  ("C-<Print>", spawn "sleep 0.2; scrot -s"),
  ("M-x r", runOrRaisePrompt defaultXPConfig),
  ("M-x x", xmonadPrompt defaultXPConfig),
  ("M-="  , spawn "amixer sset Master 1.5dB+"),
  ("M--"  , spawn "amixer sset Master 1.5dB-"),
  ("M-b"  , sendMessage ToggleStruts)
  ]

myConfig = defaultConfig {
--  manageHook = manageDocks <+> manageHook defaultConfig,
--  layoutHook = avoidStruts (layoutHook defaultConfig),
  modMask = mod4Mask,
  terminal = "xterm",
  startupHook = UF.adjustEventInput,
  handleEventHook = UF.focusOnMouseMove
  } `additionalKeysP` myKeys

xmobarCmd = "/usr/bin/xmobar ~/.xmobarrc"

toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

myXmobarPP = xmobarPP {
  ppCurrent = xmobarColor "green" "" . shorten 100
  }

addStatusBar = statusBar xmobarCmd myXmobarPP toggleStrutsKey

main = do
  config <- addStatusBar myConfig
  xmonad config
