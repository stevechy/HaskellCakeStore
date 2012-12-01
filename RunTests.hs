import Test.HUnit

test1 = TestCase (assertEqual "Equal" (1,2) (3,4))


main = runTestTT test1

