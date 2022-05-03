import UIKit

public extension CALayer {
    class func transactionWithoutAnimation(_ actions: () -> Void) {
        CATransaction.begin()
        CATransaction.setValue(true, forKey: kCATransactionDisableActions)
        actions()
        CATransaction.commit()
    }
}

public extension UIImage {
    
    static func convertToGrayscale(_ image: UIImage) -> UIImage {
        let filter = CIFilter(name: "CIPhotoEffectTonal")
        let input = CIImage(image: image)
        filter?.setValue(input, forKey: kCIInputImageKey)
        let output = filter?.outputImage
        let cgImage = CIContext().createCGImage(output!, from: output!.extent)
        return UIImage(cgImage: cgImage!)
    }
}

// Sequences & Collections

public extension Collection {
    
    subscript(safe index: Index) -> Element? {
        return startIndex <= index && index < endIndex ? self[index] : nil
    }
    
    func separate(predicate: (Iterator.Element) -> Bool) -> (matching: [Iterator.Element], nonMatching: [Iterator.Element]) {
        var split: ([Iterator.Element], [Iterator.Element]) = ([], [])
        for element in self {
            predicate(element) ? split.0.append(element) : split.1.append(element)
        }
        return split
    }
}

public extension Sequence {
    
    typealias Diff<Other: Sequence> = (common: [(Self.Element, Other.Element)], original: [Self.Element], new: [Other.Element])
    
    // can be optimized
    func diff<T>(to otherSequence: T, with comparator: (Self.Element, T.Element) -> Bool) -> Diff<T> {
        let combinations = self.compactMap { selfElement in
            (selfElement, otherSequence.first { otherElement in comparator(selfElement, otherElement) })
        }
        let common = combinations.filter { $0.1 != nil }.compactMap { ($0.0, $0.1!) }
        let removed = combinations.filter { $0.1 == nil }.compactMap { ($0.0) }
        let inserted = otherSequence.filter { element in !common.contains { comparator($0.0, element) } }
        return (common, removed, inserted)
    }
}
