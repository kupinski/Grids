import Foundation

/// A `LinearSpace` defines a 1-dimensional linear array which has a ``size``, a ``center``, and a number of pixels ``numPix``.  FIXME:  More here.
///
/// You can define a `LinearSpace` either by its center, size, and number of pixels, or by it's start and end position.  Units are unspecified and up to the user to keep track of.
public struct LinearSpace<T: BinaryFloatingPoint> {
    /// The length of the linear space in unspecified units.
    public var size: T {
        didSet {
            assert(size > T(0.0))
        }
    }
    /// The mid-point of the linear array
    public var center: T
    /// The number of 1-D pixels in the linear array
    public var numPix: Int {
        didSet {
            assert(numPix > 0)
        }
    }
    
    /// A computed property which returns the linear dimension of the 1D pixel
    public var pixelSize : T {
        return size / T(numPix)
    }
    
    /// The mid-points of the pixels as an array.
    public var grid: [T] {
        let halfSpace = size / T(2)
        let halfPix = pixelSize / T(2)
        let ret = (0..<numPix).map {
            return(center - halfSpace + halfPix + T($0) * pixelSize)
        }
        return(ret)
    }
    
    /// The edges of the pixels as an array of tuples.  (start, end) where start is less than end
    public var edges: [(T,T)] {
        let halfSpace = size / T(2)
        let ret: [(T, T)] = (0..<numPix).map {
            let startPoint = center - halfSpace  + T($0) * pixelSize
            let endPoint = center - halfSpace + pixelSize + T($0) * pixelSize
            
            return((startPoint, endPoint))
        }
        return(ret)
    }
    
    /// Return the center point of the grid.
    public subscript(_ idx: Int) -> T {
        let halfSpace = size / T(2)
        let halfPix = pixelSize / T(2)
        return(center - halfSpace + halfPix + T(idx) * pixelSize)
    }
    
    /// Return the edges of the grid.
    public subscript(edges idx: Int) -> (T, T) {
        let halfSpace = size / T(2)
        let startPoint = center - halfSpace  + T(idx) * pixelSize
        let endPoint = center - halfSpace + pixelSize + T(idx) * pixelSize
        return((startPoint, endPoint))
    }

    
    /// Create a `LinearSpace` that starts at `from` and goes to `to`.
    ///
    /// Note that the ``grid`` returned will *not* include the `from` and `to` points because these define the edges and the ``grid`` method returns pixel mid points.
    /// - Parameters:
    ///   - from: The left edge.  `from` must be less than `to`
    ///   - to: The right edge point.  `to` must be greater than `from`
    ///   - numPoints: The number of 1-D pixels
    public init(from: T, to: T, numPoints: Int) {
        precondition(to > from)
        self.center = (to + from) / 2.0
        self.numPix = numPoints
        self.size = to - from
    }
    
    /// Create a `LinearSpace` by defining the center point and the overall size in arbitrary units.
    /// - Parameters:
    ///   - center: The mid-point of the linear array
    ///   - size: The overall length of the array
    ///   - numPoints: The number of 1-D pixels in the array.
    public init(center: T, size: T, numPoints: Int) {
        self.center = center
        self.numPix = numPoints
        self.size = size
    }

}


/// Create a 2-D pixel grid.
///
/// A 2-D pixel grid is defined by two separate ``LinearSpace``s.  One for the x-dimension and one for the y-dimension.  Units are undefined and left up to the user.
public struct PixelGrid<T: BinaryFloatingPoint & SIMDScalar> {
    /// The x-axis linear space
    public var xSpace: LinearSpace<T>
    /// The y-axis linear space
    public var ySpace: LinearSpace<T>
    
    /// The size in x, and y in arbitrary units.
    public var size: SIMD2<T> {
        return(SIMD2<T>(xSpace.size, ySpace.size))
    }
    /// The mid-point of the pixel grid
    public var position: SIMD2<T> {
        return(SIMD2<T>(xSpace.center, ySpace.center))
    }
    /// The number of pixels in x and y
    public var numPix: SIMD2<Int> {
        return(SIMD2<Int>(xSpace.numPix, ySpace.numPix))
    }
    /// The total number of pixels in the 2D grid
    public var totalPix: Int {
        return (xSpace.numPix * ySpace.numPix)
    }
    /// The x- and y-axis pixel sizes in arbitrary units
    public var pixelSize: SIMD2<T> {
        return(SIMD2<T>(xSpace.pixelSize, ySpace.pixelSize))
    }
    
    /// Create a pixel grid with a specified size, center, and number of x- and y- pixels.
    /// - Parameters:
    ///   - withSize: The size in user-defined units
    ///   - atPosition: The position of the grid
    ///   - withNumPix: The number of pixels in x- and y-.
    public init(withSize: SIMD2<T>, atPosition: SIMD2<T>, withNumPix: SIMD2<Int>) {
        xSpace = LinearSpace(center: atPosition.x, size: withSize.x, numPoints: withNumPix.x)
        ySpace = LinearSpace(center: atPosition.y, size: withSize.y, numPoints: withNumPix.y)
    }

}



/// A 3D voxel spaced defining  x-, y-, and z- ``LinearSpace``s.
///
/// Units are up to the user and left unspecified in this structure.  Order of all `SIMD3` values are x, y, z.
public struct VoxelGrid<T: BinaryFloatingPoint & SIMDScalar> {
    /// The x-axis ``LinearSpace``
    public var xSpace: LinearSpace<T>
    /// The y-axis ``LinearSpace``
    public var ySpace: LinearSpace<T>
    /// The z-axis ``LinearSpace``
    public var zSpace: LinearSpace<T>
    
    /// The size in x, y, and z in arbitrary units.
    public var size: SIMD3<T> {
        return(SIMD3<T>(xSpace.size, ySpace.size, zSpace.size))
    }
    /// The mid point of the voxel space
    public var position: SIMD3<T> {
        return(SIMD3<T>(xSpace.center, ySpace.center, zSpace.center))
    }
    /// The number of points in each dimension
    public var numPix: SIMD3<Int> {
        return(SIMD3<Int>(xSpace.numPix, ySpace.numPix, zSpace.numPix))
    }
    /// The total number of voxels in the 3D grid
    public var totalVox: Int {
        return (xSpace.numPix * ySpace.numPix * zSpace.numPix)
    }
    /// The size of a voxel in each dimension
    public var voxelSize: SIMD3<T> {
        return(SIMD3<T>(xSpace.pixelSize, ySpace.pixelSize, zSpace.pixelSize))
    }

    
    /// Create a `VoxelGrid` with the specified size, center, and number of elements in each dimension.
    /// - Parameters:
    ///   - withSize: The x, y, and z sizes
    ///   - atPosition: The center of the voxel grid
    ///   - withNumPix: The number of elements in each dimensions ``LinearSpace``
    public init(withSize: SIMD3<T>, atPosition: SIMD3<T>, withNumPix: SIMD3<Int>) {
        xSpace = LinearSpace(center: atPosition.x, size: withSize.x, numPoints: withNumPix.x)
        ySpace = LinearSpace(center: atPosition.y, size: withSize.y, numPoints: withNumPix.y)
        zSpace = LinearSpace(center: atPosition.z, size: withSize.z, numPoints: withNumPix.z)
    }
    
}
