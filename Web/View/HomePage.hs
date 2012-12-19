{-# LANGUAGE OverloadedStrings #-}

module Web.View.HomePage
(render)
where



import qualified Text.Blaze.Html4.Strict as H
import Text.Blaze.Html.Renderer.Utf8
import Data.Monoid 
import qualified Blaze.ByteString.Builder

render :: H.ToMarkup a => a -> Blaze.ByteString.Builder.Builder
render user =  renderHtmlBuilder $ H.docTypeHtml $ do 
  H.head $ do
    H.title "Haskell Cake Store Home Page"
  H.body $ do    
    H.p (mappend "Hi" $ H.toHtml user)

