# 📡 Audio Communication System Simulation

[![MATLAB](https://img.shields.io/badge/MATLAB-R2026-orange.svg?style=for-the-badge&logo=mathworks)](https://www.mathworks.com/products/matlab.html)
[![Signal Processing](https://img.shields.io/badge/Field-Signal--Processing-blue?style=for-the-badge)](https://www.mathworks.com/solutions/signal-processing.html)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

An advanced MATLAB-based simulation of a complete end-to-end audio communication link. This project models signal transformation from a transmitter, passes it through various realistic physical channels, injects Additive White Gaussian Noise (AWGN), and implements an ideal low-pass filter at the receiver to recover the original signal.

---

## 🛠️ System Architecture & Features

The project is structured into **4 fundamental communication blocks**:

### 1. Transmitter (TX)
*   Loads and processes stereo/mono audio files (`.mp3`).
*   Converts multi-channel audio to mono for standard single-channel processing.
*   Performs Fast Fourier Transform (FFT) to convert signals from **Time Domain** to **Frequency Domain**.

### 2. Channel Effects (Convolution)
Simulates signal distortion across 4 optional channel profiles using Linear Time-Invariant (LTI) systems response via convolution:
*   **Delta Function:** Ideal channel with zero distortion.
*   **Decaying Exponentials:** Fast decay ($\exp(-2\pi \cdot 5000t)$) and slow decay ($\exp(-2\pi \cdot 1000t)$) representing multipath dispersion.
*   **Custom Impulse Response:** Simulates a direct path plus a delayed echo (multipath effect).

### 3. Noise Channel
*   Generates **Additive White Gaussian Noise (AWGN)** based on user-defined standard deviation ($\sigma$).
*   Visualizes how noise masks high-frequency components in both domains.

### 4. Receiver (RX)
*   Implements an **Ideal Low-Pass Filter (LPF)** with a critical cutoff frequency of $f_c = 3400\text{ Hz}$ (Standard voice bandwidth).
*   Applies frequency-domain multiplication and Inverse FFT (IFFT) to reconstruct the original time-domain audio.

---

## 🚀 Getting Started

### Prerequisites
*   MATLAB (R2020a or later recommended).
*   Signal Processing Toolbox.
*   An audio file named `test_2.mp3` located in the root directory of the script.

### Installation & Execution
1. Clone this repository to your local machine:
   
```bash
   git clone https://github.com/Ahmedatef-2/audio-communication-system-simulation.git
