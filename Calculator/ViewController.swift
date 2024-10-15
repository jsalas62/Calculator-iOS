import UIKit

class ViewController: UIViewController {
    
    var numeroActual: Double = 0
    var numeroAnterior: Double = 0
    var realizandoOperacion = false
    var operacion = ""
    
    @IBOutlet weak var etiquetaDisplay: UILabel!
    
    @IBOutlet weak var botonAC: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        etiquetaDisplay.text = "0"
        configurarBotonAC()  // Configurar formato inicial
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait  // Bloquea la orientación en vertical
    }

    func configurarBotonAC() {
        botonAC.titleLabel?.adjustsFontSizeToFitWidth = false  // Desactiva el ajuste automático del tamaño
        botonAC.titleLabel?.minimumScaleFactor = 1.0  // Asegura que no se reduzca el tamaño de la fuente
        botonAC.titleLabel?.font = UIFont.systemFont(ofSize: 35, weight: .medium)  // Establece el tamaño y estilo fijo
    }
    
    func cambiarTextoBotonAC(_ titulo: String) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 35, weight: .medium)
        ]
        
        let attributedTitle = NSAttributedString(string: titulo, attributes: attributes)
        botonAC.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    
    // Función para formatear el número y limitarlo a 9 dígitos visibles
    func formatNumber(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSize = 3  // Agrupa cada 3 dígitos para los enteros
        formatter.usesGroupingSeparator = true  // Usa separadores de miles (comas)
        formatter.maximumFractionDigits = 8  // Hasta 8 decimales si es necesario
        
        // Si el número es demasiado grande para mostrar, lo convierte a notación científica
        if number >= 1_000_000_000 || number <= -1_000_000_000 {
            return formatLargeNumber(number)
        }

        return formatter.string(from: NSNumber(value: number)) ?? "0"
    }

    // Función para manejar números muy grandes y mostrarlos en notación científica
    func formatLargeNumber(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.maximumFractionDigits = 3  // Puedes ajustar la cantidad de dígitos después del punto decimal
        formatter.exponentSymbol = "e"
        
        return formatter.string(from: NSNumber(value: number)) ?? "0"
    }

    // Función para actualizar el display y evitar que el número sea demasiado largo
    func actualizarDisplayConNumero(_ numero: Double) {
        let texto = formatNumber(numero)

        // Limitar a 9 caracteres para la parte entera, sin contar las comas
        etiquetaDisplay.text = texto
    }

    
    @IBAction func numeroPresionado(_ sender: UIButton) {
        let numero = sender.tag  // Obtiene el número presionado del tag del botón
        
        // Eliminar comas para contar solo los dígitos
        let textoSinComas = etiquetaDisplay.text!.replacingOccurrences(of: ",", with: "")
        
        // Limitar a 9 dígitos en la parte entera, o hasta 8 decimales
        if textoSinComas.contains(".") {
            let componentes = textoSinComas.split(separator: ".")
            let parteDecimal = componentes.count > 1 ? componentes[1] : ""
            if parteDecimal.count >= 8 {
                return  // No permitimos más de 8 decimales
            }
        } else if textoSinComas.count >= 9 {
            return  // No permitimos más de 9 dígitos en la parte entera
        }
        
        // Si estamos en medio de una operación, el próximo número presionado reemplaza el display
        if realizandoOperacion {
            etiquetaDisplay.text = String(numero)
            realizandoOperacion = false
        } else {
            if etiquetaDisplay.text == "0" {
                etiquetaDisplay.text = String(numero)  // Reemplaza el "0" inicial
            } else {
                etiquetaDisplay.text = etiquetaDisplay.text! + String(numero)  // Añade el número
            }
        }
        
        // Convertir a Double sin comas y actualizar el display
        let textoSinComasActualizado = etiquetaDisplay.text!.replacingOccurrences(of: ",", with: "")
        if let numeroConvertido = Double(textoSinComasActualizado) {
            numeroActual = numeroConvertido
            actualizarDisplayConNumero(numeroActual)  // Actualiza el display con el nuevo número formateado
        }
        
        // Cambiar solo el texto del botón a "C"
        cambiarTextoBotonAC("C")
    }
    
    @IBAction func puntoPresionado(_ sender: UIButton) {
        // Verificar si ya hay un punto decimal en el número actual
        if let textoActual = etiquetaDisplay.text {
            if !textoActual.contains(".") && textoActual.count < 9 {  // Asegurar límite de dígitos
                etiquetaDisplay.text = textoActual + "."
            }
        }
        // Cambiar solo el texto del botón a "C"
        cambiarTextoBotonAC("C")
    }
    
    @IBAction func alternarSignoPresionado(_ sender: UIButton) {
        if let textoActual = etiquetaDisplay.text, let numero = Double(textoActual) {
            let numeroAlternado = numero * -1
            actualizarDisplayConNumero(numeroAlternado)
            numeroActual = numeroAlternado
        }
    }
    
    @IBAction func sumarPresionado(_ sender: UIButton) {
        if operacion != "" {
            realizarOperacionPendiente()
        }
        numeroAnterior = numeroActual
        operacion = "+"
        realizandoOperacion = true
    }
    
    @IBAction func restarPresionado(_ sender: UIButton) {
        if operacion != "" {
            realizarOperacionPendiente()
        }
        numeroAnterior = numeroActual
        operacion = "-"
        realizandoOperacion = true
    }
    
    @IBAction func multiplicarPresionado(_ sender: UIButton) {
        if operacion != "" {
            realizarOperacionPendiente()
        }
        numeroAnterior = numeroActual
        operacion = "*"
        realizandoOperacion = true
    }
    
    @IBAction func dividirPresionado(_ sender: UIButton) {
        if operacion != "" {
            realizarOperacionPendiente()
        }
        numeroAnterior = numeroActual
        operacion = "/"
        realizandoOperacion = true
    }
    
    @IBAction func porcentajePresionado(_ sender: UIButton) {
        numeroActual = numeroActual / 100
        actualizarDisplayConNumero(numeroActual)
    }
    
    @IBAction func igualPresionado(_ sender: UIButton) {
        realizarOperacionPendiente()
        realizandoOperacion = false
        operacion = ""
        numeroAnterior = 0
    }
    
    @IBAction func limpiarPresionado(_ sender: UIButton) {
        etiquetaDisplay.text = "0"
        numeroActual = 0
        numeroAnterior = 0
        operacion = ""
        realizandoOperacion = false
        
        // Cambiar solo el texto del botón a "AC"
        cambiarTextoBotonAC("AC")
    }
    
    func realizarOperacionPendiente() {
        var resultado: Double = 0
        
        switch operacion {
        case "+":
            resultado = numeroAnterior + numeroActual
        case "-":
            resultado = numeroAnterior - numeroActual
        case "*":
            resultado = numeroAnterior * numeroActual
        case "/":
            if numeroActual != 0 {
                resultado = numeroAnterior / numeroActual
            } else {
                etiquetaDisplay.text = "Error"
                numeroActual = 0
                numeroAnterior = 0
                operacion = ""
                return
            }
        default:
            return
        }
        
        actualizarDisplayConNumero(resultado)
        numeroActual = resultado
    }
}
