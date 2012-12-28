{-# LANGUAGE DeriveDataTypeable #-}

module Model.Cake
(Cake(..))
where
  
import Data.Typeable  
  
data Cake = Cake { id:: Integer, name :: String } deriving (Show,Eq, Typeable)

