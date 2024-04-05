import Foundation

// Structure représentant une question dans le quiz
struct Question: Codable {
    let question: String
    let options: [String]
    let indexBonneRep: Int
    let difficulte: Difficulte
    let categorie: String
}



// Énumération définissant les niveaux de difficulté des questions
enum Difficulte: String, Codable {
    case facile
    case moyen
    case difficile
}



// Structure représentant le score d'un utilisateur
struct ScoreUtilisateur: Codable {
    let nomJoueur: String
    let score: Int
    let difficulte: Difficulte
    let categorie: String
}

// Fonction pour charger les questions à partir d'un fichier JSON
func chargerQuestions(from file: String) -> [Question]? {
    // Chemin du fichier JSON contenant les questions
    let filePath = "/Users/saku/Docs/Documents - Sameh/Cours/Développement mobile/IOS/QuizGame/" + file + ".json"
    let fileURL = URL(fileURLWithPath: filePath)
    do {
        let data = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        let questions = try decoder.decode([Question].self, from: data)
        return questions
    } catch {
        print("Error loading file: \(error)")
        return nil
    }
}

// Fonction pour permettre à l'utilisateur de sélectionner la difficulté du quiz
func selectionDifficulte() -> Difficulte? {
    print("Sélectionnez le niveau de difficulté:")
    print("1. Facile")
    print("2. Moyen")
    print("3. Difficile")
    
    var difficulte: Difficulte?
    var isValidInput = false
    
    repeat {
        if let input = readLine(), let choice = Int(input), (1...3).contains(choice) {
            switch choice {
            case 1: difficulte = .facile
            case 2: difficulte = .moyen
            case 3: difficulte = .difficile
            default: break
            }
            isValidInput = true
        } else {
            print("Choix invalide. Veuillez entrer le numéro correspondant au niveau de difficulté.")
        }
    } while !isValidInput
    
    return difficulte
}

// Fonction pour charger les questions en fonction de la catégorie et de la difficulté sélectionnées
func chargerQuestions(for categorie: String, difficulty: Difficulte) -> [Question]? {
    guard let allQuestions = chargerQuestions(from: "questions") else {
        return nil
    }
    let filteredQuestions = allQuestions.filter { $0.categorie == categorie && $0.difficulte == difficulty }
    return filteredQuestions.isEmpty ? nil : filteredQuestions
}
