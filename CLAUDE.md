# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

MoneyCounter is a native iOS/iPadOS app built with SwiftUI for counting money denominations. It uses SwiftData for persistence and follows modern Apple development patterns.

## Build Commands

```bash
# Build the project
xcodebuild -project MoneyCounter.xcodeproj -scheme MoneyCounter -configuration Debug build

# Run tests
xcodebuild test -project MoneyCounter.xcodeproj -scheme MoneyCounter -destination 'platform=iOS Simulator,name=iPhone 15'

# Clean build folder
xcodebuild -project MoneyCounter.xcodeproj -scheme MoneyCounter clean

# Build for release/archive
xcodebuild archive -project MoneyCounter.xcodeproj -scheme MoneyCounter -archivePath ./build/MoneyCounter.xcarchive

# For development, use Xcode IDE:
open MoneyCounter.xcodeproj
```

## Architecture

### Core Technologies
- **SwiftUI** - Declarative UI framework
- **SwiftData** - Modern persistence framework (requires iOS 17+)
- **Swift** - Primary language

### Key Architectural Patterns
1. **Tab-based Navigation**: MainView.swift coordinates between CounterView and HistoryView
2. **SwiftData Models**: History and Denomination models with cascade delete relationships
3. **State Management**: SwiftUI's @State, @Query, and @Environment for data flow
4. **Component Reusability**: DenominationRow is the primary reusable component

### Data Flow
- CounterView creates/updates History instances with associated Denominations
- HistoryView queries saved History records using SwiftData's @Query
- Denominations are managed as a collection within each History instance

### Key Implementation Details

**Currency Handling**: All monetary values are stored in cents (integers) to avoid floating-point precision issues:
```swift
static let denominations = [10000, 5000, 2000, 1000, 500, 200, 100, 25, 10, 5] // cents
```

**Focus Management**: Custom keyboard navigation implemented in ViewExtension.swift allows up/down arrow navigation between denomination fields.

**Auto-save**: CounterView automatically saves the current count as a History entry when modified.

## Development Notes

When modifying this codebase:
1. Maintain the cents-based integer arithmetic for all monetary calculations
2. Test keyboard navigation when adding new input fields
3. Ensure SwiftData relationships are properly configured when modifying models
4. Use SwiftUI previews (Preview Content folder) for rapid UI development
5. Follow existing patterns for state management and data flow