/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Main view controller for the AR experience.
*/

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {

    @IBOutlet weak var sessionInfoView: UIView!
	@IBOutlet weak var sessionInfoLabel: UILabel!
	@IBOutlet weak var sceneView: ARSCNView!
    var planes = NSMutableDictionary()
    var cubes = NSMutableArray()
    var enemies = NSMutableArray()
    var game = GameModel()
    
	// MARK: - View Life Cycle
	
    /// - Tag: StartARSession
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard ARWorldTrackingConfiguration.isSupported else {
          fatalError("""
            ARKit is not available on this device. For apps that require ARKit
            for core functionality, use the `arkit` key in the key in the
            `UIRequiredDeviceCapabilities` section of the Info.plist to prevent
            the app from installing. (If the app can't be installed, this error
            can't be triggered in a production scenario.)
            In apps where AR is an additive feature, use `isSupported` to
            determine whether to show UI for launching AR experiences.
          """) // For details, see https://developer.apple.com/documentation/arkit
        }

        setup()
    }
  
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Pause the view's AR session.
        sceneView.session.pause()
    }
  
    // MARK: - Scene Node Interntion

    func setup(){
        /*
         Start the view's AR session with a configuration that uses the rear camera,
         device position and orientation tracking, and plane detection.
         */
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        
        // Set a delegate to track the number of plane anchors for providing UI feedback.
        sceneView.session.delegate = self
        
        /*
         Prevent the screen from being dimmed after a while as users will likely
         have long periods of interaction without touching the screen or buttons.
         */
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Show debug UI to view performance metrics (e.g. frames per second).
        sceneView.showsStatistics = true
        setupTapRecognizers()
    }
    
    func setupTapRecognizers(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.insertCube(_:)))
        sceneView.addGestureRecognizer(tapGesture)
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.throwCube(_:)))
        longGesture.minimumPressDuration = 0.5
        sceneView.addGestureRecognizer(longGesture)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.removeEnemy(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        sceneView.addGestureRecognizer(doubleTapGesture)
    }
    
    func spawn(){
        guard game.enemyCount <= game.maxEnemies else { return }
        
        let pov = sceneView.pointOfView!
        let y = (Float(arc4random_uniform(30)) - 29) * 0.01 // Random Y Value between -0.3 and 0.3

        //Random X and Z value around the circle
        let xRad = ((Float(arc4random_uniform(361)) - 180)/180) * Float.pi
        let zRad = ((Float(arc4random_uniform(361)) - 180)/180) * Float.pi
        let length = Float(arc4random_uniform(6) + 4) * -0.3
        let x = length * sin(xRad)
        let z = length * cos(zRad)
        let position = SCNVector3Make(x, y, z)
        let worldPosition = pov.convertPosition(position, to: nil)

        game.addEnemy()
        
        let enemy = Enemy()
        enemy.placeAtPosition(position: worldPosition)
        enemies.add(enemy)
        sceneView.scene.rootNode.addChildNode(enemy)
        
    }
    
    func removee(enemy: Enemy){
        print("in remove")
        enemy.removeFromParentNode()
        game.removeEnemy()
        
    }
    
    @IBAction
    func insertCube(_ sender: UITapGestureRecognizer){
        let tapLocation = sender.location(in: sceneView);
        let result = sceneView.hitTest(tapLocation, types: ARHitTestResult.ResultType.existingPlaneUsingExtent)

        if (result.count == 0) {
          return
        }
        
        let hitResult = result.first
        let insertionOffset = 0.5
        let position = SCNVector3Make(
          (hitResult?.worldTransform.columns.3.x)!,
          (hitResult?.worldTransform.columns.3.y)! + Float(insertionOffset),
          (hitResult?.worldTransform.columns.3.z)!
        )

        let cube = Cube()
        cube.placeAtPosition(position: position)
        cubes.add(cube)
        sceneView.scene.rootNode.addChildNode(cube)
    }
    
    @IBAction
    func removeEnemy(_ sender: UITapGestureRecognizer){
        //guard enemies[0] is Enemy else{ return }
        removee(enemy: enemies[0] as! Enemy)
        enemies.removeObject(at: 0)
        
    }
    
    @IBAction
    func throwCube(_ sender: UILongPressGestureRecognizer){
        if (sender.state == UIGestureRecognizerState.ended) {
            let (direction, position) = self.getUserVector()
            let cube = Cube()
            print(position, direction)
            cube.throwCube(position: position, direction: direction)
            cubes.add(cube)
          
            sceneView.scene.rootNode.addChildNode(cube)
        }
    }
  
    //MARK - Helpers
  
    func getUserVector() -> (SCNVector3, SCNVector3) { // (direction, position)
        if let frame = self.sceneView.session.currentFrame {
            let mat = SCNMatrix4(frame.camera.transform) // 4x4 transform matrix describing camera in world space
            let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33) // orientation of camera in world space
            let pos = SCNVector3(mat.m41, mat.m42, mat.m43) // location of camera in world space

            return (dir, pos)
        }
        return (SCNVector3(0, 0, -1), SCNVector3(0, 0, -0.2))
    }
  
    // MARK: - ARSCNViewDelegate

    /// - Tag: PlaceARContent
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // Place content only for anchors found by plane detection.
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }

        let plane = Plane()
        plane.initPlane(anchor: planeAnchor, isHidden: false)

        planes.setObject(plane, forKey: planeAnchor.identifier as NSCopying)
        node.addChildNode(plane)
    }

    /// - Tag: UpdateARContent
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        // Update content only for plane anchors and nodes matching the setup created in `renderer(_:didAdd:for:)`.
        guard let planeAnchor = anchor as?  ARPlaneAnchor else { return }

        let plane = self.planes.object(forKey: planeAnchor.identifier) as! Plane

        plane.update(anchor:planeAnchor)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if game.isTimeToSpawn() {
            spawn()
        }
        game.incSpawn()
    }
    
    // MARK: - ARSessionDelegate

    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        guard let frame = session.currentFrame else { return }
        updateSessionInfoLabel(for: frame, trackingState: frame.camera.trackingState)
    }

    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        guard let frame = session.currentFrame else { return }
        updateSessionInfoLabel(for: frame, trackingState: frame.camera.trackingState)
    }

    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        updateSessionInfoLabel(for: session.currentFrame!, trackingState: camera.trackingState)
    }

    // MARK: - ARSessionObserver

    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay.
        sessionInfoLabel.text = "Session was interrupted"
    }

    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required.
        sessionInfoLabel.text = "Session interruption ended"
        resetTracking()
    }

    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user.
        sessionInfoLabel.text = "Session failed: \(error.localizedDescription)"
        resetTracking()
    }

    // MARK: - Private methods

    private func updateSessionInfoLabel(for frame: ARFrame, trackingState: ARCamera.TrackingState) {
        // Update the UI to provide feedback on the state of the AR experience.
        let message: String

        switch trackingState {
        case .normal where frame.anchors.isEmpty:
            // No planes detected; provide instructions for this app's AR interactions.
            message = "Move the device around to detect horizontal surfaces."
          
        case .normal:
            // No feedback needed when tracking is normal and planes are visible.
            message = ""
          
        case .notAvailable:
            message = "Tracking unavailable."
          
        case .limited(.excessiveMotion):
            message = "Tracking limited - Move the device more slowly."
          
        case .limited(.insufficientFeatures):
            message = "Tracking limited - Point the device at an area with visible surface detail, or improve lighting conditions."
          
        case .limited(.initializing):
            message = "Initializing AR session."
          
        }

        sessionInfoLabel.text = message
        sessionInfoView.isHidden = message.isEmpty
    }

    private func resetTracking() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
}
