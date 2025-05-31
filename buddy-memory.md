Buddy Memory Plan 

Phase 1: Setting Up the Conversational LiveKit Agent Backend
This phase establishes a simple conversational core for your voice agent using the LiveKit Agents framework. The focus is on real-time speech processing and basic AI interaction, not complex agentic behavior.

**Goal:** Deploy a basic conversational LiveKit agent that connects to a LiveKit server and greets the user.

**Steps:**

1.  **Set up LiveKit Server on Hostinger VPS:**
    *   Since you're using your Hostinger VPS for development, we will set up a self-hosted LiveKit server there.
    *   This will likely involve installing Docker and Docker Compose on your VPS (if not already present) and then using the official LiveKit Docker Compose configuration to deploy the LiveKit server and its dependencies (like Postgres and Redis).
    *   We will need to configure the LiveKit server with appropriate network settings to be accessible.
    *   **Action:** Install Docker and Docker Compose on VPS (if needed), deploy LiveKit server using Docker Compose, configure network access.

2.  **Prepare Development Environment on Hostinger VPS:**
    *   Connect to your Hostinger VPS via SSH.
    *   Create a directory for your Buddy Agent project.
    *   Clone or transfer the necessary files for your agent code into this directory.
    *   **Action:** SSH into VPS, create project directory, transfer agent code files.

3.  **Install and Configure `livekit-agents` and OpenAI Plugin:**
    *   Within your agent project directory on the VPS, create a Python virtual environment.
    *   Install the `livekit-agents` library and the OpenAI plugin using pip.
    *   Configure environment variables for `LIVEKIT_URL`, `LIVEKIT_API_KEY`, `LIVEKIT_API_SECRET` (obtained from your LiveKit server setup), and `OPENAI_API_KEY` (your key). These will be used by your agent code.
    *   **Action:** Create virtual environment, install `livekit-agents` and OpenAI plugin, set environment variables.

4.  **Write Initial Agent Logic (Simple Voice Agent):**
    *   Create a Python file (e.g., `buddy_agent.py`) for your agent's core logic, based on the "Simple Voice Agent" example in the `livekit-agents` README.
    *   Use the `livekit-agents` framework to define an agent that connects to the LiveKit room.
    *   Implement the logic to use the OpenAI TTS plugin to generate the greeting "I'm Buddy, your new AI companion!" and play it back in the room upon connection.
    *   **Action:** Create `buddy_agent.py`, write agent code using `livekit-agents` and OpenAI TTS for the greeting, referencing the "Simple Voice Agent" example.

5.  **Create Dockerfile for the Agent:**
    *   Create a `Dockerfile` in your project directory.
    *   This Dockerfile will define how to build a Docker image for your agent application.
    *   It will include steps to set up the Python environment, copy your agent code, install dependencies, and define the entry point for running your agent.
    *   **Action:** Create `Dockerfile` to containerize the agent application.

6.  **Build and Run Docker Container on Hostinger VPS:**
    *   On your Hostinger VPS, navigate to your project directory.
    *   Build the Docker image using the Dockerfile, naming it "Buddy".
    *   Run the Docker container, ensuring it has access to the necessary environment variables (LIVEKIT\_*, OPENAI\_API\_KEY) and can communicate with the LiveKit server running on the VPS.
    *   **Action:** Build Docker image named "Buddy", run the Docker container on the VPS.

7.  **Verify Agent Functionality:**
    *   Use a LiveKit client (like the Agents Playground or a simple test client) to connect to your LiveKit server on the VPS.
    *   Verify that the "Buddy" agent container starts, connects to the room, and plays the greeting message.
    *   Check Docker logs for the "Buddy" container for any errors.
    *   **Action:** Connect with a LiveKit client, verify greeting, check container logs.

Phase 2 (Revised): Building the "BuddyMemoryApp" Flutter Frontend

**Overall Goal:** Develop a bespoke Flutter mobile application ("BuddyMemoryApp") that connects to your LiveKit Cloud instance, allowing users to interact with the "Buddy" AI agent via real-time voice communication. The app will feature a custom UI based on your design specifications, leveraging the LiveKit Flutter SDK.

**Preliminary Step:**
*   If the old `buddy_mobile_app` directory (from our previous React Native/Expo attempt) still exists in your workspace, it's recommended to rename or delete it to avoid confusion with the new `BuddyMemoryApp` project.

**Architecture:**
```mermaid
graph TD
    subgraph User's Mobile Device (BuddyMemoryApp)
        A[Flutter UI (Widgets & Screens)] --> B{LiveKit Flutter SDK};
        B --> C[Microphone Input];
        D[Audio Output] --> B;
    end

    subgraph Internet
        B <--> E[LiveKit Cloud];
    end

    subgraph Your Hostinger VPS
        F[Buddy Agent Docker Container] --> G(Python LiveKit Agent);
        G <--> E;
        G --> H[OpenAI API (STT, LLM, TTS)];
    end

    I[Token Generation Service (Future)] --> B;
    I --> E;
```

**Detailed Steps for Phase 2 (Flutter):**

**Part 1: Project Setup & Core LiveKit Integration**

1.  **Initialize New Flutter Project:**
    *   Create the project:
        ```bash
        flutter create BuddyMemoryApp
        cd BuddyMemoryApp
        ```
    *   **(Action):** You will run these commands to initialize the new project.

2.  **Install Core Dependencies:**
    *   Add `livekit_client` to `pubspec.yaml` under `dependencies`. Also consider `permission_handler` for advanced permission management (especially Bluetooth on Android).
        ```yaml
        # In pubspec.yaml
        dependencies:
          flutter:
            sdk: flutter
          livekit_client: ^<latest_version> # Check pub.dev for latest
          permission_handler: ^<latest_version> # Optional, for fine-grained permissions
        ```
    *   Run `flutter pub get` in the `BuddyMemoryApp` directory.
    *   **(Action):** You will update `pubspec.yaml` and run `flutter pub get`.

3.  **Platform-Specific Setup for LiveKit & Permissions (Refer to LiveKit Flutter SDK docs for latest details):**
    *   **iOS (ios/Runner/Info.plist & ios/Podfile):**
        *   Add microphone and camera (if video planned) usage descriptions to `Info.plist`:
            ```xml
            <key>NSCameraUsageDescription</key>
            <string>$(PRODUCT_NAME) uses your camera for video features.</string>
            <key>NSMicrophoneUsageDescription</key>
            <string>$(PRODUCT_NAME) uses your microphone for voice communication.</string>
            ```
        *   Enable Background Audio: In Xcode, select the app target, go to "Signing & Capabilities", click "+ Capability", and add "Background Modes". Check "Audio, AirPlay, and Picture in Picture". This adds to `Info.plist`:
            ```xml
            <key>UIBackgroundModes</key>
            <array><string>audio</string></array>
            ```
        *   Set minimum iOS deployment target in `ios/Podfile`: `platform :ios, '12.1'` (or higher as recommended by SDK).
        *   If using Flutter < 3.3.0 or encountering architecture issues, add to `ios/Podfile`:
            ```ruby
            post_install do |installer|
              installer.pods_project.targets.each do |target|
                flutter_additional_ios_build_settings(target)
                target.build_configurations.each do |config|
                  config.build_settings['ONLY_ACTIVE_ARCH'] = 'YES'
                end
              end
            end
            ```
        *   After `Podfile` changes, navigate to `ios` directory and run `pod install --repo-update`.
    *   **Android (android/app/src/main/AndroidManifest.xml):**
        *   Add necessary permissions:
            ```xml
            <uses-feature android:name="android.hardware.camera" android:required="false" />
            <uses-feature android:name="android.hardware.camera.autofocus" android:required="false" />
            <uses-permission android:name="android.permission.CAMERA" />
            <uses-permission android:name="android.permission.RECORD_AUDIO" />
            <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
            <uses-permission android:name="android.permission.CHANGE_NETWORK_STATE" />
            <uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
            <!-- For Bluetooth -->
            <uses-permission android:name="android.permission.BLUETOOTH" android:maxSdkVersion="30" />
            <uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
            <uses-permission android:name="android.permission.BLUETOOTH_ADMIN" android:maxSdkVersion="30" />
            ```
        *   For Bluetooth headset support, use `permission_handler` to request `Permission.bluetooth` and `Permission.bluetoothConnect` at runtime (e.g., in `main()` before `runApp`).
            ```dart
            // In main.dart
            // import 'package:permission_handler/permission_handler.dart';
            // Future<void> _checkPermissions() async {
            //   var bluetoothStatus = await Permission.bluetooth.request();
            //   if (bluetoothStatus.isPermanentlyDenied) { print('Bluetooth Permission disabled'); }
            //   var bluetoothConnectStatus = await Permission.bluetoothConnect.request();
            //   if (bluetoothConnectStatus.isPermanentlyDenied) { print('Bluetooth Connect Permission disabled'); }
            // }
            // void main() async { WidgetsFlutterBinding.ensureInitialized(); await _checkPermissions(); runApp(MyApp()); }
            ```
    *   **Desktop (macOS/Windows/Linux):**
        *   Ensure Flutter desktop support is enabled for your environment.
        *   M1 Macs: `sudo arch -x86_64 gem install ffi` may be needed.
        *   Windows: Visual Studio 2019 (with C++ tools) is typically required.
    *   **(Action):** You will perform these native configuration steps.

4.  **Basic App Structure & Navigation Shell (Flutter):**
    *   In `lib/main.dart`, set up `MaterialApp` with a basic navigator (e.g., `Navigator` with named routes or a package like `go_router`).
    *   Create placeholder screen widgets (e.g., `StatelessWidget` or `StatefulWidget`) for `IndexScreen`, `ChatScreen`, and `AuthScreen` in a `lib/screens/` directory.
    *   **(Action):** Create screen files and configure basic navigation.

5.  **Core LiveKit Connection Logic & State Management:**
    *   Implement LiveKit connection in a service or a state management solution (e.g., Riverpod, Provider, BLoC) to manage the `Room` object and connection state.
    *   Example connection snippet (adapt for your state management):
        ```dart
        // lib/services/livekit_service.dart or similar
        import 'package:livekit_client/livekit_client.dart';
        // ...
        class LiveKitService {
          Room? room;
          EventsListener<RoomEvent>? _roomListener;
          final String _url = 'YOUR_LIVEKIT_SERVER_URL'; // From config/env
          // Token management will be crucial
          Future<void> connect(String token) async {
            final roomOptions = RoomOptions(
              adaptiveStream: true,
              dynacast: true,
              // e2ee: true, // If E2E encryption is desired
              // publishDefaults: const PublishDefaults(audioBitrate: 32000), // Example
            );
            // It's often better to create Room instance just before connect
            // and manage its lifecycle carefully.
            room = Room(); // Or LiveKitClient.createRoom();
            _roomListener = room!.createListener(); // Create listener before connect if preferred by SDK pattern

            await room!.connect(_url, token, roomOptions: roomOptions);
            // Setup listeners after connection
            _setupRoomListeners();
            // Enable local media as needed
            await room!.localParticipant?.setMicrophoneEnabled(true);
          }

          void _setupRoomListeners() {
            _roomListener!
              ..on<RoomDisconnectedEvent>((event) {
                print('Room disconnected: ${event?.reason}');
                // Handle UI updates, cleanup
              })
              ..on<ParticipantConnectedEvent>((event) {
                print('Participant connected: ${event.participant.identity}');
                // Handle new participant UI
              })
              ..on<ParticipantDisconnectedEvent>((event) {
                print('Participant disconnected: ${event.participant.identity}');
                // Handle participant leaving UI
              });
            // Add more specific event listeners as needed (e.g., for tracks, data messages)
            room!.addListener(_onRoomChanged); // For generic state changes
          }

          void _onRoomChanged() {
            // Generic handler for room state changes, might trigger UI rebuild via state management
          }

          Future<void> disconnect() async {
            await _roomListener?.dispose();
            await room?.disconnect();
            room = null;
          }
        }
        ```
    *   Manage the LiveKit `token` (hardcoded for development, later fetched from a secure backend service).
    *   **(Action):** Implement LiveKit connection, disconnection, token handling, and basic media publishing within your chosen state management pattern.

**Part 2: UI Development & LiveKit Interaction**

6.  **Implement Design System Basics (Flutter):**
    *   Create theme files (e.g., `lib/theme/app_theme.dart`, `lib/theme/colors.dart`, `lib/theme/typography.dart`) defining `ThemeData`, `ColorScheme`, `TextTheme`, custom fonts, etc., based on your guide.
    *   **(Action):** Create and apply theme files.

7.  **Develop Core Reusable Widgets (Flutter):**
    *   `GlowOrb` (`lib/widgets/glow_orb.dart`): Implement using Flutter's rendering and animation capabilities (e.g., `Container` with `BoxDecoration` for gradients/glow, `AnimationController` for breathing/ripple effects).
    *   `ActionCard` (`lib/widgets/action_card.dart`): Implement glass morphism (e.g., `ClipRRect` with `BackdropFilter` and `ImageFilter.blur`), gradient icons (SVG or custom paint), and press effects (`InkWell` or `GestureDetector`).
    *   **(Action):** Develop these reusable UI components.

8.  **Develop `ChatScreen.dart` UI & LiveKit Interaction:**
    *   **Layout:** Use Flutter widgets (`Scaffold`, `Column`, `Expanded`, `ListView.builder` for chat history, `Row` for controls).
    *   **State Management:** Connect to your LiveKit service/state manager to access `room` status, participants, and tracks. Listen to changes to rebuild UI.
    *   **Voice Control Button & State Machine:**
        *   Implement the dynamic button and conversation states (`idle`, `listening`, `processing`, `speaking`, `paused`) using your state management solution.
        *   **`idle`:** On press: request mic permission (if needed via `permission_handler`), `room.localParticipant.setMicrophoneEnabled(true)`, transition state.
        *   **`listening`:** On stop: `room.localParticipant.setMicrophoneEnabled(false)`, transition state.
        *   **`processing` / `speaking`:** Update UI based on agent activity (detected via remote participant audio tracks or custom data messages).
    *   **Message Display:** Use `ListView.builder` with custom widgets for user/AI message bubbles.
    *   **Visualizations:** Implement animated audio visualizations using Flutter's animation framework.
    *   **(Action):** Develop `ChatScreen.dart` with UI, state machine, and LiveKit audio interaction.

9.  **Implement `IndexScreen.dart` UI:**
    *   Layout with greeting, central `GlowOrb`, and `ActionCard`s navigating to `ChatScreen`.
    *   **(Action):** Develop `IndexScreen.dart`.

10. **Implement `AuthScreen.dart` (Placeholder):**
    *   Basic placeholder for future authentication/settings.
    *   **(Action):** Develop `AuthScreen.dart`.

**Part 3: Refinement & Advanced Features**

11. **Handling Remote Audio (Agent Responses) in `ChatScreen.dart`:**
    *   Listen to `room.onTrackSubscribed`, `room.onTrackPublished` or changes in `room.remoteParticipants`. The LiveKit Flutter SDK provides `EventsListener` for specific events like `TrackSubscribedEvent`, `TrackPublishedEvent`.
    *   Remote audio tracks are typically played automatically by the SDK once subscribed.
    *   Update UI (e.g., transition to `speaking` state) when the agent's audio track becomes active. This can be inferred from `TrackSubscribedEvent` for an audio track from the agent participant, or specific data messages from the agent.
    *   **(Action):** Ensure robust handling of agent's audio and corresponding UI updates.

12. **Refine State Management & UI Feedback:**
    *   Ensure the conversation state machine is accurate and responsive.
    *   Use your chosen state management solution (Riverpod, Provider, BLoC) effectively to manage UI updates based on LiveKit events and user interactions.
    *   **(Action):** Thoroughly test state transitions and UI feedback.

13. **Implement Animations:**
    *   Integrate `breathingAnimation`, `rippleAnimation`, and `waveVisualization` using Flutter's animation tools (`AnimationController`, `Tween`, `AnimatedBuilder`, etc.).
    *   **(Action):** Implement and test all specified animations.

14. **Flutter Specific Considerations:**
    *   Use `SafeArea` widget for proper layout on devices with notches/islands.
    *   Optimize performance: `const` widgets, efficient list rendering, minimize widget rebuilds.
    *   Follow Flutter best practices for project structure, linting, and testing.
    *   **(Action):** Review and implement Flutter-specific best practices.

**Voice Integration Clarification:**
*   The primary audio pathway (user speaking to agent, agent speaking to user) will be managed by the **LiveKit Flutter SDK**. Your backend Python agent handles STT and TTS.
*   Client-side STT/TTS libraries are **not included in this initial plan** to keep the focus on robust LiveKit integration. They can be considered for future enhancements if specific client-side, offline voice processing features are deemed necessary.

**Further Considerations from LiveKit Flutter SDK (for future reference):**
*   **Screen Sharing:** The SDK supports screen sharing across platforms.
    *   Android: Requires defining a foreground service in `AndroidManifest.xml` (e.g., `<service android:name="de.julianassmann.flutter_background.IsolateHolderService" ... android:foregroundServiceType="mediaProjection" />` - verify service name if it's from a dependency or LiveKit itself).
    *   iOS: Needs a broadcast extension.
    *   Desktop: Can use `ScreenSelectDialog` to pick a window/screen. `LocalVideoTrack.createScreenShareTrack(...)`.
*   **End-to-End Encryption (E2EE):** Supported. For Flutter web, specific `e2ee.worker.dart.js` compilation is needed. Native platforms generally support it without extra settings.
*   **Advanced Track Manipulation:** Manually create and publish tracks like `LocalVideoTrack.createCameraTrack()`.
*   **Video Rendering:** `VideoTrackRenderer` widget is available if video features are added.
*   **Android Audio Modes:** `flutter_webrtc` (a dependency) allows setting `AndroidAudioConfiguration.media` or `AndroidAudioConfiguration.communication`. Default is communication. Media mode offers better quality for playback-oriented apps but system controls audio routing.
    ```dart
    // import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
    // Future<void> _initializeAndroidAudioSettings() async {
    //   await webrtc.WebRTC.initialize(options: {
    //     'androidAudioConfiguration': webrtc.AndroidAudioConfiguration.media.toMap()
    //   });
    //   webrtc.Helper.setAndroidAudioConfiguration(webrtc.AndroidAudioConfiguration.media);
    // }
    ```
*   **Event Handling:** Utilize `Room.addListener(_onChange)` for generic changes and `_listener.on<SpecificEvent>((event) { ... })` for detailed event handling (e.g., `RoomDisconnectedEvent`, `ParticipantConnectedEvent`, `TrackMutedEvent`). Remember to dispose listeners.
*   **Mute/Unmute Local Tracks:** `trackPub.muted = true/false;`.
*   **Subscriber Controls:** `RemoteTrackPublication` offers controls for subscribing/unsubscribing, changing quality, or disabling tracks.

Phase 3: Connecting Pinecone for Long-Term Memory (RAG)
This phase adds persistent, external knowledge to your agent.
1. Set Up Your Pinecone Account/Instance:
    * Create a Pinecone account and set up your vector index.
2. Prepare Your Data for Pinecone:
    * Collect, chunk, and embed your knowledge data.
    * Ingest the vectors into your Pinecone index.
3. Integrate Pinecone with Your livekit-agents:
    * Within your livekit-agents code, integrate a RAG framework like LlamaIndex.
    * Configure this framework to use your Pinecone index as its vector store.
    * Update your agent's logic to retrieve relevant information from Pinecone and use it to augment LLM prompts for more informed responses.

Phase 4: Integrating n8n for Extended Workflows
This phase leverages n8n to connect your agent to other services for non-real-time actions.
1. Identify Auxiliary Workflows:
    * Determine what "behind-the-scenes" actions your agent might need to trigger (e.g., creating a CRM ticket, sending an email, logging data to a spreadsheet, interacting with external APIs not directly handled by the agent).
2. Set up n8n Workflows with Webhooks:
    * In n8n, create new workflows.
    * Start each workflow with a "Webhook" trigger. This will give you a unique URL your agent can call.
3. Trigger n8n from Your LiveKit Agent:
    * Within your livekit-agents code, when a specific condition or user intent is detected (e.g., "user wants to submit a support request"), make an HTTP request to the corresponding n8n webhook URL.
    * Pass any necessary data (e.g., customer details, request summary) in the body of the HTTP request.
4. Orchestrate Actions within n8n:
    * Inside the n8n workflow, use its various nodes to perform the desired actions (e.g., connect to a CRM API, send an email via an email service, log data to a Google Sheet). n8n will handle the authentication and logic for these external integrations.