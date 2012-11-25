{-# LANGUAGE OverloadedStrings #-}

module Web.View.HomePage
(render)
where



import Text.Blaze.Html4.Strict
import Text.Blaze.Html4.Strict.Attributes 
import qualified Text.Blaze.Html4.Strict as H
import qualified Text.Blaze.Html4.Strict.Attributes as A
import Text.Blaze.Html.Renderer.Utf8
import Data.ByteString
import Data.ByteString.Lazy.UTF8
import Data.Monoid 

render user =  renderHtmlBuilder $ docTypeHtml $ do 
  H.head $ do
    H.title "Haskell Cake Store Home Page"
  body $ do    
    p (mappend "Hi" $ toHtml user)

