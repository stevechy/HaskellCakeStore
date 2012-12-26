{-# LANGUAGE OverloadedStrings #-}

module Web.View.Cake
(render)
where



import qualified Text.Blaze.Html4.Strict as H
import Text.Blaze.Html.Renderer.Utf8
import Data.Monoid 
import qualified Blaze.ByteString.Builder
import Control.Monad
import qualified Model.Cake

render ::  [Model.Cake.Cake] -> Blaze.ByteString.Builder.Builder
render cakeList =  renderHtmlBuilder $ H.docTypeHtml $ do 
  H.head $ do
    H.title "Haskell Cake Store Cake List"
  H.body $ do    
    H.h1 "Cake List"
    _ <- forM cakeList (\cake -> H.p (mappend "Cake name: " $ H.toHtml $ Model.Cake.name cake))
    return ()

