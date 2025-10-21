
# LiquidVision

## Overview
LiquidVision is a SwiftUI iOS application that classifies images with Core ML and instantly evaluates the sentiment of the predicted label using Apple’s Natural Language framework. The experience is presented through a lightweight MVVM-C architecture to keep UI, state, and navigation responsibilities clearly separated.

## Tech Stack
- Swift 5.10
- SwiftUI & PhotosUI
- Core ML (MobileNetV2)
- Apple Natural Language (NLTagger + Sentiment)
- Vision (VNCoreMLRequest)
- XCTest

## Architecture
LiqudVision follows an MVVM-C pattern:
- **Model / Services**: `ImageClassificationServicing` and `SentimentAnalysisServicing` encapsulate ML and NLP work.
- **ViewModel**: `ClassificationViewModel` and `SentimentViewModel` own async state, translate service results into user-facing strings, and expose observable properties.
- **View**: SwiftUI views render state and user interactions with minimal logic.
- **Coordinator**: `AppCoordinator`, `ClassificationCoordinator`, and `SentimentCoordinator` compose view models, manage navigation, and coordinate feature flows.

This split keeps business logic testable and the view layer declarative.

## Project Structure
```
LiquidVision/
├── Coordinators/
│   ├── AppCoordinator.swift
│   ├── ClassificationCoordinator.swift
│   └── SentimentCoordinator.swift
├── Services/
│   ├── ImageClassificationService.swift
│   └── SentimentAnalysisService.swift
├── ViewModels/
│   ├── Classification/
│   │   └── ClassificationViewModel.swift
│   └── Sentiment/
│       └── SentimentViewModel.swift
├── Views/
│   ├── Classification/
│   │   └── ClassificationView.swift
│   ├── Sentiment/
│   │   └── SentimentView.swift
│   └── Shared/
│       └── CameraView.swift
├── LiquidVisionApp.swift
└── Assets, ML model, and supporting files
```

Unit and UI tests live under `LiquidVisionTests/` and `LiquidVisionUITests/`.

## Features
- **Image Classification**: Pick or capture a photo and run MobileNetV2 inference with Vision + Core ML.
- **Sentiment Insight**: Analyze the predicted label’s sentiment asynchronously and surface score + polarity.
- **Camera Support**: SwiftUI-friendly `CameraView` wrapper for `UIImagePickerController`.
- **Theming**: Gradient-backed, glassmorphism-inspired UI shared across features.
- **MVVM-C Navigation**: Tab-based experience composed via coordinators for modularity.

## Example Usage
1. Launch LiquidVision on an iOS 16+ device or simulator.
2. Select **Vision** tab (default) and tap **Choose Photo** to pick from the library or **Capture Photo** to use the camera.
3. After the image is classified, review the predicted label, confidence, and sentiment summary for that prediction.
4. Switch to the **Sentiment** tab to manually enter text and analyze its polarity using the Natural Language framework.

## Testing
All critical layers are covered with XCTest:

```bash
xcodebuild test \
  -scheme LiquidVision \
  -destination 'platform=iOS Simulator,name=iPhone 15 Pro' \
  -enableCodeCoverage YES
```

Unit tests validate view-model behaviors, service error handling, and async flows; UI tests are currently skipped while the interface evolves. Review the generated coverage report in Xcode’s Report navigator to ensure the project stays above the 60% target.
