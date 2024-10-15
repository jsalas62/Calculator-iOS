import UIKit

@IBDesignable
class RoundButton: UIButton {
    
    // Esta propiedad te permite configurar el radio de las esquinas en el Interface Builder
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }

    // Override layoutSubviews para actualizar el cornerRadius y hacerlo circular
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Asegúrate de que el botón sea un círculo: la mitad de su ancho o altura
        self.layer.cornerRadius = self.bounds.size.width / 2
        self.clipsToBounds = true
    }
}
