
import Foundation
import CoreGraphics

struct RenderingEnvironment {
    let context: CGContext
    var transform: Transform
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

func re(from project: R_Project) -> RenderingEnvironment {
    
    let w = Int(project.settings.width * 500)
    let h = Int(project.settings.height * 500)

    let context = CGContext(data: nil,
                            width: w,
                            height: h,
                            bitsPerComponent: 8,
                            bytesPerRow: 4 * w,
                            space: CGColorSpaceCreateDeviceRGB(),
                            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!

    let rect = CGRect(
        x: 0,
        y: 0,
        width: w,
        height: h
    )

    return RenderingEnvironment(context: context, transform: project.transform, rect: rect)
}

func defaultRE() -> RenderingEnvironment {
    
    let w = 100
    let h = 100

    let context = CGContext(data: nil,
                            width: w,
                            height: h,
                            bitsPerComponent: 8,
                            bytesPerRow: 4 * w,
                            space: CGColorSpaceCreateDeviceRGB(),
                            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!

    let rect = CGRect(
        x: 0,
        y: 0,
        width: w,
        height: h
    )

    return RenderingEnvironment(context: context, transform: Transform(), rect: rect)
}
