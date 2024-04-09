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
    let filePath = "/Users/saku/Docs/Documents - Sameh/Cours/Développement mobile/IOS/QuizGame/questions.json"
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



// Fonction pour demander à l'utilisateur son nom
func getNomJoueur() -> String {
    print("Entrez votre nom:")
    if let nomJoueur = readLine() {
        return nomJoueur
    } else {
        return "Joueur"
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



// Fonction pour mélanger les questions afin de rendre le quiz plus aléatoire
func shuffleQuestions(_ questions: [Question]) -> [Question] {
    return questions.shuffled()
}



// Fonction pour obtenir la réponse de l'utilisateur à une question donnée
func getReponseUtilisateur(for question: Question) -> Int? {
    print(question.question)
    for (index, option) in question.options.enumerated() {
        print("\(index + 1). \(option)")
    }
    var reponseUtilisateur: Int?
    var isValidInput = false
    repeat {
        if let input = readLine(), let choice = Int(input), (1...question.options.count).contains(choice) {
            reponseUtilisateur = choice - 1
            isValidInput = true
        } else {
            print("Réponse invalide. Veuillez entrer le numéro correspondant à votre choix.")
        }
    } while !isValidInput
    
    return reponseUtilisateur
}



// Fonction pour enregistrer le score de l'utilisateur
func saveScoreUtilisateur(nomJoueur: String, score: Int, difficulte: Difficulte, categorie: String) {
    let scoreUtilisateur = ScoreUtilisateur(nomJoueur: nomJoueur, score: score, difficulte: difficulte, categorie: categorie)
    var scores = chargerScoreUtilisateurs() ?? []
    scores.append(scoreUtilisateur)
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    
    do {
        let data = try encoder.encode(scores)
        
        // Enregistrer les données JSON dans un fichier
        let filePath = "/Users/saku/Docs/Documents - Sameh/Cours/Développement mobile/IOS/QuizGame/scores.json"
        let fileURL = URL(fileURLWithPath: filePath)
        try data.write(to: fileURL)
        
        print("Score de \(nomJoueur) enregistré: \(score) (Difficulté: \(difficulte.rawValue), Catégorie: \(categorie))")
    } catch {
        print("Erreur lors de l'enregistrement du score : \(error)")
    }
}



// Fonction pour charger les scores des utilisateurs à partir d'un fichier JSON
func chargerScoreUtilisateurs() -> [ScoreUtilisateur]? {
    // Charger les données JSON à partir du fichier
    let filePath = "/Users/saku/Docs/Documents - Sameh/Cours/Développement mobile/IOS/QuizGame/scores.json"
    let fileURL = URL(fileURLWithPath: filePath)
    
    do {
        let data = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        let scores = try decoder.decode([ScoreUtilisateur].self, from: data)
        return scores
    } catch {
        print("Erreur lors du chargement des scores : \(error)")
        return nil
    }
}



// Fonction pour afficher le score final de l'utilisateur
func afficherScoreFinal(_ score: Int) {
    print("Votre score final est de \(score) points.")
}



// Fonction pour permettre à l'utilisateur de sélectionner la catégorie du quiz
func selectionCategorie() -> String? {
    print("Veuillez choisir la catégorie :")
    print("1 - Géographie")
    print("2 - Naruto")
    // Ajoutez d'autres catégories selon votre fichier JSON
    
    var categorie: String?
    var isValidInput = false
    
    repeat {
        if let input = readLine(), let choice = Int(input), (1...2).contains(choice) {
            switch choice {
            case 1: categorie = "Géographie"
            case 2: categorie = "Naruto"
            // Ajoutez d'autres cas pour d'autres catégories si nécessaire
            default: break
            }
            isValidInput = true
        } else {
            print("Choix invalide. Veuillez entrer le numéro correspondant à la catégorie.")
        }
    } while !isValidInput
    
    return categorie
}



// Fonction principale pour démarrer le jeu
func startGame() {
    var jouerEncore = true
    while jouerEncore {
        print("1. Jouer")
        print("2. Afficher les scores")
        
        if let choix = readLine(), let menuChoice = Int(choix) {
            switch menuChoice {
            case 1:
                // Jouer au quiz
                let nomJoueur = getNomJoueur()
                guard let categorie = selectionCategorie() else {
                    print("Catégorie invalide.")
                    continue
                }
                
                guard let difficulte = selectionDifficulte() else {
                    print("Option invalide.")
                    continue
                }
                
                guard let questions = chargerQuestions(for: categorie, difficulty: difficulte) else {
                    print("Impossible de charger les questions pour la catégorie et la difficulté sélectionnées.")
                    continue
                }
                
                let shuffledQuestions = shuffleQuestions(questions)
                var score = 0
                
                for question in shuffledQuestions {
                    if let reponseUtilisateur = getReponseUtilisateur(for: question), reponseUtilisateur == question.indexBonneRep {
                        score += 1
                        print("Correct!")
                    } else {
                        print("Dommage, c'était \(question.options[question.indexBonneRep])")
                    }
                }
                
                afficherScoreFinal(score)
                saveScoreUtilisateur(nomJoueur: nomJoueur, score: score, difficulte: difficulte, categorie: categorie)
                
            case 2:
                // Afficher les scores des utilisateurs
                if let scores = chargerScoreUtilisateurs() {
                    // Triez les scores en fonction du score décroissant
                    let sortedScores = scores.sorted { $0.score > $1.score }
                    print("Scores des joueurs:")
                    for score in sortedScores {
                        print("\(score.nomJoueur): \(score.score) (Difficulté: \(score.difficulte.rawValue), Catégorie: \(score.categorie))")
                    }
                } else {
                    print("Aucun score disponible.")
                }
            default:
                print("Choix invalide.")
            }
        } else {
            print("Choix invalide.")
        }
        
        // Demander à l'utilisateur s'il souhaite revenir au menu principal
        print("Souhaitez-vous revenir au menu? (Oui/Non)")
        if let choix = readLine(), choix.lowercased() == "non" {
            jouerEncore = false
        }
    }
}

// Démarrer le jeu
startGame()
