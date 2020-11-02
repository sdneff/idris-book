import Data.Vect

createEmpties : Vect n (Vect 0 elem)
createEmpties = replicate _ []

transposeMat : Vect m (Vect n elem) -> Vect n (Vect m elem)
transposeMat [] = createEmpties
transposeMat (x :: xs) = let xsTrans = transposeMat xs in
                         zipWith (::) x xsTrans


addMatrix : Num a => Vect n (Vect m a) -> Vect n (Vect m a) -> Vect n (Vect m a)
addMatrix [] [] = []
addMatrix (x :: xs) (y :: ys) = zipWith (+) x y :: addMatrix xs ys


multVects : Num a => (xs : Vect m a) -> (ys : Vect m a) -> a
multVects xs ys = sum (zipWith (*) xs ys)

mkRow : Num a => (xs : Vect m a) -> (transYs : Vect p (Vect m a)) -> Vect p a
mkRow x [] = []
mkRow x (y :: xs) = multVects x y :: mkRow x xs

multHelper : Num a => (xs : Vect n (Vect m a)) -> (transYs : Vect p (Vect m a)) -> Vect n (Vect p a)
multHelper [] transYs = []
multHelper (x :: xs) transYs = mkRow x transYs :: multHelper xs transYs

multMatrix : Num a => Vect n (Vect m a) -> Vect m (Vect p a) -> Vect n (Vect p a)
multMatrix xs ys = let transYs = transposeMat ys in
                   multHelper xs transYs
