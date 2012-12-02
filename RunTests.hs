import Test.HUnit

import qualified Tests.DataTest

test1 = TestCase (assertEqual "Equal" (1,2) (3,4))

tests = TestList [TestLabel "test1" test1, TestLabel "data tests" Tests.DataTest.tests ]

main = runTestTT tests

