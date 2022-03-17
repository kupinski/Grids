import XCTest
@testable import Grids

final class GridsTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let z = LinearSpace(from: 1000000, to: 1000008, numPoints: 14)
//        let z = LinearSpace(center: 0.0, size: 3.0, numPoints: 14)
        for idx in z.grid.indices {
            if (idx != z.grid.count - 1) {
                print(z.grid[idx + 1] - z.grid[idx])
            }
        }
    }
}
