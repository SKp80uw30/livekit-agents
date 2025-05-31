# Chat Screen Design Reference

## Overview
This document describes the design elements of the chat screen for the BuddyMemoryApp, based on the provided reference image.

## Design Details

### Background
*   **Type:** Gradient
*   **Colors:** Dark purple, transitioning to a darker shade towards the bottom.

### Top Bar
*   **Left Element:** Back arrow icon (white).
*   **Right Element:** "GlowOrb"
    *   **Appearance:** A circular element with concentric rings and a glowing effect, similar to the one on the authentication screen.
    *   **Animation:**
        *   Pulsates slowly when a conversation is active.
        *   **Potential Reactivity (to explore with SDK/states):**
            *   Increased movement/intensity when a user or Buddy is actively speaking.
            *   Subtler, slower pulsation when waiting for input or between turns.

### Chat Area
*   **User Message Bubble:**
    *   Example Text: "Hey Buddy, what's happening?"
    *   Background: Light grey/off-white.
    *   Shape: Rounded rectangle.
    *   Alignment: Right.
*   **Buddy Message Bubble:**
    *   Example Text: "Not a whole lot you know, this and that. How did you go finding your dream car?"
    *   Background: Dark, slightly translucent (similar to the auth screen card).
    *   Shape: Rounded rectangle.
    *   Alignment: Left.

### Bottom Input Area
*   **Instructional Text:** "Tap to speak" (light grey/white text, centered above the microphone button).
*   **Microphone Button:**
    *   Shape: Large circle.
    *   Icon: White microphone symbol.
    *   Background: Purple to blue gradient.

### Overall Style
*   **Theme:** Consistent with the authentication screen - clean, modern, dark.
*   **Key Features:** Gradients, rounded elements, clear visual distinction between user and Buddy messages.