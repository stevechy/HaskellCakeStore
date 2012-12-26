{-# LANGUAGE NoMonomorphismRestriction  #-}
module Data.Cakes
(getCakes,
 addCake)

where
  
import Database.HDBC 
import qualified Data.DataHandler
import qualified Model.Cake

getCakes :: Data.DataHandler.DataCall [Model.Cake.Cake]
getCakes = Data.DataHandler.DataCall {
  Data.DataHandler.name = "getCakes",
  Data.DataHandler.execution = do
    let unmarshallCake resultRow = Model.Cake.Cake { Model.Cake.id = fromSql $ resultRow !! 0, Model.Cake.name = fromSql $ resultRow !! 1 }
    let getCakesTrans connection = do 
          results <- quickQuery' connection "SELECT id, name from cakes" []
          return $ map unmarshallCake results
    Data.DataHandler.withTrans getCakesTrans
  }
  
addCake :: String -> Data.DataHandler.DataCall Integer
addCake name = Data.DataHandler.DataCall {
  Data.DataHandler.name = "addCake",
  Data.DataHandler.execution = do
    let addCakesTrans connection =  run connection ("INSERT INTO cakes (name) VALUES ('"++name++"')") []
    Data.DataHandler.withTrans addCakesTrans
  }
    