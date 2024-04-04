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
