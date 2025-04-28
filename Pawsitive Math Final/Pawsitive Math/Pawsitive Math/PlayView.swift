import SwiftUI
import SwiftData

// PLAY page
struct PlayView: View {
    
    @State private var answer: String = "" // input answer
    @State private var question: String = "" // question
    @State private var answerMessage: String = "" // message to show after submission
    
    @State private var showPopup: Bool = false // popup message showing yes/no
    @State private var correctAnswer: Double = 0 // correct answer for the question
    @State private var answerColour: Color = .black // default answer colour
    @State private var disableAnswerInput: Bool = false // disable text box
    
    @State private var rewardsTotal: Int = 0 // points starting from 0
    @State private var rewardsGained: Int = 0 // default point being 0
    
    @State private var energy: CGFloat = 0.8 // default energy value
    @State private var happiness: CGFloat = 0.5 // default happiness value
    @State private var level: CGFloat = 0.05 // default level value
    
    @Environment(\.dismiss) var dismiss // dismiss the view
    @ObservedObject var rewardsSystem: RewardsSystem // keeping track of the points
    
    var body: some View {
        
        ZStack{
            
            // default beige background
            Color(red: 255/255, green: 249/255, blue: 232/255).ignoresSafeArea()
            
            VStack{
                
                VStack(spacing: 40){
                    
                    VStack(spacing: 30){
                        
                        // displaying the math equation
                        Text(question)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        // text box to type answer
                        TextField("Write your answer here...", text: $answer)
                            .disabled(disableAnswerInput) // stops player from entering number in the text box after submitting answer
                            .textFieldStyle(.roundedBorder)
                            .padding()
                            .frame(height: 50)
                            .background(Color(red: 255/255, green: 249/255, blue: 232/255))
                            .overlay(RoundedRectangle(cornerRadius: 5)
                                .stroke(Color(red: 246/255, green: 162/255, blue: 191/255), lineWidth: 3))
                            .frame(width: 200)
                        
                        // checking answer button
                        Button(action:{
                            checkAnswer()
                        }) {
                            Text("Check")
                                .frame(width: 100, height: 50)
                                .background(Color(red: 246/255, green: 162/255, blue: 191/255))
                                .foregroundColor(.black)
                                .cornerRadius(10)
                                .overlay(RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(red: 255/255, green: 249/255, blue: 232/255), lineWidth: 3))
                        }
                        
                        .buttonStyle(.plain)
                    }
                    
                    // question box styling
                    .padding(40)
                    .frame(width: 300, height: 300)
                    .background(Color(red: 250/255, green: 210/255, blue: 224/255))
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(red: 246/255, green: 162/255, blue: 191/255), lineWidth: 5))
                    .cornerRadius(10)
                    .shadow(radius: 8)
                }
                
                Spacer()
                
            }
            
            .padding(.top, 50)
            
            // popup message shows to check answer
            if showPopup{
                
                VStack{
                    
                    VStack(spacing: 20){
                        
                        // display whether the answer was correct or not
                        Text(answerMessage)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(answerColour) // green or red
                            .multilineTextAlignment(.center)
                        
                        // display the correct answer
                        Text("Answer = \(Int(correctAnswer))")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(Color.blue)
                        
                        // displays how many points gained from the question
                        Text("Rewards: \(rewardsGained)")
                            .font(.body)
                            .fontWeight(.bold)
                            .foregroundColor(Color.yellow)
                        
                        HStack(spacing: 30){
                            
                            // back button
                            Button(action:{
                                    dismiss()
                                }) {
                                    Image(systemName: "house")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.black)
                                }
                            
                            // next question button
                            Button(action:{
                                showPopup = false
                                answer = ""
                                disableAnswerInput = false
                                generateQuestion() // generate a another question
                            }) {
                                Image(systemName: "chevron.forward.2")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.black)
                            }
                        }
                    }

                    // popup message styling
                    .padding()
                    .frame(width: 230, height: 250)
                    .background(Color(red: 255/255, green: 249/255, blue: 232/255))
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(red: 246/255, green: 162/255, blue: 191/255), lineWidth: 5))
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    
                }
                
                .frame(width: 250)
            }
            
            VStack{
                
                Spacer()
                
                // display the status bars at the bottom of the screen
                StatusBarsView(energy: energy, happiness: happiness, level: $level)
                    .background(Color(red: 255/255, green: 249/255, blue: 232/255))
            }
        }
        
        // heading
        .navigationTitle("Quiz time!")
        .navigationBarBackButtonHidden(true)
        
        // back button taking you back to the room
        .toolbar{
            Button(action:{
                dismiss()
            }){
                Image(systemName: "house")
                    .foregroundColor(.black)
            }
        }
        
        // generate a question when you open the play page
        .onAppear {
            generateQuestion()

        }
    }
    
    // function for generating random math questions
    func generateQuestion(){
        let symbols = ["+", "-", "*", "/"]
        let number1 = Int.random(in: 1...10)
        let number2 = Int.random(in: 1...10)
        let symbol = symbols.randomElement()!
        
        switch symbol{
        case "+": // addition
            correctAnswer = Double(number1 + number2)
            question = "\(number1) + \(number2) = ?"
        case "-": // subtraction
            correctAnswer = Double(number1 - number2)
            question = "\(number1) - \(number2) = ?"
        case "*": // multiple
            correctAnswer = Double(number1 * number2)
            question = "\(number1) × \(number2) = ?"
        case "/": // division
            let numerator = number1 * number2
            correctAnswer = Double(numerator) / Double(number2)
            question = "\(numerator) ÷ \(number2) = ?"
        default:
            break
        }
    }
    
    // function for checking whether the answer is correct or not
    func checkAnswer(){
        guard let typedAnswer = Double(answer) else{
            return
        }
        
        // energy decreases by 5% after playing
        if energy > 0.05 {
            energy -= 0.05
        } else{
            energy = 0.0 // energy can't go lower than 0
        }
        
        // if answer is correct
        if typedAnswer == correctAnswer {
            answerMessage = "Your answer is correct! :)"
            answerColour = .green
            rewardsGained = Int.random(in: 20...40) // randomised points between 20-40 for correct answers
            level += 0.1 // level bar goes up by 10%
            happiness += 0.05 // happiness bar goes up by 5%
            happiness = min(happiness, 1.0) // happiness bar can't go higher than 100%
            
        } else{
            // if answer is incorrect
            answerMessage = "Your answer is incorrect :("
            answerColour = .red
            rewardsGained = 2 // still gaining 2 points for attempting even if the answer is incorrect
            level += 0.02 // level bar goes up by 2%
            happiness -= 0.05 // happiness bar goes down by 5%
            happiness = max(happiness, 0.0) // happiness bar can't go lower than 0%
        }
        // level resets to 0% after reaching 100%
        if level >= 1.0{
            level = 0.0
        }

        // adding the gained points to the total amount
        rewardsSystem.rewardsTotal += rewardsGained
        showPopup = true
        disableAnswerInput = true
    }
}

// points total object to access across the application
class RewardsSystem: ObservableObject{
    @Published var rewardsTotal: Int = 0
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
