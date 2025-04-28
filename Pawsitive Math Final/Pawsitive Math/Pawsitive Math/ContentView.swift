import SwiftUI
import SwiftData

// home page
struct ContentView: View {
    
    @State private var energy: CGFloat = 0.8 // default energy value
    @State private var happiness: CGFloat = 0.5 // default happiness value
    @State private var level: CGFloat = 0.05 // default value

    @StateObject private var rewardsSystem = RewardsSystem() // keeping track of the points
    
    //@State private var scene: SCNScene? = nil
    
    var body: some View {
        NavigationStack{
            
            VStack{
                
                // display the status bar at the top of the page
                StatusBarsView(energy: energy, happiness: happiness, level: $level)

//                SceneView(scene: $scene, sceneName: "pawsitiveModel.usdz")
//                    .frame(width: 200, height: 200)
                
                Spacer()
                
                // placeholder image of the 3D model of the bedroom
                Image("pawsitiveModelPlaceholder")
                    .resizable()
                    .frame(width: 360, height: 360)
                    .padding(.all)
                
                Spacer()

                // navigation bar placed at the bottom of the screen
                NavigationBar(rewardsSystem: rewardsSystem)
                                
            }
            
            // default beige background colour
            .background(Color(red: 255/255, green: 249/255, blue: 232/255).ignoresSafeArea())
        }
    }
}

// NAVIGATION BAR
struct NavigationBar: View {
    @ObservedObject var rewardsSystem: RewardsSystem // keeping track of the points
    
    var body: some View {
        HStack(spacing: 5){
                      
            // display the player's points
            Image(systemName:"star")
                .font(.headline)
                .frame(width: 30, height: 30)
            Text("\(rewardsSystem.rewardsTotal)")
            
            Spacer()

            // link to the wardrobe page
            NavigationLink(destination: WardrobeView(rewardsSystem: rewardsSystem)) {
                Image(systemName:"tshirt")
                    .foregroundColor(.black)
                    .frame(width: 30, height: 30)
            }
            
            Spacer()

            // link to the playing page
            NavigationLink(destination: PlayView(rewardsSystem: rewardsSystem)) {
                Image(systemName:"plus.forwardslash.minus")
                    .foregroundColor(.black)
                    .frame(width: 30, height: 30)
            }
            
            Spacer()

            // link to the sleeping page
            NavigationLink(destination: SleepView()) {
                Image(systemName:"bed.double")
                    .foregroundColor(.black)
                    .frame(width: 30, height: 30)
            }
        }
        
        // navigation bar styling
        .padding()
        .background(Color(red: 255/255, green: 210/255, blue: 224/255))
        .cornerRadius(10)
        .shadow(radius: 10)
        .overlay(RoundedRectangle(cornerRadius: 10)
            .stroke(Color(red: 246/255, green: 162/255, blue: 191/255), lineWidth: 3))
        .padding(.horizontal)
    }
}

// PROGRESSION BAR SECTION
struct StatusBarsView: View {
    
    // the status for the progression bars
    var energy: CGFloat
    var happiness: CGFloat
    
    @Binding var level: CGFloat
    @State private var currentLevel: Int = 1 // start from level 1 and goes up
    
    @State private var barsAnimations = false // animation for the progression bars
    
    // function for leveling up
    private func levelup(){
        if level >= 1.0 {
            level = 0.0
            currentLevel += 1
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8){

            // energy progression bar
            StatusBar(icon: Image(systemName:"bolt.fill"), label: "Energy: \(Int(energy * 100))%", color: Color(red: 255/255, green: 237/255, blue: 63/255), value: energy, barsAnimations: $barsAnimations)
            // happiness progression bar
            StatusBar(icon: Image(systemName:"face.smiling.inverse"), label: "Happiness: \(Int(happiness * 100))%", color: Color(red: 255/255, green: 110/255, blue: 202/255), value: happiness, barsAnimations: $barsAnimations)
            // level progression bar
            StatusBar(icon: Image(systemName:"medal.star"), label: "Level \(currentLevel): \(Int(level * 100))%", color: Color(red: 119/255, green: 192/255, blue: 255/255), value: level, barsAnimations: $barsAnimations)
            
        }
        
        // progression bar section styling
        .padding(.vertical, 6)
        .padding(.horizontal, 12)
        .background(Color(red: 255/255, green: 210/255, blue: 224/255))
        .cornerRadius(10)
        .shadow(radius: 10)
        .overlay(RoundedRectangle(cornerRadius: 10)
            .stroke(Color(red: 246/255, green: 162/255, blue: 191/255), lineWidth: 3))
        .padding(.horizontal)
        
        // animationn for the energy bar
        .onChange(of: energy, initial: false) { oldValue, newValue in
            withAnimation(.easeInOut(duration: 0.5)) {
                barsAnimations = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                barsAnimations = false
            }
        }
        
        // animation for the level bar
        .onChange(of: level, initial: false) { oldValue, newValue in
            levelup() // levelup function
            withAnimation(.easeInOut(duration: 0.5)) {
                barsAnimations = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                barsAnimations = false
            }
        }
    }
}

// STATUS BARS
struct StatusBar: View {
    
    // descriptions for the status bars
    let icon: Image
    let label: String
    let color: Color
    let value: CGFloat
    
    @Binding var barsAnimations: Bool
    @State private var animation: CGFloat = 0

    var body: some View {
        
        VStack(alignment: .leading, spacing: 2){
            
            HStack(spacing: 6){
                // icons of the status
                icon
                    .foregroundColor(color)
                
                // label of the status
                Text(label)
                    .font(.caption)
                    .bold()
            }

            ZStack(alignment: .leading){
                
                GeometryReader { geometry in
                    
                    // styling for the bars with white background
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 16)
                        .foregroundColor(.white.opacity(0.8))
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1))
                    
                    // styling for the the bars with their specific colour and animation
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: geometry.size.width * animation, height: 15.5)
                        .foregroundColor(color)
                        .overlay(LinearGradient(gradient: Gradient(colors: [color.opacity(0.7), color.opacity(1)]), startPoint: .leading, endPoint: .trailing)
                            .opacity(0.6)
                            .blendMode(.plusLighter)
                            .blur(radius: 4))
                        .cornerRadius(10)
                }
                
                .frame(height: 25)
            }
        }
        
        // animation for the progression
        .onAppear{
            animation = value
        }
        
        .onChange(of: value, initial: false) { oldValue, newValue in
            withAnimation(.easeInOut(duration: 0.6)) {
                animation = newValue
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
