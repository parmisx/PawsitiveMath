// this was used for attempting at importing the 3D model of the bedroom into the game,
// however the model was not being rendered properly.
// ended up using only image of the 3D model as the background of the main page.

//// 3D models imports
//import SceneKit
//import UIKit
//
//// 3D model of the bedroom
//struct SceneView: UIViewRepresentable {
//    
//    @State private var scene: SCNScene? = nil
//    
//    // function create the viewport with the controls and lighting
//    func makeUIView(context: Context) -> SCNView {
//        let view = SCNView()
//        view.allowsCameraControl = true
//        view.autoenablesDefaultLighting = true
//        view.antialiasingMode = .multisampling2X
//        view.scene = scene
//        view.backgroundColor = .clear
//                
//        return view
//    }
//    
//    // function to update the viewport
//    func updateUIView(_ uiView: SCNView, context: Context) {
//        if let scene = scene {
//            uiView.scene = scene
//        }
//    }
//    
//    // function to set up the 3D scene
//    private func setupScene(_ scene: SCNScene, in view: SCNView) {
//        setupCamera(for: scene)
//        //addRotation(to: scene)
//        scene.rootNode.scale = SCNVector3(0.3, 0.3, 0.3)
//        view.scene = scene
//    }
//    
//    // function to set up the camera
//    private func setupCamera(for scene: SCNScene) {
//        let cameraNode = SCNNode()
//        cameraNode.camera = SCNCamera()
//        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
//        scene.rootNode.addChildNode(cameraNode)
//    }
//}
//
//#Preview {
//    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
//}
