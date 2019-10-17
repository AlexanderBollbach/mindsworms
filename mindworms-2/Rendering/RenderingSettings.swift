
import Foundation
import CoreGraphics

struct RenderingEnvironment {
    let context: CGContext
    let transform: Transform
    let rect: CGRect
}

func lowResRE() -> RenderingEnvironment {

    let s = 50
    
    let context = CGContext(
        data: nil,
        width: s,
        height: s,
        bitsPerComponent: 8,
        bytesPerRow: 4 * s,
        space: CGColorSpaceCreateDeviceRGB(),
        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )!
    
    let rect = CGRect(
        x: 0,
        y: 0,
        width: s,
        height: s
    )
    
    return RenderingEnvironment(context: context, transform: Transform(), rect: rect)
}

func defaultRE() -> RenderingEnvironment {
    
    let exportSettings = ProjectSettings()
    
    let context = CGContext(data: nil,
                            width: exportSettings.canvasWidth,
                            height: exportSettings.canvasHeight,
                            bitsPerComponent: 8,
                            bytesPerRow: 4 * exportSettings.canvasWidth,
                            space: CGColorSpaceCreateDeviceRGB(),
                            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
    
    let rect = CGRect(
        x: 0,
        y: 0,
        width: exportSettings.canvasWidth,
        height: exportSettings.canvasHeight
    )
    
    return RenderingEnvironment(context: context, transform: Transform(), rect: rect)
}
