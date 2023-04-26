import Combine
import UIKit

extension UITextField {
    func publisher(for keyPath: KeyPath<UITextField, String?>) -> AnyPublisher<String?, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { [unowned self] _ in self[keyPath: keyPath] }
            .eraseToAnyPublisher()
    }
}
