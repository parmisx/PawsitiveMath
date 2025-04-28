import SwiftUI
import SwiftData

// SLEEPING page
struct SleepView: View {
    
    @State private var energyRestore: Timer? // restore energy every second
    @State private var energy: CGFloat = 0.8 // default energy value
    @State private var happiness: CGFloat = 0.5 // default happiness value
    @State private var level: CGFloat = 0.05 // default value
    
    @Environment(\.dismiss) var dismiss // dismiss the view

    var body: some View {
        
        VStack(spacing: 0){
            
            ZStack{
                
                // grey background
                Color(red: 121/255, green: 121/255, blue: 121/255).ignoresSafeArea()
                
                VStack(spacing: 20){
                    
                    // displaying the sleep message
                    Image(systemName: "moon.zzz")
                    
                    Text("ZzZz...Shhhh... Pet is currently sleeping... ")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text("Go get some rest just like him!")
                        .font(.subheadline)
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .padding(.all)
                    
                    Image(systemName: "zzz")
                }
            }
            
            // displaying the status bars at the bottom of the screen
            StatusBarsView(energy: energy, happiness: happiness, level: $level)
                .background(Color(red: 121/255, green: 121/255, blue: 121/255))
        }
        
        // heading
        .navigationTitle("Sleeping...")
        .navigationBarBackButtonHidden(true)
        
        // back button taking you back to the room
        .toolbar{
            Button(action:{
                dismiss()
            }) {
                Image(systemName: "house").foregroundColor(.black)
            }
        }
        
        .onAppear{
            // the energy restores by 1% in 1 second
            energyRestore = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                if energy < 1.0 {
                    energy += 0.01
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
