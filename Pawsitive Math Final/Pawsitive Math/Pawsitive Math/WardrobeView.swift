import SwiftUI
import SwiftData

// WARDROBE page
struct WardrobeView: View {
    
    let clothes = ["hatPlaceholder", "shirtPlaceholder", "trousersPlaceholder", "shoesPlaceholder"] // the clothing options
    
    @State private var selectedCloth: String? = nil // selected clothing item
    @State private var buyMessage: String = "" // popup message at purchase

    @ObservedObject var rewardsSystem: RewardsSystem // keeping track of the points
    
    @State private var changeButtonColor: Color = Color(red: 250/255, green: 210/255, blue: 224/255) // button colour
    @State private var petImage: String = "petPlaceholder" // placeholder picture of pet

    @Environment(\.dismiss) var dismiss // dismiss the view
    
    var body: some View {
        
        ZStack{
            
            // default beige background
            Color(red: 255/255, green: 249/255, blue: 232/255).ignoresSafeArea()
            
            VStack{
                
                Spacer()

                HStack(alignment: .top, spacing: 20){
                    
                    VStack(spacing: 20){
                        
                        HStack{
                            
                            // displaying player's points
                            Image(systemName:"star")
                                .font(.headline)
                                .frame(width: 30, height: 30)
                            
                            Text("Your points: \(rewardsSystem.rewardsTotal) ")
                                .fontWeight(.bold)
                        }
                        
                        // displaying each of the clothing options
                        ForEach(clothes, id: \.self) { imageName in
                            Button(action:{
                                // update the pet image with the clothing item when clicked
                                selectedCloth = imageName
                                updatePetImage(for: imageName)
                            }) {
                                // clothing item images
                                Image(imageName)
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(10)
                                    .shadow(radius: selectedCloth == imageName ? 10 : 0)
                                    .overlay(RoundedRectangle(cornerRadius: 10)
                                        .stroke(selectedCloth == imageName ? Color.white : Color.clear, lineWidth: 3))
                                
                                // price tag of the clothing items
                                Image(systemName: "tag")
                                    .foregroundColor(.pink)
                                
                                Text("200")
                                    .fontWeight(.bold)
                                    .foregroundColor(.pink)

                            }
                        }
                    }
                    // the wardrobe styling
                    .padding()
                    .frame(width: 190, height: 600)
                    .background(Color(red: 238/255, green: 214/255, blue: 187/255))
                    .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(red: 196/255, green: 153/255, blue: 102/255), lineWidth: 5))
                    .cornerRadius(10)
                    
                    VStack(spacing: 100){
                        
                        Spacer()
                        
                        // image of the pet
                        Image(petImage)
                            .resizable()
                            .frame(width: 140, height: 300)
                        
                        // change button = buy clothing button
                        Button(action:{
                            buyClothes()
                        }) {
                            Text("Change")
                                .frame(width: 100, height: 50)
                                .background(changeButtonColor) // button colour changes based on points
                                .foregroundColor(.black)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .overlay(RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(red: 246/255, green: 162/255, blue: 191/255), lineWidth: 3))
                        }
                    }
                }
                
                .frame(maxWidth: .infinity)
                .padding()
                
                //Spacer()
                VStack{
                    
                    Spacer()
                    
                    // popup buy message
                    if !buyMessage.isEmpty{
                        Text(buyMessage)
                            .font(.headline)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(red: 246/255, green: 162/255, blue: 191/255), lineWidth: 3))
                            .cornerRadius(10)
                            .padding(.bottom, 30)
                            .transition(.opacity)
                            .shadow(radius: 5)
                    }
                }
                
                .animation(.easeInOut, value: buyMessage)
            }
        }
        
        // heading
        .navigationTitle("Pet Wardrobe")
        .navigationBarBackButtonHidden(true)
        .shadow(radius: 10)
        
        // back button taking you back to the room
        .toolbar{
            Button(action:{
                dismiss()
                }){
                    Image(systemName: "house")
                        .foregroundColor(.black)
            }
        }
    }
    
    // function to update the pet image with selected clothing item
    func updatePetImage(for cloth: String){
        switch cloth{
        case "hatPlaceholder":
            petImage = "petWithHatPlaceholder"
        case "shirtPlaceholder":
            petImage = "petWithTshirtPlaceholder"
        case "trousersPlaceholder":
            petImage = "petWithTrousersPlaceholder"
        case "shoesPlaceholder":
            petImage = "petWithShoesPlaceholder"
        default:
            petImage = "petPlaceholder"
        }
    }

    // function for buying clothes
    func buyClothes(){
        
        // buy clothes with 200 points
        if rewardsSystem.rewardsTotal >= 200{
            buyMessage = "Item Purchased :)"
            rewardsSystem.rewardsTotal -= 200 // deduct 200 points from player's total points
            changeButtonColor = Color.green
            
        } else{
            // when player doesn't have not enough points
            buyMessage = "Not enough points :("
            changeButtonColor = .red
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
