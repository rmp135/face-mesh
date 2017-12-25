//
//  Utilities.swift
//  face-mesh
//
//  Created by Ryan Poole on 24/12/2017.
//  Copyright © 2017 Ryan Poole. All rights reserved.
//

import SceneKit
import ARKit

class Utilities {
    func exportToCollada(geometry: ARFaceGeometry) -> String {
        let verticesText = geometry.vertices.map { vertex in String(vertex.x) + " " + String(vertex.y) + " " + String(vertex.z) }.joined(separator: " ")
        
        var templateText = ""
        
        let path = Bundle.main.path(forResource: "Template", ofType: "txt")
        
        do {
            try templateText = String(contentsOfFile: path!)
        } catch  {
            
        }
        
        templateText = templateText.replacingOccurrences(of: "{{VERTEX_POSITIONS}}", with: verticesText)
        
        let date = Date()
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        templateText = templateText.replacingOccurrences(of: "{{DATE}}", with: formatter.string(from: date))
        
        return templateText
    }

    func vertices(node:SCNNode) -> [SCNVector3] {
        let vertexSources = node.geometry?.sources(for: SCNGeometrySource.Semantic.vertex)
        if let vertexSource = vertexSources?.first {
            let count = vertexSource.data.count / MemoryLayout<SCNVector3>.size
            return vertexSource.data.withUnsafeBytes {
                [SCNVector3](UnsafeBufferPointer<SCNVector3>(start: $0, count: count))
            }
        }
        return []
    }
}
