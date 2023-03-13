//
//  ContentView.swift
//  Instafilter
//
//  Created by artembolotov on 07.03.2023.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State private var image: Image?
    
    @State private var filterIntensity = 0.5
    @State private var filterRadius = 0.5
    @State private var filterScale = 0.5
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    
    @State private var currentFilter: CIFilter = CIFilter.vignette()
    let context = CIContext()
    
    @State private var showingFilterSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack(alignment: .bottom) {
                    GeometryReader { proxy in
                        ZStack {
                            Rectangle()
                                .fill(.secondary)
                            
                            Text("Tap to select a picture")
                                .foregroundColor(.white)
                                .font(.headline)
                            
                            image?
                                .resizable()
                                .scaledToFill()
                                .frame(width: proxy.size.width - 16)
                                .clipped()
                        }
                        .padding(8)
                        .onTapGesture {
                             showingImagePicker = true
                        }
                    }
                    
                    if currentFilter.inputKeys.contains(where: ["inputIntensity", "inputRadius", "inputScale"].contains) {
                        
                        VStack {
                            if currentFilter.inputKeys.contains("inputIntensity") {
                                HStack {
                                    Text("Intensity")
                                    Slider(value: $filterIntensity)
                                        .onChange(of: filterIntensity) { _ in applyProcessing() }
                                }
                            }
                    
                            if currentFilter.inputKeys.contains("inputRadius") {
                                HStack {
                                    Text("Radius")
                                    Slider(value: $filterRadius)
                                        .onChange(of: filterRadius) { _ in applyProcessing()}
                                }
                            }
                    
                            if currentFilter.inputKeys.contains("inputScale") {
                                HStack {
                                    Text("Scale")
                                    Slider(value: $filterScale)
                                        .onChange(of: filterScale) { _ in applyProcessing()}
                                }
                            }
                        }
                        .padding()
                        .background(.ultraThickMaterial)
                    }
                }
                
                HStack {
                    Button("Change filter") {
                        showingFilterSheet = true
                    }
                    
                    Spacer()
                    
                    Button("Save", action: save)
                        .disabled(processedImage == nil)
                }
                .padding([.horizontal])
            }
            .padding(.bottom)
            .navigationTitle("Instafilter")
            .onChange(of: inputImage) { _ in loadImage() }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .confirmationDialog("Select a filter", isPresented: $showingFilterSheet) {
                Group {
                    Button("Crystallize") { setFilter(CIFilter.crystallize()) }
                    Button("Edges") { setFilter(CIFilter.edges() ) }
                    Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
                    Button("Pixelate") { setFilter(CIFilter.pixellate()) }
                    Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
                    Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
                }
                Button("Vignette") { setFilter(CIFilter.vignette()) }
                Button("Thermal") { setFilter(CIFilter.thermal()) }
                Button("Tonal") { setFilter(CIFilter.photoEffectTonal()) }
                Button("xRay") { setFilter(CIFilter.xRay()) }
                Button("Cancel", role: .cancel) { }
            }
        }
    }
    
    func loadImage() {
        guard let inputImage else { return }
        
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func save() {
        guard let processedImage else { return }
        
        let imageSaver = ImageSaver()
        
        imageSaver.sucessHandler = {
            print("Saved successeflly")
        }
        
        imageSaver.errorHandler = {
            print("Oops! \($0.localizedDescription)")
        }
        
        imageSaver.writeToPhotoAlbum(image: processedImage)
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterRadius * 200, forKey: kCIInputRadiusKey)
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(filterScale * 10, forKey: kCIInputScaleKey)
        }
        
        guard let outputImege = currentFilter.outputImage else { return }
        
        if let cgImg = context.createCGImage(outputImege, from: outputImege.extent) {
            let uiImage = UIImage(cgImage: cgImg)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }
    
    func setFilter(_ filter: CIFilter) {
        guard currentFilter.name != filter.name else { return }
        
        currentFilter = filter
        resetSliders()
        
        loadImage()
    }
    
    func resetSliders() {
        filterIntensity = 0.5
        filterRadius = 0.5
        filterScale = 0.5
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
