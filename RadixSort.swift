import Foundation

// Setup the arrays.
// First we set up a sorted array as a starting point.
// We then shuffle that array to have a working array to sort.
// The idea is to keep the original sorted array in order to compare against it later.
let sorted = [4, 7, 9, 50, 83, 123, 211, 1024, 1337, 9001]
var working = sorted.shuffled()

// Create a function to sort the array.
// This function takes an inout parameter named `array`.
// This means that the function's mutation of `array` will persist even after the function has ended.
func radixSort(_ array: inout [Int]) {
    // Get the max value of `array`.
    // This is important because we are concerned with how many digits the max value has.
    // i.e. 1337 has 4 digits.
    guard let maxValue = array.max() else {
        return
    }

    // Setup buckets.
    // There are 10 digits in the decimal system, therefore we need 10 buckets.
    var buckets = [[Int]](repeating: [], count: 10)

    // Setup radix position.
    // We are going to use this power of ten in order to know which digit to look at.
    var powerOfTen = 1

    // Sorting engine.
    // This engine will loop through as many times as the max value's number of digits.
    // An example about how this works:
    //     - Assume the max value is 1337 and powerOfTen starts as 1.
    //     - Therefore: 1337 / 1 = 1337.
    //     - This is greater than 0, so we run the while loop.
    //     - The next time around we compare 1337 / 10 > 0.
    //     - Using integer division 1337 / 10 = 133, which is greater than 0 so we continue the loop.
    //     - The next time: 1337 / 100 = 13 > 0.
    //     - The next time: 1337 / 1000 = 1 > 0.
    //     - However: 1337 / 10000 = 0, which is not greater than 0. Therefore we stop the loop.
    //     - This means that the loop ran four times, the max value's number of digits.
    while maxValue / powerOfTen > 0 {
        // Put array values into buckets.
        array = array.compactMap { value in
            // Inside of the brackets we figure out in which "bucket" (index) to place the value.
            // An example about how this works:
            //     - Assume we we are looking at value 83.
            //     - We would expect to place this in the 3rd bucket the first time around.
            //     - We would expect to place this in the 8th bucket the second time around.
            //     - We would expect any subsequent times to place the value in the 0th bucket.
            //     - (note: we are using 0-indexed ordinal numbers;
            //        therefore the 0th bucket is really the first array,
            //        the 1st bucket is the second array,
            //        et cetera)
            //     - So the first time we start with 83 / 1 = 83 % 10 = 3.
            //     - The second time we calculate 83 / 10 = 8 % 10 = 8.
            //     - (note: remember that we are using integer division)
            //     - The third time we calculate 83 / 100 = 0 % 10 = 0.
            //     - Any subsequent time will continue to calculate 0.
            buckets[value / powerOfTen % 10].append(value)

            // compactMap will remove any nil values.
            // Therefore, we return nil so that `array` is empty after compactMap is finished.
            return nil
        }

        // Put bucket values into the array.
        // Here we are explicitly going through each bucket IN ORDER.
        // We start with the 0th bucket (first array) and end with the 9th bucket (tenth array).
        // We are also taking each value out of the individual buckets IN ORDER.
        // Meaning that the "front" of the array is "popped" first.
        // This is a FIFO (first-in, first-out) operation.
        // This specific order in which the values are placed into the buckets and later retrieved from the buckets
        // is where the real magic happens for Radix Sort and how we obtain a sorted array after the algorithm finishes.
        buckets = buckets.map { bucket in
            bucket.forEach { value in
                array.append(value)
            }

            // We return an empty bucket here so that after map is finished we are back to ten EMPTY buckets.
            return []
        }

        // Move radix position.
        // Simply multiple this value by 10 after each loop.
        // We start with 1, then 10, then 100, et cetera.
        // This helps us look at specific digits in each value with each iteration of the while loop.
        powerOfTen *= 10
    }
}

// Print unsorted working array.
print("Before sorting: \(working)")

// Sort the working array.
// Here we use the ampersand (&) since radixSort(_:) takes an inout parameter.
radixSort(&working)

// Print sorted working array.
print(" After sorting: \(working)")

// Verify the array is sorted.
sorted == working ? print("👍") : print("👎")
