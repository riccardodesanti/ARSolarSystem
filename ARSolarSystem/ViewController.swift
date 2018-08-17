//
//  ViewController.swift
//  ARSolarSystem
//
//  Created by Riccardo De Santi on 18/08/2018.
//  Copyright © 2018 Riccardo De Santi. All rights reserved.
//

import UIKit
import ARKit

struct MotionParams {
    let x: CGFloat
    let y: CGFloat
    let z: CGFloat
    let duration: TimeInterval
}

class ViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let solarSystem = SCNScene()
        
        createPlanetLayer(radius: 0.11, img: #imageLiteral(resourceName: "sun"), zDelta: 0, rot: MotionParams(x: 0, y: 1, z: 0, duration: 1), rev: MotionParams(x: 0, y: 0, z: 0, duration: 1), scene: solarSystem, satellite: false)
        createPlanetLayer(radius: 0.01, img: #imageLiteral(resourceName: "mercury"), zDelta: 0.18, rot: MotionParams(x: 0, y: 1, z: 0, duration: 5), rev: MotionParams(x: 0, y: 1, z: 0, duration: 2), scene: solarSystem, satellite: false)
        createPlanetLayer(radius: 0.03, img: #imageLiteral(resourceName: "venus"), zDelta: 0.28, rot: MotionParams(x: 0, y: 1, z: 0, duration: 10), rev: MotionParams(x: 0, y: 1, z: 0, duration: 4), scene: solarSystem, satellite: false)
        createPlanetLayer(radius: 0.03, img: #imageLiteral(resourceName: "earth"), zDelta: 0.39, rot: MotionParams(x: 0, y: 1, z: 0, duration: 0.5), rev: MotionParams(x: 0, y: 1, z: 0, duration: 5), scene: solarSystem, satellite: true)
        createPlanetLayer(radius: 0.015, img: #imageLiteral(resourceName: "mars"), zDelta: 0.49, rot: MotionParams(x: 0, y: 1, z: 0, duration: 1), rev: MotionParams(x: 0, y: 1, z: 0, duration: 7), scene: solarSystem, satellite: false)
        createPlanetLayer(radius: 0.06, img: #imageLiteral(resourceName: "jupiter"), zDelta: 0.65, rot: MotionParams(x: 0, y: 1, z: 0, duration: 0.5), rev: MotionParams(x: 0, y: 1, z: 0, duration: 11), scene: solarSystem, satellite: false)
        createPlanetLayer(radius: 0.045, img: #imageLiteral(resourceName: "saturn"), zDelta: 0.79, rot: MotionParams(x: 0, y: 1, z: 0, duration: 0.5), rev: MotionParams(x: 0, y: 1, z: 0, duration: 18), scene: solarSystem, satellite: false)
        createPlanetLayer(radius: 0.02, img: #imageLiteral(resourceName: "uranus"), zDelta: 0.88, rot: MotionParams(x: 0, y: 1, z: 0, duration: 0.7), rev: MotionParams(x: 0, y: 1, z: 0, duration: 35), scene: solarSystem, satellite: false)
        createPlanetLayer(radius: 0.02, img: #imageLiteral(resourceName: "neptune"), zDelta: 0.96, rot: MotionParams(x: 0, y: 1, z: 0, duration: 0.9), rev: MotionParams(x: 0, y: 1, z: 0, duration: 50), scene: solarSystem, satellite: false)
        createPlanetLayer(radius: 0.005, img: #imageLiteral(resourceName: "pluto"), zDelta: 1.01, rot: MotionParams(x: 0, y: 1, z: 0, duration: 3), rev: MotionParams(x: 0, y: 1, z: 0, duration: 70), scene: solarSystem, satellite: false)
        
        sceneView.scene = solarSystem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func createPlanetLayer(radius: CGFloat, img: UIImage, zDelta: Float, rot: MotionParams, rev: MotionParams, scene: SCNScene, satellite: Bool) {
        //Definition of  rotation ( counter-clockwise for every planet except Venus and Uranus)
        let RotationAction = SCNAction.rotateBy(x: rot.x, y: rot.y, z: rot.z, duration: rot.duration)
        let RotationLoop = SCNAction.repeatForever(RotationAction)
        
        
        //Defines and activates revolutionary motion ( with different period for each planet)
        let revolutionAction = SCNAction.rotateBy(x: rev.x, y: rev.y, z: rev.z, duration: rev.duration)
        let revolutionLoop = SCNAction.repeatForever(revolutionAction)
        
        // Planet 1 creation
        //Creation of the node/layer used for the revolutionary motion ( this node rotates around its own y axis)
        let planetLayer = SCNNode()
        planetLayer.position = SCNVector3(0,0,0)
        
        // Creation of the Sphere Objects and its relative node later added to the layer just created.
        let planet = SCNSphere(radius: radius)
        let planetMaterial = SCNMaterial()
        planetMaterial.diffuse.contents = img
        planet.materials = [planetMaterial]
        let planetNode = SCNNode(geometry: planet)
        planetNode.position = SCNVector3(0,0,zDelta)
        planetLayer.addChildNode(planetNode)
        
        //Activates rotational motion ( same for each planet for semplification purposes )
        planetNode.runAction(RotationLoop)
        planetLayer.runAction(revolutionLoop)
        
        //Creates moon and makes it rev around the earth
        if (satellite) {
            //Definition of  rotation ( counter-clockwise for every planet except Venus and Uranus)
            let RotationActionSatellite = SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 2.8)
            let RotationLoopSatellite = SCNAction.repeatForever(RotationActionSatellite)
            
            
            //Defines and activates revolutionary motion ( with different period for each planet)
            let revolutionActionSatellite = SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 3)
            let revolutionLoopSatellite = SCNAction.repeatForever(revolutionActionSatellite)
            
            let satelliteLayer = SCNNode()
            satelliteLayer.position = SCNVector3(0,0,0)
            
            let satellite = SCNSphere(radius: 0.006)
            let satelliteMaterial = SCNMaterial()
            satelliteMaterial.diffuse.contents = #imageLiteral(resourceName: "moon")
            satellite.materials = [satelliteMaterial]
            let satelliteNode = SCNNode(geometry: satellite)
            satelliteNode.position = SCNVector3(0,0,0.04)
            satelliteLayer.addChildNode(satelliteNode)
            
            //Activates rotational motion ( same for each planet for semplification purposes )
            satelliteNode.runAction(RotationLoopSatellite)
            satelliteLayer.runAction(revolutionLoopSatellite)
            
            //Makes it rev around the earth
            planetNode.addChildNode(satelliteLayer)
        }
        
        scene.rootNode.addChildNode(planetLayer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



