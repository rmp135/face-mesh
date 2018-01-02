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
    func exportToSTL(geometry: ARFaceGeometry) -> String {
    
        var vertexIndex = 0
        
        var faces: [[vector_float3]] = [[]]
        
        for i in 0..<geometry.triangleIndices.count {
            if ((i / 3) != vertexIndex) {
                faces.append([])
                vertexIndex = i / 3
            }
            faces[vertexIndex].append(geometry.vertices[Int(geometry.triangleIndices[i])])
        }
        
        var text = "solid Exported from face-mesh"
        text += faces.map { v in "\nfacet normal 0 0 0\nouter loop\nvertex \(v[0].x) \(v[0].y) \(v[0].z)\nvertex \(v[1].x) \(v[1].y) \(v[1].z)\nvertex \(v[2].x) \(v[2].y) \(v[2].z)\nendloop\nendfacet" }.joined(separator: "")
        text += "\nendsolid Exported from face-mesh"
        return text
    }
    
    func framesToBuffer(frames: [[vector_float3]]) -> Data {
        var data = Data()
        for frame in frames {
            data.append(UnsafeBufferPointer(start: frame, count: frame.count))
        }
        return data
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
