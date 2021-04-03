import XMonad hiding ( (|||) )
import System.IO (hPutStrLn,hClose)
import qualified XMonad.StackSet as W
import System.Exit

import qualified Data.Map as M
--import Data.List.Split (chunksOf)
--import Test.FitSpec.PrettyPrint (columns)
import Data.Maybe (fromMaybe)
import Data.Tree
import Data.Char (isSpace, toUpper)
import Data.Monoid

import XMonad.Hooks.WorkspaceHistory
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.Minimize
import XMonad.Hooks.ManageHelpers
--import XMonad.Hooks.ManageDocks (docksEventHook, manageDocks)
import XMonad.Hooks.EwmhDesktops  -- for some fullscreen events, also for xcomposite in obs.
import XMonad.Hooks.ServerMode
--import XMonad.Hooks.ManageDocks (ToggleStruts(..))
import XMonad.Hooks.ManageDocks (avoidStruts, docksEventHook, manageDocks,ToggleStruts(..))
import XMonad.Hooks.InsertPosition
import XMonad.Hooks.SetWMName
 
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.Roledex
import XMonad.Layout.MosaicAlt
--import XMonad.Layout.Hidden
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.Minimize
import qualified XMonad.Layout.BoringWindows as BW
import XMonad.Layout.ThreeColumns
-- import XMonad.Layout.ImageButtonDecoration
import XMonad.Layout.Accordion
import XMonad.Layout.LayoutCombinators

import XMonad.Layout.Groups.Wmii

import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle -- (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances --(StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowNavigation
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))

import XMonad.Actions.WorkspaceCursors
import XMonad.Actions.Navigation2D
import XMonad.Actions.DynamicProjects
import qualified XMonad.Actions.Search as S
import XMonad.Actions.WithAll
import XMonad.Actions.SimpleDate
import XMonad.Actions.TagWindows
import XMonad.Actions.WindowBringer
import XMonad.Actions.CycleWS
import XMonad.Actions.CycleWindows
import XMonad.Actions.WindowMenu
import qualified XMonad.Actions.Plane as Plane
import XMonad.Actions.CopyWindow
import XMonad.Actions.Minimize
import XMonad.Actions.GroupNavigation
import XMonad.Actions.MouseResize
import XMonad.Actions.DynamicWorkspaces
--import XMonad.Actions.Commands (defaultCommands)
import qualified XMonad.Actions.TreeSelect as TS
import XMonad.Actions.GridSelect
import XMonad.Actions.RotSlaves -- (rotSlavesDown, rotAllDown)

import XMonad.Util.EZConfig  (additionalKeysP,mkNamedKeymap)
import XMonad.Util.Run (spawnPipe,safeSpawn,runProcessWithInput)
import XMonad.Util.XUtils (fi)
import XMonad.Util.SpawnOnce
import XMonad.Util.NamedScratchpad
import XMonad.Util.NamedWindows --(getName)
import XMonad.Util.Scratchpad
--import XMonad.Util.Spotify
import XMonad.Config.Xfce

import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.Input
import XMonad.Prompt.ConfirmPrompt
import XMonad.Prompt.XMonad
import XMonad.Prompt.FuzzyMatch
import XMonad.Prompt.Window
import XMonad.Prompt.RunOrRaise

import XMonad.ManageHook
-- For PagerHints
import Codec.Binary.UTF8.String (encode)
import Control.Monad
-- import qualified DBus as D
-- import qualified DBus.Client as D
import Data.Monoid
import Foreign.C.Types (CInt)

myModMask :: KeyMask
myModMask = mod4Mask

myFont1 :: String
myFont1 = "xft:Lucida MAC:bold:size=14:antialias=true:hinting=true"

myFont2 :: String
myFont2 = "xft:Lucida Grande:bold:size=65:antialias=true:hinting=true"

--myAltMask :: KeyMask
--myAltMask = mod1Mask

myFont :: String
myFont = "xft:Mononoki Font:bold:size=20"

myTerminal :: String
myTerminal = "alacritty"

myBrowser1 :: String
myBrowser1 = "firefox"

myEditor :: String
myEditor = "emacs"

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

myBrowser2 :: String
myBrowser2 = "brave"

myBorderWidth :: Dimension
myBorderWidth = 1           -- Sets border width for windows

altMask = mod1Mask

myNormalBorderColor ::  String
myNormalBorderColor   = "#292d3e"  -- Border color of normal windows

myFocusedBorderColor  :: String   -- Border color of focused windo
myFocusedBorderColor  = "#bfc5ff"  -- Border color of focused windows

myLogHook :: X ()
myLogHook = fadeInactiveLogHook fadeAmount
    where fadeAmount = 1.0

quickL = [("Firefox", "firefox")
         ,("Emacs","emacs")
         ,("sEmacs","sudo emacs")
         ,("bluetooth","pavucontrol")
         ,("Terminal", "kitty")]
         
quickL' = ["firefox","emacs","sudo emacs","pavucontrol","kitty"]

quickL'' = [("Firefox",spawn "firefox")
           ,("Emacs",spawn "emacs")
           ,("SMacs",spawn "sudo emacs")
           ,("Bluetooth",spawn "pavucontrol")
           ,("Terminal",spawn "kitty")]

main :: IO()
main = do

  xmproc0 <- (spawnPipe "xmobar /etc/nixos/dotfiles/programs/desktop/xmobar/xmobarrc") 
  -- dbus <- D.connectSession
  --   -- Request access to the DBus name
  -- D.requestName dbus (D.busName_ "org.xmonad.Log")
  --      [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]
  --setRandomWallpaper [ "$HOME/Pictures/wallpapers"]
  xmonad $  dynamicProjects projects
         $  withNavigation2DConfig def
         $  additionalNav2DKeys (xK_Up, xK_Left, xK_Down, xK_Right)
                                    [(mod4Mask,               windowGo  ),
                                     (mod4Mask .|. shiftMask, windowSwap)]
                                    False
         -- $ pagerHints
         -- xmproc <- spawnPipe "xmobar  $HOME/.config/xmobar/xmobarrc"
         
         $ ewmh xfceConfig
    			{ modMask     = myModMask -- Use the "Win" key for the mod key
    			, layoutHook         =    minimize . BW.boringWindows $ showWName' myShowWNameTheme myLayoutHook  
    			, manageHook = ( isFullscreen --> doFullFloat ) <+> myManageHook <+> manageDocks
			-- , manageHook = myManageHook
    			, handleEventHook    = serverModeEventHookCmd
                       				<+> serverModeEventHook
                       				<+> serverModeEventHookF "XMONAD_PRINT" (io . putStrLn)
                       				<+> docksEventHook
                                      <+> minimizeEventHook
    			, startupHook = myStartupHook
    			, terminal    = myTerminal
   			, borderWidth =  myBorderWidth         -- Sets border width for windows
    			, normalBorderColor   =  myNormalBorderColor  -- Border color of normal windows
    			, focusedBorderColor  =  myFocusedBorderColor  -- Border color of focused windows
    			, workspaces         = myWorkspaces
                        , logHook = workspaceHistoryHook <+> myLogHook <+> dynamicLogWithPP xmobarPP
                        -- , logHook           =  ewmhDesktopsLogHook
                        { ppOutput = \x -> hPutStrLn xmproc0 x
                        , ppCurrent = xmobarColor "#98be65" "" . wrap "[" "]"           -- Current workspace in xmobar
                        , ppVisible = xmobarColor "#98be65" "" -- . clickable              -- Visible but not current workspace
                        , ppHidden = xmobarColor "#82AAFF" "" . wrap "*" "" -- . clickable -- Hidden workspaces in xmobar
                        , ppHiddenNoWindows = xmobarColor "#c792ea" "" -- . clickable     -- Hidden workspaces (no windows)
                        , ppTitle = xmobarColor "#b3afc2" "" . shorten 60               -- Title of active window in xmobar
                        , ppSep =  "<fc=#666666> <fn=1>|</fn> </fc>"                    -- Separators in xmobar
                        , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"            -- Urgent workspace
                        , ppExtras  = [windowCount]                                     -- # of windows current workspace
                        , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
                        }
                        -- , keys = plaineKeys
                          -- 
              --, keys               = myKeys''
    			       	}  `additionalKeysP` myKeys
        --  $ pagerHints
         --  $ myConfig
                        
-- plaineKeys conf = M.union (keys def conf) $ myNewKeys conf
-- myNewKeys (XConfig {modMask = modm}) = planeKeys modm (Lines 3) Finite

myWorkspaces :: [String]
myWorkspaces = ["origin","NSP"]

projects :: [Project]
projects = [
    -- Project { projectName      = "browser"
    --         , projectDirectory = "~/Download"
    --         , projectStartHook = Just $ do  spawn "brave"
    --         }
   --      Project { projectName      = "wsudo"
   --          , projectDirectory = "~/"
   --          , projectStartHook = Just $ do  spawn "sudo emacs"
   --          }
   -- , Project { projectName      = "emacs"
   --          , projectDirectory = "~/"
   --          , projectStartHook = Just $ do  spawn "emacs"
   --          }
    -- , Project { projectName      = "sicp"
    --         , projectDirectory = "~/books"
    --         , projectStartHook = Just $ do  spawn "okular sicp.pdf"
    --         }
    --  , Project { projectName      = "luah"
    --         , projectDirectory = "~/books"
    --         , projectStartHook = Just $ do  spawn "okular haskell/Luah.pdf"
    --         }
    --   , Project { projectName      = "algo"
    --         , projectDirectory = "~/books"
    --         , projectStartHook = Just $ do  spawn "okular haskell/Haskell-Algo.pdf"
    --         }
    --   , Project { projectName      = "dm"
    --         , projectDirectory = "~/books"
    --         , projectStartHook = Just $ do  spawn "okular dm.pdf"
    --         }
    --        , Project { projectName      = "o"
    --         , projectDirectory = "~/books"
    --         , projectStartHook = Just $ do  spawn "okular dmspectrum.pdf"
    --         }
    --        , Project { projectName      = "befa"
    --         , projectDirectory = "~/books"
    --         , projectStartHook = Just $ do  spawn "okular befa.pdf"
    --         }
    --        , Project { projectName      = "2"
    --         , projectDirectory = "~/books"
    --         , projectStartHook = Just $ do  spawn "okular 2ndYear.pdf"
    --         }
         -- , Project { projectName      = "syllabus"
         --    , projectDirectory = "~/books"
         --    , projectStartHook = Just $ do  spawn "okular 3rdYear.pdf"
         --    }
   {- , Project { projectName      = "library"
            , projectDirectory = "~/books"
            , projectStartHook = Just $ do shellPrompt  switchXPConfig--runOrRaisePrompt runOrRaiseXPConfig -- "ke"
                         --Nothing --  spawn "ko"
        }
  , Project { projectName      = "terminal"
            , projectDirectory = "~/"
            , projectStartHook = Just $ do spawn  "emacsclient -c -a '' --eval '(+vterm/here nil))'"--"cool-retro-term"
       -}
  ]


myKeys :: [(String,X())]
myKeys =[
       ("S-<Return>" ,  xmonadPromptC myKeys' ultimateXPConfig )-- $ aynRandXPConfig $ unsafePerformIO (getStdRandom (randomR (1, 2))))
       , ("S-<Tab>" ,  xmonadPromptC myKeys' ultimateXPConfig ) -- $ aynRandXPConfig $ unsafePerformIO (getStdRandom (randomR (1, 3))))
       ,  ("S-<Space>" ,  xmonadPromptC myKeys' ultimateXPConfig )-- $ aynRandXPConfig $ unsafePerformIO (getStdRandom (randomR (1, 4))))
       ,  ("M-<Space>" ,  xmonadPromptC myKeys' ultimateXPConfig )-- $ aynRandXPConfig $ unsafePerformIO (getStdRandom (randomR (1, 5))))
       ,  ("M1-<Space>" ,  xmonadPromptC myKeys'  ultimateXPConfig) -- ultimateXPConfig )-- $ aynRandXPConfig $ unsafePerformIO (getStdRandom (randomR (1, 5))))
       --  , ("M1-<Return>",  spawn myTerminal )
       --  , ("M-<Tab>" ,  spawnSelected' myList)
       , ("M-2",  spawn "scrot")
       , ("M-`", treeselectAction tsDefaultConfig)
       , ("M1-q" , sendMessage $ MT.Toggle NBFULL)
       , ("M1-C-o" , shellPrompt  xShellXPConfig)
       , ("M1-C-g" , S.promptSearch  ultima10XPConfig aiGoogle )
       , ("M1-o" , shellPrompt  xShellXPConfig)
       , ("M-m", runSelectedAction defaultGSConfig {gs_cellheight = 160,  gs_navigate = myNavigation,gs_cellwidth = 310,gs_font = "xft:SF Pro Text :size=19"}  layoutList)
       -- , ("M-<Tab>" , mass)--windowMenXPConfig)
       , ("M1-i", runSelectedAction defaultGSConfig {gs_cellheight = 160,  gs_navigate = myNavigation,gs_cellwidth = 310,gs_font = "xft:SF Pro Text :size=19"}  quickL'')
       -- , ("M-h" , shellPrompt  xShellXPConfig)
       , ("M1-y" ,   windowMenu)
       , ("M-<Tab>" ,  goToSelected  defaultGSConfig{gs_cellheight = 160,  gs_navigate = myNavigation,gs_cellwidth = 310,gs_font = "xft:SF Pro Text :size=17",gs_bordercolor="black"}) -- mass)--windowMenu)
       , ("M1-<Tab>",  windows W.focusDown)-- moveTo Prev NonEmptyWS )
       , ("M1-C-q",  Plane.planeMove  (Plane.Lines 4) Plane.Finite Plane.ToUp )
       , ("M1-C-w",  Plane.planeMove  (Plane.Lines 4) Plane.Finite Plane.ToDown )
       , ("M1-C-e",  Plane.planeMove  (Plane.Lines 4) Plane.Finite Plane.ToLeft )
       , ("M1-C-r",  Plane.planeMove  (Plane.Lines 4) Plane.Finite Plane.ToRight )
       -- , ("M1-q",   moveTo Next NonEmptyWS )
     --  , ("M1-<Tab>",nextMatch Backward (return True))
     --  , ("S-[",      prevWS )
     --  , ("S-]",      nextWS )
       , ("M-f" ,sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts)
       -- , ("M1-q" ,sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts)
       , ("M1-f",sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts)
       , ("M1-[",   moveTo Prev NonEmptyWS )
       , ("M1-]",   moveTo Next NonEmptyWS )
       , ("M-q",    moveTo Prev NonEmptyWS )
       , ("M-[",     prevWS )
       , ("M1-w", withFirstMinimized maximizeWindowAndFocus)
       , ("M-w",      withFocused minimizeWindow)
       , ("M-]",     nextWS )
       , ("S-<Backspace>" ,  kill )
       , ("M1-<Backspace>" , removeWorkspace )
       , ("M-<Backspace>" ,  killAll )
       
    -- Increase/decrease spacing (gaps)
        , ("M-d", decWindowSpacing 4)           -- Decrease window spacing
        , ("M-i", incWindowSpacing 4)           -- Increase window spacing
        , ("M-S-d", decScreenSpacing 4)         -- Decrease screen spacing
        , ("M-S-i", incScreenSpacing 4)         -- Increase screen spacing

       , ("M1-<Return>" ,  namedScratchpadAction myScratchPads "kitty")
       -- , ("M-<Return>" ,  spawnSelected' mygridConfig )--namedScratchpadAction myScratchPads "kitty")
       , ("M-<Return>" ,  namedScratchpadAction myScratchPads "kitty")
       -- , ("M1-p" ,  namedScratchpadAction myScratchPads "fire2")
       , ("M1-C-v" ,toggleGroupFull )
       , ("M1-C-c" ,zoomGroupIn )
       , ("M1-C-t" ,groupToTabbedLayout )
       , ("M1-C-f" ,groupToFullLayout )
       , ("M1-C-n" ,groupToNextLayout )
     ]

  
myNavigation :: TwoD a (Maybe a)
myNavigation = makeXEventhandler $ shadowWithKeymap navKeyMap navDefaultHandler
 where navKeyMap = M.fromList [
          ((0,xK_Escape), cancel)
         ,((0,xK_space), select)
         ,((0,xK_slash) , substringSearch myNavigation)
         ,((0,xK_Left)  , move (-1,0)  >> myNavigation)
         ,((0,xK_h)     , move (-1,0)  >> myNavigation)
         ,((0,xK_Right) , move (1,0)   >> myNavigation)
         ,((0,xK_l)     , move (1,0)   >> myNavigation)
         ,((0,xK_Down)  , move (0,1)   >> myNavigation)
         ,((0,xK_j)     , move (0,1)   >> myNavigation)
         ,((0,xK_Up)    , move (0,-1)  >> myNavigation)
         ,((0,xK_k)    , move (0,-1)  >> myNavigation)
         ,((0,xK_y)     , move (-1,-1) >> myNavigation)
         ,((0,xK_i)     , move (1,-1)  >> myNavigation)
         ,((0,xK_n)     , move (-1,1)  >> myNavigation)
         ,((0,xK_m)     , move (1,-1)  >> myNavigation)
         ,((0,xK_c) , setPos (0,0) >> myNavigation)
         ]
       -- The navigation handler ignores unknown key symbols
       navDefaultHandler = const myNavigation
tsDefaultConfig :: TS.TSConfig a
tsDefaultConfig = TS.TSConfig { TS.ts_hidechildren = True
                              , TS.ts_background   = 0xff000000--0xdd292d3e
                              , TS.ts_font         = "xft:SF Pro Text:style=Medium:size=18"--myFont1
                              -- , TS.ts_node         = (0xffd0d0d0, 0xff202331)
                              -- , TS.ts_nodealt      = (0xffd0d0d0, 0xff292d3e)
                              , TS.ts_node         = (0xff000000, 0xffffffff)
                              , TS.ts_nodealt      = (0xfff0000f, 0xffffffff)
                              , TS.ts_highlight    = (0xff0000ff, 0xff000000)
                              , TS.ts_extra        = 0xffffffff
                              , TS.ts_node_width   = 350
                              , TS.ts_node_height  = 50
                              , TS.ts_originX      = 0
                              , TS.ts_originY      = 0
                              , TS.ts_indent       = 80
                              , TS.ts_navigate     = myTreeNavigation
                              }

myTreeNavigation = M.fromList
    [ ((0, xK_Escape),   TS.cancel)
    , ((0, xK_Return),   TS.select)
    , ((0, xK_space),    TS.select)
    , ((0, xK_Up),       TS.movePrev)
    , ((0, xK_Down),     TS.moveNext)
    -- , ((0, xK_Down),     TS.moveNext)
    , ((0, xK_Left),     TS.moveParent)
    , ((0, xK_Right),    TS.moveChild)
    , ((0, xK_k),        TS.movePrev)
    , ((0, xK_j),        TS.moveNext)
    , ((0, xK_u),        TS.moveParent)
    , ((0, xK_n),        TS.moveChild)
    , ((0, xK_o),        TS.moveHistBack)
    , ((0, xK_i),        TS.moveHistForward)
   ]


treeselectAction :: TS.TSConfig (X ()) -> X ()
treeselectAction a = TS.treeselectAction a
  [
    Node (TS.TSNode "+Run" "Run anything" (return ()))
    [ Node (TS.TSNode "Shell" "Bash shell" ( shellPrompt  xShellXPConfig))[]
    ,  Node (TS.TSNode "RunOrRaise" "Run" ( runOrRaisePrompt  xShellXPConfig))[]
    ] 
  , Node (TS.TSNode "+Most used" "" (return ()))
   [  Node (TS.TSNode "Kitty" "Drop down terminal" (spawn "kitty")) []
  , Node (TS.TSNode "Firefox" "Drop down browser"   (spawn "firefox"))[]
  , Node (TS.TSNode "Emacs" "Drop down editor"   (spawn "emacs"))[]
  , Node (TS.TSNode "sEmacs" "Drop down editor(root)"   (spawn "sudo emacs"))[]
   , Node (TS.TSNode "Spotify" "Drop down spotify"   (  namedScratchpadAction myScratchPads "spotify"))[]
    ]
  , Node(TS.TSNode "+Search" "" (return()))
  [ Node (TS.TSNode "Books" "Gen . lib . rus" ( S.promptSearch   xShellXPConfig books))[]
  , Node (TS.TSNode "Store" "Nixos store" (S.promptSearch   xShellXPConfig nixos))[]
  , Node (TS.TSNode "https:" "vanila" (S.promptSearch   xShellXPConfig vanila))[]
  , Node (TS.TSNode "Google" "google search" (S.promptSearch   xShellXPConfig aiGoogle))[]
  , Node (TS.TSNode "Youtube" "videos" (S.promptSearch   xShellXPConfig S.youtube))[]
   ]
  , Node(TS.TSNode "+Utilites" "" (return()))
  [
    
   Node (TS.TSNode "Redshift" "brightness" ( runSelectedAction defaultGSConfig {gs_cellheight = 160,  gs_navigate = myNavigation,gs_cellwidth = 310,gs_font = "xft:SF Pro Text :size=19"}  redshift))[]
  ]
   , Node (TS.TSNode " + Exit" "" (return ()))
   [  Node (TS.TSNode "Shutdown" "switch off the computer"  ( confirmPrompt xShellXPConfig' "shutdown" $ spawn "poweroff"))[]
  , Node (TS.TSNode "Restart" "Restart the computer"   (  confirmPrompt xShellXPConfig' "restart" $ spawn "reboot"))[]
   , Node (TS.TSNode "Logout" "Logout of xmonad"   (   confirmPrompt xShellXPConfig' "exit" $ io $ exitWith ExitSuccess))[]
    ]
  ]

spawnSelected' :: [(String, String)] -> X ()
spawnSelected' lst = gridselect conf lst >>= flip whenJust spawn
    where conf = def
                   { gs_cellheight   = 150
                   , gs_cellwidth    = 340
                   , gs_cellpadding  = 6
                   , gs_originFractX = 0.5
                   , gs_originFractY = 0.5
                   , gs_font         = myFont
                   }

myList :: [(String,String)]
myList = [("Shift+Return  Main menu","")
         ,("Shift+Tab     Main menu","")
         ,("Alt+Return    Exec terminal","")
         ,("Mod4+2        Screenshot",""   )
         ]

-- myColorizer ::  Bool -> X (String, String)
myColorizer = colorRangeFromClassName
                  (0x28,0x2c,0x34) -- lowest inactive bg
                  (0x28,0x2c,0x34) -- highest inactive bg
                  (0xc7,0x92,0xea) -- active bg
                  (0xc0,0xa7,0x9a) -- inactive fg
                  (0x28,0x2c,0x34) -- active fg


-- gridSelect menu layout
mygridConfig :: p -> GSConfig Window
mygridConfig colorizer = (buildDefaultGSConfig myColorizer)
    { gs_cellheight   = 40
    , gs_cellwidth    = 200
    , gs_cellpadding  = 6
    , gs_originFractX = 0.5
    , gs_originFractY = 0.5
    , gs_font         =  "xft:SF Pro Text:style=Medium:size=22"
    }

colorizer :: a -> Bool -> X (String, String)
colorizer _ isFg = do
    fBC <- asks (focusedBorderColor . config)
    nBC <- asks (normalBorderColor . config)
    return $ if isFg
                then (fBC, nBC)
                else (nBC, fBC)

-- windowMenu :: X ()
-- windowMenu = withFocused $ \w -> do
--     tags <- asks (workspaces . config)
--     Rectangle x y wh ht <- getSize w
--     Rectangle sx sy swh sht <- gets $ screenRect . W.screenDetail . W.current . windowset
--     let originFractX = (fi x - fi sx + fi wh / 2) / fi swh
--         originFractY = (fi y - fi sy + fi ht / 2) / fi sht
--         gsConfig = (buildDefaultGSConfig colorizer)
--                     { gs_originFractX = originFractX
--                     , gs_originFractY = originFractY }
--         actions = [ ("rotUnfocusedUp" , rotUnfocusedUp)
--                   , ("Cancel menu", return ())
--                   , ("Close"      , kill)
--   --                , ("Maximize"   , sendMessage $ maximizeRestore w)
--                   , ("Minimize"   , minimizeWindow w)
--                   ] ++
--                   [ ("Move to " ++ tag, windows $ W.shift tag)
--                     | tag <- tags ]
--     runSelectedAction gsConfig actions

getSize :: Window -> X (Rectangle)
getSize w = do
  d  <- asks display
  wa <- io $ getWindowAttributes d w
  let x = fi $ wa_x wa
      y = fi $ wa_y wa
      wh = fi $ wa_width wa
      ht = fi $ wa_height wa
  return (Rectangle x y wh ht)
-- gridSelect menu layout
-- mygridConfig :: p -> GSConfig Window
-- mygridConfig colorizer = (buildDefaultGSConfig myColorizer)
--     { gs_cellheight   = 40
--     , gs_cellwidth    = 200
--     , gs_cellpadding  = 6
--     , gs_originFractX = 0.5
--     , gs_originFractY = 0.5
--     , gs_font         = myFont
--     }
{-myMass =  def   { gs_cellheight   = 150
                   , gs_cellwidth    = 340
                   , gs_cellpadding  = 6
                   --, gs_colorizer    = myColorizer
                   , gs_originFractX = 0.5
                   , gs_originFractY = 0.5
                   --, gs_font         = myFont
                   -}

mass = runSelectedAction def{  gs_cellheight   = 150 ,  gs_cellwidth    = 340 , gs_font = myFont} windowList --(buildDefaultGSConfig myColorizer) windowList --myMass okay
okay = [("rotUnfocusedUp" , rotUnfocusedUp)
       , ("rotFocusedDown" , rotFocusedDown)
       , ("rotOpposite"    , rotOpposite)
       , ("rotUnfocusedUp" , rotUnfocusedUp)
       , ("rotFocusedUp"   , rotFocusedUp)
       , ("rotUnfocusedDown", rotUnfocusedDown)
       ]
windowList = [("addTag", tagPrompt ultimateXPConfig (\s -> withFocused (addTag s)))
             , ("deleteTag", tagDelPrompt ultimateXPConfig)
             , ("killWin", tagPrompt ultimateXPConfig (\s -> withTaggedGlobal s killWindow))
             , ("hideWin", tagPrompt ultimateXPConfig (\s -> withTaggedGlobal s minimizeWindow))
             , ("maximizeWin", tagPrompt ultimateXPConfig (\s -> withTaggedGlobal s maximizeWindowAndFocus))
   --   , ("w2", tagPrompt ultimateXPConfig (\s -> withTaggedP s (W.shiftWin "2")))
             , ("shiftHere", tagPrompt ultimateXPConfig (\s -> withTaggedGlobalP s shiftHere))
             , ("goto", tagPrompt ultimateXPConfig (\s -> focusUpTaggedGlobal s))
             ]

-- Xmonad has several search engines available to use located in
-- XMonad.Actions.Search. Additionally, you can add other search engines
-- such as those listed below.
archwiki, ebay, news, reddit, urban :: S.SearchEngine

archwiki = S.searchEngine "archwiki" "https://wiki.archlinux.org/index.php?search="
ebay     = S.searchEngine "ebay" "https://www.ebay.com/sch/i.html?_nkw="
news     = S.searchEngine "news" "https://news.google.com/search?q="
reddit   = S.searchEngine "reddit" "https://www.reddit.com/search/?q="
urban    = S.searchEngine "urban" "https://www.urbandictionary.com/define.php?term="
nixos    = S.searchEngine "playStore" "https://search.nixos.org/packages?channel=20.09&from=0&size=30&sort=relevance&query="
github   = S.searchEngine  "github" "https://github.com/search?q="
tutorial = S.searchEngine "tutorial" "https://www.youtube.com/watch?v=CrNOCk5m1FU"
whatsapp = S.searchEngine "whatsapp" "https://web.whatsapp.com/"
aiGoogle = S.intelligent S.google
mty      = S.searchEngine "empty" "https://gitlab.com/vladimirLenin/"
books    = S.searchEngine "books" "http://gen.lib.rus.ec/search.php?req="
php      = S.searchEngine "server" "http://localhost:4000/"
vanila   = S.searchEngine "https://" "https://" 

searchList :: [(String, S.SearchEngine)]
searchList = [ ("a", archwiki)
             , ("d", S.duckduckgo)
             , ("e", ebay)
             , ("g", S.google)
             , ("h", S.hoogle)
             , ("i", S.images)
             , ("n", news)
             , ("r", reddit)
             , ("s", S.stackage)
             , ("t", S.thesaurus)
             , ("v", S.vocabulary)
             , ("b", S.wayback)
             , ("u", urban)
             , ("w", S.wikipedia)
             , ("y", S.youtube)
             , ("z", S.amazon)
             ]
-- great replacement for dzen.
myXPConfig :: XPConfig
myXPConfig = def
  { --position            = CenteredAt { xpCenterY = 0.5, xpWidth = 1 }
  --position            =  Bottom
  position            =  Top
  , bgColor           = "#000000"
  , fgColor           = "#DDDDDD"
  , fgHLight          = "#FFFFFF"
  , bgHLight          = "#333333"
  , borderColor       = "#FFFFFF"
  , promptBorderWidth = 1
  , font              = "xft:LucidaGrande:size=26"
  , height            = 80
  , searchPredicate   = fuzzyMatch
  , alwaysHighlight   = True
  , defaultPrompter   = id $ map toUpper
  }

{-
dtXPKeymap :: M.Map (KeyMask,KeySym) (XP ())
dtXPKeymap = M.fromList $
     map (first $ (,) controlMask)   -- control + <key>
     [ (xK_z, killBefore)            -- kill line backwards
     , (xK_k, killAfter)             -- kill line forwards
     , (xK_a, startOfLine)           -- move to the beginning of the line
     , (xK_e, endOfLine)             -- move to the end of the line
     , (xK_m, deleteString Next)     -- delete a character foward
     , (xK_b, moveCursor Prev)       -- move cursor forward
     , (xK_f, moveCursor Next)       -- move cursor backward
     , (xK_BackSpace, killWord Prev) -- kill the previous word
     , (xK_y, pasteString)           -- paste a string
     , (xK_g, quit)                  -- quit out of prompt
     , (xK_bracketleft, quit)
     ]
     ++
     map (first $ (,) altMask)       -- meta key + <key>
     [ (xK_BackSpace, killWord Prev) -- kill the prev word
     , (xK_f, moveWord Next)         -- move a word forward
     , (xK_b, moveWord Prev)         -- move a word backward
     , (xK_d, killWord Next)         -- kill the next word
     , (xK_n, moveHistory W.focusUp')   -- move up thru history
     , (xK_p, moveHistory W.focusDown') -- move down thru history
     ]
     ++
     map (first $ (,) 0) -- <key>
     [ (xK_Return, setSuccess True >> setDone True)
     , (xK_KP_Enter, setSuccess True >> setDone True)
     , (xK_BackSpace, deleteString Prev)
     , (xK_Delete, deleteString Next)
     , (xK_Left, moveCursor Prev)
     , (xK_Right, moveCursor Next)
     , (xK_Home, startOfLine)
     , (xK_End, endOfLine)
     , (xK_Down, moveHistory W.focusUp')
     , (xK_Up, moveHistory W.focusDown')
     , (xK_Escape, quit)
     ] -}

myXPConfig' = def
                {
                                     position            = CenteredAt { xpCenterY = 0.2, xpWidth = 0.5 }
                                     , bgColor           = "grey7"
                                     , fgColor           = "grey80"
                                     , bgHLight          = "#02bfa0"
                                     , fgHLight          = "White"
                                     , borderColor       = "white"
                                     , alwaysHighlight   = True
                                     , promptBorderWidth = 4
                                     , defaultText       = []
                                     , font              = "xft:LucidaGrande:size=26"
                                     , height            = 96
				     , autoComplete      = Just 100000
                  }

runOrRaiseXPConfig :: XPConfig
runOrRaiseXPConfig = myXPConfig' {
                                  bgColor = "#e0dfde"
                                , borderColor = "#000000"
                                , fgColor = "#0f0f0f"
				, autoComplete = Nothing
                                 }

switchXPConfig = amberXPConfig {

                                     position            = Top --CenteredAt { xpCenterY = 0.2, xpWidth = 0.5 }
                                     , font              = "xft:FiraSans:size=26"
                                     , searchPredicate   = fuzzyMatch
                                     , height            = 76
                                     , bgHLight          = "#02bfa0"
                                     , fgHLight          = "White"

                      }
ultimateXPConfig = greenXPConfig {
                               autoComplete      = Just 100000    -- set Just 100000 for .1 sec
                               , height            = 80
                               -- ,fgColor = "green"
                               ,  position =  CenteredAt {xpCenterY = 0.29 , xpWidth = 0.68}
                               , promptBorderWidth = 0
                                ,  font = "xft:FiraSans:size=21"
                                -- , font = "xft:SF Pro Display:style=Regular:size=21"
                                -- font = "xft:"
                               -- , font = "xft:SF Pro Text:style=Medium:size=21"
                               , promptKeymap        = vimLikeXPKeymap
                       }
ultimateWindows = ultimateXPConfig {
                                        font = "xft:FiraSans:size=24"
                                   , height            = 100
                                   }
ultima10XPConfig = ultimateXPConfig {
                                    autoComplete      = Nothing    -- set Just 100000 for .1 sec
  				    , position = Top                             
                                    ,  font = "xft:FiraSans:size=20"
                                    , height            = 40
                                    }
xShellXPConfig = ultima10XPConfig {
                                        
                               fgColor = "#ffffff"
                                , font = "xft:SF Pro Text:style=Medium:size=22"
  				 -- , position = Top                             
                                , position =  CenteredAt {xpCenterY = 0.18 , xpWidth = 0.6}
                               , borderColor = "#0f0f0f"
                                ,  height            = 82
                               , promptBorderWidth =2
                                  }
xShellXPConfig' = xShellXPConfig {               
                                         autoComplete      = Just 100000    -- set Just 100000 for .1 sec
                               }
-- dtXPKeymap :: M.Map (KeyMask,KeySym) (XP ())
-- dtXPKeymap = M.fromList $
--      map (first $ (,) controlMask)      -- control + <key>
--      [ (xK_z, killBefore)               -- kill line backwards
--      , (xK_k, killAfter)                -- kill line forwards
--      , (xK_a, startOfLine)              -- move to the beginning of the line
--      , (xK_e, endOfLine)                -- move to the end of the line
--      , (xK_m, deleteString Next)        -- delete a character foward
--      , (xK_b, moveCursor Prev)          -- move cursor forward
--      , (xK_f, moveCursor Next)          -- move cursor backward
--      , (xK_BackSpace, killWord Prev)    -- kill the previous word
--      , (xK_y, pasteString)              -- paste a string
--      , (xK_g, quit)                     -- quit out of prompt
--      , (xK_bracketleft, quit)
--      ]
--      ++
--      map (first $ (,) altMask)          -- meta key + <key>
--      [ (xK_BackSpace, killWord Prev)    -- kill the prev word
--      , (xK_f, moveWord Next)            -- move a word forward
--      , (xK_b, moveWord Prev)            -- move a word backward
--      , (xK_d, killWord Next)            -- kill the next word
--      , (xK_n, moveHistory W.focusUp')   -- move up thru history
--      , (xK_p, moveHistory W.focusDown') -- move down thru history
--      ]
--      ++
--      map (first $ (,) 0) -- <key>
--      [ (xK_Return, setSuccess True >> setDone True)
--      , (xK_KP_Enter, setSuccess True >> setDone True)
--      , (xK_BackSpace, deleteString Prev)
--      , (xK_Delete, deleteString Next)
--      , (xK_Left, moveCursor Prev)
--      , (xK_Right, moveCursor Next)
--      , (xK_Home, startOfLine)
--      , (xK_End, endOfLine)
--      , (xK_Down, moveHistory W.focusUp')
--      , (xK_Up, moveHistory W.focusDown')
--      , (xK_Escape, quit)
--      ]

penUltiXPConfig = ultima10XPConfig {
                                       autoComplete = Just 100000 
                                   }
layoutXPConfig = ultimateXPConfig {
                                       position =  CenteredAt {xpCenterY = 0.34 , xpWidth = 0.88}
                                     ,  font = "xft:LucidaGrande:size=22"
                                    }
ultima2XPConfig = amberXPConfig {

                                autoComplete      = Just 100000    -- set Just 100000 for .1 sec
                                ,  height            = 80
                               ,  font = "xft:LucidaGrande:size=26"
                               ,  position =  CenteredAt {xpCenterY = 0.3 , xpWidth = 0.84}
                       }
myBackgroundColor = "#151515"

myContentColor = "#d0d0d0"

myFontq = "xft:SauceCodePro Nerd Font:regular:pixelsize=23"

myXPromptConfig :: XPConfig
myXPromptConfig =
      XPC
        { promptBorderWidth = 1
        , alwaysHighlight = True
        , height = 42
        , historySize = 256
        , font =   myFontq
        , bgColor = myBackgroundColor
        , fgColor = myContentColor
        , bgHLight = myBackgroundColor
        , fgHLight = myContentColor
        , borderColor = myBackgroundColor
        , position = Top
        , autoComplete = Just 100000
        , showCompletionOnTab = False
        , searchPredicate = fuzzyMatch
        , defaultPrompter = id
        , sorter = const id
        , maxComplRows = Just 7
        , promptKeymap = defaultXPKeymap
        , completionKey = (0, xK_Tab)
        , changeModeKey = xK_grave
        , historyFilter = id
        , defaultText = []
        }

searchPrompt :: X()
searchPrompt = inputPrompt myXPConfig "yay " ?+ appStore

appStore :: String -> X()
appStore query =  spawn (((myTerminal ++) " -e yay " ++ ) query)

webList = [   ("github"  , S.selectSearch $ S.searchEngine "mass" "https://github.com/vamshi-lisp")
            , ("tutHaskell",  S.selectSearch $ S.searchEngine "ass" "https://www.srid.ca/1948201.html")
            , ("gitlab", S.selectSearch mty)
    ]
editPrompt :: String -> X()
editPrompt home = do
  str <- inputPrompt cfg "Edit: ~/"
  case str of
    Just s -> openEditor s
    Nothing -> pure ()
 where
  cfg = myXPromptConfig {defaultText = ""}

openEditor :: String -> X()
openEditor path =
  safeSpawn "emacsclient" ["-c","-a","emacs",path]

mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Below is a variation of the above except no borders are applied
-- if fewer than two windows. So a single window has no gaps.
mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

-- Defining a bunch of layouts, many that I don't use.
tall     = renamed [Replace "tall"]
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 8
           $ ResizableTall 1 (3/100) (1/2) []
magnify  = renamed [Replace "magnify"]
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ magnifier
           $ limitWindows 12
           $ mySpacing 58
           $ MosaicAlt M.empty
           -- $ Grid (16/10)
           -- $ ResizableTall 1 (3/100) (1/2) []
monocle  = renamed [Replace "monocle"]
           $ windowNavigation
                   $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 20 Full
floats   = renamed [Replace "floats"]
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 20 simplestFloat
grid     = renamed [Replace "grid"]
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 8
           $ mkToggle (single MIRROR)
           $ Grid (16/10)
spirals  = renamed [Replace "spirals"]
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ mySpacing' 8
           $ spiral (6/7)
threeCol = renamed [Replace "threeCol"]
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 7
           $ mySpacing' 4
           $ ThreeCol 1 (3/100) (1/2)
threeRow = renamed [Replace "threeRow"]
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 7
           $ mySpacing' 4
           -- Mirror takes a layout and rotates it by 90 degrees.
           -- So we are applying Mirror to the ThreeCol layout.
           $ Mirror
           $ ThreeCol 1 (3/100) (1/2)

wmiiL      =  renamed [Replace "wmiiL"]
              $ (wmii shrinkText def)
mosaicAlt = renamed [Replace "Mosaic Alt"]
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 28
           $ MosaicAlt M.empty
tabs     = renamed [Replace "tabs"]
           -- I cannot add spacing to this layout because it will
           -- add spacing between window and tabs which looks bad.
           $ tabbed shrinkText myTabTheme
roledex  = renamed [Replace "roledex"]
           $ Roledex
-- imagel =   renamed [Replace "imagel"]
--            $ imageButtonDeco shrinkText defaultThemeWithImageButtons (layoutHook def)
 {-
  hiddenWindow =   renamed [Replace "hiddenWindow"]
                  $ windowNavigation
                  $ addTabs shrinkText myTabTheme
                  $ subLayout [] (smartBorders Simplest)
                  $ limitWindows 12
                  $ mySpacing 8
                  $ hiddenWindows (Tall 1 (3/100) (1/2)) -}
accordion =   renamed [Replace "accordion"]
                  $ windowNavigation
                  $ addTabs shrinkText myTabTheme
                  $ subLayout [] (smartBorders Simplest)
                  $ limitWindows 12
                  $ mySpacing 8
                  $ Accordion
myTabTheme = def { fontName            =   "xft:Source Code Pro Semibold :size=10"
                 , activeColor         = "#46d9ff"
                 , inactiveColor       = "#313846"
                 , activeBorderColor   = "#46d9ff"
                 , inactiveBorderColor = "#282c34"
                 , activeTextColor     = "#282c34"
                 , inactiveTextColor   = "#d0d0d0"
                 }

-- The layout hook
myLayoutHook = avoidStruts $ mouseResize $ windowArrange $ T.toggleLayouts floats
               $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
             where
               -- I've commented out the layouts I don't use.
               myDefaultLayout = mosaicAlt
                                 ||| roledex
                                 ||| magnify
                                 ||| wmiiL
                                 ||| tall
                                 ||| accordion
                                 ||| noBorders monocle
                                 ||| floats
                                 ||| noBorders tabs
                                 ||| grid
                                 ||| spirals
                                 ||| threeCol
                                 ||| threeRow
                                 ||| tabs
                                   

layoutList = [("wmiiL", sendMessage $ JumpToLayout "wmiiL")
             , ("roledex", sendMessage $ JumpToLayout "roledex")
             , ("tall", sendMessage $ JumpToLayout "tall")
             , ("accordion", sendMessage $ JumpToLayout "accordion")
             , ("magnify", sendMessage $ JumpToLayout "magnify")
             , ("noMonocle", sendMessage $ JumpToLayout "noBorders monocle")
             , ("floats", sendMessage $ JumpToLayout "floats")

             , ("mosaicAlt", sendMessage $ JumpToLayout "Mosaic Alt")
             , ("tabs", sendMessage $ JumpToLayout "tabs")
             , ("noTabs", sendMessage $ JumpToLayout "noBorders tabs")
             , ("grid", sendMessage $ JumpToLayout "grid")
             , ("spirals", sendMessage $ JumpToLayout "spirals")
             , ("threeCol", sendMessage $ JumpToLayout "threeCol")
             , ("threeRow", sendMessage $ JumpToLayout "threeRow")
             ]

layoutAction =[("layoutList" , xmonadPromptC layoutList xShellXPConfig')
              , ("nextLayout", sendMessage NextLayout)    --("prevLayout", sendMessage PrevLayout)           -- Switch to next layout
              -- Switch to next layout
        , ("arrange", sendMessage Arrange)
        , ("deArrange", sendMessage DeArrange)
        , ("fullScreen", sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts) -- Toggles noborder/full
        , ("toggleStruts", sendMessage ToggleStruts)     -- Toggles struts
        , ("noBorders", sendMessage $ MT.Toggle NOBORDERS)  -- Toggles noborder
 -- Sublayouts
    -- This is used to push windows to tabbed sublayouts, or pull them out of it.
        , ("pullGroupL", sendMessage $ pullGroup L)
        , ("pullGroupR", sendMessage $ pullGroup R)
        , ("pullGroupU", sendMessage $ pullGroup U)
        , ("pullGroupD", sendMessage $ pullGroup D)
        , ("mergeAll", withFocused (sendMessage . MergeAll))
        , ("unMerge", withFocused (sendMessage . UnMerge))
        , ("unMergeAll", withFocused (sendMessage . UnMergeAll))
        , ("nextTab", onGroup W.focusUp')    -- Switch focus to next tab
        , ("prevTab", onGroup W.focusDown')  -- Switch focus to prev tab
        ]

myStartupHook :: X ()
myStartupHook = do
                    spawn "brightnessctl s 1"
                    spawn "xmodmap -e \"keycode 105 = KP_Enter \""
                    setWMName "LG3D"
                     
myManageHook :: ManageHook
myManageHook = composeOne
  [ className =? "Pidgin" -?> doFloat
  , className =? "XCalc"  -?> doFloat
  , className =? "mpv"    -?> doFloat
  , className =? "spotify" -?> doFloat
  , isDialog              -?> doCenterFloat

    -- Move transient windows to their parent:
  , transience
  ] <+> namedScratchpadManageHook myScratchPads
--   <+> namedScratchpadManageHook myScratchPads'

--spotList = [("[prev",audioPrev)
--	   ,("pausePlay",audioPlayPause)
--	   ,("]next",audioNext)]

playerctlList :: [(String , X())]
playerctlList = [("[prev", spawn "playerctl previous")
               ,("]next", spawn "playerctl next")
	       ,("pauseplay", spawn "playerctl play-pause")]

quitList = [
       ("anDelete" , kill)
      , ("workspace" , {- addName "Kill WorkSpace" $ -} removeWorkspace )
      , ("supressAll" , {-addName "Kill One Window" $ -} killAll)
           ]

exitList =  [
  ("shutdown", confirmPrompt xShellXPConfig' "shutdown" $ spawn "poweroff")
      , ("reboot", confirmPrompt xShellXPConfig' "restart" $ spawn "reboot")
      , ("logout",confirmPrompt xShellXPConfig' "exit" $ io $ exitWith ExitSuccess)
      ]

inputList = [
                ("kitty",prompt ("kitty" ++ " -e") xShellXPConfig )
            ,("firefox",safePrompt "firefox" xShellXPConfig )
            ]

myKeys' :: [(String , X())]
myKeys' = [

       ("activeWindows",  windowPrompt xShellXPConfig Goto allWindows)
      , ("configuration",xmonadPromptC settings xShellXPConfig' )
      -- , ("doomEmacs",editPrompt "/home/vamshi/")
      , ("exit" , xmonadPromptC exitList xShellXPConfig')
      -- , ("exit" , runSelectedAction defaultGSConfig {gs_cellheight = 160,  gs_navigate = myNavigation,gs_cellwidth = 310,gs_font = "xft:SF Pro Text :size=19"}  exitList)
      -- , ("firefox" ,  namedScratchpadAction myScratchPads "fire1")
      , ("fullScreen", sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts) -- Toggles noborder/full
      , ("gotoProject" , switchProjectPrompt  xShellXPConfig')
      , ("input", xmonadPromptC inputList xShellXPConfig')
      , ("kitty" ,  namedScratchpadAction myScratchPads "kitty")-- ("trivial" , spawn "")
      , ("layouts" , xmonadPromptC layoutAction  xShellXPConfig')
      --, ("hide taffybar" ,  sendMessage ToggleStruts)
      --, ("",xmonadPromptC spotList ultimateXPConfig )
      , ("music" ,  namedScratchpadAction myScratchPads "spotify")
      --, ("brave" ,  namedScratchpadAction myScratchPads "brave")
      --, ("oCust", xmonadPromptC custList ultimateXPConfig)
     -- , ("jList", xmonadPromptC webList ultimateXPConfig)
      , ("play", xmonadPromptC playerctlList ultimateXPConfig)
           , ("C-t t", treeselectAction tsDefaultConfig)
--      , ("ug2" ,  namedScratchpadAction myScratchPads "syllabus")
    --  , ("kill all windows",  killAll)
      --, ( "vhelp" , treeselectAction tsDefaultConfig)
      --, ("myShell",  spawn "emacsclient -c -a '' --eval '(eshell)'")
      --, ("terminal", {-addName "Konsole" $ -} spawn myTerminal )
     -- , ("next-ws",{- addName "next ws" $ -} nextWS)
      --, ("prev-ws", {- addName "prev ws" $ -} prevWS)
 --     , ("M-2", addName "capture screen" $ spawn "scrot")
 --     ,  ("exrestart" ,spawn "xmonad --recompile ; xmonad --restart")
  --    ,  ("xmonadPrompt", xmonadPromptC xmonadEdit ultima2XPConfig)
      , ("quit" , xmonadPromptC quitList xShellXPConfig')
      , ("runOrRaise" , runOrRaisePrompt xShellXPConfig)
      , ("search" , xmonadPromptC searchPrompts xShellXPConfig')
      , ("throwToProject" , shiftToProjectPrompt  xShellXPConfig')
      , ("utilities" , xmonadPromptC  scratchList penUltiXPConfig)
        , ("window", xmonadPromptC windowList xShellXPConfig')
        , ("onWhatsapp",S.selectSearch whatsapp)
      -- , ("xmonadConfig" , spawn "emacs /etc/nixos/dotfiles/xmonad/README.org")
      , ("Tutorial" ,  S.selectSearchBrowser "/run/current-system/sw/bin/brave" tutorial)
      {-, ("aMenu",windowMenu) -}
      --, ("h", mass)
       , ("xshell" , shellPrompt  xShellXPConfig)
     ]
redshift  = [
            ("dark",spawn "systemctl --user restart redshift.service")
            , ("bright",spawn "systemctl --user stop redshift.service")
            ]
settings = [("dark",spawn "systemctl --user restart redshift.service")
            , ("bright",spawn "systemctl --user stop redshift.service")
            , ("sound", spawn "kitty -e pulsemixer")
            , ("light" ,  namedScratchpadAction myScratchPads "light")
            ]

searchPrompts = [("books"    ,  S.promptSearch   xShellXPConfig books)
      		, ("playStore" , S.promptSearch   xShellXPConfig nixos )
      		, ("just" , S.promptSearch   xShellXPConfig vanila )
      		, ("server" , S.promptSearchBrowser  xShellXPConfig "/run/current-system/sw/bin/brave" php )
      		, ("google" , S.promptSearch   xShellXPConfig aiGoogle )
      		, ("youtube" , S.promptSearch  xShellXPConfig  S.youtube)]
      		-- , ("youtube" , S.promptSearchBrowser ultima10XPConfig "/run/current-system/sw/bin/brave" S.youtube )]

myScratchPads :: [NamedScratchpad]
myScratchPads = [
                  NS "kitty"  "kitty" (className =? "kitty")  (customFloating $ W.RationalRect (0.08) (0.08) (0.85) (0.84))
                , NS "htop"  "kitty -e htop" (className =? "kitty")  (customFloating $ W.RationalRect (0.08) (0.07) (0.85) (0.84))
                , NS "bluetooth"  "kitty -e bluetoothctl" (className =? "kitty")  (customFloating $ W.RationalRect (0.08) (0.07) (0.85) (0.84))
                , NS "pulsemixer"  "kitty -e pulsemixer" (className =? "kitty")  (customFloating $ W.RationalRect (0.08) (0.07) (0.85) (0.84))
                , NS "light"  "kitty -e sudo nvim /sys/class/backlight/intel_backlight/brightness" (className =? "kitty")  (customFloating $ W.RationalRect (0.08) (0.07) (0.85) (0.84))
                -- , NS "fire1"  myBrowser1 (className =? "Firefox")  (customFloating $ W.RationalRect (0.0001) (0.04) (0.9991) (0.9999))
                -- , NS "fire2"  myBrowser1 (className =? "Firefox")  (customFloating $ W.RationalRect (0) (0) (1) (1))
                , NS "spotify"  "spotify" (className =? "Spotify") (customFloating $ W.RationalRect (0) (0) (1) (1))
                , NS "brave"  "brave" (className =? "brave") (customFloating $ W.RationalRect (0) (0) (1) (1))
                , NS "emacs"  "emacs" (title =? "emacs-scratch") (customFloating $ W.RationalRect (0) (0) (1) (1))
                , NS "syllabus"  "okular ~/books/syllabus.pdf" (className =? "Okular") defaultFloating ]

scratchList = [--("htop" ,  namedScratchpadAction myScratchPads "htop")
	       ("htop",spawn "kitty -e htop")
               , ("haskell", spawn "kitty -e ghci")
               , ("python", spawn "kitty -e python")
               , ("clojure", spawn "cd ~/maps/clojure/dawn/src ; kitty -e lein repl")
               , ("bluetooth", spawn "kitty -e bluetoothctl")
               -- , ("bluetooth" ,  namedScratchpadAction myScratchPads "bluetooth")
               -- , ("pulsemixer" ,  namedScratchpadAction myScratchPads "pulsemixer")
               ]

-- myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font              = "xft:AppleGaramond:bold:size=120"
    --  swn_font              ="xft:Lucida MAC:size=120"
    , swn_fade              = 1.0
    , swn_bgcolor           = "#0F0F0F"
    , swn_color             = "#d8c1e3"
    }

-- | The \"Current Layout\" custom hint.
xLayoutProp :: X Atom
xLayoutProp = getAtom "_XMONAD_CURRENT_LAYOUT"

-- | The \"Visible Workspaces\" custom hint.
xVisibleProp :: X Atom
xVisibleProp = getAtom "_XMONAD_VISIBLE_WORKSPACES"

-- | Add support for the \"Current Layout\" and \"Visible Workspaces\" custom
-- hints to the given config.
pagerHints :: XConfig a -> XConfig a
pagerHints c =
  c { handleEventHook = handleEventHook c +++ pagerHintsEventHook
    , logHook = logHook c +++ pagerHintsLogHook
    }
  where x +++ y = x `mappend` y

-- | Update the current values of both custom hints.
pagerHintsLogHook :: X ()
pagerHintsLogHook = do
  withWindowSet
    (setCurrentLayout . description . W.layout . W.workspace . W.current)
  withWindowSet
    (setVisibleWorkspaces . map (W.tag . W.workspace) . W.visible)

-- | Set the value of the \"Current Layout\" custom hint to the one given.
setCurrentLayout :: String -> X ()
setCurrentLayout l = withDisplay $ \dpy -> do
  r <- asks theRoot
  a <- xLayoutProp
  c <- getAtom "UTF8_STRING"
  let l' = map fromIntegral (encode l)
  io $ changeProperty8 dpy r a c propModeReplace l'

-- | Set the value of the \"Visible Workspaces\" hint to the one given.
setVisibleWorkspaces :: [String] -> X ()
setVisibleWorkspaces vis = withDisplay $ \dpy -> do
  r  <- asks theRoot
  a  <- xVisibleProp
  c  <- getAtom "UTF8_STRING"
  let vis' = map fromIntegral $ concatMap ((++[0]) . encode) vis
  io $ changeProperty8 dpy r a c propModeReplace vis'

-- | Handle all \"Current Layout\" events received from pager widgets, and
-- set the current layout accordingly.
pagerHintsEventHook :: Event -> X All
pagerHintsEventHook ClientMessageEvent
                      { ev_message_type = mt
                      , ev_data = d
                      } = withWindowSet $ \_ -> do
  a <- xLayoutProp
  when (mt == a) $ sendLayoutMessage d
  return (All True)
pagerHintsEventHook _ = return (All True)

-- | Request a change in the current layout by sending an internal message
-- to XMonad.
sendLayoutMessage :: [CInt] -> X ()
sendLayoutMessage evData = case evData of
  []   -> return ()
  x:_  -> if x < 0
            then sendMessage FirstLayout
            else sendMessage NextLayout
