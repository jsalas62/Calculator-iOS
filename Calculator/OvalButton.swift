import UIKit

@IBDesignable
class OvalButton: UIButton {

    // Ajustar el cornerRadius para hacerlo ovalado
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }

    // Sobrescribimos layoutSubviews para establecer el tamaño y las esquinas
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Aquí definimos que el botón sea ovalado ajustando el cornerRadius
        self.layer.cornerRadius = self.bounds.height / 2 // Redondeamos las esquinas a la mitad de la altura

        // Asegúrate de que las vistas internas no se salgan del borde
        self.clipsToBounds = true
    }
}
