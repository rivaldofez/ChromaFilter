//
//  MetalRenderView.swift
//  ChromaFilter
//
//  Created by Rivaldo Fernandes on 17/12/23.
//

import MetalKit
import CoreImage

class MetalRenderView: MTKView {
    private lazy var commandQueue: MTLCommandQueue? = {
        return device?.makeCommandQueue()
    }()
    
    private lazy var ciContext: CIContext? = {
        guard let device = device else { return nil }
        return CIContext(mtlDevice: device)
    }()
    
    private var image: CIImage? {
        didSet {
            renderImage()
        }
    }
    
    override init(frame frameRect: CGRect, device: MTLDevice?) {
        super.init(frame: frameRect, device: device)
        
        if super.device == nil {
            fatalError("Metal is not supported by this device")
        }
        framebufferOnly = false
    }
    
    func setImage(_ image: CIImage?) {
        guard let image = image else { return }
        self.image = image
    }
    
    func getImage() -> CIImage? {
        return self.image
    }
    
    private func renderImage() {
        guard let image = image,
              let currentDrawable = currentDrawable,
              let ciContext = ciContext else { return }
        
        let commandBuffer = commandQueue?.makeCommandBuffer()
        let destination = CIRenderDestination(width: Int(drawableSize.width),
                                              height: Int(drawableSize.height),
                                              pixelFormat: .rgba8Unorm,
                                              commandBuffer: commandBuffer) { () -> MTLTexture in
            return currentDrawable.texture
        }
        
        do {
            try ciContext.startTask(toRender: image.transformToOrigin(withSize: drawableSize), to: destination)
        } catch {
            fatalError("cannot transform image to new format")
        }
        
        commandBuffer?.present(currentDrawable)
        commandBuffer?.commit()
        draw()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
