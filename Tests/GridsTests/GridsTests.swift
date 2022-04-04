import XCTest
@testable import Grids

final class GridsTests: XCTestCase {
    func testExample() throws {
        
        for N in [2.0, 10.0, 100.0, 1000.0] {
            let z1 = Array(stride(from: -1.0 + 1.0 / N, through: 1.0 - 1.0 / N, by: (2.0 / N)))
            let grid1 = LinearSpace(from: -1.0, to: 1.0, numPoints: Int(N))
            
            let b = zip(z1, grid1.grid)
            for vals in b {
                XCTAssertEqual(vals.0, vals.1, accuracy: 0.00001)
            }
        }
    }
}
