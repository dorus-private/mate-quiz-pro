//
//  Lautstärke.swift
//  Math Quiz Pro IOS
//
//  Created by Leon Șular on 08.12.23.
//


import Foundation
import AVFoundation
import SwiftUI

class MicrophoneMonitor: ObservableObject {
    
    // 1
    var audioRecorder: AVAudioRecorder
    private var timer: Timer?
    
    private var currentSample: Int
    private let numberOfSamples: Int
    
    // 2
    @Published public var soundSamples: [Float]
    
    init(numberOfSamples: Int) {
        self.numberOfSamples = numberOfSamples // In production check this is > 0.
        self.soundSamples = [Float](repeating: .zero, count: numberOfSamples)
        self.currentSample = 0
        
        // 3
        let audioSession = AVAudioSession.sharedInstance()
        if audioSession.recordPermission != .granted {
            audioSession.requestRecordPermission { (isGranted) in
                if !isGranted {
                    
                }
            }
        }
        
        // 4
        let url = URL(fileURLWithPath: "/dev/null", isDirectory: true)
        let recorderSettings: [String:Any] = [
            AVFormatIDKey: NSNumber(value: kAudioFormatAppleLossless),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue
        ]
        
        // 5
        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: recorderSettings)
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [])
            
            startMonitoring()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    // 6
    func startMonitoring() {
        audioRecorder.isMeteringEnabled = true
        audioRecorder.record()
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in
            // 7
            self.audioRecorder.updateMeters()
            self.soundSamples[self.currentSample] = self.audioRecorder.averagePower(forChannel: 0)
            self.currentSample = (self.currentSample + 1) % self.numberOfSamples
        })
    }
    
    // 8
    deinit {
        stopRecorder()
    }
    
    func stopRecorder() {
        timer?.invalidate()
        audioRecorder.stop()
    }
}

var numberOfSamples: Int = 10

struct BarView: View {
   // 1
    var value: CGFloat

    var body: some View {
        ZStack {
           // 2
            RoundedRectangle(cornerRadius: 20)
                // 3
                .frame(width: (UIScreen.main.bounds.width - CGFloat(numberOfSamples) * 4) / CGFloat(numberOfSamples), height: value)
        }
    }
}

struct Lautstärke: View {
    // 1
    @ObservedObject private var mic = MicrophoneMonitor(numberOfSamples: numberOfSamples)
    @State var db = 0
    @State var color: Color = .green
    @State var intensivität: Double = 1
    @AppStorage("intensivität") var intensivitätStorage: Double = 1
    @AppStorage("task") private var task = "lautstärke"
    @AppStorage("lautstärkeFarbe") private var lautstärkeFarbe = 0
    let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    
    // 2
    private func normalizeSoundLevel(level: Float) -> CGFloat {
        let level = max(0.2, CGFloat(level) + 50) / 2 // between 0.1 and 25
        
        return CGFloat(level * (300 / 25)) // scaled to max at 300 (our height of our bar)
    }
    
    var body: some View {
        VStack {
            Text("Stellen Sie die Empfindlichkeit der Lautstärke Messung ein")
                .multilineTextAlignment(.center)
                .padding(20)

            Slider(value: $intensivität, in: 1...10, step: 1)
                .padding()
            if UIDevice.current.userInterfaceIdiom == .pad {
                HStack {
                    ForEach(0...9, id: \.self) { value in
                        Text("\(10 - value)")
                            .frame(width: UIScreen.main.bounds.width / 10.7)
                    }
                }
            }
            Spacer()
                .frame(height: 10)
            HStack {
                Spacer()
                    .frame(width: 20)
                Text("Sehr empfindlich")
                Spacer()
                Text("Kaum empfindlich")
                Spacer()
                    .frame(width: 20)
            }
            Spacer()
            HStack(spacing: 4) {
                 // 4
                Spacer()
                    .frame(width: 20)
                ForEach(mic.soundSamples, id: \.self) { level in
                    VStack {
                        BarView(value: self.normalizeSoundLevel(level: level))
                            .foregroundColor(color)
                    }
                }
                Spacer()
                    .frame(width: 20)
            }
            .onAppear {
                task = "lautstärke"
                captureAudio()
            }
            .onReceive(timer) { time in
                intensivitätStorage = intensivität
            }
            Spacer()
            HStack {
                Image(systemName: "info.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.blue)
                Text("Auf dem externen Bildschirm wird eine Lautstärke Ampel angezeigt")
                    .padding(20)
            }
        }
    }
    
    private func captureAudio() {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilename = documentPath.appendingPathComponent("recording.m4a")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            let audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()
            audioRecorder.isMeteringEnabled = true
            
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                audioRecorder.updateMeters()
                db = Int(audioRecorder.averagePower(forChannel: 0))
                let level = 70 / Int(intensivität * 3)
                if db < level * -2 {
                    color = .green
                    lautstärkeFarbe = 0
                } else if db > level * -2 && db < -1 * level {
                    color  = .yellow
                    lautstärkeFarbe = 1
                } else {
                    color = .red
                    lautstärkeFarbe = 2
                }
            }
        } catch {
            print("ERROR: Failed to start recording process.")
        }
    }
}

struct LautstärkeAmpel: View {
    @AppStorage("lautstärkeFarbe") var lautstärkeFarbe1 = 0
    @State var lautstärkeFarbe = "green"
    let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: (geo.size.width - 100) / 1.5, height: geo.size.height / 3)
                        Spacer()
                    }
                    Spacer()
                        .frame(height: 120)
                    Spacer()
                }
                HStack {
                    Spacer()
                    Circle()
                        .frame(width: geo.size.height / 3 - 150, height: geo.size.height - 150)
                        .foregroundColor(.red)
                        .opacity(lautstärkeFarbe == "red" ? 1 : 0.5)
                    Spacer()
                        .frame(width: 100)
                    Circle()
                        .frame(width: geo.size.height / 3 - 150, height: geo.size.height - 150)
                        .foregroundColor(.yellow)
                        .opacity(lautstärkeFarbe == "yellow" ? 1 : 0.5)
                    Spacer()
                        .frame(width: 100)
                    Circle()
                        .frame(width: geo.size.height / 3 - 150, height: geo.size.height - 150)
                        .foregroundColor(.green)
                        .opacity(lautstärkeFarbe == "green" ? 1 : 0.5)
                    Spacer()
                }
            }
        }
        .onReceive(timer) { time in
            if lautstärkeFarbe1 == 0 {
                lautstärkeFarbe = "green"
            } else if lautstärkeFarbe1 == 1 {
                lautstärkeFarbe = "yellow"
            } else {
                lautstärkeFarbe = "red"
            }
        }
    }
}
