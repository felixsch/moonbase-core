module Moonbase.Theme
  ( Theme(..)
  , defaultTheme
  , Color
  , FontAttribute(..)
  , Font(..)
  , bold
  , italic
  , underline
  , size
  , defaultSans
  , defaultMonospace
  , black, white, red, lime, blue
  , yellow, cyan, magenta, silver
  , gray, maroon, olive, green
  , purple, teal, navy
  ) where


import {-# SOURCE #-} Moonbase

-- | Color defined as html heximal color string (eg. "#fafa21")
type Color = String

-- | Font attributes
data FontAttribute = Bold      -- ^ Draw the font bold
                   | Thin      -- ^ Draw the font thiner as normal
                   | Normal    -- ^ Reset all attributes
                   | Italic    -- ^ Draw font italic
                   | Underline -- ^ Underline font

-- | Font settings 
data Font = Font
  { fontName :: String          -- ^ Name of the font (Name __must__ match the font-config name)
  , fontSize :: Int             -- ^ Size of the font
  , fontAttr :: [FontAttribute] -- ^ Attributes like bold, italic
  }

-- | make a font bold
bold :: Font -> Font
bold font = font { fontAttr = Bold : (fontAttr font) }

-- | make a font italic
italic :: Font -> Font
italic font = font { fontAttr = Italic : (fontAttr font) }

-- | underline a font
underline :: Font -> Font
underline font = font { fontAttr = Underline : (fontAttr font) }

-- | change the size
size :: Int -> Font -> Font
size s font = font { fontSize = s }


-- | Moonbase theme definition
data Theme = Theme
  { bg        :: Color             -- ^ Background color
  , normal    :: Font              -- ^ Normal font
  , normalC   :: Color             -- ^ Normal font color
  , hl        :: Font              -- ^ Highlight font
  , hlC1      :: Color             -- ^ First Highlight color
  , hlA1      :: [FontAttribute]   -- ^ First Highlight attributes
  , hlC2      :: Color             -- ^ Second Highlight color
  , hlA2      :: [FontAttribute]   -- ^ Second hightlight attributes
  , disabledC :: Color             -- ^ Color of disabled items
  , disabledA :: [FontAttribute]   -- ^ Attributes of disabled items
  }


-- | Default Sans font definition
defaultSans :: Font
defaultSans = Font "Sans" 12 []

-- | Default Monospace font definition
defaultMonospace :: Font
defaultMonospace = Font "Monospace" 12 []

-- | Moonbase default theme
defaultTheme :: Theme
defaultTheme = Theme
  { bg        = black
  , normal    = defaultSans
  , normalC   = white
  , hl        = defaultSans
  , hlC1      = lime
  , hlA1      = [Bold]
  , hlC2      = magenta
  , hlA2      = []
  , disabledC = gray
  , disabledA = [Italic] }


-- | Basic 8-bit colors
black, white, red, lime , blue, yellow, cyan, magenta, silver, gray, maroon, olive, green, purple, teal, navy :: Color
black 	= "#000000"
white 	= "#FFFFFF"
red 	= "#FF0000"
lime 	= "#00FF00"
blue 	= "#0000FF"
yellow 	= "#FFFF00"
cyan    = "#00FFFF"
magenta = "#FF00FF"
silver 	= "#C0C0C0"
gray 	= "#808080"
maroon 	= "#800000"
olive 	= "#808000"
green 	= "#008000"
purple 	= "#800080"
teal 	= "#008080"
navy 	= "#000080"


