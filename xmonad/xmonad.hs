import XMonad
import XMonad.Hooks.DynamicLog
import qualified Data.Map as M
import qualified XMonad.StackSet as W

main = xmonad =<< xmobar defaultConfig
  { keys = newKeys
  , terminal = "gnome-terminal"
  }

defKeys    = keys defaultConfig
delKeys x  = foldr M.delete           (defKeys x) (toRemove x)
newKeys x  = foldr (uncurry M.insert) (delKeys x) (toAdd    x)
toRemove x =
  -- unbind Alt-Enter, for browsers
  [ (modMask x, xK_Return)
  ]
toAdd x =
  -- bind terminal to Alt-t, since we're going to remap Alt-Shift-Enter below
  [ ((modMask x, xK_t), spawn "gnome-terminal")
  -- bind swapMaster to Alt-Shift-Enter, since we unbound Alt-Enter above
  , ((modMask x .|. shiftMask, xK_Return), windows W.swapMaster)
  ]
