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

    -- Hooks
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

  -- Layouts
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.MosaicAlt
--import XMonad.Layout.Hidden
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.Minimize
import qualified XMonad.Layout.BoringWindows as BW
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Accordion
import XMonad.Layout.LayoutCombinators

    -- Layouts modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
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

    -- Actions
import XMonad.Actions.Navigation2D
import XMonad.Actions.DynamicProjects
import qualified XMonad.Actions.Search as S
import XMonad.Actions.WithAll
import XMonad.Actions.SimpleDate
import XMonad.Actions.TagWindows
import XMonad.Actions.WindowBringer
import XMonad.Actions.CycleWS
import XMonad.Actions.CycleWindows
--import XMonad.Actions.WindowMenu
--import qualified XMonad.Actions.Plane as Plane
import XMonad.Actions.CopyWindow
import XMonad.Actions.Minimize
import XMonad.Actions.GroupNavigation
import XMonad.Actions.MouseResize
import XMonad.Actions.DynamicWorkspaces
--import XMonad.Actions.Commands (defaultCommands)
import qualified XMonad.Actions.TreeSelect as TS
import XMonad.Actions.GridSelect

    -- Util
import XMonad.Util.EZConfig  (additionalKeysP,mkNamedKeymap)
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.XUtils (fi)
import XMonad.Util.SpawnOnce
import XMonad.Util.NamedScratchpad
import XMonad.Util.NamedWindows --(getName)
import XMonad.Util.Scratchpad

    -- Prompt
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.Input
import XMonad.Prompt.ConfirmPrompt
import XMonad.Prompt.XMonad
import XMonad.Prompt.FuzzyMatch
import XMonad.Prompt.Window
import XMonad.Prompt.RunOrRaise

import XMonad.Util.Spotify

import XMonad.ManageHook
-- For PagerHints
import Codec.Binary.UTF8.String (encode)
import Control.Monad
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
myBorderWidth = 2          -- Sets border width for windows

altMask = mod1Mask

myNormalBorderColor ::  String
myNormalBorderColor   = "#292d3e"  -- Border color of normal windows

myFocusedBorderColor  :: String   -- Border color of focused windo
myFocusedBorderColor  = "#bbc5ff"  -- Border color of focused windows

main :: IO()
main = do

  --setRandomWallpaper [ "$HOME/Pictures/wallpapers"]
  xmonad $  dynamicProjects projects
         $  withNavigation2DConfig def
         $  additionalNav2DKeys (xK_Up, xK_Left, xK_Down, xK_Right)
                                    [(mod4Mask,               windowGo  ),
                                     (mod4Mask .|. shiftMask, windowSwap)]
                                    False
         $ ewmh
         $ pagerHints
         $ myConfig
myConfig  = def
    			{ modMask     = myModMask -- Use the "Win" key for the mod key
    			, layoutHook         =  minimize . BW.boringWindows $ showWName' myShowWNameTheme myLayoutHook
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
              --, keys               = myKeys''
    			       	}  `additionalKeysP` myKeys

myWorkspaces :: [String]
myWorkspaces = ["hi!!"]

projects :: [Project]
projects = [
    Project { projectName      = "browser"
            , projectDirectory = "~/Download"
            , projectStartHook = Just $ do  spawn "brave"
            }
       , Project { projectName      = "wsudo"
            , projectDirectory = "~/"
            , projectStartHook = Just $ do  spawn "sudo emacs"
            }
   , Project { projectName      = "editor"
            , projectDirectory = "~/"
            , projectStartHook = Just $ do  spawn "emacs"
            }
   , Project { projectName      = "sicp"
            , projectDirectory = "~/books"
            , projectStartHook = Just $ do  spawn "okular sicp.pdf"
            }
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
       ,  ("S-<Tab>" ,  xmonadPromptC myKeys' ultimateXPConfig ) -- $ aynRandXPConfig $ unsafePerformIO (getStdRandom (randomR (1, 3))))
       ,  ("S-<Space>" ,  xmonadPromptC myKeys' ultimateXPConfig )-- $ aynRandXPConfig $ unsafePerformIO (getStdRandom (randomR (1, 4))))
       ,  ("M-<Space>" ,  xmonadPromptC myKeys' ultimateXPConfig )-- $ aynRandXPConfig $ unsafePerformIO (getStdRandom (randomR (1, 5))))
       ,  ("M1-<Space>" ,  xmonadPromptC myKeys'  ultimateXPConfig)-- ultimateXPConfig )-- $ aynRandXPConfig $ unsafePerformIO (getStdRandom (randomR (1, 5))))
       --  , ("M1-<Return>",  spawn myTerminal )
       --  , ("M-<Tab>" ,  spawnSelected' myList)
       , ("M-2",  spawn "scrot")
       , ("M-<Tab>" , mass)--windowMenu)
       , ("M1-<Tab>",   moveTo Prev NonEmptyWS )
       , ("M1-q",   moveTo Next NonEmptyWS )
     --  , ("M1-<Tab>",nextMatch Backward (return True))
     --  , ("S-[",      prevWS )
     --  , ("S-]",      nextWS )
       , ("M1-[",   moveTo Prev NonEmptyWS )
       , ("M1-]",   moveTo Next NonEmptyWS )
       , ("M-q",     prevWS )
       , ("M-[",     prevWS )
       , ("M-w",     nextWS )
       , ("M-]",     nextWS )
       , ("S-<Backspace>" ,  kill )
       , ("M1-<Backspace>" , removeWorkspace )
       , ("M-<Backspace>" ,  killAll )
       , ("M1-<Return>" ,  namedScratchpadAction myScratchPads "kitty")
       -- , ("M-<Return>" ,  namedScratchpadAction myScratchPads "firefox")
     ]

tsDefaultConfig :: TS.TSConfig a
tsDefaultConfig = TS.TSConfig { TS.ts_hidechildren = True
                              , TS.ts_background   = 0xdd292d3e
                              , TS.ts_font         = myFont1
                              , TS.ts_node         = (0xffd0d0d0, 0xff202331)
                              , TS.ts_nodealt      = (0xffd0d0d0, 0xff292d3e)
                              , TS.ts_highlight    = (0xffffffff, 0xff755999)
                              , TS.ts_extra        = 0xffd0d0d0
                              , TS.ts_node_width   = 360
                              , TS.ts_node_height  = 40
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
    , ((0, xK_Left),     TS.moveParent)
    , ((0, xK_Right),    TS.moveChild)
    , ((0, xK_k),        TS.movePrev)
    , ((0, xK_j),        TS.moveNext)
    , ((0, xK_h),        TS.moveParent)
    , ((0, xK_l),        TS.moveChild)
    , ((0, xK_o),        TS.moveHistBack)
    , ((0, xK_i),        TS.moveHistForward)
   ]


treeselectAction :: TS.TSConfig (X ()) -> X ()
treeselectAction a = TS.treeselectAction a
  [
   Node (TS.TSNode " + Scratchpads" "" (return ()))
   [  Node (TS.TSNode "kitty" "Drop down terminal" (spawn "kitty")) []
  , Node (TS.TSNode "firefox" "Drop down browser"   (  namedScratchpadAction myScratchPads "firefox"))[]
   , Node (TS.TSNode "music" "Drop down spotify"   (  namedScratchpadAction myScratchPads "spotify"))[]
    ]
   , Node (TS.TSNode " + Exit" "" (return ()))
   [  Node (TS.TSNode "kitty" "Drop down terminal" (spawn "kitty")) []
  , Node (TS.TSNode "firefox" "Drop down browser"   (  namedScratchpadAction myScratchPads "firefox"))[]
   , Node (TS.TSNode "music" "Drop down spotify"   (  namedScratchpadAction myScratchPads "spotify"))[]
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

myColorizer :: Window -> Bool -> X (String, String)
myColorizer = colorRangeFromClassName
                  (0x28,0x2c,0x34) -- lowest inactive bg
                  (0x28,0x2c,0x34) -- highest inactive bg
                  (0xc7,0x92,0xea) -- active bg
                  (0xc0,0xa7,0x9a) -- inactive fg
                  (0x28,0x2c,0x34) -- active fg

colorizer :: a -> Bool -> X (String, String)
colorizer _ isFg = do
    fBC <- asks (focusedBorderColor . config)
    nBC <- asks (normalBorderColor . config)
    return $ if isFg
                then (fBC, nBC)
                else (nBC, fBC)

windowMenu :: X ()
windowMenu = withFocused $ \w -> do
    tags <- asks (workspaces . config)
    Rectangle x y wh ht <- getSize w
    Rectangle sx sy swh sht <- gets $ screenRect . W.screenDetail . W.current . windowset
    let originFractX = (fi x - fi sx + fi wh / 2) / fi swh
        originFractY = (fi y - fi sy + fi ht / 2) / fi sht
        gsConfig = (buildDefaultGSConfig colorizer)
                    { gs_originFractX = originFractX
                    , gs_originFractY = originFractY }
        actions = [ ("rotUnfocusedUp" , rotUnfocusedUp)
                  , ("Cancel menu", return ())
                  , ("Close"      , kill)
  --                , ("Maximize"   , sendMessage $ maximizeRestore w)
                  , ("Minimize"   , minimizeWindow w)
                  ] ++
                  [ ("Move to " ++ tag, windows $ W.shift tag)
                    | tag <- tags ]
    runSelectedAction gsConfig actions

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
mygridConfig :: p -> GSConfig Window
mygridConfig colorizer = (buildDefaultGSConfig myColorizer)
    { gs_cellheight   = 40
    , gs_cellwidth    = 200
    , gs_cellpadding  = 6
    , gs_originFractX = 0.5
    , gs_originFractY = 0.5
    , gs_font         = myFont
    }
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
windowList = [("AddTag", tagPrompt ultimateXPConfig (\s -> withFocused (addTag s)))
             , ("DeleteTag", tagDelPrompt ultimateXPConfig)
             , ("KillWin", tagPrompt ultimateXPConfig (\s -> withTaggedGlobal s killWindow))
             , ("MinimizeWin", tagPrompt ultimateXPConfig (\s -> withTaggedGlobal s minimizeWindow))
             , ("MaximizeWin", tagPrompt ultimateXPConfig (\s -> withTaggedGlobal s maximizeWindowAndFocus))
   --   , ("w2", tagPrompt ultimateXPConfig (\s -> withTaggedP s (W.shiftWin "2")))
             , ("ShiftHere", tagPrompt ultimateXPConfig (\s -> withTaggedGlobalP s shiftHere))
             , ("Goto", tagPrompt ultimateXPConfig (\s -> focusUpTaggedGlobal s))
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
aiGoogle = S.intelligent S.google
mty      = S.searchEngine "empty" "https://gitlab.com/vladimirLenin"
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
  , alwaysHighlight   = True
  , promptBorderWidth = 1
  , font              = "xft:LucidaGrande:size=26"
  , height            = 80
  , searchPredicate   = fuzzyMatch
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
                              ,  position =  CenteredAt {xpCenterY = 0.19 , xpWidth = 0.88}
                               ,  font = "xft:FiraSans:size=22"
                       }
ultima10XPConfig = ultimateXPConfig {
                                      autoComplete      = Nothing    -- set Just 100000 for .1 sec
  				, position = Top                             
                               ,  font = "xft:FiraSans:size=25"
                                    }
penUltiXPConfig = ultima10XPConfig {
                                       autoComplete = Just 100000 
                                   }
layoutXPConfig = ultimateXPConfig {
                                       position =  CenteredAt {xpCenterY = 0.34 , xpWidth = 0.88}
                                     ,  font = "xft:LucidaGrande:size=26"
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
{-myLayouts = avoidStruts $ toggleLayouts (noBorders Full) others
  where
    others = ResizableTall 1 (3/100) (1/2) [] ||| emptyBSP
-}
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
           $ mySpacing 8
           $ ResizableTall 1 (3/100) (1/2) []
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
mosaicAlt = renamed [Replace "Mosaic Alt"]
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 8
           $ MosaicAlt M.empty
tabs     = renamed [Replace "tabs"]
           -- I cannot add spacing to this layout because it will
           -- add spacing between window and tabs which looks bad.
           $ tabbed shrinkText myTabTheme
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
myTabTheme = def { fontName            = myFont
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
                                 ||| tall
                                 ||| accordion
                                 ||| magnify
                                 ||| noBorders monocle
                                 ||| floats
                                 ||| noBorders tabs
                                 ||| grid
                                 ||| spirals
                                 ||| threeCol
                                 ||| threeRow

-- Layouts

layoutList = [("tall", sendMessage $ JumpToLayout "tall")
             , ("accordion", sendMessage $ JumpToLayout "accordion")
             , ("magnify", sendMessage $ JumpToLayout "magnify")
             , ("noMonocle", sendMessage $ JumpToLayout "noBorders monocle")
             , ("floats", sendMessage $ JumpToLayout "floats")

             , ("mosaicAlt", sendMessage $ JumpToLayout "Mosaic Alt")
             , ("noTabs", sendMessage $ JumpToLayout "noBorders tabs")
             , ("grid", sendMessage $ JumpToLayout "grid")
             , ("spirals", sendMessage $ JumpToLayout "spirals")
             , ("threeCol", sendMessage $ JumpToLayout "threeCol")
             , ("threeRow", sendMessage $ JumpToLayout "threeRow")
             ]

layoutAction =[   ("nextLayout", sendMessage NextLayout)    --("prevLayout", sendMessage PrevLayout)           -- Switch to next layout
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

spotList = [("prev",audioPrev)
	   ,("pausePlay",audioPlayPause)
	   ,("next",audioNext)] 


playerctlList :: [(String , X())]
playerctlList = [("prev", spawn "playerctl previous")
               ,("next", spawn "playerctl next")
	       ,("pauseplay", spawn "playerctl play-pause")]

myKeys' :: [(String , X())]
myKeys' = [  ("kitty" ,  namedScratchpadAction myScratchPads "kitty")-- ("trivial" , spawn "")
      -- , ("toggleFullScreen", sendMessage (Toggle "Full"))
      --, ("hide taffybar" ,  sendMessage ToggleStruts)
      -- , ("firefox" ,  namedScratchpadAction myScratchPads "firefox")
      , ("pSpotify",xmonadPromptC spotList ultimateXPConfig )
      , ("music" ,  namedScratchpadAction myScratchPads "spotify")
      --, ("brave" ,  namedScratchpadAction myScratchPads "brave")
      , ("qdeleteAll" , killAll)
      , ("oCust", xmonadPromptC custList ultimateXPConfig)
      , ("jList", xmonadPromptC webList ultimateXPConfig)
      , ("iPlayerCtl", xmonadPromptC playerctlList ultimateXPConfig)
      -- , ("zmacs" ,  namedScratchpadAction myScratchPads "emacs")
 --     , ("hide"  , withFocused hideWindow)
  --    , ("oldunhide", popOldestHiddenWindow)
  --    , ("newunhide", popNewestHiddenWindow)
      , ("1minimize" , withFocused minimizeWindow)
      , (";minimize" , withFocused minimizeWindow)
     -- , ("imaximize", withLastMinimized maximizeWindowAndFocus)
 --     , ("jmacs" , xmonadPromptC emacsList ultimateXPConfig)
--      , ("ug2" ,  namedScratchpadAction myScratchPads "syllabus")
      , ("delete" , {-addName "Kill One Window" $ -} kill)
      , ("qworkspace" , {- addName "Kill WorkSpace" $ -} removeWorkspace )
      , ("vindows", windowPrompt ultimateXPConfig Goto allWindows)
    --  , ("kill all windows",  killAll)
      --, ( "vhelp" , treeselectAction tsDefaultConfig)
      --, ("myShell",  spawn "emacsclient -c -a '' --eval '(eshell)'")
      --, ("terminal", {-addName "Konsole" $ -} spawn myTerminal )
     -- , ("next-ws",{- addName "next ws" $ -} nextWS)
      --, ("prev-ws", {- addName "prev ws" $ -} prevWS)
 --     , ("M-2", addName "capture screen" $ spawn "scrot")
      , ("eshutdown", confirmPrompt ultima10XPConfig "shutdown" $ spawn "poweroff")
      , ("ereboot", confirmPrompt ultima10XPConfig "restart" $ spawn "reboot")
      , ("elogout",confirmPrompt ultima10XPConfig "exit" $ io $ exitWith ExitSuccess)
 --     ,  ("exrestart" ,spawn "xmonad --recompile ; xmonad --restart")
  --    ,  ("xmonadPrompt", xmonadPromptC xmonadEdit ultima2XPConfig)
      , ("cratchPrompt" , xmonadPromptC  scratchList penUltiXPConfig)
      , ("bshellPrompt" , shellPrompt  ultima10XPConfig)
      , ("laction" , xmonadPromptC layoutAction  penUltiXPConfig)
      , ("aSearch" , xmonadPromptC searchPrompts penUltiXPConfig)
      , ("llist" , xmonadPromptC layoutList penUltiXPConfig)
      , ("runOrRaisePrompt" , runOrRaisePrompt ultima10XPConfig)
      , ("switchtPrompt" , switchProjectPrompt  penUltiXPConfig)
 --     , ("windowPrompt", windowPrompt myXPConfig'  Delete allWindows)
      , ("throwWindowPrompt" , shiftToProjectPrompt  penUltiXPConfig)
      -- , ("xmonadConfig" , spawn "emacs /etc/nixos/dotfiles/xmonad/README.org")
      , ("Tutorial" ,  S.selectSearchBrowser "/run/current-system/sw/bin/brave" tutorial)
 --    , ( "_f",  withFocused (addTag  $ return map fst . M.toList $ allWindows ))--show W.currentTag )) --withFocused)) --(show  ( length . W.integrate' . W.stack . W.workspace . W.current . windowset <$> get))))
     -- , ("window", gotoMenu')
 --     , ("oRotMenu",mass )
 {-      , ("1",withFocused (delTag "abc"))
      , ("2", withTaggedGlobalP "abc" W.sink)
      , ("3", withTaggedP "abc" (W.shiftWin "2"))
      , ("4", withTaggedGlobalP "abc" shiftHere)
      , ("5", focusUpTaggedGlobal "abc")
       , ("ro", rotOpposite)
      , ("rafp", rotUnfocusedUp)
      , ("rufd", rotUnfocusedDown)
      , ("rfu", rotFocusedUp)
      , ("rdf", rotFocusedDown)
      , ("aMenu",windowMenu) -}
      , ("h", mass)
      , ("waddTag", tagPrompt ultimateXPConfig (\s -> withFocused (addTag s)))
      , ("wdelete", tagDelPrompt ultimateXPConfig)
      , ("wkill", tagPrompt ultimateXPConfig (\s -> withTaggedGlobal s killWindow))
      , ("w;minimize", tagPrompt ultimateXPConfig (\s -> withTaggedGlobal s minimizeWindow))
      , ("wmaximize", tagPrompt ultimateXPConfig (\s -> withTaggedGlobal s maximizeWindowAndFocus))
   --   , ("w2", tagPrompt ultimateXPConfig (\s -> withTaggedP s (W.shiftWin "2")))
      , ("wshiftHere", tagPrompt ultimateXPConfig (\s -> withTaggedGlobalP s shiftHere))
      , ("wgoto", tagPrompt ultimateXPConfig (\s -> focusUpTaggedGlobal s))
     ]

custList = [("php",spawn "kitty -e php -S localhost:4000")
	   ,("htop",spawn "kitty -e htop")]

searchPrompts = [("books"    ,  S.promptSearch  ultima10XPConfig books)
      		, ("playStore" , S.promptSearch  ultima10XPConfig nixos )
      		, ("just" , S.promptSearch  ultima10XPConfig vanila )
      		, ("server" , S.promptSearchBrowser ultima10XPConfig "/run/current-system/sw/bin/brave" php )
      		, ("google" , S.promptSearch  ultima10XPConfig aiGoogle )
      		, ("youtube" , S.promptSearchBrowser ultima10XPConfig "/run/current-system/sw/bin/brave" S.youtube )]


myScratchPads :: [NamedScratchpad]
myScratchPads = [
                  NS "kitty"  "kitty" (className =? "kitty")  (customFloating $ W.RationalRect (0.08) (0.07) (0.85) (0.84))
                , NS "htop"  "kitty -e htop" (className =? "kitty")  (customFloating $ W.RationalRect (0.08) (0.07) (0.85) (0.84))
                , NS "bluetooth"  "kitty -e bluetoothctl" (className =? "kitty")  (customFloating $ W.RationalRect (0.08) (0.07) (0.85) (0.84))
                , NS "pulsemixer"  "kitty -e pulsemixer" (className =? "kitty")  (customFloating $ W.RationalRect (0.08) (0.07) (0.85) (0.84))
                , NS "light"  "kitty -e sudo nvim /sys/class/backlight/intel_backlight/brightness" (className =? "kitty")  (customFloating $ W.RationalRect (0.08) (0.07) (0.85) (0.84))
                -- , NS myBrowser1  myBrowser1 (className =? "Firefox")  (customFloating $ W.RationalRect (0.02) (0.03) (0.95) (0.93))
                , NS "spotify"  "spotify" (className =? "Spotify") (customFloating $ W.RationalRect (0) (0) (1) (1))
                , NS "brave"  "brave" (className =? "brave") (customFloating $ W.RationalRect (0) (0) (1) (1))
                , NS "emacs"  "emacs" (title =? "emacs-scratch") (customFloating $ W.RationalRect (0) (0) (1) (1))
                , NS "syllabus"  "okular ~/books/syllabus.pdf" (className =? "Okular") defaultFloating ]

scratchList = [("htop" ,  namedScratchpadAction myScratchPads "htop")
               , ("light" ,  namedScratchpadAction myScratchPads "light")
	       ,("htop",spawn "kitty -e htop")
               , ("haskell", spawn "kitty -e ghci")
               , ("python", spawn "kitty -e python")
               , ("clojure", spawn "cd ~/maps/clojure/dawn/src ; kitty -e lein repl")
               
               -- , ("bluetooth" ,  namedScratchpadAction myScratchPads "bluetooth")
               , ("bluetooth", spawn "kitty -e bluetoothctl")
               , ("sound", spawn "kitty -e pulsemixer")
               -- , ("pulsemixer" ,  namedScratchpadAction myScratchPads "pulsemixer")
               ]

-- myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font              = "xft:AppleGaramond:bold:size=140"
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
