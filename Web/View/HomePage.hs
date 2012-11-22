module Web.View.HomePage
(render)
where

{-# LANGUAGE OverloadedStrings #-}

import qualified Web.WebHelper as WebHelper

render user = ["<html>","<body>","Hi", user,"</body>","</html>"] 

