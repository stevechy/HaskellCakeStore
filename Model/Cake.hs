module Model.Cake
(Cake(..))
where
  
data Cake = Cake { id:: Integer, name :: String } deriving (Show,Eq)

