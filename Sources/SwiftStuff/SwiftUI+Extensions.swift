import SwiftUI

// Extensions for SwiftUI.

extension EdgeInsets {
    init(value: CGFloat) {
        self.init(top: value, leading: value, bottom: value, trailing: value)
    }
}

extension View {
    func asHostingController() -> UIHostingController<Self> {
        UIHostingController(rootView: self)
    }
}
