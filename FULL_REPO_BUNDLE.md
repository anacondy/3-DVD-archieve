# 3-DVD-archive — Full Text Bundle
Generated: 2026-06-17T11:30:15.511370+00:00
Branch: test/text-bundle
Base: main
Files included: 13
```text
Repository: anacondy/3-DVD-archieve
```

---

### FILE: .last_update
```text
1765009160
```

### FILE: AnacondyProperDates.html
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>Retro DVD Interface + Repo List</title>
    <!-- Importing Retro Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=VT323&family=Press+Start+2P&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        :root {
            --phosphor-main: #33ff00;
            --phosphor-dim: #1a8000;
            --particle-color: #ffff00; /* Yellow Frost */
            --bg-color: #050505;
            --scanline-color: rgba(0, 0, 0, 0.5);
            --highlight-bg: rgba(51, 255, 0, 0.2);
        }

        body, html {
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
            background-color: var(--bg-color);
            color: var(--phosphor-main);
            font-family: 'VT323', monospace;
            overflow: hidden; /* Prevent scrolling */
            user-select: none;
            -webkit-user-select: none;
            touch-action: none; /* Crucial for mobile app feel */
        }

        /* --- CRT EFFECT LAYERS --- */
        #crt-container {
            position: relative;
            width: 100%;
            height: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        /* Canvas for Particles */
        #particle-canvas {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 1;
        }

        /* UI Layer */
        #ui-layer {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 2;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            pointer-events: none; /* Let clicks pass to canvas */
            padding: 20px;
            box-sizing: border-box;
            opacity: 0; /* Hidden initially */
            transition: opacity 1s ease-in;
        }

        /* Intro Layer */
        #intro-layer {
            position: absolute;
            z-index: 10;
            width: 100%;
            height: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
            background: var(--bg-color);
            transition: opacity 1s ease-out;
            opacity: 0; /* Hidden until start */
        }

        /* Start Overlay */
        #start-overlay {
            position: absolute;
            z-index: 50;
            width: 100%;
            height: 100%;
            background: black;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            cursor: pointer;
        }

        /* Scanlines */
        .scanlines {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(
                to bottom,
                rgba(255,255,255,0),
                rgba(255,255,255,0) 50%,
                rgba(0,0,0,0.2) 50%,
                rgba(0,0,0,0.2)
            );
            background-size: 100% 4px;
            z-index: 20;
            pointer-events: none;
        }

        /* Screen Glow/Vignette */
        .vignette {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: radial-gradient(circle, rgba(0,0,0,0) 60%, rgba(0,0,0,0.6) 100%);
            z-index: 21;
            pointer-events: none;
            box-shadow: inset 0 0 50px rgba(0,0,0,0.7);
        }

        /* --- UI ELEMENTS --- */
        .glow-text {
            text-shadow: 0 0 5px var(--phosphor-main), 0 0 10px var(--phosphor-main);
        }

        .dim-text {
            color: var(--phosphor-dim);
            text-shadow: none;
        }

        .pixel-font {
            font-family: 'Press Start 2P', cursive;
        }

        /* Intro DVD Logo SVG Styling */
        .dvd-svg {
            width: 80%;
            max-width: 400px;
            fill: none;
            stroke: var(--phosphor-main);
            stroke-width: 3;
            stroke-linecap: round;
            stroke-linejoin: round;
            filter: drop-shadow(0 0 8px var(--phosphor-main));
        }

        .dvd-path {
            stroke-dasharray: 1000;
            stroke-dashoffset: 1000;
        }

        .dvd-disc {
            stroke-dasharray: 600;
            stroke-dashoffset: 600;
        }
        
        /* Animations */
        .animate-draw {
            animation: drawStroke 3s ease-in-out forwards;
        }
        
        .animate-draw-delay {
            animation: drawStroke 3s ease-in-out 0.5s forwards;
        }

        @keyframes drawStroke {
            to {
                stroke-dashoffset: 0;
            }
        }

        /* Flashing cursor */
        .blink {
            animation: blinker 1s linear infinite;
        }
        @keyframes blinker {
            50% { opacity: 0; }
        }

        /* Author Signature Effect */
        .author-signature {
            color: #fff; /* White hot core */
            text-shadow: 0 0 5px #fff, 0 0 10px var(--phosphor-main), 0 0 20px var(--phosphor-main);
            animation: signaturePulse 2s infinite ease-in-out alternate;
        }

        @keyframes signaturePulse {
            0% { opacity: 0.7; text-shadow: 0 0 2px #fff, 0 0 5px var(--phosphor-main); transform: scale(0.98); }
            100% { opacity: 1; text-shadow: 0 0 10px #fff, 0 0 20px var(--phosphor-main), 0 0 40px var(--phosphor-main); transform: scale(1.02); }
        }

        /* Layout Grid */
        .top-bar, .bottom-bar {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
        }
        
        .side-data {
            font-size: 0.8rem;
            line-height: 1.2;
            opacity: 0.8;
        }

        .center-hud {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            text-align: center;
            width: 100%;
            max-width: 800px;
            pointer-events: auto; 
        }

        /* Splash Screen (DVD VIDEO) */
        #splash-screen {
            transition: opacity 0.5s ease-out;
        }

        /* Repository List Styles */
        #repo-screen {
            display: none; /* Hidden initially */
            opacity: 0;
            transition: opacity 1s ease-in;
            text-align: center;
            width: 100%;
        }

        .repo-list-container {
            width: 90%;
            max-width: 600px;
            height: 55vh; /* Spacious height */
            margin: 20px auto;
            border: 2px solid var(--phosphor-dim);
            padding: 10px;
            overflow-y: auto;
            text-align: left;
            background: rgba(0, 20, 0, 0.3);
            box-shadow: 0 0 15px rgba(51, 255, 0, 0.1);
            -webkit-overflow-scrolling: touch; /* Smooth scrolling on iOS */
        }

        /* Custom Retro Scrollbar */
        .repo-list-container::-webkit-scrollbar {
            width: 12px;
        }
        .repo-list-container::-webkit-scrollbar-track {
            background: #000;
            border-left: 1px solid var(--phosphor-dim);
        }
        .repo-list-container::-webkit-scrollbar-thumb {
            background: var(--phosphor-dim);
            border: 1px solid #000;
        }
        .repo-list-container::-webkit-scrollbar-thumb:hover {
            background: var(--phosphor-main);
        }

        .repo-item {
            display: block;
            padding: 15px;
            margin-bottom: 5px;
            text-decoration: none;
            color: var(--phosphor-main);
            font-size: 1.2rem;
            border-bottom: 1px dashed var(--phosphor-dim);
            transition: all 0.2s;
            cursor: pointer;
            position: relative;
        }

        .repo-item:hover {
            background-color: var(--phosphor-main);
            color: black;
            font-weight: bold;
            text-shadow: none;
        }

        .repo-item:hover::before {
            content: '>';
            position: absolute;
            left: 5px;
        }

        /* Responsive tweaks */
        @media (max-width: 768px) {
            .side-data { font-size: 0.6rem; }
            .dvd-svg { width: 90%; }
            .repo-item { font-size: 0.9rem; padding: 12px; } /* Slightly smaller text for mobile */
            .center-hud { width: 95%; }
        }

    </style>
</head>
<body>

    <div id="crt-container">
        <!-- CRT Visual Effects -->
        <div class="scanlines"></div>
        <div class="vignette"></div>

        <!-- Start Overlay -->
        <div id="start-overlay" onclick="startExperience()">
            <div class="pixel-font glow-text text-xl animate-bounce">▶ TAP TO START</div>
            <div class="dim-text mt-4 text-sm">INITIALIZE SYSTEM AUDIO</div>
        </div>

        <!-- 1. The Particle Canvas -->
        <canvas id="particle-canvas"></canvas>

        <!-- 2. The Intro Layer (DVD Logo) -->
        <div id="intro-layer">
            <svg class="dvd-svg" viewBox="0 0 200 100" xmlns="http://www.w3.org/2000/svg">
                <path id="path1" class="dvd-path" d="M20 20 H50 C70 20 70 60 50 60 H20 Z M30 30 V50 H45 C55 50 55 30 45 30 H30" />
                <path id="path2" class="dvd-path" d="M75 20 L90 60 L105 20" />
                <path id="path3" class="dvd-path" d="M110 20 H130 C150 20 150 60 130 60 H110 Z M120 30 V50 H125 C135 50 135 30 125 30 H120" />
                <ellipse id="disc1" class="dvd-disc" cx="90" cy="75" rx="60" ry="10" />
                <path id="disc2" class="dvd-disc" d="M40 90 H140" stroke-dasharray="5,5" />
            </svg>
        </div>

        <!-- 3. The Main UI Layer (Loads after intro) -->
        <div id="ui-layer">
            <div class="top-bar">
                <div class="side-data text-left">
                    <span class="glow-text">REC ●</span><br>
                    <span class="dim-text">TAPE: A-04</span><br>
                    <span class="dim-text">FPS: <span id="fps-counter">60</span></span>
                </div>
                <div class="pixel-font text-center text-xl tracking-widest glow-text opacity-50">
                    SYSTEM READY
                </div>
                <div class="side-data text-right">
                    <span class="dim-text">BAT: 98%</span><br>
                    <span class="dim-text">MEM: <span id="mem-counter">OK</span></span><br>
                    <span class="blink glow-text">_ACTIVE</span>
                </div>
            </div>

            <!-- Central Content Area -->
            <div class="center-hud">
                
                <!-- Screen 1: Splash (DVD VIDEO) -->
                <div id="splash-screen">
                    <h1 class="pixel-font text-4xl md:text-6xl glow-text mb-4 tracking-tighter">DVD VIDEO</h1>
                    <div class="w-64 h-2 bg-green-900 mx-auto border border-green-500 relative overflow-hidden">
                        <div id="loading-bar" class="absolute top-0 left-0 h-full bg-green-400 w-full opacity-70"></div>
                    </div>
                    <p class="mt-2 text-sm dim-text uppercase tracking-widest">
                        LOADING ARCHIVES...
                    </p>
                </div>

                <!-- Screen 2: Repository List (Hidden Initially) -->
                <div id="repo-screen">
                    <h2 class="pixel-font text-2xl md:text-4xl glow-text mb-2">ARCHIVE INDEX</h2>
                    <p class="dim-text text-sm mb-4">SELECT TITLE TO ACCESS</p>
                    
                    <div class="repo-list-container" id="repo-list">
                        <!-- Content Injected via JS -->
                    </div>

                    <!-- Sine wave simulation moved here -->
                    <canvas id="wave-canvas" width="300" height="40" class="mt-4 mx-auto opacity-70"></canvas>

                    <!-- AUTHOR SIGNATURE -->
                    <div class="mt-2 mb-2">
                        <div class="text-[0.6rem] dim-text tracking-[0.5em] mb-1">//// SYS.ARCHITECT ////</div>
                        <div class="author-signature pixel-font text-xl md:text-2xl tracking-widest">ANACONDY</div>
                    </div>
                </div>

            </div>

            <div class="bottom-bar">
                <div class="side-data">
                    <span class="dim-text">COORD X: <span id="coord-x">000</span></span><br>
                    <span class="dim-text">COORD Y: <span id="coord-y">000</span></span>
                </div>
                <div class="side-data text-right">
                     <span class="dim-text">MODE: BROWSE</span><br>
                     <span class="glow-text">TOUCH SCROLL</span>
                </div>
            </div>
        </div>
    </div>

    <script>
        /* =========================================
           DATA CONFIGURATION
           ========================================= */
        const rawRepoList = [
            { name: "25--3-pro-test", url: "https://anacondy.github.io/25--3-pro-test/", date: "2025-11-18T20:39:36Z" },
            { name: "25-2-saving-pro-2", url: "https://anacondy.github.io/25-2-saving-pro-2/", date: "2025-11-19T18:55:24Z" },
            { name: "3--Aussie-Political-MAP", url: "https://anacondy.github.io/3--Aussie-Political-MAP/", date: "2025-11-21T13:00:53Z" },
            { name: "3-Bad-day-24-CRT-SPACESHIP-", url: "https://anacondy.github.io/3-Bad-day-24-CRT-SPACESHIP-/", date: "2025-11-24T09:55:23Z" },
            { name: "3-Canada-map-", url: "https://anacondy.github.io/3-Canada-map-/", date: "2025-11-21T12:12:32Z" },
            { name: "3-CyperpunkSettings", url: "https://anacondy.github.io/3-CyperpunkSettings/", date: "2025-11-24T21:05:18Z" },
            { name: "3-Gem-ind-via-VCS", url: "https://anacondy.github.io/3-Gem-ind-via-VCS/", date: "2025-11-23T19:29:47Z" },
            { name: "3-GEM-Map", url: "https://anacondy.github.io/3-GEM-Map/", date: "2025-11-21T11:18:45Z" },
            { name: "3-Germany", url: "https://anacondy.github.io/3-Germany/", date: "2025-11-21T13:24:14Z" },
            { name: "3-Heli-24", url: "https://anacondy.github.io/3-Heli-24/", date: "2025-11-24T11:34:35Z" },
            { name: "3-L-trange-Experience", url: "https://anacondy.github.io/3-L-trange-Experience/", date: "2025-11-24T22:41:04Z" },
            { name: "3-mobile-indian-map", url: "https://anacondy.github.io/3-mobile-indian-map/", date: "2025-11-23T21:47:00Z" },
            { name: "3-Neon-pulse--24-bad-day- ❌", url: "https://anacondy.github.io/3-Neon-pulse--24-bad-day-/", date: "2025-11-24T10:07:12Z" },
            { name: "3-Regency-Horror-Menu", url: "https://anacondy.github.io/3-Regency-Horror-Menu/", date: "2025-11-22T13:21:26Z" },
            { name: "3-Regency-latern", url: "https://anacondy.github.io/3-Regency-latern/", date: "2025-11-22T16:53:33Z" },
            { name: "3-RetroDVD", url: "https://anacondy.github.io/3-RetroDVD/", date: "2025-11-24T21:01:38Z" },
            { name: "3-System-registry-", url: "https://anacondy.github.io/3-System-registry-/", date: "2025-11-22T14:34:50Z" },
            { name: "3-USA-getting-live-", url: "https://anacondy.github.io/3-USA-getting-live-/", date: "2025-11-21T12:16:31Z" },
            { name: "3-West-world", url: "https://anacondy.github.io/3-West-world/", date: "2025-11-21T14:14:28Z" },
            { name: "3-WestWorld-without-bounce-", url: "https://anacondy.github.io/3-WestWorld-without-bounce-/", date: "2025-11-21T14:21:58Z" },
            { name: "alvido-test-2", url: "https://anacondy.github.io/alvido-test-2/", date: "2025-10-12T20:04:26Z" },
            { name: "alvido-test-4", url: "https://anacondy.github.io/alvido-test-4/", date: "2025-10-12T20:14:07Z" },
            { name: "alvido-test-5", url: "https://anacondy.github.io/alvido-test-5/", date: "2025-10-12T20:20:35Z" },
            { name: "alvido-testing-1", url: "https://anacondy.github.io/alvido-testing-1/", date: "2025-10-12T19:54:10Z" },
            { name: "deep-res-Job", url: "https://anacondy.github.io/deep-res-Job/", date: "2025-11-11T03:18:04Z" },
            { name: "falling-leaves-", url: "https://anacondy.github.io/falling-leaves-/", date: "2025-11-05T05:13:48Z" },
            { name: "GJ-Terminal-2-sorting-card-page-", url: "https://anacondy.github.io/GJ-Terminal-2-sorting-card-page-/", date: "2025-10-16T16:15:18Z" },
            { name: "GJ-Terminal-just-a-data-table-with-good-UI", url: "https://anacondy.github.io/GJ-Terminal-just-a-data-table-with-good-UI/", date: "2025-10-16T15:55:51Z" },
            { name: "glassmorphic-site-card-Ui-html-", url: "https://anacondy.github.io/glassmorphic-site-card-Ui-html-/", date: "2025-10-15T19:20:59Z" },
            { name: "GPA-calculator", url: "https://anacondy.github.io/GPA-calculator/", date: "2025-08-20T16:53:40Z" },
            { name: "Indian-SC-verdicts-site", url: "https://anacondy.github.io/Indian-SC-verdicts-site/", date: "2025-10-19T23:26:19Z" },
            { name: "leaves-dying-", url: "https://anacondy.github.io/leaves-dying-/", date: "2025-11-05T06:05:02Z" },
            { name: "live-volcano-ui", url: "https://anacondy.github.io/live-volcano-ui/", date: "2025-09-02T15:55:20Z" },
            { name: "login-input", url: "https://anacondy.github.io/login-input/", date: "2025-11-05T18:27:40Z" },
            { name: "mobile-comparison-site-", url: "https://anacondy.github.io/mobile-comparison-site-/", date: "2025-08-22T11:09:53Z" },
            { name: "MP-tracker-site-", url: "https://anacondy.github.io/MP-tracker-site-/", date: "2025-11-02T18:11:27Z" },
            { name: "my-living-map", url: "https://anacondy.github.io/my-living-map/", date: "2025-08-31T18:31:11Z" },
            { name: "paper-gemini-archieve-saving-progress-2-", url: "https://anacondy.github.io/paper-gemini-archieve-saving-progress-2-/", date: "2025-10-12T08:23:43Z" },
            { name: "papers-gemini-archive-4-", url: "https://anacondy.github.io/papers-gemini-archive-4-/", date: "2025-10-12T19:33:51Z" },
            { name: "Papers-login-better-security-", url: "https://anacondy.github.io/Papers-login-better-security-/", date: "2025-10-14T17:57:36Z" },
            { name: "Pint-site-saving-progress-1-", url: "https://anacondy.github.io/Pint-site-saving-progress-1-/", date: "2025-11-03T14:39:35Z" },
            { name: "powershell-cl-sc-cases-site-htmls-", url: "https://anacondy.github.io/powershell-cl-sc-cases-site-htmls-/", date: "2025-10-21T18:14:38Z" },
            { name: "SC-site-with-home-page-", url: "https://anacondy.github.io/SC-site-with-home-page-/", date: "2025-10-20T19:24:33Z" },
            { name: "stars-ui", url: "https://anacondy.github.io/stars-ui/", date: "2025-09-01T22:00:39Z" },
            { name: "stars-ui-2-", url: "https://anacondy.github.io/stars-ui-2-/", date: "2025-09-10T14:26:48Z" },
            { name: "stars-UI-3", url: "https://anacondy.github.io/stars-UI-3/", date: "2025-09-10T14:42:56Z" },
            { name: "termial-archieve-before-SQLite-imp", url: "https://anacondy.github.io/termial-archieve-before-SQLite-imp/", date: "2025-10-12T21:29:58Z" },
            { name: "Terminal-Archives-PYQs-", url: "https://anacondy.github.io/Terminal-Archives-PYQs-/", date: "2025-10-10T19:51:18Z" },
            { name: "terminal-site-post-mortem-", url: "https://anacondy.github.io/terminal-site-post-mortem-/", date: "2025-10-15T17:59:37Z" }
        ];

        /* =========================================
           AUDIO ENGINE (Web Audio API)
           ========================================= */
        let audioCtx;
        let masterGain;
        
        const AudioEngine = {
            init: async function() {
                const AudioContext = window.AudioContext || window.webkitAudioContext;
                
                // Only create if not already existing
                if (!audioCtx) {
                    audioCtx = new AudioContext();
                }

                // MOBILE FIX: Always try to resume on user gesture
                if (audioCtx.state === 'suspended') {
                    await audioCtx.resume();
                }

                if (!masterGain) {
                    masterGain = audioCtx.createGain();
                    masterGain.gain.value = 0.3; 
                    masterGain.connect(audioCtx.destination);
                    
                    // Only start loops if they haven't started (prevent doubling up)
                    this.startAmbience();
                    this.playBootSound();
                }
            },

            startAmbience: function() {
                // Low Hum
                const oscLow = audioCtx.createOscillator();
                oscLow.type = 'sine';
                oscLow.frequency.value = 60;
                const gainLow = audioCtx.createGain();
                gainLow.gain.value = 0.1;
                oscLow.connect(gainLow);
                gainLow.connect(masterGain);
                oscLow.start();

                // High Whine
                const oscHigh = audioCtx.createOscillator();
                oscHigh.type = 'sine';
                oscHigh.frequency.value = 15000;
                const gainHigh = audioCtx.createGain();
                gainHigh.gain.value = 0.02;
                oscHigh.connect(gainHigh);
                gainHigh.connect(masterGain);
                oscHigh.start();
            },

            playBootSound: function() {
                const osc = audioCtx.createOscillator();
                const gain = audioCtx.createGain();
                osc.type = 'triangle';
                osc.frequency.setValueAtTime(100, audioCtx.currentTime);
                osc.frequency.exponentialRampToValueAtTime(800, audioCtx.currentTime + 2);
                gain.gain.setValueAtTime(0, audioCtx.currentTime);
                gain.gain.linearRampToValueAtTime(0.5, audioCtx.currentTime + 0.5);
                gain.gain.exponentialRampToValueAtTime(0.01, audioCtx.currentTime + 3);
                osc.connect(gain);
                gain.connect(masterGain);
                osc.start();
                osc.stop(audioCtx.currentTime + 3.1);
            },

            playParticleSound: function(intensity) {
                if (!audioCtx || audioCtx.state === 'suspended') return;
                
                if (Math.random() > 0.3) return; 
                const osc = audioCtx.createOscillator();
                const gain = audioCtx.createGain();
                const freq = 2000 + Math.random() * 3000; 
                osc.type = 'sine';
                osc.frequency.setValueAtTime(freq, audioCtx.currentTime);
                gain.gain.setValueAtTime(0.05 * intensity, audioCtx.currentTime);
                gain.gain.exponentialRampToValueAtTime(0.001, audioCtx.currentTime + 0.1);
                osc.connect(gain);
                gain.connect(masterGain);
                osc.start();
                osc.stop(audioCtx.currentTime + 0.15);
            },

            playHoverSound: function() {
                if (!audioCtx || audioCtx.state === 'suspended') return;
                
                const osc = audioCtx.createOscillator();
                const gain = audioCtx.createGain();
                osc.type = 'square';
                osc.frequency.setValueAtTime(400, audioCtx.currentTime);
                osc.frequency.exponentialRampToValueAtTime(600, audioCtx.currentTime + 0.05);
                gain.gain.setValueAtTime(0.05, audioCtx.currentTime);
                gain.gain.exponentialRampToValueAtTime(0.001, audioCtx.currentTime + 0.05);
                osc.connect(gain);
                gain.connect(masterGain);
                osc.start();
                osc.stop(audioCtx.currentTime + 0.06);
            }
        };

        /* =========================================
           VISUAL ENGINE
           ========================================= */
        const PARTICLE_COUNT = 800; 
        const MOUSE_RADIUS = 120;
        const PARTICLE_COLOR = '#ffff00';
        
        const canvas = document.getElementById('particle-canvas');
        const ctx = canvas.getContext('2d');
        const uiLayer = document.getElementById('ui-layer');
        const introLayer = document.getElementById('intro-layer');
        const startOverlay = document.getElementById('start-overlay');
        const splashScreen = document.getElementById('splash-screen');
        const repoScreen = document.getElementById('repo-screen');
        
        // --- START SEQUENCE ---
        async function startExperience() {
            // 1. Init Audio (Await for resume if needed)
            await AudioEngine.init();

            // 2. Remove overlay
            startOverlay.style.opacity = '0';
            setTimeout(() => startOverlay.style.display = 'none', 500);

            // 3. Init Particles & Render
            initParticles();
            animate();
            renderRepoList();

            // 4. Play Intro (DVD Logo)
            introLayer.style.opacity = '1';
            document.getElementById('path1').classList.add('animate-draw');
            document.getElementById('path2').classList.add('animate-draw');
            document.getElementById('path3').classList.add('animate-draw');
            document.getElementById('disc1').classList.add('animate-draw-delay');
            document.getElementById('disc2').classList.add('animate-draw-delay');

            // 5. Transition to Splash Screen
            setTimeout(() => {
                introLayer.style.opacity = '0';
                setTimeout(() => {
                    introLayer.style.display = 'none';
                    uiLayer.style.opacity = '1';
                    initWave(); 
                    
                    // 6. Transition to Repo List (After 3 seconds on Splash)
                    setTimeout(() => {
                        splashScreen.style.opacity = '0';
                        setTimeout(() => {
                            splashScreen.style.display = 'none';
                            repoScreen.style.display = 'block';
                            // Force reflow
                            void repoScreen.offsetWidth;
                            repoScreen.style.opacity = '1';
                        }, 500);
                    }, 3000);

                }, 1000);
            }, 3500);

            resizeCanvas();
        }

        // --- RENDER REPO LIST ---
        function formatRetroDate(isoDateString) {
            if(!isoDateString) return "UNKNOWN";
            const date = new Date(isoDateString);
            const months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
            const day = date.getDate().toString().padStart(2, '0');
            const month = months[date.getMonth()];
            const year = date.getFullYear();
            return `${day}-${month}-${year}`;
        }

        function renderRepoList() {
            const listContainer = document.getElementById('repo-list');
            listContainer.innerHTML = '';
            
            rawRepoList.forEach((repo, index) => {
                const link = document.createElement('a');
                link.href = repo.url;
                link.className = 'repo-item';
                link.target = "_blank"; // Open in new tab
                
                // Add index number for retro list feel
                const idxStr = (index + 1).toString().padStart(2, '0');
                
                link.innerHTML = `
                    <div style="display:flex; justify-content:space-between; align-items: center;">
                        <span class="truncate pr-4">${idxStr}. ${repo.name}</span>
                        <span class="dim-text text-xs whitespace-nowrap">${formatRetroDate(repo.date)}</span>
                    </div>
                `;
                
                // Add hover sound effect
                link.addEventListener('mouseenter', () => AudioEngine.playHoverSound());
                // For touch devices, ensure sound plays on interaction
                link.addEventListener('click', () => AudioEngine.playHoverSound()); 
                
                listContainer.appendChild(link);
            });
        }

        // --- PARTICLE SYSTEM ---
        let particles = [];
        let mouse = { x: null, y: null, active: false, velocity: 0 };
        let lastMousePos = { x: 0, y: 0 };

        window.addEventListener('resize', () => {
            resizeCanvas();
            initParticles();
        });

        function resizeCanvas() {
            canvas.width = window.innerWidth;
            canvas.height = window.innerHeight;
        }

        const updateMouse = (x, y) => {
            const dx = x - lastMousePos.x;
            const dy = y - lastMousePos.y;
            mouse.velocity = Math.sqrt(dx*dx + dy*dy);
            lastMousePos.x = x;
            lastMousePos.y = y;
            mouse.x = x;
            mouse.y = y;
            mouse.active = true;
            
            if (document.getElementById('coord-x')) {
                document.getElementById('coord-x').innerText = Math.floor(x).toString().padStart(3, '0');
                document.getElementById('coord-y').innerText = Math.floor(y).toString().padStart(3, '0');
            }
        };

        window.addEventListener('mousemove', (e) => updateMouse(e.x, e.y));
        
        // Mobile Touch Handling (Prevent Default to stop scrolling while touching canvas)
        window.addEventListener('touchmove', (e) => {
            // Only prevent default if touching the canvas directly (not the list)
            if(e.target === canvas) {
                // e.preventDefault(); // Optional: uncomment if you want to block ALL scrolling on canvas
            }
            updateMouse(e.touches[0].clientX, e.touches[0].clientY);
        }, {passive: false});

        window.addEventListener('touchstart', (e) => {
            lastMousePos.x = e.touches[0].clientX;
            lastMousePos.y = e.touches[0].clientY;
            updateMouse(e.touches[0].clientX, e.touches[0].clientY);
            // Resume audio context on touch if needed
            if(audioCtx && audioCtx.state === 'suspended') {
                audioCtx.resume();
            }
        }, {passive: false});

        window.addEventListener('touchend', () => { mouse.active = false; mouse.velocity = 0; });
        window.addEventListener('mouseout', () => { mouse.active = false; mouse.velocity = 0; });

        class Particle {
            constructor() {
                this.x = Math.random() * canvas.width;
                this.y = Math.random() * canvas.height;
                this.vx = (Math.random() - 0.5) * 0.5;
                this.vy = (Math.random() - 0.5) * 0.5;
                this.size = Math.random() * 2 + 1; 
                this.baseX = this.x;
                this.baseY = this.y;
                this.density = (Math.random() * 30) + 1;
            }

            draw() {
                ctx.fillStyle = PARTICLE_COLOR;
                ctx.fillRect(this.x, this.y, this.size, this.size);
            }

            update() {
                if (mouse.active) {
                    let dx = mouse.x - this.x;
                    let dy = mouse.y - this.y;
                    let distance = Math.sqrt(dx * dx + dy * dy);
                    
                    if (distance < MOUSE_RADIUS) {
                        const forceDirectionX = dx / distance;
                        const forceDirectionY = dy / distance;
                        const maxDistance = MOUSE_RADIUS;
                        const force = (maxDistance - distance) / maxDistance;
                        const directionX = forceDirectionX * force * this.density;
                        const directionY = forceDirectionY * force * this.density;

                        this.vx -= directionX;
                        this.vy -= directionY;

                        if (mouse.velocity > 5 && Math.random() > 0.99) {
                            AudioEngine.playParticleSound(Math.min(mouse.velocity / 20, 1));
                        }
                    }
                }
                this.x += this.vx;
                this.y += this.vy;
                this.vx *= 0.95; 
                this.vy *= 0.95;
                if (this.x > canvas.width) this.x = 0;
                if (this.x < 0) this.x = canvas.width;
                if (this.y > canvas.height) this.y = 0;
                if (this.y < 0) this.y = canvas.height;
            }
        }

        function initParticles() {
            particles = [];
            const count = window.innerWidth < 768 ? PARTICLE_COUNT / 2 : PARTICLE_COUNT;
            for (let i = 0; i < count; i++) {
                particles.push(new Particle());
            }
        }

        function animate() {
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            for (let i = 0; i < particles.length; i++) {
                particles[i].draw();
                particles[i].update();
            }
            requestAnimationFrame(animate);
        }

        function initWave() {
            const waveCanvas = document.getElementById('wave-canvas');
            const waveCtx = waveCanvas.getContext('2d');
            let offset = 0;
            function drawWave() {
                waveCtx.clearRect(0, 0, waveCanvas.width, waveCanvas.height);
                waveCtx.beginPath();
                waveCtx.lineWidth = 2;
                waveCtx.strokeStyle = '#33ff00';
                for (let i = 0; i < waveCanvas.width; i++) {
                    const y = 20 + Math.sin(i * 0.05 + offset) * 10 * Math.sin(offset * 0.1);
                    waveCtx.lineTo(i, y);
                }
                waveCtx.stroke();
                offset += 0.1;
                requestAnimationFrame(drawWave);
            }
            drawWave();

            setInterval(() => {
                const fpsEl = document.getElementById('fps-counter');
                if(fpsEl) fpsEl.innerText = Math.floor(58 + Math.random() * 4);
                
                const memEl = document.getElementById('mem-counter');
                if(memEl) memEl.innerText = Math.random() > 0.9 ? "BUSY" : "OK";
            }, 500);
            
            const bar = document.getElementById('loading-bar');
            let width = 100;
            setInterval(() => {
                if(bar) {
                    width = (width + 5) % 100;
                    bar.style.width = width + '%';
                }
            }, 100);
        }
    </script>
</body>
</html>
```

### FILE: AnacondyVersion.html
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>Retro DVD Interface + Repo List</title>
    <!-- Importing Retro Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=VT323&family=Press+Start+2P&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        :root {
            --phosphor-main: #33ff00;
            --phosphor-dim: #1a8000;
            --particle-color: #ffff00; /* Yellow Frost */
            --bg-color: #050505;
            --scanline-color: rgba(0, 0, 0, 0.5);
            --highlight-bg: rgba(51, 255, 0, 0.2);
        }

        body, html {
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
            background-color: var(--bg-color);
            color: var(--phosphor-main);
            font-family: 'VT323', monospace;
            overflow: hidden; /* Prevent scrolling */
            user-select: none;
            -webkit-user-select: none;
        }

        /* --- CRT EFFECT LAYERS --- */
        #crt-container {
            position: relative;
            width: 100%;
            height: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        /* Canvas for Particles */
        #particle-canvas {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 1;
        }

        /* UI Layer */
        #ui-layer {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 2;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            pointer-events: none; /* Let clicks pass to canvas */
            padding: 20px;
            box-sizing: border-box;
            opacity: 0; /* Hidden initially */
            transition: opacity 1s ease-in;
        }

        /* Intro Layer */
        #intro-layer {
            position: absolute;
            z-index: 10;
            width: 100%;
            height: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
            background: var(--bg-color);
            transition: opacity 1s ease-out;
            opacity: 0; /* Hidden until start */
        }

        /* Start Overlay */
        #start-overlay {
            position: absolute;
            z-index: 50;
            width: 100%;
            height: 100%;
            background: black;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            cursor: pointer;
        }

        /* Scanlines */
        .scanlines {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(
                to bottom,
                rgba(255,255,255,0),
                rgba(255,255,255,0) 50%,
                rgba(0,0,0,0.2) 50%,
                rgba(0,0,0,0.2)
            );
            background-size: 100% 4px;
            z-index: 20;
            pointer-events: none;
        }

        /* Screen Glow/Vignette */
        .vignette {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: radial-gradient(circle, rgba(0,0,0,0) 60%, rgba(0,0,0,0.6) 100%);
            z-index: 21;
            pointer-events: none;
            box-shadow: inset 0 0 50px rgba(0,0,0,0.7);
        }

        /* --- UI ELEMENTS --- */
        .glow-text {
            text-shadow: 0 0 5px var(--phosphor-main), 0 0 10px var(--phosphor-main);
        }

        .dim-text {
            color: var(--phosphor-dim);
            text-shadow: none;
        }

        .pixel-font {
            font-family: 'Press Start 2P', cursive;
        }

        /* Intro DVD Logo SVG Styling */
        .dvd-svg {
            width: 80%;
            max-width: 400px;
            fill: none;
            stroke: var(--phosphor-main);
            stroke-width: 3;
            stroke-linecap: round;
            stroke-linejoin: round;
            filter: drop-shadow(0 0 8px var(--phosphor-main));
        }

        .dvd-path {
            stroke-dasharray: 1000;
            stroke-dashoffset: 1000;
        }

        .dvd-disc {
            stroke-dasharray: 600;
            stroke-dashoffset: 600;
        }
        
        /* Animations controlled by JS now to sync with audio */
        .animate-draw {
            animation: drawStroke 3s ease-in-out forwards;
        }
        
        .animate-draw-delay {
            animation: drawStroke 3s ease-in-out 0.5s forwards;
        }

        @keyframes drawStroke {
            to {
                stroke-dashoffset: 0;
            }
        }

        /* Flashing cursor */
        .blink {
            animation: blinker 1s linear infinite;
        }
        @keyframes blinker {
            50% { opacity: 0; }
        }

        /* Author Signature Effect */
        .author-signature {
            color: #fff; /* White hot core */
            text-shadow: 0 0 5px #fff, 0 0 10px var(--phosphor-main), 0 0 20px var(--phosphor-main);
            animation: signaturePulse 2s infinite ease-in-out alternate;
        }

        @keyframes signaturePulse {
            0% { opacity: 0.7; text-shadow: 0 0 2px #fff, 0 0 5px var(--phosphor-main); transform: scale(0.98); }
            100% { opacity: 1; text-shadow: 0 0 10px #fff, 0 0 20px var(--phosphor-main), 0 0 40px var(--phosphor-main); transform: scale(1.02); }
        }

        /* Layout Grid */
        .top-bar, .bottom-bar {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
        }
        
        .side-data {
            font-size: 0.8rem;
            line-height: 1.2;
            opacity: 0.8;
        }

        .center-hud {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            text-align: center;
            width: 100%;
            max-width: 800px;
            /* Allow clicking inside the HUD (for links) */
            pointer-events: auto; 
        }

        /* Splash Screen (DVD VIDEO) */
        #splash-screen {
            transition: opacity 0.5s ease-out;
        }

        /* Repository List Styles */
        #repo-screen {
            display: none; /* Hidden initially */
            opacity: 0;
            transition: opacity 1s ease-in;
            text-align: center;
            width: 100%;
        }

        .repo-list-container {
            width: 90%;
            max-width: 600px;
            height: 55vh; /* Restored to larger size (was 45vh) */
            margin: 20px auto;
            border: 2px solid var(--phosphor-dim);
            padding: 10px;
            overflow-y: auto;
            text-align: left;
            background: rgba(0, 20, 0, 0.3);
            box-shadow: 0 0 15px rgba(51, 255, 0, 0.1);
        }

        /* Custom Retro Scrollbar */
        .repo-list-container::-webkit-scrollbar {
            width: 12px;
        }
        .repo-list-container::-webkit-scrollbar-track {
            background: #000;
            border-left: 1px solid var(--phosphor-dim);
        }
        .repo-list-container::-webkit-scrollbar-thumb {
            background: var(--phosphor-dim);
            border: 1px solid #000;
        }
        .repo-list-container::-webkit-scrollbar-thumb:hover {
            background: var(--phosphor-main);
        }

        .repo-item {
            display: block;
            padding: 15px;
            margin-bottom: 5px;
            text-decoration: none;
            color: var(--phosphor-main);
            font-size: 1.2rem;
            border-bottom: 1px dashed var(--phosphor-dim);
            transition: all 0.2s;
            cursor: pointer;
            position: relative;
        }

        .repo-item:hover {
            background-color: var(--phosphor-main);
            color: black;
            font-weight: bold;
            text-shadow: none;
        }

        .repo-item:hover::before {
            content: '>';
            position: absolute;
            left: 5px;
        }

        /* Responsive tweaks */
        @media (max-width: 768px) {
            .side-data { font-size: 0.6rem; }
            .dvd-svg { width: 90%; }
            .repo-item { font-size: 1rem; padding: 12px; }
            .center-hud { width: 95%; }
        }

    </style>
</head>
<body>

    <div id="crt-container">
        
        <!-- CRT Visual Effects -->
        <div class="scanlines"></div>
        <div class="vignette"></div>

        <!-- Start Overlay -->
        <div id="start-overlay" onclick="startExperience()">
            <div class="pixel-font glow-text text-xl animate-bounce">▶ TAP TO START</div>
            <div class="dim-text mt-4 text-sm">INITIALIZE SYSTEM AUDIO</div>
        </div>

        <!-- 1. The Particle Canvas -->
        <canvas id="particle-canvas"></canvas>

        <!-- 2. The Intro Layer (DVD Logo) -->
        <div id="intro-layer">
            <svg class="dvd-svg" viewBox="0 0 200 100" xmlns="http://www.w3.org/2000/svg">
                <path id="path1" class="dvd-path" d="M20 20 H50 C70 20 70 60 50 60 H20 Z M30 30 V50 H45 C55 50 55 30 45 30 H30" />
                <path id="path2" class="dvd-path" d="M75 20 L90 60 L105 20" />
                <path id="path3" class="dvd-path" d="M110 20 H130 C150 20 150 60 130 60 H110 Z M120 30 V50 H125 C135 50 135 30 125 30 H120" />
                <ellipse id="disc1" class="dvd-disc" cx="90" cy="75" rx="60" ry="10" />
                <path id="disc2" class="dvd-disc" d="M40 90 H140" stroke-dasharray="5,5" />
            </svg>
        </div>

        <!-- 3. The Main UI Layer (Loads after intro) -->
        <div id="ui-layer">
            <div class="top-bar">
                <div class="side-data text-left">
                    <span class="glow-text">REC ●</span><br>
                    <span class="dim-text">TAPE: A-04</span><br>
                    <span class="dim-text">FPS: <span id="fps-counter">60</span></span>
                </div>
                <div class="pixel-font text-center text-xl tracking-widest glow-text opacity-50">
                    SYSTEM READY
                </div>
                <div class="side-data text-right">
                    <span class="dim-text">BAT: 98%</span><br>
                    <span class="dim-text">MEM: <span id="mem-counter">OK</span></span><br>
                    <span class="blink glow-text">_ACTIVE</span>
                </div>
            </div>

            <!-- Central Content Area -->
            <div class="center-hud">
                
                <!-- Screen 1: Splash (DVD VIDEO) -->
                <div id="splash-screen">
                    <h1 class="pixel-font text-4xl md:text-6xl glow-text mb-4 tracking-tighter">DVD VIDEO</h1>
                    <div class="w-64 h-2 bg-green-900 mx-auto border border-green-500 relative overflow-hidden">
                        <div id="loading-bar" class="absolute top-0 left-0 h-full bg-green-400 w-full opacity-70"></div>
                    </div>
                    <p class="mt-2 text-sm dim-text uppercase tracking-widest">
                        LOADING ARCHIVES...
                    </p>
                </div>

                <!-- Screen 2: Repository List (Hidden Initially) -->
                <div id="repo-screen">
                    <h2 class="pixel-font text-2xl md:text-4xl glow-text mb-2">ARCHIVE INDEX</h2>
                    <p class="dim-text text-sm mb-4">SELECT TITLE TO ACCESS</p>
                    
                    <div class="repo-list-container" id="repo-list">
                        <!-- Content Injected via JS -->
                    </div>

                    <!-- Sine wave simulation moved here -->
                    <canvas id="wave-canvas" width="300" height="40" class="mt-4 mx-auto opacity-70"></canvas>

                    <!-- AUTHOR SIGNATURE -->
                    <div class="mt-2 mb-2">
                        <div class="text-[0.6rem] dim-text tracking-[0.5em] mb-1">//// SYS.ARCHITECT ////</div>
                        <div class="author-signature pixel-font text-xl md:text-2xl tracking-widest">ANACONDY</div>
                    </div>
                </div>

            </div>

            <div class="bottom-bar">
                <div class="side-data">
                    <span class="dim-text">COORD X: <span id="coord-x">000</span></span><br>
                    <span class="dim-text">COORD Y: <span id="coord-y">000</span></span>
                </div>
                <div class="side-data text-right">
                     <span class="dim-text">MODE: BROWSE</span><br>
                     <span class="glow-text">TOUCH SCROLL</span>
                </div>
            </div>
        </div>
    </div>

    <script>
        /* =========================================
           DATA CONFIGURATION
           ========================================= */
        const rawRepoList = [
            { name: "25--3-pro-test", url: "https://anacondy.github.io/25--3-pro-test/" },
            { name: "25-2-saving-pro-2", url: "https://anacondy.github.io/25-2-saving-pro-2/" },
            { name: "3--Aussie-Political-MAP", url: "https://anacondy.github.io/3--Aussie-Political-MAP/" },
            { name: "3-Bad-day-24-CRT-SPACESHIP-", url: "https://anacondy.github.io/3-Bad-day-24-CRT-SPACESHIP-/" },
            { name: "3-Canada-map-", url: "https://anacondy.github.io/3-Canada-map-/" },
            { name: "3-CyperpunkSettings", url: "https://anacondy.github.io/3-CyperpunkSettings/" },
            { name: "3-Gem-ind-via-VCS", url: "https://anacondy.github.io/3-Gem-ind-via-VCS/" },
            { name: "3-GEM-Map", url: "https://anacondy.github.io/3-GEM-Map/" },
            { name: "3-Germany", url: "https://anacondy.github.io/3-Germany/" },
            { name: "3-Heli-24", url: "https://anacondy.github.io/3-Heli-24/" },
            { name: "3-L-trange-Experience", url: "https://anacondy.github.io/3-L-trange-Experience/" },
            { name: "3-mobile-indian-map", url: "https://anacondy.github.io/3-mobile-indian-map/" },
            { name: "3-Neon-pulse--24-bad-day- ❌", url: "https://anacondy.github.io/3-Neon-pulse--24-bad-day-/" },
            { name: "3-Regency-Horror-Menu", url: "https://anacondy.github.io/3-Regency-Horror-Menu/" },
            { name: "3-Regency-latern", url: "https://anacondy.github.io/3-Regency-latern/" },
            { name: "3-RetroDVD", url: "https://anacondy.github.io/3-RetroDVD/" },
            { name: "3-System-registry-", url: "https://anacondy.github.io/3-System-registry-/" },
            { name: "3-USA-getting-live-", url: "https://anacondy.github.io/3-USA-getting-live-/" },
            { name: "3-West-world", url: "https://anacondy.github.io/3-West-world/" },
            { name: "3-WestWorld-without-bounce-", url: "https://anacondy.github.io/3-WestWorld-without-bounce-/" },
            { name: "alvido-test-2", url: "https://anacondy.github.io/alvido-test-2/" },
            { name: "alvido-test-4", url: "https://anacondy.github.io/alvido-test-4/" },
            { name: "alvido-test-5", url: "https://anacondy.github.io/alvido-test-5/" },
            { name: "alvido-testing-1", url: "https://anacondy.github.io/alvido-testing-1/" },
            { name: "deep-res-Job", url: "https://anacondy.github.io/deep-res-Job/" },
            { name: "falling-leaves-", url: "https://anacondy.github.io/falling-leaves-/" },
            { name: "GJ-Terminal-2-sorting-card-page-", url: "https://anacondy.github.io/GJ-Terminal-2-sorting-card-page-/" },
            { name: "GJ-Terminal-just-a-data-table-with-good-UI", url: "https://anacondy.github.io/GJ-Terminal-just-a-data-table-with-good-UI/" },
            { name: "glassmorphic-site-card-Ui-html-", url: "https://anacondy.github.io/glassmorphic-site-card-Ui-html-/" },
            { name: "GPA-calculator", url: "https://anacondy.github.io/GPA-calculator/" },
            { name: "Indian-SC-verdicts-site", url: "https://anacondy.github.io/Indian-SC-verdicts-site/" },
            { name: "leaves-dying-", url: "https://anacondy.github.io/leaves-dying-/" },
            { name: "live-volcano-ui", url: "https://anacondy.github.io/live-volcano-ui/" },
            { name: "login-input", url: "https://anacondy.github.io/login-input/" },
            { name: "mobile-comparison-site-", url: "https://anacondy.github.io/mobile-comparison-site-/" },
            { name: "MP-tracker-site-", url: "https://anacondy.github.io/MP-tracker-site-/" },
            { name: "my-living-map", url: "https://anacondy.github.io/my-living-map/" },
            { name: "paper-gemini-archieve-saving-progress-2-", url: "https://anacondy.github.io/paper-gemini-archieve-saving-progress-2-/" },
            { name: "papers-gemini-archive-4-", url: "https://anacondy.github.io/papers-gemini-archive-4-/" },
            { name: "Papers-login-better-security-", url: "https://anacondy.github.io/Papers-login-better-security-/" },
            { name: "Pint-site-saving-progress-1-", url: "https://anacondy.github.io/Pint-site-saving-progress-1-/" },
            { name: "powershell-cl-sc-cases-site-htmls-", url: "https://anacondy.github.io/powershell-cl-sc-cases-site-htmls-/" },
            { name: "SC-site-with-home-page-", url: "https://anacondy.github.io/SC-site-with-home-page-/" },
            { name: "stars-ui", url: "https://anacondy.github.io/stars-ui/" },
            { name: "stars-ui-2-", url: "https://anacondy.github.io/stars-ui-2-/" },
            { name: "stars-UI-3", url: "https://anacondy.github.io/stars-UI-3/" },
            { name: "termial-archieve-before-SQLite-imp", url: "https://anacondy.github.io/termial-archieve-before-SQLite-imp/" },
            { name: "Terminal-Archives-PYQs-", url: "https://anacondy.github.io/Terminal-Archives-PYQs-/" },
            { name: "terminal-site-post-mortem-", url: "https://anacondy.github.io/terminal-site-post-mortem-/" }
        ];

        /* =========================================
           AUDIO ENGINE (Web Audio API)
           ========================================= */
        let audioCtx;
        let masterGain;
        
        const AudioEngine = {
            init: function() {
                const AudioContext = window.AudioContext || window.webkitAudioContext;
                audioCtx = new AudioContext();
                
                masterGain = audioCtx.createGain();
                masterGain.gain.value = 0.3; 
                masterGain.connect(audioCtx.destination);
                
                this.startAmbience();
                this.playBootSound();
            },

            startAmbience: function() {
                // Low Hum
                const oscLow = audioCtx.createOscillator();
                oscLow.type = 'sine';
                oscLow.frequency.value = 60;
                const gainLow = audioCtx.createGain();
                gainLow.gain.value = 0.1;
                oscLow.connect(gainLow);
                gainLow.connect(masterGain);
                oscLow.start();

                // High Whine
                const oscHigh = audioCtx.createOscillator();
                oscHigh.type = 'sine';
                oscHigh.frequency.value = 15000;
                const gainHigh = audioCtx.createGain();
                gainHigh.gain.value = 0.02;
                oscHigh.connect(gainHigh);
                gainHigh.connect(masterGain);
                oscHigh.start();
            },

            playBootSound: function() {
                const osc = audioCtx.createOscillator();
                const gain = audioCtx.createGain();
                osc.type = 'triangle';
                osc.frequency.setValueAtTime(100, audioCtx.currentTime);
                osc.frequency.exponentialRampToValueAtTime(800, audioCtx.currentTime + 2);
                gain.gain.setValueAtTime(0, audioCtx.currentTime);
                gain.gain.linearRampToValueAtTime(0.5, audioCtx.currentTime + 0.5);
                gain.gain.exponentialRampToValueAtTime(0.01, audioCtx.currentTime + 3);
                osc.connect(gain);
                gain.connect(masterGain);
                osc.start();
                osc.stop(audioCtx.currentTime + 3.1);
            },

            playParticleSound: function(intensity) {
                if (!audioCtx) return;
                if (Math.random() > 0.3) return; 
                const osc = audioCtx.createOscillator();
                const gain = audioCtx.createGain();
                const freq = 2000 + Math.random() * 3000; 
                osc.type = 'sine';
                osc.frequency.setValueAtTime(freq, audioCtx.currentTime);
                gain.gain.setValueAtTime(0.05 * intensity, audioCtx.currentTime);
                gain.gain.exponentialRampToValueAtTime(0.001, audioCtx.currentTime + 0.1);
                osc.connect(gain);
                gain.connect(masterGain);
                osc.start();
                osc.stop(audioCtx.currentTime + 0.15);
            },

            playHoverSound: function() {
                if (!audioCtx) return;
                const osc = audioCtx.createOscillator();
                const gain = audioCtx.createGain();
                osc.type = 'square';
                osc.frequency.setValueAtTime(400, audioCtx.currentTime);
                osc.frequency.exponentialRampToValueAtTime(600, audioCtx.currentTime + 0.05);
                gain.gain.setValueAtTime(0.05, audioCtx.currentTime);
                gain.gain.exponentialRampToValueAtTime(0.001, audioCtx.currentTime + 0.05);
                osc.connect(gain);
                gain.connect(masterGain);
                osc.start();
                osc.stop(audioCtx.currentTime + 0.06);
            }
        };

        /* =========================================
           VISUAL ENGINE
           ========================================= */
        const PARTICLE_COUNT = 800; 
        const MOUSE_RADIUS = 120;
        const PARTICLE_COLOR = '#ffff00';
        
        const canvas = document.getElementById('particle-canvas');
        const ctx = canvas.getContext('2d');
        const uiLayer = document.getElementById('ui-layer');
        const introLayer = document.getElementById('intro-layer');
        const startOverlay = document.getElementById('start-overlay');
        const splashScreen = document.getElementById('splash-screen');
        const repoScreen = document.getElementById('repo-screen');
        
        // --- START SEQUENCE ---
        function startExperience() {
            // 1. Remove overlay
            startOverlay.style.opacity = '0';
            setTimeout(() => startOverlay.style.display = 'none', 500);

            // 2. Init Audio & Particles
            AudioEngine.init();
            initParticles();
            animate();
            renderRepoList();

            // 3. Play Intro (DVD Logo)
            introLayer.style.opacity = '1';
            document.getElementById('path1').classList.add('animate-draw');
            document.getElementById('path2').classList.add('animate-draw');
            document.getElementById('path3').classList.add('animate-draw');
            document.getElementById('disc1').classList.add('animate-draw-delay');
            document.getElementById('disc2').classList.add('animate-draw-delay');

            // 4. Transition to Splash Screen
            setTimeout(() => {
                introLayer.style.opacity = '0';
                setTimeout(() => {
                    introLayer.style.display = 'none';
                    uiLayer.style.opacity = '1';
                    initWave(); 
                    
                    // 5. Transition to Repo List (After 3 seconds on Splash)
                    setTimeout(() => {
                        splashScreen.style.opacity = '0';
                        setTimeout(() => {
                            splashScreen.style.display = 'none';
                            repoScreen.style.display = 'block';
                            // Force reflow
                            void repoScreen.offsetWidth;
                            repoScreen.style.opacity = '1';
                        }, 500);
                    }, 3000);

                }, 1000);
            }, 3500);

            resizeCanvas();
        }

        // --- RENDER REPO LIST ---
        function generateRandomRetroDate() {
            const years = ['1998', '1999', '2001', '2024', '2025'];
            const months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'NOV', 'DEC'];
            const day = Math.floor(Math.random() * 28) + 1;
            return `${years[Math.floor(Math.random()*years.length)]}-${months[Math.floor(Math.random()*months.length)]}-${day < 10 ? '0'+day : day}`;
        }

        function renderRepoList() {
            const listContainer = document.getElementById('repo-list');
            listContainer.innerHTML = '';
            
            rawRepoList.forEach((repo, index) => {
                const link = document.createElement('a');
                link.href = repo.url;
                link.className = 'repo-item';
                link.target = "_blank"; // Open in new tab
                
                // Add index number for retro list feel
                const idxStr = (index + 1).toString().padStart(2, '0');
                
                link.innerHTML = `
                    <div style="display:flex; justify-content:space-between; align-items: center;">
                        <span class="truncate pr-4">${idxStr}. ${repo.name}</span>
                        <span class="dim-text text-xs whitespace-nowrap">${generateRandomRetroDate()}</span>
                    </div>
                `;
                
                // Add hover sound effect
                link.addEventListener('mouseenter', () => AudioEngine.playHoverSound());
                link.addEventListener('click', () => AudioEngine.playHoverSound()); // For touch
                
                listContainer.appendChild(link);
            });
        }

        // --- PARTICLE SYSTEM ---
        let particles = [];
        let mouse = { x: null, y: null, active: false, velocity: 0 };
        let lastMousePos = { x: 0, y: 0 };

        window.addEventListener('resize', () => {
            resizeCanvas();
            initParticles();
        });

        function resizeCanvas() {
            canvas.width = window.innerWidth;
            canvas.height = window.innerHeight;
        }

        const updateMouse = (x, y) => {
            const dx = x - lastMousePos.x;
            const dy = y - lastMousePos.y;
            mouse.velocity = Math.sqrt(dx*dx + dy*dy);
            lastMousePos.x = x;
            lastMousePos.y = y;
            mouse.x = x;
            mouse.y = y;
            mouse.active = true;
            document.getElementById('coord-x').innerText = Math.floor(x).toString().padStart(3, '0');
            document.getElementById('coord-y').innerText = Math.floor(y).toString().padStart(3, '0');
        };

        window.addEventListener('mousemove', (e) => updateMouse(e.x, e.y));
        window.addEventListener('touchmove', (e) => {
            updateMouse(e.touches[0].clientX, e.touches[0].clientY);
        }, {passive: false});
        window.addEventListener('touchstart', (e) => {
            lastMousePos.x = e.touches[0].clientX;
            lastMousePos.y = e.touches[0].clientY;
            updateMouse(e.touches[0].clientX, e.touches[0].clientY);
        }, {passive: false});

        window.addEventListener('touchend', () => { mouse.active = false; mouse.velocity = 0; });
        window.addEventListener('mouseout', () => { mouse.active = false; mouse.velocity = 0; });

        class Particle {
            constructor() {
                this.x = Math.random() * canvas.width;
                this.y = Math.random() * canvas.height;
                this.vx = (Math.random() - 0.5) * 0.5;
                this.vy = (Math.random() - 0.5) * 0.5;
                this.size = Math.random() * 2 + 1; 
                this.baseX = this.x;
                this.baseY = this.y;
                this.density = (Math.random() * 30) + 1;
            }

            draw() {
                ctx.fillStyle = PARTICLE_COLOR;
                ctx.fillRect(this.x, this.y, this.size, this.size);
            }

            update() {
                if (mouse.active) {
                    let dx = mouse.x - this.x;
                    let dy = mouse.y - this.y;
                    let distance = Math.sqrt(dx * dx + dy * dy);
                    
                    if (distance < MOUSE_RADIUS) {
                        const forceDirectionX = dx / distance;
                        const forceDirectionY = dy / distance;
                        const maxDistance = MOUSE_RADIUS;
                        const force = (maxDistance - distance) / maxDistance;
                        const directionX = forceDirectionX * force * this.density;
                        const directionY = forceDirectionY * force * this.density;

                        this.vx -= directionX;
                        this.vy -= directionY;

                        if (mouse.velocity > 5 && Math.random() > 0.99) {
                            AudioEngine.playParticleSound(Math.min(mouse.velocity / 20, 1));
                        }
                    }
                }
                this.x += this.vx;
                this.y += this.vy;
                this.vx *= 0.95; 
                this.vy *= 0.95;
                if (this.x > canvas.width) this.x = 0;
                if (this.x < 0) this.x = canvas.width;
                if (this.y > canvas.height) this.y = 0;
                if (this.y < 0) this.y = canvas.height;
            }
        }

        function initParticles() {
            particles = [];
            const count = window.innerWidth < 768 ? PARTICLE_COUNT / 2 : PARTICLE_COUNT;
            for (let i = 0; i < count; i++) {
                particles.push(new Particle());
            }
        }

        function animate() {
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            for (let i = 0; i < particles.length; i++) {
                particles[i].draw();
                particles[i].update();
            }
            requestAnimationFrame(animate);
        }

        function initWave() {
            const waveCanvas = document.getElementById('wave-canvas');
            const waveCtx = waveCanvas.getContext('2d');
            let offset = 0;
            function drawWave() {
                waveCtx.clearRect(0, 0, waveCanvas.width, waveCanvas.height);
                waveCtx.beginPath();
                waveCtx.lineWidth = 2;
                waveCtx.strokeStyle = '#33ff00';
                for (let i = 0; i < waveCanvas.width; i++) {
                    const y = 20 + Math.sin(i * 0.05 + offset) * 10 * Math.sin(offset * 0.1);
                    waveCtx.lineTo(i, y);
                }
                waveCtx.stroke();
                offset += 0.1;
                requestAnimationFrame(drawWave);
            }
            drawWave();

            setInterval(() => {
                document.getElementById('fps-counter').innerText = Math.floor(58 + Math.random() * 4);
                document.getElementById('mem-counter').innerText = Math.random() > 0.9 ? "BUSY" : "OK";
            }, 500);
            
            const bar = document.getElementById('loading-bar');
            let width = 100;
            setInterval(() => {
                width = (width + 5) % 100;
                bar.style.width = width + '%';
            }, 100);
        }
    </script>
</body>
</html>
```

### FILE: CHANGELOG.md
```markdown
# Repository Update Log

**Last Updated:** (Will be automatically updated by workflow)

## Summary

- **Repositories Added:** 0
- **Repositories Deleted:** 0
- **Status Changes:** 0
- **Date Updates:** 0
- **Errors/Issues:** 0

## ℹ️ No Changes

This file will be automatically updated by the workflow every time it runs.

The workflow will track and display:
- 🆕 New repositories added
- 🗑️ Repositories deleted (no longer have GitHub Pages)
- 🔄 Status changes (active ↔ 404 ↔ building)
- 📅 Date updates (when repositories become active)
- ⚠️ Errors or issues detected

Each section will include a table with relevant details including repository names, URLs, statuses, and dates.
```

### FILE: GITHUB_ACTIONS_GUIDE.md
```markdown
# GitHub Actions & Automation Guide for Students

**A comprehensive guide to understanding and using GitHub Actions for automation**

---

## Table of Contents

1. [What is GitHub Actions?](#what-is-github-actions)
2. [How GitHub Actions Works](#how-github-actions-works)
3. [Key Concepts](#key-concepts)
4. [Common Use Cases](#common-use-cases)
5. [Student-Specific Applications](#student-specific-applications)
6. [Real-Life Examples](#real-life-examples)
7. [Getting Started](#getting-started)
8. [Best Practices](#best-practices)
9. [Free Tier & Limits](#free-tier--limits)
10. [Resources & Learning](#resources--learning)

---

## What is GitHub Actions?

GitHub Actions is **GitHub's built-in automation platform** that allows you to automate tasks in your software development workflow. Think of it as having a robot assistant that can automatically perform tasks whenever certain events happen in your repository.

### Simple Analogy
Imagine you have a personal assistant who:
- Checks your homework every time you submit it
- Automatically publishes your website when you update the code
- Sends you a notification when someone comments on your project
- Updates your project documentation when you change the code

That's essentially what GitHub Actions does for your code!

---

## How GitHub Actions Works

### The Basic Flow

```
Event Trigger → GitHub Starts a Virtual Computer → Runs Your Tasks → Saves Results → Shuts Down
```

### Step-by-Step Breakdown

1. **Event Occurs**
   - You push code to GitHub
   - A schedule time is reached (like our 17-hour interval)
   - Someone creates a pull request
   - You manually trigger the workflow

2. **GitHub Spins Up a Runner**
   - Runner = A virtual computer (like Ubuntu Linux, Windows, or macOS)
   - Fresh, clean environment every time
   - Has all the tools you might need (Git, Node.js, Python, etc.)

3. **Executes Your Workflow**
   - Follows the steps you defined in a YAML file
   - Can run commands, scripts, or use pre-built actions
   - Has access to your repository code

4. **Reports Results**
   - Shows success/failure status
   - Provides logs of everything that happened
   - Can commit changes back to your repository

5. **Cleans Up**
   - Virtual computer is destroyed
   - No trace left behind (except your results)

### Under the Hood

```yaml
# This is a workflow file (.github/workflows/example.yml)
name: My First Workflow

on:
  push:                    # Trigger: when you push code
    branches: [main]
  schedule:                # Trigger: on a schedule
    - cron: '0 9 * * 1'   # Every Monday at 9 AM UTC

jobs:
  my-job:
    runs-on: ubuntu-latest # Use Ubuntu Linux
    steps:
      - name: Checkout code
        uses: actions/checkout@v4    # Get your repository code
      
      - name: Run a script
        run: echo "Hello, World!"    # Execute a command
```

---

## Key Concepts

### 1. Workflows
**Definition**: An automated process made up of one or more jobs.
- Defined in YAML files in `.github/workflows/` directory
- Can be triggered by events or schedules
- Multiple workflows can run independently

**Example Use**: "Every time I push code, run tests"

### 2. Events
**Definition**: Specific activities that trigger a workflow.

**Common Events**:
- `push` - Code is pushed to a branch
- `pull_request` - A PR is opened/updated
- `schedule` - Time-based (using cron syntax)
- `workflow_dispatch` - Manual trigger
- `release` - A new release is created
- `issues` - Issues are opened/closed

### 3. Jobs
**Definition**: A set of steps that execute on the same runner.
- Jobs run in parallel by default
- Can depend on other jobs
- Each job runs in a fresh virtual environment

### 4. Steps
**Definition**: Individual tasks within a job.
- Run sequentially in order
- Can run commands or use actions
- Share the same runner

### 5. Actions
**Definition**: Reusable units of code.
- Created by GitHub, community, or you
- Can be shared across workflows
- Found in GitHub Marketplace

### 6. Runners
**Definition**: Virtual machines that execute your workflows.

**Available Options**:
- `ubuntu-latest` (Linux)
- `windows-latest` (Windows)
- `macos-latest` (macOS)

---

## Common Use Cases

### 1. Continuous Integration (CI)

**What**: Automatically test your code when changes are made.

**Why**: Catch bugs early, ensure code quality.

**Example Workflow**:
```yaml
name: Run Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
      - name: Install dependencies
        run: npm install
      - name: Run tests
        run: npm test
```

**Real Benefit**: Never merge broken code again!

---

### 2. Continuous Deployment (CD)

**What**: Automatically deploy your application when code is pushed.

**Why**: No manual deployment steps, faster releases.

**Example Workflow**:
```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build website
        run: npm run build
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./dist
```

**Real Benefit**: Your website updates automatically when you push code!

---

### 3. Code Quality Checks

**What**: Automatically check code style, formatting, and best practices.

**Why**: Maintain consistent code quality across your project.

**Example Workflow**:
```yaml
name: Code Quality

on: [push, pull_request]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      - name: Install linters
        run: pip install flake8 black
      - name: Check code style
        run: black --check .
      - name: Lint code
        run: flake8 .
```

**Real Benefit**: Consistent code style without manual checking!

---

### 4. Automated Documentation

**What**: Generate and update documentation from your code.

**Why**: Keep docs in sync with code automatically.

**Example Workflow**:
```yaml
name: Generate Docs

on:
  push:
    branches: [main]

jobs:
  docs:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup Python
        uses: actions/setup-python@v4
      - name: Install Sphinx
        run: pip install sphinx
      - name: Build documentation
        run: sphinx-build -b html docs/ docs/_build
      - name: Deploy docs
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./docs/_build
```

**Real Benefit**: Documentation always matches your latest code!

---

### 5. Scheduled Tasks

**What**: Run tasks on a schedule (like our repository update workflow).

**Why**: Automate recurring tasks without manual intervention.

**Example Workflow**:
```yaml
name: Daily Backup

on:
  schedule:
    - cron: '0 2 * * *'  # Every day at 2 AM UTC

jobs:
  backup:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Create backup
        run: |
          tar -czf backup.tar.gz .
          # Upload to cloud storage
      - name: Commit backup info
        run: |
          git config user.name 'github-actions[bot]'
          git config user.email 'github-actions[bot]@users.noreply.github.com'
          echo "Last backup: $(date)" > backup.txt
          git add backup.txt
          git commit -m "Update backup timestamp"
          git push
```

**Real Benefit**: Never forget regular maintenance tasks!

---

### 6. Dependency Updates

**What**: Automatically check for and update dependencies.

**Why**: Keep your project secure and up-to-date.

**Example**: Use Dependabot (built-in GitHub feature)
```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
```

**Real Benefit**: Security patches applied automatically!

---

## Student-Specific Applications

### For Coursework

#### 1. **Auto-Grade Assignments**
```yaml
name: Auto-Grade Submission

on:
  push:
    branches: [submission]

jobs:
  grade:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run test suite
        run: python test_assignment.py
      - name: Calculate grade
        run: python calculate_grade.py
      - name: Post results
        run: |
          echo "Grade: $GRADE/100" >> $GITHUB_STEP_SUMMARY
```

**Use Case**: Submit assignment by pushing to a branch, get instant feedback.

---

#### 2. **Project Report Generation**
```yaml
name: Generate Weekly Report

on:
  schedule:
    - cron: '0 18 * * 5'  # Every Friday at 6 PM

jobs:
  report:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Generate commit statistics
        run: |
          git log --since="7 days ago" --pretty=format:"%h - %an: %s" > weekly_report.txt
      - name: Count contributions
        run: |
          echo "Lines added: $(git diff --stat HEAD~7 HEAD | tail -1)" >> weekly_report.txt
      - name: Commit report
        run: |
          git add weekly_report.txt
          git commit -m "Weekly progress report"
          git push
```

**Use Case**: Automatic progress tracking for your professor or team.

---

#### 3. **Plagiarism Detection**
```yaml
name: Check for Plagiarism

on: [pull_request]

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install plagiarism checker
        run: pip install copydetect
      - name: Run check
        run: |
          copydetect -t . -r reference_code/ -o report.html
      - name: Upload report
        uses: actions/upload-artifact@v3
        with:
          name: plagiarism-report
          path: report.html
```

**Use Case**: Ensure code originality in group projects.

---

#### 4. **Presentation Slide Generation**
```yaml
name: Build Presentation

on:
  push:
    paths:
      - 'slides/**'

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install Marp
        run: npm install -g @marp-team/marp-cli
      - name: Convert Markdown to PDF
        run: marp slides/presentation.md --pdf
      - name: Upload slides
        uses: actions/upload-artifact@v3
        with:
          name: presentation
          path: slides/presentation.pdf
```

**Use Case**: Write slides in Markdown, get PDF automatically.

---

### For Personal Projects

#### 5. **Portfolio Website Auto-Deploy**
```yaml
name: Deploy Portfolio

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup Node.js
        uses: actions/setup-node@v4
      - name: Build website
        run: |
          npm install
          npm run build
      - name: Deploy
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./build
```

**Use Case**: Update portfolio by just pushing code changes.

---

#### 6. **Blog Post Publishing**
```yaml
name: Publish Blog

on:
  push:
    paths:
      - 'posts/**/*.md'

jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v2
      - name: Build blog
        run: hugo --minify
      - name: Deploy
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./public
```

**Use Case**: Write blog posts in Markdown, auto-publish to your site.

---

#### 7. **Social Media Auto-Post**
```yaml
name: Share New Project

on:
  release:
    types: [published]

jobs:
  tweet:
    runs-on: ubuntu-latest
    steps:
      - name: Tweet about release
        uses: Eomm/why-don-t-you-tweet@v1
        with:
          tweet-message: "🚀 Just released ${{ github.event.release.name }}! Check it out: ${{ github.event.release.html_url }}"
        env:
          TWITTER_CONSUMER_API_KEY: ${{ secrets.TWITTER_API_KEY }}
          TWITTER_CONSUMER_API_SECRET: ${{ secrets.TWITTER_API_SECRET }}
          TWITTER_ACCESS_TOKEN: ${{ secrets.TWITTER_ACCESS_TOKEN }}
          TWITTER_ACCESS_TOKEN_SECRET: ${{ secrets.TWITTER_TOKEN_SECRET }}
```

**Use Case**: Automatic social media updates for your projects.

---

## Real-Life Examples

### Example 1: Full-Stack Web App CI/CD

**Scenario**: You're building a full-stack web application for a class project.

**Problem**: You need to ensure the frontend and backend work together, and deploy updates frequently.

**Solution**:
```yaml
name: Full-Stack CI/CD

on:
  push:
    branches: [main]
  pull_request:

jobs:
  test-backend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      - name: Install dependencies
        run: |
          cd backend
          pip install -r requirements.txt
      - name: Run backend tests
        run: |
          cd backend
          pytest
      - name: Check code coverage
        run: |
          cd backend
          pytest --cov=. --cov-report=xml
      - name: Upload coverage
        uses: codecov/codecov-action@v3

  test-frontend:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
      - name: Install dependencies
        run: |
          cd frontend
          npm install
      - name: Run frontend tests
        run: |
          cd frontend
          npm test
      - name: Build frontend
        run: |
          cd frontend
          npm run build

  deploy:
    needs: [test-backend, test-frontend]
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - name: Deploy to Heroku
        uses: akhileshns/heroku-deploy@v3.12.14
        with:
          heroku_api_key: ${{ secrets.HEROKU_API_KEY }}
          heroku_app_name: "my-class-project"
          heroku_email: "your-email@example.com"
```

**Benefits**:
- ✅ Catches bugs before they reach production
- ✅ Ensures frontend and backend compatibility
- ✅ Automatic deployment on successful tests
- ✅ No manual deployment steps

---

### Example 2: Research Paper LaTeX Compilation

**Scenario**: You're writing a research paper in LaTeX for your thesis.

**Problem**: You want to automatically compile your PDF whenever you update the source.

**Solution**:
```yaml
name: Compile LaTeX Paper

on:
  push:
    paths:
      - '**.tex'
      - 'references.bib'

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Compile LaTeX
        uses: xu-cheng/latex-action@v2
        with:
          root_file: main.tex
          
      - name: Upload PDF
        uses: actions/upload-artifact@v3
        with:
          name: paper-pdf
          path: main.pdf
          
      - name: Create Release
        if: startsWith(github.ref, 'refs/tags/')
        uses: softprops/action-gh-release@v1
        with:
          files: main.pdf
```

**Benefits**:
- ✅ Never worry about LaTeX compilation errors
- ✅ Always have the latest PDF available
- ✅ Easy sharing with advisors

---

### Example 3: Data Science Notebook Execution

**Scenario**: You have Jupyter notebooks that analyze data and need to run daily.

**Problem**: Manual execution is time-consuming and easy to forget.

**Solution**:
```yaml
name: Run Data Analysis

on:
  schedule:
    - cron: '0 6 * * *'  # Every day at 6 AM
  workflow_dispatch:     # Also allow manual trigger

jobs:
  analyze:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'
          
      - name: Install dependencies
        run: |
          pip install jupyter nbconvert pandas matplotlib
          
      - name: Execute notebook
        run: |
          jupyter nbconvert --to notebook --execute analysis.ipynb
          
      - name: Convert to HTML
        run: |
          jupyter nbconvert --to html analysis.nbconvert.ipynb
          
      - name: Commit results
        run: |
          git config user.name 'github-actions[bot]'
          git config user.email 'github-actions[bot]@users.noreply.github.com'
          git add analysis.nbconvert.ipynb analysis.html
          git commit -m "Daily analysis: $(date)"
          git push
```

**Benefits**:
- ✅ Automated daily data analysis
- ✅ Results tracked in version control
- ✅ HTML output for easy viewing

---

### Example 4: Mobile App Build & Test

**Scenario**: You're developing a React Native mobile app.

**Problem**: Need to test on multiple platforms and create builds.

**Solution**:
```yaml
name: Build Mobile App

on:
  push:
    branches: [main, develop]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup Node.js
        uses: actions/setup-node@v4
      - name: Install dependencies
        run: npm install
      - name: Run tests
        run: npm test
      - name: Lint code
        run: npm run lint

  build-android:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup JDK
        uses: actions/setup-java@v3
        with:
          java-version: '11'
      - name: Build Android APK
        run: |
          cd android
          ./gradlew assembleRelease
      - name: Upload APK
        uses: actions/upload-artifact@v3
        with:
          name: android-apk
          path: android/app/build/outputs/apk/release/app-release.apk

  build-ios:
    needs: test
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup Xcode
        uses: maxim-lobanov/setup-xcode@v1
      - name: Build iOS app
        run: |
          cd ios
          xcodebuild -workspace MyApp.xcworkspace -scheme MyApp -configuration Release
```

**Benefits**:
- ✅ Automated builds for both platforms
- ✅ Catch build errors early
- ✅ Easy distribution to testers

---

### Example 5: Documentation Website with Search

**Scenario**: You're maintaining documentation for an open-source project.

**Problem**: Documentation needs to be built, searchable, and always up-to-date.

**Solution**:
```yaml
name: Build Documentation Site

on:
  push:
    branches: [main]
    paths:
      - 'docs/**'

jobs:
  build-deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Python
        uses: actions/setup-python@v4
        
      - name: Install MkDocs
        run: |
          pip install mkdocs-material
          pip install mkdocs-search
          
      - name: Build documentation
        run: mkdocs build
        
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./site
          
      - name: Generate search index
        run: |
          # Custom script to generate Algolia search index
          python scripts/generate_search_index.py
```

**Benefits**:
- ✅ Professional documentation site
- ✅ Automatic updates on every change
- ✅ Searchable content

---

## Getting Started

### Step 1: Create Your First Workflow

1. **Create the workflow directory**:
   ```bash
   mkdir -p .github/workflows
   ```

2. **Create a workflow file** (e.g., `.github/workflows/hello-world.yml`):
   ```yaml
   name: Hello World
   
   on: [push]
   
   jobs:
     greet:
       runs-on: ubuntu-latest
       steps:
         - name: Say hello
           run: echo "Hello, World! This is my first GitHub Action!"
   ```

3. **Commit and push**:
   ```bash
   git add .github/workflows/hello-world.yml
   git commit -m "Add first workflow"
   git push
   ```

4. **View the results**:
   - Go to your GitHub repository
   - Click "Actions" tab
   - See your workflow run!

---

### Step 2: Understanding Cron Syntax

Cron expressions define when scheduled workflows run:

```
┌───────────── minute (0 - 59)
│ ┌───────────── hour (0 - 23)
│ │ ┌───────────── day of month (1 - 31)
│ │ │ ┌───────────── month (1 - 12)
│ │ │ │ ┌───────────── day of week (0 - 6) (Sunday = 0)
│ │ │ │ │
* * * * *
```

**Examples**:
- `0 0 * * *` - Every day at midnight
- `0 9 * * 1` - Every Monday at 9 AM
- `*/15 * * * *` - Every 15 minutes
- `0 0 1 * *` - First day of every month
- `0 0 * * 0` - Every Sunday

**Tool**: Use [crontab.guru](https://crontab.guru/) to build cron expressions.

---

### Step 3: Using Secrets

For sensitive data (API keys, passwords):

1. **Add secrets in GitHub**:
   - Go to Settings → Secrets and variables → Actions
   - Click "New repository secret"
   - Add name and value

2. **Use in workflow**:
   ```yaml
   steps:
     - name: Use secret
       run: echo "API Key: ${{ secrets.MY_API_KEY }}"
       env:
         API_KEY: ${{ secrets.MY_API_KEY }}
   ```

**⚠️ Important**: Never commit secrets to your repository!

---

### Step 4: Debugging Workflows

**View Logs**:
1. Go to Actions tab
2. Click on the workflow run
3. Click on the job
4. Expand steps to see detailed logs

**Enable Debug Logging**:
Add these secrets:
- `ACTIONS_STEP_DEBUG` = `true`
- `ACTIONS_RUNNER_DEBUG` = `true`

**Common Issues**:
- ❌ **Permission denied**: Check repository permissions
- ❌ **Command not found**: Install the tool first
- ❌ **Timeout**: Increase timeout or optimize script
- ❌ **Rate limiting**: Add delays between API calls

---

## Best Practices

### 1. Keep Workflows Simple
- ✅ One workflow = one purpose
- ✅ Break complex tasks into multiple jobs
- ✅ Use descriptive names

### 2. Use Actions from Marketplace
- ✅ Don't reinvent the wheel
- ✅ Check action popularity and maintenance
- ✅ Pin to specific versions (`uses: actions/checkout@v4`)

### 3. Cache Dependencies
```yaml
- name: Cache npm dependencies
  uses: actions/cache@v3
  with:
    path: ~/.npm
    key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
```

### 4. Set Timeouts
```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    timeout-minutes: 10  # Prevent runaway workflows
```

### 5. Use Matrix Builds
Test across multiple versions:
```yaml
jobs:
  test:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
        python-version: ['3.9', '3.10', '3.11']
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v4
        with:
          python-version: ${{ matrix.python-version }}
```

### 6. Secure Your Workflows
- ✅ Use `GITHUB_TOKEN` for authentication
- ✅ Store secrets in GitHub Secrets
- ✅ Review third-party actions before using
- ✅ Limit workflow permissions

---

## Free Tier & Limits

### GitHub Actions Free Tier

**For Public Repositories**:
- ✅ **Unlimited minutes** for public repos
- ✅ All features available
- ✅ No cost whatsoever

**For Private Repositories**:
- ✅ **2,000 minutes/month** free
- ✅ Additional minutes: $0.008/minute
- ✅ Storage: 500 MB free

### Resource Limits

**Per Workflow Run**:
- Maximum duration: 6 hours
- Maximum jobs: 20 jobs per workflow
- Maximum concurrent jobs: Varies by plan

**Per Job**:
- Maximum duration: 6 hours
- Maximum matrix size: 256 jobs

**Storage**:
- Artifacts: 90 days retention
- Logs: 90 days retention

### Tips to Save Minutes

1. **Use caching** to speed up workflows
2. **Cancel redundant runs** for PRs
3. **Use conditions** to skip unnecessary jobs
4. **Optimize test suites** to run faster

---

## Resources & Learning

### Official Documentation
- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [Workflow Syntax](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)
- [Actions Marketplace](https://github.com/marketplace?type=actions)

### Learning Resources
- [GitHub Actions Tutorial](https://github.com/skills/hello-github-actions)
- [Awesome Actions](https://github.com/sdras/awesome-actions) - Curated list
- [GitHub Actions by Example](https://www.actionsbyexample.com/)

### Community
- [GitHub Community Forum](https://github.com/orgs/community/discussions)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/github-actions)
- [r/github](https://www.reddit.com/r/github/)

### Video Tutorials
- [GitHub Actions Tutorial for Beginners](https://www.youtube.com/watch?v=R8_veQiYBjI) by TechWorld with Nana
- [GitHub Actions Course](https://www.youtube.com/watch?v=eB0nUzAI7M8) by freeCodeCamp

### Books
- "Learning GitHub Actions" by Brent Laster
- "GitHub Actions Cookbook" by Michael Kaufmann

---

## Practical Exercises for Students

### Beginner Level

**Exercise 1: Hello World**
Create a workflow that prints your name and the current date.

**Exercise 2: Python Test Runner**
Create a workflow that runs Python tests when you push code.

**Exercise 3: Scheduled Reporter**
Create a workflow that runs weekly and generates a commit count report.

### Intermediate Level

**Exercise 4: Multi-Language Project**
Create a workflow that tests both Python backend and JavaScript frontend.

**Exercise 5: Auto-Deploy Portfolio**
Build and deploy your portfolio website automatically.

**Exercise 6: Issue Labeler**
Create a workflow that automatically labels issues based on keywords.

### Advanced Level

**Exercise 7: Release Automation**
Automatically create releases with changelog and compiled binaries.

**Exercise 8: Performance Monitoring**
Run performance tests and track metrics over time.

**Exercise 9: Multi-Platform Builds**
Build and test your application on Windows, macOS, and Linux.

---

## Quick Reference

### Common Workflow Templates

#### Node.js Project
```yaml
name: Node.js CI
on: [push, pull_request]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
      - run: npm ci
      - run: npm test
      - run: npm run build
```

#### Python Project
```yaml
name: Python CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      - run: pip install -r requirements.txt
      - run: pytest
```

#### Docker Build
```yaml
name: Docker Build
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build Docker image
        run: docker build -t myapp:latest .
      - name: Push to registry
        run: |
          echo ${{ secrets.DOCKER_PASSWORD }} | docker login -u ${{ secrets.DOCKER_USERNAME }} --password-stdin
          docker push myapp:latest
```

---

## Conclusion

GitHub Actions is a powerful tool that can save you time, improve code quality, and automate repetitive tasks. As a student, learning to use automation early will:

✅ **Make you more productive** - Spend time on what matters
✅ **Improve your skills** - Learn DevOps and CI/CD practices
✅ **Stand out to employers** - Demonstrate professional development practices
✅ **Build better projects** - Consistent quality and testing

**Start small**, experiment with simple workflows, and gradually build more complex automations. The skills you learn will be valuable throughout your career!

---

**Questions? Need Help?**

- Check the [GitHub Actions Documentation](https://docs.github.com/en/actions)
- Ask in [GitHub Community Discussions](https://github.com/orgs/community/discussions)
- Search [Stack Overflow](https://stackoverflow.com/questions/tagged/github-actions)

**Happy Automating! 🚀**
```

### FILE: IMPLEMENTATION.md
```markdown
# Auto-Update Repository Archive - Implementation Guide

## Overview
This implementation adds an automatic repository status checking system that runs every ~32 hours to keep the 3-DVD-archieve site up-to-date.

## Files Modified/Created

### 1. `repos.json` (New)
Central data file containing all repository information:
```json
[
  {
    "name": "repository-name",
    "url": "https://anacondy.github.io/repository-name/",
    "date": "2025-12-01",
    "status": "active" | "404" | "building"
  }
]
```

### 2. `index.html` (Modified)
- Added `loadRepoData()` function to fetch repository data from JSON
- Updated `formatRetroDate()` to handle ISO date format (YYYY-MM-DD)
- Modified `startExperience()` to load data before rendering
- Status indicators (❌/⏳) automatically added based on status field

### 3. `.github/workflows/update-repo-status.yml` (New)
GitHub Actions workflow that:
- Runs on a cron schedule (approximately every 32 hours)
- **Automatically discovers all public repositories** with GitHub Pages enabled
- Checks each repository URL for availability
- Updates status and dates in repos.json
- **Generates detailed changelog** with tables showing all changes
- Commits changes automatically

### 4. `CHANGELOG.md` (Auto-generated)
Automatically generated file that tracks all repository updates:
- 🆕 Repositories added
- 🗑️ Repositories deleted (no longer have GitHub Pages)
- 🔄 Status changes (active ↔ 404 ↔ building)
- 📅 Date updates (when repositories become active)
- ⚠️ Errors/Issues detected

Each section includes a markdown table with repository details, URLs, statuses, and dates.

## How It Works

### Workflow Schedule
The workflow runs **every 17 hours** throughout the week:
- **Monday**: 00:00, 17:00 UTC
- **Tuesday**: 10:00 UTC
- **Wednesday**: 03:00, 20:00 UTC
- **Thursday**: 13:00 UTC
- **Friday**: 06:00, 23:00 UTC
- **Saturday**: 16:00 UTC
- **Sunday**: 09:00 UTC

This creates a consistent 17-hour interval between runs, resulting in approximately **10 updates per week** (compared to the previous ~5 updates per week with 32-hour intervals).

### Auto-Discovery Process
The workflow automatically discovers repositories by:
1. **Fetching all public repositories** from the anacondy organization via GitHub API
2. **Checking GitHub Pages status** for each repository using the GitHub Pages API
3. **Adding new repositories** with GitHub Pages to the list automatically
4. **Preserving existing data** for repositories that were previously discovered

### Status Detection
The workflow makes HEAD requests to each repository URL:
- **200 OK** → `status: "active"` → No indicator shown
- **404 Not Found** → `status: "404"` → ❌ shown
- **Other responses** → `status: "building"` → ⏳ shown

### Date Updates
- Dates are set to the current date when a **new repository is discovered**
- Dates are updated **only when** a repository changes to "active" status
- This prevents unnecessary commits when nothing has changed

### Change Tracking & Reporting
Every workflow run generates a detailed `CHANGELOG.md` file with:
- **Summary statistics** (repositories added, deleted, status changes, etc.)
- **Tables for each change type**:
  - 🆕 New repositories added (with URL, status, and date)
  - 🗑️ Repositories deleted (repositories that no longer have GitHub Pages)
  - 🔄 Status changes (showing old → new status transitions)
  - 📅 Date updates (when repositories become active)
  - ⚠️ Errors/Issues (repositories with 404 or building status)
- **Commit message includes** a summary of changes made

This provides full transparency on what the automation did during each run.

### Rate Limiting
- 200ms delay between each request
- Total check time: ~13 seconds for 66 repositories
- Avoids overwhelming GitHub's servers

## Manual Workflow Trigger

You can manually run the workflow from the GitHub Actions tab:
1. Go to the repository on GitHub
2. Click "Actions" tab
3. Select "Update Repository Status" workflow
4. Click "Run workflow" button

## Testing Locally

To test the status checking logic:
```bash
node << 'EOF'
const https = require('https');

function checkUrl(url) {
  return new Promise((resolve) => {
    const req = https.request(url, { method: 'HEAD', timeout: 10000 }, (res) => {
      resolve(res.statusCode === 200 ? 'active' : res.statusCode === 404 ? '404' : 'building');
    });
    req.on('error', () => resolve('404'));
    req.on('timeout', () => { req.destroy(); resolve('building'); });
    req.end();
  });
}

checkUrl('https://anacondy.github.io/3-DVD-archieve/')
  .then(status => console.log('Status:', status));
EOF
```

## Maintenance

### Adding New Repositories
**No manual intervention required!** The workflow automatically discovers new repositories with GitHub Pages enabled. Simply:
1. Enable GitHub Pages on your repository
2. Wait for the next workflow run (~32 hours)
3. The repository will appear on the site automatically

Alternatively, you can trigger the workflow manually from the GitHub Actions tab for immediate discovery.

### Removing Repositories
Repositories are automatically discovered based on GitHub Pages status. If you disable GitHub Pages on a repository:
1. The repository will remain in `repos.json` with its last known status
2. To completely remove it, manually delete the entry from `repos.json`

### Changing Check Frequency
Edit `.github/workflows/update-repo-status.yml` and modify the cron schedules. Current schedule runs every 17 hours:
```yaml
schedule:
  - cron: '0 0,17 * * 1,3,5,7'    # 00:00 and 17:00 UTC on Mon, Wed, Fri, Sun
  - cron: '0 10 * * 2,6'          # 10:00 UTC on Tue, Sat
  # ... (see workflow file for complete schedule)
```

## Troubleshooting

### Workflow not running?
- Check the Actions tab for errors
- Verify the workflow file syntax
- Ensure repository has Actions enabled

### Status not updating?
- Check workflow logs in Actions tab
- Verify the URL is accessible
- Test URL manually with curl:
  ```bash
  curl -I https://anacondy.github.io/repo-name/
  ```

### Site not loading data?
- Check browser console for errors
- Verify repos.json is valid JSON
- Test with: `curl https://anacondy.github.io/3-DVD-archieve/repos.json`

## Performance Metrics

- **Total Repositories**: Auto-discovered (currently ~66)
- **Discovery Duration**: ~30-60 seconds (depends on total repo count)
- **Check Duration**: ~13 seconds per 66 repositories
- **Delay Between Requests**: 200ms
- **Workflow Frequency**: Every 17 hours (~10 runs per week)
- **Monthly GitHub Actions Minutes**: ~4-5 minutes (increased from 2-3 with previous 32-hour schedule)

## Security

- ✅ No secrets or credentials required
- ✅ CodeQL security scan: 0 vulnerabilities
- ✅ Safe HTTP requests with timeouts
- ✅ Error handling for failed requests
- ✅ Commits tagged with `[skip ci]` to prevent infinite loops

## Recent Enhancements

✅ **Auto-Discovery** (December 2025)
- Workflow now automatically discovers all repositories with GitHub Pages
- No manual repo.json editing required
- Uses GitHub API to fetch organization repositories
- Checks GitHub Pages status for each repository

## Future Enhancements

Potential improvements for future iterations:
1. Email notifications on status changes
2. Historical status tracking
3. Response time monitoring
4. Batch updates to reduce API calls
5. Dashboard for repository health metrics
6. Filtering by topics or labels
```

### FILE: index.html
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>Retro DVD Interface + Repo List</title>
    <!-- Importing Retro Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=VT323&family=Press+Start+2P&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        :root {
            --phosphor-main: #33ff00;
            --phosphor-dim: #1a8000;
            --particle-color: #ffff00; /* Yellow Frost */
            --bg-color: #050505;
            --scanline-color: rgba(0, 0, 0, 0.5);
            --highlight-bg: rgba(51, 255, 0, 0.2);
        }

        body, html {
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
            background-color: var(--bg-color);
            color: var(--phosphor-main);
            font-family: 'VT323', monospace;
            overflow: hidden; /* Prevent scrolling */
            user-select: none;
            -webkit-user-select: none;
            touch-action: none; /* Crucial for mobile app feel */
        }

        /* --- CRT EFFECT LAYERS --- */
        #crt-container {
            position: relative;
            width: 100%;
            height: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        /* Canvas for Particles - GPU accelerated */
        #particle-canvas {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 1;
            will-change: transform;
            transform: translateZ(0);
            backface-visibility: hidden;
        }

        /* UI Layer */
        #ui-layer {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 2;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            pointer-events: none; /* Let clicks pass to canvas */
            padding: 20px;
            box-sizing: border-box;
            opacity: 0; /* Hidden initially */
            transition: opacity 1s ease-in;
        }

        /* Intro Layer */
        #intro-layer {
            position: absolute;
            z-index: 10;
            width: 100%;
            height: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
            background: var(--bg-color);
            transition: opacity 1s ease-out;
            opacity: 0; /* Hidden until start */
        }

        /* Start Overlay */
        #start-overlay {
            position: absolute;
            z-index: 50;
            width: 100%;
            height: 100%;
            background: black;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            cursor: pointer;
        }

        /* Scanlines - GPU accelerated */
        .scanlines {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(
                to bottom,
                rgba(255,255,255,0),
                rgba(255,255,255,0) 50%,
                rgba(0,0,0,0.2) 50%,
                rgba(0,0,0,0.2)
            );
            background-size: 100% 4px;
            z-index: 20;
            pointer-events: none;
            will-change: transform;
            transform: translateZ(0);
            backface-visibility: hidden;
        }

        /* Screen Glow/Vignette - GPU accelerated */
        .vignette {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: radial-gradient(circle, rgba(0,0,0,0) 60%, rgba(0,0,0,0.6) 100%);
            z-index: 21;
            pointer-events: none;
            box-shadow: inset 0 0 50px rgba(0,0,0,0.7);
            will-change: transform;
            transform: translateZ(0);
            backface-visibility: hidden;
        }

        /* --- UI ELEMENTS --- */
        .glow-text {
            text-shadow: 0 0 5px var(--phosphor-main), 0 0 10px var(--phosphor-main);
        }

        .dim-text {
            color: var(--phosphor-dim);
            text-shadow: none;
        }

        .pixel-font {
            font-family: 'Press Start 2P', cursive;
        }

        /* Intro DVD Logo SVG Styling */
        .dvd-svg {
            width: 80%;
            max-width: 400px;
            fill: none;
            stroke: var(--phosphor-main);
            stroke-width: 3;
            stroke-linecap: round;
            stroke-linejoin: round;
            filter: drop-shadow(0 0 8px var(--phosphor-main));
        }

        .dvd-path {
            stroke-dasharray: 1000;
            stroke-dashoffset: 1000;
        }

        .dvd-disc {
            stroke-dasharray: 600;
            stroke-dashoffset: 600;
        }
        
        /* Animations controlled by JS now to sync with audio */
        .animate-draw {
            animation: drawStroke 3s ease-in-out forwards;
        }
        
        .animate-draw-delay {
            animation: drawStroke 3s ease-in-out 0.5s forwards;
        }

        @keyframes drawStroke {
            to {
                stroke-dashoffset: 0;
            }
        }

        /* Flashing cursor */
        .blink {
            animation: blinker 1s linear infinite;
        }
        @keyframes blinker {
            50% { opacity: 0; }
        }

        /* Author Signature Effect */
        .author-signature {
            color: #fff; /* White hot core */
            text-shadow: 0 0 5px #fff, 0 0 10px var(--phosphor-main), 0 0 20px var(--phosphor-main);
            animation: signaturePulse 2s infinite ease-in-out alternate;
        }

        @keyframes signaturePulse {
            0% { opacity: 0.7; text-shadow: 0 0 2px #fff, 0 0 5px var(--phosphor-main); transform: scale(0.98); }
            100% { opacity: 1; text-shadow: 0 0 10px #fff, 0 0 20px var(--phosphor-main), 0 0 40px var(--phosphor-main); transform: scale(1.02); }
        }

        /* Layout Grid */
        .top-bar, .bottom-bar {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
        }
        
        .side-data {
            font-size: 0.8rem;
            line-height: 1.2;
            opacity: 0.8;
        }

        .center-hud {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            text-align: center;
            width: 100%;
            max-width: 800px;
            /* Allow clicking inside the HUD (for links) */
            pointer-events: auto; 
        }

        /* Splash Screen (DVD VIDEO) */
        #splash-screen {
            transition: opacity 0.5s ease-out;
        }

        /* Repository List Styles */
        #repo-screen {
            display: none; /* Hidden initially */
            opacity: 0;
            transition: opacity 1s ease-in;
            text-align: center;
            width: 100%;
        }

        .repo-list-container {
            width: 90%;
            max-width: 600px;
            height: 55vh; /* Spacious height */
            margin: 20px auto;
            border: 2px solid var(--phosphor-dim);
            padding: 10px;
            overflow-y: auto;
            text-align: left;
            background: rgba(0, 20, 0, 0.3);
            box-shadow: 0 0 15px rgba(51, 255, 0, 0.1);
            -webkit-overflow-scrolling: touch; /* Smooth scrolling on iOS */
        }

        /* Custom Retro Scrollbar */
        .repo-list-container::-webkit-scrollbar {
            width: 12px;
        }
        .repo-list-container::-webkit-scrollbar-track {
            background: #000;
            border-left: 1px solid var(--phosphor-dim);
        }
        .repo-list-container::-webkit-scrollbar-thumb {
            background: var(--phosphor-dim);
            border: 1px solid #000;
        }
        .repo-list-container::-webkit-scrollbar-thumb:hover {
            background: var(--phosphor-main);
        }

        .repo-item {
            display: block;
            padding: 15px;
            margin-bottom: 5px;
            text-decoration: none;
            color: var(--phosphor-main);
            font-size: 1.2rem;
            border-bottom: 1px dashed var(--phosphor-dim);
            transition: all 0.2s;
            cursor: pointer;
            position: relative;
        }

        .repo-item:hover {
            background-color: var(--phosphor-main);
            color: black;
            font-weight: bold;
            text-shadow: none;
        }

        .repo-item:hover::before {
            content: '>';
            position: absolute;
            left: 5px;
        }

        /* Responsive tweaks */
        @media (max-width: 768px) {
            .side-data { font-size: 0.6rem; }
            .dvd-svg { width: 90%; }
            .repo-item { font-size: 0.9rem; padding: 12px; } /* Slightly smaller text for mobile */
            .center-hud { width: 95%; }
            .repo-list-container {
                max-width: 95%;
                -webkit-overflow-scrolling: touch; /* Smooth scrolling on iOS */
            }
        }

        /* Optimizations for 16:9 aspect ratio displays (standard widescreen) */
        @media (aspect-ratio: 16/9) {
            .repo-list-container {
                max-width: 700px;
                height: 60vh;
            }
        }
        
        /* Optimizations for 16:9 aspect ratio mobile devices */
        @media (max-aspect-ratio: 16/9) and (max-width: 480px) {
            .repo-list-container { height: 52vh; }
            .repo-item { padding: 10px; font-size: 0.85rem; }
        }

        /* Optimizations for 20:9 and taller aspect ratio mobile devices (modern smartphones) */
        @media (min-aspect-ratio: 19/9) and (max-width: 768px) {
            .repo-list-container { 
                height: 65vh; /* Use more vertical space on tall phones */
            }
            .side-data {
                font-size: 0.55rem;
                line-height: 1.1;
            }
            .repo-item { 
                padding: 14px;
                font-size: 1rem;
            }
        }
        
        /* High DPI / Retina optimizations for better performance */
        @media (-webkit-min-device-pixel-ratio: 2), (min-resolution: 192dpi) {
            .scanlines {
                background-size: 100% 2px; /* Finer scanlines on high DPI */
            }
            .vignette {
                box-shadow: inset 0 0 40px rgba(0,0,0,0.6); /* Lighter shadow for better performance */
            }
        }

    </style>
</head>
<body>

    <div id="crt-container">
        
        <!-- CRT Visual Effects -->
        <div class="scanlines"></div>
        <div class="vignette"></div>

        <!-- Start Overlay -->
        <div id="start-overlay" onclick="startExperience()">
            <div class="pixel-font glow-text text-xl animate-bounce">▶ TAP TO START</div>
            <div class="dim-text mt-4 text-sm">INITIALIZE SYSTEM AUDIO</div>
        </div>

        <!-- 1. The Particle Canvas -->
        <canvas id="particle-canvas"></canvas>

        <!-- 2. The Intro Layer (DVD Logo) -->
        <div id="intro-layer">
            <svg class="dvd-svg" viewBox="0 0 200 100" xmlns="http://www.w3.org/2000/svg">
                <path id="path1" class="dvd-path" d="M20 20 H50 C70 20 70 60 50 60 H20 Z M30 30 V50 H45 C55 50 55 30 45 30 H30" />
                <path id="path2" class="dvd-path" d="M75 20 L90 60 L105 20" />
                <path id="path3" class="dvd-path" d="M110 20 H130 C150 20 150 60 130 60 H110 Z M120 30 V50 H125 C135 50 135 30 125 30 H120" />
                <ellipse id="disc1" class="dvd-disc" cx="90" cy="75" rx="60" ry="10" />
                <path id="disc2" class="dvd-disc" d="M40 90 H140" stroke-dasharray="5,5" />
            </svg>
        </div>

        <!-- 3. The Main UI Layer (Loads after intro) -->
        <div id="ui-layer">
            <div class="top-bar">
                <div class="side-data text-left">
                    <span class="glow-text">REC ●</span><br>
                    <span class="dim-text">TAPE: A-04</span><br>
                    <span class="dim-text">FPS: <span id="fps-counter">60</span></span>
                </div>
                <div class="pixel-font text-center text-xl tracking-widest glow-text opacity-50">
                    SYSTEM READY
                </div>
                <div class="side-data text-right">
                    <span class="dim-text">BAT: 98%</span><br>
                    <span class="dim-text">MEM: <span id="mem-counter">OK</span></span><br>
                    <span class="blink glow-text">_ACTIVE</span>
                </div>
            </div>

            <!-- Central Content Area -->
            <div class="center-hud">
                
                <!-- Screen 1: Splash (DVD VIDEO) -->
                <div id="splash-screen">
                    <h1 class="pixel-font text-4xl md:text-6xl glow-text mb-4 tracking-tighter">DVD VIDEO</h1>
                    <div class="w-64 h-2 bg-green-900 mx-auto border border-green-500 relative overflow-hidden">
                        <div id="loading-bar" class="absolute top-0 left-0 h-full bg-green-400 w-full opacity-70"></div>
                    </div>
                    <p class="mt-2 text-sm dim-text uppercase tracking-widest">
                        LOADING ARCHIVES...
                    </p>
                </div>

                <!-- Screen 2: Repository List (Hidden Initially) -->
                <div id="repo-screen">
                    <h2 class="pixel-font text-2xl md:text-4xl glow-text mb-2">ARCHIVE INDEX</h2>
                    <p class="dim-text text-sm mb-4">SELECT TITLE TO ACCESS</p>
                    
                    <div class="repo-list-container" id="repo-list">
                        <!-- Content Injected via JS -->
                    </div>

                    <!-- Sine wave simulation moved here -->
                    <canvas id="wave-canvas" width="300" height="40" class="mt-4 mx-auto opacity-70"></canvas>

                    <!-- AUTHOR SIGNATURE -->
                    <div class="mt-2 mb-2">
                        <div class="text-[0.6rem] dim-text tracking-[0.5em] mb-1">//// SYS.ARCHITECT ////</div>
                        <div class="author-signature pixel-font text-xl md:text-2xl tracking-widest">ANACONDY</div>
                    </div>
                </div>

            </div>

            <div class="bottom-bar">
                <div class="side-data">
                    <span class="dim-text">COORD X: <span id="coord-x">000</span></span><br>
                    <span class="dim-text">COORD Y: <span id="coord-y">000</span></span>
                </div>
                <div class="side-data text-right">
                     <span class="dim-text">MODE: BROWSE</span><br>
                     <span class="glow-text">TOUCH SCROLL</span>
                </div>
            </div>
        </div>
    </div>

    <script>
        /* =========================================
           DATA CONFIGURATION
           ========================================= */
        let rawRepoList = [];
        
        // Load repository data from JSON file
        async function loadRepoData() {
            try {
                const response = await fetch('repos.json');
                const data = await response.json();
                // Filter to only include repos that are active (online on GitHub Pages)
                // This excludes private repos and repos with 404 or building status
                rawRepoList = data
                    .filter(repo => repo.status === 'active')
                    .map(repo => {
                        return {
                            name: repo.name,
                            url: repo.url,
                            date: repo.date,
                            status: repo.status
                        };
                    });
                // Sort by date descending (newest first)
                rawRepoList.sort((a, b) => new Date(b.date) - new Date(a.date));
            } catch (error) {
                console.error('Failed to load repository data:', error);
                // Fallback data in case fetch fails
                rawRepoList = [];
            }
        }

        /* =========================================
           AUDIO ENGINE (Web Audio API)
           ========================================= */
        let audioCtx;
        let masterGain;
        
        const AudioEngine = {
            init: async function() {
                const AudioContext = window.AudioContext || window.webkitAudioContext;
                
                // Only create if not already existing
                if (!audioCtx) {
                    audioCtx = new AudioContext();
                }

                // MOBILE FIX: Always try to resume on user gesture
                if (audioCtx.state === 'suspended') {
                    await audioCtx.resume();
                }

                if (!masterGain) {
                    masterGain = audioCtx.createGain();
                    masterGain.gain.value = 0.3; 
                    masterGain.connect(audioCtx.destination);
                    
                    // Only start loops if they haven't started (prevent doubling up)
                    this.startAmbience();
                    this.playBootSound();
                }
            },

            startAmbience: function() {
                // Low Hum
                const oscLow = audioCtx.createOscillator();
                oscLow.type = 'sine';
                oscLow.frequency.value = 60;
                const gainLow = audioCtx.createGain();
                gainLow.gain.value = 0.1;
                oscLow.connect(gainLow);
                gainLow.connect(masterGain);
                oscLow.start();

                // High Whine
                const oscHigh = audioCtx.createOscillator();
                oscHigh.type = 'sine';
                oscHigh.frequency.value = 15000;
                const gainHigh = audioCtx.createGain();
                gainHigh.gain.value = 0.02;
                oscHigh.connect(gainHigh);
                gainHigh.connect(masterGain);
                oscHigh.start();
            },

            playBootSound: function() {
                const osc = audioCtx.createOscillator();
                const gain = audioCtx.createGain();
                osc.type = 'triangle';
                osc.frequency.setValueAtTime(100, audioCtx.currentTime);
                osc.frequency.exponentialRampToValueAtTime(800, audioCtx.currentTime + 2);
                gain.gain.setValueAtTime(0, audioCtx.currentTime);
                gain.gain.linearRampToValueAtTime(0.5, audioCtx.currentTime + 0.5);
                gain.gain.exponentialRampToValueAtTime(0.01, audioCtx.currentTime + 3);
                osc.connect(gain);
                gain.connect(masterGain);
                osc.start();
                osc.stop(audioCtx.currentTime + 3.1);
            },

            playParticleSound: function(intensity) {
                if (!audioCtx || audioCtx.state === 'suspended') return;
                
                if (Math.random() > 0.3) return; 
                const osc = audioCtx.createOscillator();
                const gain = audioCtx.createGain();
                const freq = 2000 + Math.random() * 3000; 
                osc.type = 'sine';
                osc.frequency.setValueAtTime(freq, audioCtx.currentTime);
                gain.gain.setValueAtTime(0.05 * intensity, audioCtx.currentTime);
                gain.gain.exponentialRampToValueAtTime(0.001, audioCtx.currentTime + 0.1);
                osc.connect(gain);
                gain.connect(masterGain);
                osc.start();
                osc.stop(audioCtx.currentTime + 0.15);
            },

            playHoverSound: function() {
                if (!audioCtx || audioCtx.state === 'suspended') return;
                
                const osc = audioCtx.createOscillator();
                const gain = audioCtx.createGain();
                osc.type = 'square';
                osc.frequency.setValueAtTime(400, audioCtx.currentTime);
                osc.frequency.exponentialRampToValueAtTime(600, audioCtx.currentTime + 0.05);
                gain.gain.setValueAtTime(0.05, audioCtx.currentTime);
                gain.gain.exponentialRampToValueAtTime(0.001, audioCtx.currentTime + 0.05);
                osc.connect(gain);
                gain.connect(masterGain);
                osc.start();
                osc.stop(audioCtx.currentTime + 0.06);
            }
        };

        /* =========================================
           VISUAL ENGINE (Optimized for 60+ FPS)
           ========================================= */
        // Constants for device capability thresholds
        const SCREEN_AREA_THRESHOLD_LOW = 1.5; // Million pixels
        const SCREEN_AREA_THRESHOLD_HIGH = 2.5; // Million pixels
        const PIXEL_RATIO_THRESHOLD = 1.5;
        const MOBILE_WIDTH_THRESHOLD = 768;
        
        // Cache device pixel ratio (doesn't change during runtime)
        const DEVICE_PIXEL_RATIO = window.devicePixelRatio || 1;
        
        // Adaptive particle count based on device capabilities
        let cachedParticleCount = null;
        const getOptimalParticleCount = () => {
            // Return cached value if already calculated
            if (cachedParticleCount !== null) return cachedParticleCount;
            
            const width = window.innerWidth;
            const height = window.innerHeight;
            const screenArea = (width * height) / 1000000; // in millions of pixels
            
            // High-end device detection via pixel ratio and screen size
            const isHighEndDevice = DEVICE_PIXEL_RATIO > PIXEL_RATIO_THRESHOLD || screenArea > SCREEN_AREA_THRESHOLD_HIGH;
            
            // Mobile detection
            const isMobile = width < MOBILE_WIDTH_THRESHOLD;
            
            // Base particle count on screen size and device capability
            let count;
            if (isMobile) {
                count = screenArea > SCREEN_AREA_THRESHOLD_LOW ? 400 : 300;
            } else if (isHighEndDevice) {
                count = screenArea > SCREEN_AREA_THRESHOLD_HIGH ? 1000 : 800;
            } else {
                count = 600;
            }
            
            cachedParticleCount = count;
            return count;
        };
        
        const PARTICLE_COUNT = getOptimalParticleCount();
        const MOUSE_RADIUS = 120;
        const PARTICLE_COLOR = '#ffff00';
        
        const canvas = document.getElementById('particle-canvas');
        const ctx = canvas.getContext('2d', { 
            alpha: true,
            desynchronized: true, // Enable low-latency canvas for high refresh rates
            willReadFrequently: false
        });
        const uiLayer = document.getElementById('ui-layer');
        const introLayer = document.getElementById('intro-layer');
        const startOverlay = document.getElementById('start-overlay');
        const splashScreen = document.getElementById('splash-screen');
        const repoScreen = document.getElementById('repo-screen');
        
        // --- START SEQUENCE ---
        async function startExperience() {
            // 1. Load repository data first
            await loadRepoData();
            
            // 2. Init Audio (Await for resume if needed)
            await AudioEngine.init();

            // 3. Remove overlay
            startOverlay.style.opacity = '0';
            setTimeout(() => startOverlay.style.display = 'none', 500);

            // 4. Init Particles & Render
            initParticles();
            animate();
            renderRepoList();

            // 5. Play Intro (DVD Logo)
            introLayer.style.opacity = '1';
            document.getElementById('path1').classList.add('animate-draw');
            document.getElementById('path2').classList.add('animate-draw');
            document.getElementById('path3').classList.add('animate-draw');
            document.getElementById('disc1').classList.add('animate-draw-delay');
            document.getElementById('disc2').classList.add('animate-draw-delay');

            // 6. Transition to Splash Screen
            setTimeout(() => {
                introLayer.style.opacity = '0';
                setTimeout(() => {
                    introLayer.style.display = 'none';
                    uiLayer.style.opacity = '1';
                    initWave(); 
                    
                    // 7. Transition to Repo List (After 3 seconds on Splash)
                    setTimeout(() => {
                        splashScreen.style.opacity = '0';
                        setTimeout(() => {
                            splashScreen.style.display = 'none';
                            repoScreen.style.display = 'block';
                            // Force reflow
                            void repoScreen.offsetWidth;
                            repoScreen.style.opacity = '1';
                        }, 500);
                    }, 3000);

                }, 1000);
            }, 3500);

            resizeCanvas();
        }

        // --- RENDER REPO LIST ---
        function formatRetroDate(dateStr) {
            // dateStr is in format "2025-11-29" - convert to "29-NOV-2025"
            if (!dateStr) return "UNKNOWN";
            const date = new Date(dateStr);
            if (isNaN(date.getTime())) return "UNKNOWN";
            const months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
            const day = date.getDate().toString().padStart(2, '0');
            const month = months[date.getMonth()];
            const year = date.getFullYear();
            return `${day}-${month}-${year}`;
        }

        function renderRepoList() {
            const listContainer = document.getElementById('repo-list');
            listContainer.innerHTML = '';
            
            rawRepoList.forEach((repo, index) => {
                const link = document.createElement('a');
                link.href = repo.url;
                link.className = 'repo-item';
                link.target = "_blank"; // Open in new tab
                
                // Add index number for retro list feel
                const idxStr = (index + 1).toString().padStart(2, '0');
                
                link.innerHTML = `
                    <div style="display:flex; justify-content:space-between; align-items: center;">
                        <span class="truncate pr-4">${idxStr}. ${repo.name}</span>
                        <span class="dim-text text-xs whitespace-nowrap">${formatRetroDate(repo.date)}</span>
                    </div>
                `;
                
                // Add hover sound effect
                link.addEventListener('mouseenter', () => AudioEngine.playHoverSound());
                link.addEventListener('click', () => AudioEngine.playHoverSound()); // For touch
                
                listContainer.appendChild(link);
            });
        }

        // --- PARTICLE SYSTEM ---
        let particles = [];
        let mouse = { x: null, y: null, active: false, velocity: 0 };
        let lastMousePos = { x: 0, y: 0 };

        window.addEventListener('resize', () => {
            cachedParticleCount = null; // Clear cache on resize
            resizeCanvas();
            initParticles();
        });

        function resizeCanvas() {
            const rect = canvas.getBoundingClientRect();
            
            // Set display size (css pixels)
            canvas.style.width = rect.width + 'px';
            canvas.style.height = rect.height + 'px';
            
            // Set actual size in memory (scaled for retina displays)
            canvas.width = rect.width * DEVICE_PIXEL_RATIO;
            canvas.height = rect.height * DEVICE_PIXEL_RATIO;
            
            // Scale context to account for device pixel ratio
            ctx.scale(DEVICE_PIXEL_RATIO, DEVICE_PIXEL_RATIO);
            
            // Update canvas dimensions for particle calculations
            canvas.displayWidth = rect.width;
            canvas.displayHeight = rect.height;
        }

        const updateMouse = (x, y) => {
            const dx = x - lastMousePos.x;
            const dy = y - lastMousePos.y;
            mouse.velocity = Math.sqrt(dx*dx + dy*dy);
            lastMousePos.x = x;
            lastMousePos.y = y;
            mouse.x = x;
            mouse.y = y;
            mouse.active = true;
            
            if (document.getElementById('coord-x')) {
                document.getElementById('coord-x').innerText = Math.floor(x).toString().padStart(3, '0');
                document.getElementById('coord-y').innerText = Math.floor(y).toString().padStart(3, '0');
            }
        };

        window.addEventListener('mousemove', (e) => updateMouse(e.x, e.y));
        
        // Mobile Touch Handling (Prevent Default to stop scrolling while touching canvas)
        window.addEventListener('touchmove', (e) => {
            // Only prevent default if touching the canvas directly (not the list)
            if(e.target === canvas) {
                // e.preventDefault(); // Optional: uncomment if you want to block ALL scrolling on canvas
            }
            updateMouse(e.touches[0].clientX, e.touches[0].clientY);
        }, {passive: false});

        window.addEventListener('touchstart', (e) => {
            lastMousePos.x = e.touches[0].clientX;
            lastMousePos.y = e.touches[0].clientY;
            updateMouse(e.touches[0].clientX, e.touches[0].clientY);
            // Resume audio context on touch if needed
            if(audioCtx && audioCtx.state === 'suspended') {
                audioCtx.resume();
            }
        }, {passive: false});

        window.addEventListener('touchend', () => { mouse.active = false; mouse.velocity = 0; });
        window.addEventListener('mouseout', () => { mouse.active = false; mouse.velocity = 0; });

        class Particle {
            constructor() {
                const w = canvas.displayWidth || canvas.width;
                const h = canvas.displayHeight || canvas.height;
                this.x = Math.random() * w;
                this.y = Math.random() * h;
                this.vx = (Math.random() - 0.5) * 0.5;
                this.vy = (Math.random() - 0.5) * 0.5;
                this.size = Math.random() * 2 + 1; 
                this.baseX = this.x;
                this.baseY = this.y;
                this.density = (Math.random() * 30) + 1;
            }

            draw() {
                // Optimized drawing - fillRect is faster than arc for squares
                ctx.fillStyle = PARTICLE_COLOR;
                ctx.fillRect(this.x | 0, this.y | 0, this.size, this.size); // Bitwise OR for integer conversion (faster)
            }

            update() {
                const w = canvas.displayWidth || canvas.width;
                const h = canvas.displayHeight || canvas.height;
                
                if (mouse.active) {
                    const dx = mouse.x - this.x;
                    const dy = mouse.y - this.y;
                    const distSq = dx * dx + dy * dy; // Use squared distance to avoid sqrt
                    const radiusSq = MOUSE_RADIUS * MOUSE_RADIUS;
                    
                    if (distSq < radiusSq) {
                        const distance = Math.sqrt(distSq); // Only calculate sqrt when needed
                        const forceDirectionX = dx / distance;
                        const forceDirectionY = dy / distance;
                        const force = (MOUSE_RADIUS - distance) / MOUSE_RADIUS;
                        const directionX = forceDirectionX * force * this.density;
                        const directionY = forceDirectionY * force * this.density;

                        this.vx -= directionX;
                        this.vy -= directionY;

                        // Optimized audio triggering
                        if (mouse.velocity > 5 && Math.random() > 0.99) {
                            AudioEngine.playParticleSound(Math.min(mouse.velocity / 20, 1));
                        }
                    }
                }
                
                // Update position
                this.x += this.vx;
                this.y += this.vy;
                this.vx *= 0.95; 
                this.vy *= 0.95;
                
                // Wrap around screen edges
                if (this.x > w) this.x = 0;
                else if (this.x < 0) this.x = w;
                if (this.y > h) this.y = 0;
                else if (this.y < 0) this.y = h;
            }
        }

        function initParticles() {
            particles = [];
            const count = getOptimalParticleCount();
            for (let i = 0; i < count; i++) {
                particles.push(new Particle());
            }
        }

        // High refresh rate animation loop with FPS tracking
        let lastFrameTime = performance.now();
        let frameCount = 0;
        let actualFPS = 60;
        let fpsUpdateTime = performance.now();
        
        // Cache DOM elements to avoid repeated lookups
        let fpsCounterEl = null;
        
        function animate(currentTime) {
            // Calculate delta time for frame-independent animation
            const deltaTime = currentTime - lastFrameTime;
            lastFrameTime = currentTime;
            
            // FPS calculation
            frameCount++;
            if (currentTime - fpsUpdateTime >= 1000) {
                actualFPS = frameCount;
                frameCount = 0;
                fpsUpdateTime = currentTime;
                
                // Update FPS counter in UI (cache element reference)
                if (!fpsCounterEl) fpsCounterEl = document.getElementById('fps-counter');
                if (fpsCounterEl) fpsCounterEl.innerText = actualFPS;
            }
            
            // Get display dimensions
            const w = canvas.displayWidth || canvas.width;
            const h = canvas.displayHeight || canvas.height;
            
            // Clear canvas efficiently
            ctx.clearRect(0, 0, w, h);
            
            // Batch rendering for better performance
            ctx.fillStyle = PARTICLE_COLOR;
            for (let i = 0; i < particles.length; i++) {
                particles[i].update();
                particles[i].draw();
            }
            
            requestAnimationFrame(animate);
        }

        function initWave() {
            const waveCanvas = document.getElementById('wave-canvas');
            const waveCtx = waveCanvas.getContext('2d', { alpha: true });
            let offset = 0;
            let lastWaveTime = performance.now();
            
            // Performance optimization: Skip pixels for smoother rendering
            const WAVE_PIXEL_STEP = 2; // Render every 2nd pixel for better performance
            
            function drawWave(currentTime) {
                // Frame-independent animation
                const deltaTime = (currentTime - lastWaveTime) / 16.67; // Normalize to 60fps baseline
                lastWaveTime = currentTime;
                
                waveCtx.clearRect(0, 0, waveCanvas.width, waveCanvas.height);
                waveCtx.beginPath();
                waveCtx.lineWidth = 2;
                waveCtx.strokeStyle = '#33ff00';
                for (let i = 0; i < waveCanvas.width; i += WAVE_PIXEL_STEP) {
                    const y = 20 + Math.sin(i * 0.05 + offset) * 10 * Math.sin(offset * 0.1);
                    waveCtx.lineTo(i, y);
                }
                waveCtx.stroke();
                offset += 0.1 * deltaTime;
                requestAnimationFrame(drawWave);
            }
            drawWave(performance.now());

            // Cache DOM element references
            const memCounterEl = document.getElementById('mem-counter');
            const loadingBarEl = document.getElementById('loading-bar');
            
            // Update memory status
            setInterval(() => {
                if(memCounterEl) memCounterEl.innerText = Math.random() > 0.9 ? "BUSY" : "OK";
            }, 500);
            
            // Loading bar animation
            let width = 100;
            setInterval(() => {
                if(loadingBarEl) {
                    width = (width + 5) % 100;
                    loadingBarEl.style.width = width + '%';
                }
            }, 100);
        }
    </script>
</body>
</html>
```

### FILE: LICENSE
```text
MIT License

Copyright (c) 2025 Anuj Meena

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

### FILE: log.txt
```text

```

### FILE: README.md
```markdown
# 3-DVD-archieve

A retro DVD-style interface for browsing the Anacondy archive collection.

**Live Site:** https://anacondy.github.io/3-DVD-archieve/

**Repository Status & History:** [View Status](Repository-Status-and-History.md)

## Screenshots

### Desktop View
![Desktop Archive View](https://github.com/user-attachments/assets/f336b951-561a-42ce-ba84-5a20ff6ade4a)

### Mobile View (16:9 / 20:9 optimized)
![Mobile Archive View](https://github.com/user-attachments/assets/8ac9edb2-7202-4e59-948a-359402bbcc82)

## Features

- 🎮 Retro CRT-style visual effects with scanlines and vignette
- ✨ Interactive particle system with smooth 60fps animations
- 🔊 Immersive audio effects with Web Audio API
- 📱 Fully responsive design optimized for mobile devices (16:9 and 20:9 aspect ratios)
- 🎨 Animated ANACONDY signature with glowing pulse effect
- 📅 Archive entries with proper date formatting
- 🖱️ Touch-friendly scrolling and interactions
- 🤖 **Automated repository discovery** - updates every ~32 hours
- 📊 **Change tracking** - see what's new in [CHANGELOG.md](CHANGELOG.md)

## Author

**ANACONDY** - System Architect
```

### FILE: RepoDates
```text
Repository Name,Repo Link,Creation Date
25--3-pro-test,https://github.com/anacondy/25--3-pro-test,2025-11-18T20:39:36Z
25-2-saving-pro-2,https://github.com/anacondy/25-2-saving-pro-2,2025-11-19T18:55:24Z
25-3-gemini-,https://github.com/anacondy/25-3-gemini-,2025-11-20T19:44:40Z
3--Aussie-Political-MAP,https://github.com/anacondy/3--Aussie-Political-MAP,2025-11-21T13:00:53Z
3-24-25-26-,https://github.com/anacondy/3-24-25-26-,2025-11-23T11:56:00Z
3-Bad-day-24-CRT-SPACESHIP-,https://github.com/anacondy/3-Bad-day-24-CRT-SPACESHIP-,2025-11-24T09:55:23Z
3-Canada-map-,https://github.com/anacondy/3-Canada-map-,2025-11-21T12:12:32Z
3-CyperpunkSettings,https://github.com/anacondy/3-CyperpunkSettings,2025-11-24T21:05:18Z
3-DVD-archieve,https://github.com/anacondy/3-DVD-archieve,2025-11-25T23:45:24Z
3-Europe-Map,https://github.com/anacondy/3-Europe-Map,2025-11-21T13:48:09Z
3-GEM---Europe-Parliament-bal,https://github.com/anacondy/3-GEM---Europe-Parliament-bal,2025-11-21T13:57:13Z
3-Gem-ind-via-VCS,https://github.com/anacondy/3-Gem-ind-via-VCS,2025-11-23T19:29:47Z
3-GEM-Map,https://github.com/anacondy/3-GEM-Map,2025-11-21T11:18:45Z
3-Germany,https://github.com/anacondy/3-Germany,2025-11-21T13:24:14Z
3-Heli-24,https://github.com/anacondy/3-Heli-24,2025-11-24T11:34:35Z
3-L-trange-Experience,https://github.com/anacondy/3-L-trange-Experience,2025-11-24T22:41:04Z
3-mobile-indian-map,https://github.com/anacondy/3-mobile-indian-map,2025-11-23T21:47:00Z
3-Music-Player-JSX,https://github.com/anacondy/3-Music-Player-JSX,2025-11-24T22:34:17Z
3-Neon-pulse--24-bad-day-,https://github.com/anacondy/3-Neon-pulse--24-bad-day-,2025-11-24T10:07:12Z
3-PS2-collection,https://github.com/anacondy/3-PS2-collection,2025-11-24T21:12:10Z
3-Regency-Horror-Menu,https://github.com/anacondy/3-Regency-Horror-Menu,2025-11-22T13:21:26Z
3-Regency-latern,https://github.com/anacondy/3-Regency-latern,2025-11-22T16:53:33Z
3-RetroDVD,https://github.com/anacondy/3-RetroDVD,2025-11-24T21:01:38Z
3-Robust-S-S-Scrapper,https://github.com/anacondy/3-Robust-S-S-Scrapper,2025-11-23T18:23:59Z
3-System-registry-,https://github.com/anacondy/3-System-registry-,2025-11-22T14:34:50Z
3-USA-getting-live-,https://github.com/anacondy/3-USA-getting-live-,2025-11-21T12:16:31Z
3-USA-Glassomorphic-MAP-2025,https://github.com/anacondy/3-USA-Glassomorphic-MAP-2025,2025-11-21T11:24:14Z
3-West-world,https://github.com/anacondy/3-West-world,2025-11-21T14:14:28Z
3-Western-world-sav-pro,https://github.com/anacondy/3-Western-world-sav-pro,2025-11-21T14:03:12Z
3-WestWorld-without-bounce-,https://github.com/anacondy/3-WestWorld-without-bounce-,2025-11-21T14:21:58Z
alvido-test-2,https://github.com/anacondy/alvido-test-2,2025-10-12T20:04:26Z
alvido-test-4,https://github.com/anacondy/alvido-test-4,2025-10-12T20:14:07Z
alvido-test-5,https://github.com/anacondy/alvido-test-5,2025-10-12T20:20:35Z
alvido-testing-1,https://github.com/anacondy/alvido-testing-1,2025-10-12T19:54:10Z
before-AI-GJ-Terminal,https://github.com/anacondy/before-AI-GJ-Terminal,2025-10-17T22:17:17Z
codes-,https://github.com/anacondy/codes-,2025-08-30T12:13:34Z
deep-res-Job,https://github.com/anacondy/deep-res-Job,2025-11-11T03:18:04Z
falling-leaves-,https://github.com/anacondy/falling-leaves-,2025-11-05T05:13:48Z
GJ-flask-app-,https://github.com/anacondy/GJ-flask-app-,2025-10-16T21:19:02Z
GJ-Ter-perplex-fills-data-from-gemini-API,https://github.com/anacondy/GJ-Ter-perplex-fills-data-from-gemini-API,2025-10-18T08:45:56Z
GJ-Terminal-2-sorting-card-page-,https://github.com/anacondy/GJ-Terminal-2-sorting-card-page-,2025-10-16T16:15:18Z
GJ-Terminal-csv-,https://github.com/anacondy/GJ-Terminal-csv-,2025-10-16T21:43:27Z
GJ-Terminal-just-a-data-table-with-good-UI,https://github.com/anacondy/GJ-Terminal-just-a-data-table-with-good-UI,2025-10-16T15:55:51Z
glassmorphic-site-card-Ui-html-,https://github.com/anacondy/glassmorphic-site-card-Ui-html-,2025-10-15T19:20:59Z
GPA-calculator,https://github.com/anacondy/GPA-calculator,2025-08-20T16:53:40Z
html-site-for-articles,https://github.com/anacondy/html-site-for-articles,2025-10-20T00:45:07Z
Indian-SC-verdicts-site,https://github.com/anacondy/Indian-SC-verdicts-site,2025-10-19T23:26:19Z
introduction-to-github,https://github.com/anacondy/introduction-to-github,2025-03-27T22:10:20Z
leaves-dying-,https://github.com/anacondy/leaves-dying-,2025-11-05T06:05:02Z
live-volcano-ui,https://github.com/anacondy/live-volcano-ui,2025-09-02T15:55:20Z
login-input,https://github.com/anacondy/login-input,2025-11-05T18:27:40Z
meena,https://github.com/anacondy/meena,2024-08-27T13:48:52Z
mobile-comparison-site-,https://github.com/anacondy/mobile-comparison-site-,2025-08-22T11:09:53Z
MP-tracker-site-,https://github.com/anacondy/MP-tracker-site-,2025-11-02T18:11:27Z
my-living-map,https://github.com/anacondy/my-living-map,2025-08-31T18:31:11Z
paper-gemini-archieve-saving-progress-2-,https://github.com/anacondy/paper-gemini-archieve-saving-progress-2-,2025-10-12T08:23:43Z
paper-gemini-archieve-saving-progress-3,https://github.com/anacondy/paper-gemini-archieve-saving-progress-3,2025-10-12T11:28:46Z
papers-gemini-archive-4-,https://github.com/anacondy/papers-gemini-archive-4-,2025-10-12T19:33:51Z
Papers-login-better-security-,https://github.com/anacondy/Papers-login-better-security-,2025-10-14T17:57:36Z
Pint-site-saving-progress-1-,https://github.com/anacondy/Pint-site-saving-progress-1-,2025-11-03T14:39:35Z
powershell-cl-sc-cases-site-htmls-,https://github.com/anacondy/powershell-cl-sc-cases-site-htmls-,2025-10-21T18:14:38Z
QuizApp,https://github.com/anacondy/QuizApp,2025-11-23T19:26:57Z
SC-site-,https://github.com/anacondy/SC-site-,2025-10-19T21:18:44Z
SC-site-2-saving-progress,https://github.com/anacondy/SC-site-2-saving-progress,2025-10-19T22:07:10Z
SC-site-with-home-page-,https://github.com/anacondy/SC-site-with-home-page-,2025-10-20T19:24:33Z
skills-introduction-to-github,https://github.com/anacondy/skills-introduction-to-github,2025-03-27T22:12:49Z
stars-ui,https://github.com/anacondy/stars-ui,2025-09-01T22:00:39Z
stars-ui-2-,https://github.com/anacondy/stars-ui-2-,2025-09-10T14:26:48Z
stars-UI-3,https://github.com/anacondy/stars-UI-3,2025-09-10T14:42:56Z
swot,https://github.com/anacondy/swot,2024-09-20T13:02:03Z
termial-archieve-before-SQLite-imp,https://github.com/anacondy/termial-archieve-before-SQLite-imp,2025-10-12T21:29:58Z
Terminal-Archives-PYQs-,https://github.com/anacondy/Terminal-Archives-PYQs-,2025-10-10T19:51:18Z
terminal-site-post-mortem-,https://github.com/anacondy/terminal-site-post-mortem-,2025-10-15T17:59:37Z
```

### FILE: repos.json
```json
[
  {
    "name": "my-living-map",
    "url": "https://anacondy.github.io/my-living-map/",
    "date": "2026-03-30",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-08-31",
    "date_gap": "211 days"
  },
  {
    "name": "Q-A-parli",
    "url": "https://anacondy.github.io/Q-A-parli/",
    "date": "2026-03-30",
    "status": "404",
    "workflow_version": "218",
    "created_at": "2026-03-29",
    "date_gap": "1 days"
  },
  {
    "name": "sansad-qa",
    "url": "https://anacondy.github.io/sansad-qa/",
    "date": "2026-03-30",
    "status": "404",
    "workflow_version": "218",
    "created_at": "2026-03-29",
    "date_gap": "1 days"
  },
  {
    "name": "Void-Green",
    "url": "https://anacondy.github.io/Void-Green/",
    "date": "2026-03-25",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2026-03-23",
    "date_gap": "2 days"
  },
  {
    "name": "Void-player-",
    "url": "https://anacondy.github.io/Void-player-/",
    "date": "2026-03-25",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2026-03-24",
    "date_gap": "1 days"
  },
  {
    "name": "CARTO-flight-Gemini",
    "url": "https://anacondy.github.io/CARTO-flight-Gemini/",
    "date": "2026-03-16",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2026-03-15",
    "date_gap": "1 days"
  },
  {
    "name": "3-GAL",
    "url": "https://anacondy.github.io/3-GAL/",
    "date": "2026-03-14",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-11-29",
    "date_gap": "105 days"
  },
  {
    "name": "CSE-candidate-INDEX",
    "url": "https://anacondy.github.io/CSE-candidate-INDEX/",
    "date": "2026-03-14",
    "status": "404",
    "workflow_version": "218",
    "created_at": "2026-03-06",
    "date_gap": "8 days"
  },
  {
    "name": "grok-cis",
    "url": "https://anacondy.github.io/grok-cis/",
    "date": "2026-03-14",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-12-22",
    "date_gap": "82 days"
  },
  {
    "name": "3-PS-Archieves",
    "url": "https://anacondy.github.io/3-PS-Archieves/",
    "date": "2026-03-13",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-11-26",
    "date_gap": "107 days"
  },
  {
    "name": "cinema-scanner-",
    "url": "https://anacondy.github.io/cinema-scanner-/",
    "date": "2026-03-13",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-12-07",
    "date_gap": "96 days"
  },
  {
    "name": "GITHUB-BOARD-profile-icon",
    "url": "https://anacondy.github.io/GITHUB-BOARD-profile-icon/",
    "date": "2026-03-13",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2026-03-09",
    "date_gap": "4 days"
  },
  {
    "name": "GITHUB-SOURCE",
    "url": "https://anacondy.github.io/GITHUB-SOURCE/",
    "date": "2026-03-13",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2026-03-09",
    "date_gap": "4 days"
  },
  {
    "name": "Grok-Scanner-",
    "url": "https://anacondy.github.io/Grok-Scanner-/",
    "date": "2026-03-13",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-12-09",
    "date_gap": "94 days"
  },
  {
    "name": "Qualified-Candidates-frontend-",
    "url": "https://anacondy.github.io/Qualified-Candidates-frontend-/",
    "date": "2026-03-13",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2026-03-06",
    "date_gap": "7 days"
  },
  {
    "name": "root_964_experience",
    "url": "https://anacondy.github.io/root_964_experience/",
    "date": "2026-03-13",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-12-01",
    "date_gap": "102 days"
  },
  {
    "name": "geopolitical-insights",
    "url": "https://anacondy.github.io/geopolitical-insights/",
    "date": "2026-02-28",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2026-02-27",
    "date_gap": "1 days"
  },
  {
    "name": "Grok-Sissy",
    "url": "https://anacondy.github.io/Grok-Sissy/",
    "date": "2025-12-22",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-12-18",
    "date_gap": "4 days"
  },
  {
    "name": "25-2-saving-pro-2",
    "url": "https://anacondy.github.io/25-2-saving-pro-2/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-11-19",
    "date_gap": "23 days"
  },
  {
    "name": "3-25-GJ-Terminal",
    "url": "https://anacondy.github.io/3-25-GJ-Terminal/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-11-26",
    "date_gap": "16 days"
  },
  {
    "name": "3-Acid-Grauge-Exp",
    "url": "https://anacondy.github.io/3-Acid-Grauge-Exp/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-12-07",
    "date_gap": "5 days"
  },
  {
    "name": "3-Bad-day-24-CRT-SPACESHIP-",
    "url": "https://anacondy.github.io/3-Bad-day-24-CRT-SPACESHIP-/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-11-24",
    "date_gap": "18 days"
  },
  {
    "name": "3-desktop-refresher",
    "url": "https://anacondy.github.io/3-desktop-refresher/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-12-07",
    "date_gap": "5 days"
  },
  {
    "name": "3-DVD-archieve",
    "url": "https://anacondy.github.io/3-DVD-archieve/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-11-25",
    "date_gap": "17 days"
  },
  {
    "name": "3-ethereal-drift",
    "url": "https://anacondy.github.io/3-ethereal-drift/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-11-27",
    "date_gap": "15 days"
  },
  {
    "name": "3-Gem-ind-via-VCS",
    "url": "https://anacondy.github.io/3-Gem-ind-via-VCS/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-11-23",
    "date_gap": "19 days"
  },
  {
    "name": "3-GEM-Map",
    "url": "https://anacondy.github.io/3-GEM-Map/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-11-21",
    "date_gap": "21 days"
  },
  {
    "name": "3-Germany",
    "url": "https://anacondy.github.io/3-Germany/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-11-21",
    "date_gap": "21 days"
  },
  {
    "name": "3-iran",
    "url": "https://anacondy.github.io/3-iran/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-12-01",
    "date_gap": "11 days"
  },
  {
    "name": "3-mobile-indian-map",
    "url": "https://anacondy.github.io/3-mobile-indian-map/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-11-23",
    "date_gap": "19 days"
  },
  {
    "name": "3-Ouroboros-Terminal",
    "url": "https://anacondy.github.io/3-Ouroboros-Terminal/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-12-01",
    "date_gap": "11 days"
  },
  {
    "name": "3-PS2-collection",
    "url": "https://anacondy.github.io/3-PS2-collection/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-11-24",
    "date_gap": "18 days"
  },
  {
    "name": "3-Regency-Horror-Menu",
    "url": "https://anacondy.github.io/3-Regency-Horror-Menu/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-11-22",
    "date_gap": "20 days"
  },
  {
    "name": "3-Robust-S-S-Scrapper",
    "url": "https://anacondy.github.io/3-Robust-S-S-Scrapper/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-11-23",
    "date_gap": "19 days"
  },
  {
    "name": "3-SOTL-Speed-test",
    "url": "https://anacondy.github.io/3-SOTL-Speed-test/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-11-28",
    "date_gap": "14 days"
  },
  {
    "name": "3-Sys-Repo-Access-READ-ONLY-",
    "url": "https://anacondy.github.io/3-Sys-Repo-Access-READ-ONLY-/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-12-01",
    "date_gap": "11 days"
  },
  {
    "name": "3-System-registry-",
    "url": "https://anacondy.github.io/3-System-registry-/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-11-22",
    "date_gap": "20 days"
  },
  {
    "name": "3-USA-getting-live-",
    "url": "https://anacondy.github.io/3-USA-getting-live-/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-11-21",
    "date_gap": "21 days"
  },
  {
    "name": "3-USA-Glassomorphic-MAP-2025",
    "url": "https://anacondy.github.io/3-USA-Glassomorphic-MAP-2025/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-11-21",
    "date_gap": "21 days"
  },
  {
    "name": "3-WestWorld-without-bounce-",
    "url": "https://anacondy.github.io/3-WestWorld-without-bounce-/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-11-21",
    "date_gap": "21 days"
  },
  {
    "name": "alvido-test-2",
    "url": "https://anacondy.github.io/alvido-test-2/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-10-12",
    "date_gap": "61 days"
  },
  {
    "name": "alvido-test-4",
    "url": "https://anacondy.github.io/alvido-test-4/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-10-12",
    "date_gap": "61 days"
  },
  {
    "name": "alvido-testing-1",
    "url": "https://anacondy.github.io/alvido-testing-1/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-10-12",
    "date_gap": "61 days"
  },
  {
    "name": "Cover-posters",
    "url": "https://anacondy.github.io/Cover-posters/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-12-03",
    "date_gap": "9 days"
  },
  {
    "name": "falling-leaves-",
    "url": "https://anacondy.github.io/falling-leaves-/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-11-05",
    "date_gap": "37 days"
  },
  {
    "name": "GJ-Terminal-2-sorting-card-page-",
    "url": "https://anacondy.github.io/GJ-Terminal-2-sorting-card-page-/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-10-16",
    "date_gap": "57 days"
  },
  {
    "name": "glassmorphic-site-card-Ui-html-",
    "url": "https://anacondy.github.io/glassmorphic-site-card-Ui-html-/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-10-15",
    "date_gap": "58 days"
  },
  {
    "name": "GPA-calculator",
    "url": "https://anacondy.github.io/GPA-calculator/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-08-20",
    "date_gap": "114 days"
  },
  {
    "name": "Indian-SC-verdicts-site",
    "url": "https://anacondy.github.io/Indian-SC-verdicts-site/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-10-19",
    "date_gap": "54 days"
  },
  {
    "name": "iran-grade-colors",
    "url": "https://anacondy.github.io/iran-grade-colors/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-12-01",
    "date_gap": "11 days"
  },
  {
    "name": "leaves-dying-",
    "url": "https://anacondy.github.io/leaves-dying-/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-11-05",
    "date_gap": "37 days"
  },
  {
    "name": "Legend-Player",
    "url": "https://anacondy.github.io/Legend-Player/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-12-01",
    "date_gap": "11 days"
  },
  {
    "name": "live-volcano-ui",
    "url": "https://anacondy.github.io/live-volcano-ui/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-09-02",
    "date_gap": "101 days"
  },
  {
    "name": "login-input",
    "url": "https://anacondy.github.io/login-input/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-11-05",
    "date_gap": "37 days"
  },
  {
    "name": "mobile-comparison-site-",
    "url": "https://anacondy.github.io/mobile-comparison-site-/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-08-22",
    "date_gap": "112 days"
  },
  {
    "name": "papers-gemini-archive-4-",
    "url": "https://anacondy.github.io/papers-gemini-archive-4-/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-10-12",
    "date_gap": "61 days"
  },
  {
    "name": "Papers-login-better-security-",
    "url": "https://anacondy.github.io/Papers-login-better-security-/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-10-14",
    "date_gap": "59 days"
  },
  {
    "name": "Poster-Scanner",
    "url": "https://anacondy.github.io/Poster-Scanner/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-12-03",
    "date_gap": "9 days"
  },
  {
    "name": "Poster-scanner-2-",
    "url": "https://anacondy.github.io/Poster-scanner-2-/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-12-03",
    "date_gap": "9 days"
  },
  {
    "name": "powershell-cl-sc-cases-site-htmls-",
    "url": "https://anacondy.github.io/powershell-cl-sc-cases-site-htmls-/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-10-21",
    "date_gap": "52 days"
  },
  {
    "name": "SC-site-with-home-page-",
    "url": "https://anacondy.github.io/SC-site-with-home-page-/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-10-20",
    "date_gap": "53 days"
  },
  {
    "name": "Silent-Hill-Transcriber",
    "url": "https://anacondy.github.io/Silent-Hill-Transcriber/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-12-02",
    "date_gap": "10 days"
  },
  {
    "name": "stars-ui",
    "url": "https://anacondy.github.io/stars-ui/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-09-01",
    "date_gap": "102 days"
  },
  {
    "name": "stars-ui-2-",
    "url": "https://anacondy.github.io/stars-ui-2-/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-09-10",
    "date_gap": "93 days"
  },
  {
    "name": "termial-archieve-before-SQLite-imp",
    "url": "https://anacondy.github.io/termial-archieve-before-SQLite-imp/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-10-12",
    "date_gap": "61 days"
  },
  {
    "name": "Terminal-Archives-PYQs-",
    "url": "https://anacondy.github.io/Terminal-Archives-PYQs-/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-10-10",
    "date_gap": "63 days"
  },
  {
    "name": "terminal-site-post-mortem-",
    "url": "https://anacondy.github.io/terminal-site-post-mortem-/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-10-15",
    "date_gap": "58 days"
  },
  {
    "name": "URoot-964",
    "url": "https://anacondy.github.io/URoot-964/",
    "date": "2025-12-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-11-27",
    "date_gap": "15 days"
  },
  {
    "name": "3-car-grauge-exp-2-",
    "url": "https://anacondy.github.io/3-car-grauge-exp-2-/",
    "date": "2025-12-09",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-12-07",
    "date_gap": "2 days"
  },
  {
    "name": "Horror-dvd-wall",
    "url": "https://anacondy.github.io/Horror-dvd-wall/",
    "date": "2025-12-09",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-12-03",
    "date_gap": "6 days"
  },
  {
    "name": "3-CyperpunkSettings",
    "url": "https://anacondy.github.io/3-CyperpunkSettings/",
    "date": "2025-11-30",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-11-24",
    "date_gap": "6 days"
  },
  {
    "name": "MOUNTE-CRISTO",
    "url": "https://anacondy.github.io/MOUNTE-CRISTO/",
    "date": "2025-11-30",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-11-27",
    "date_gap": "3 days"
  },
  {
    "name": "3-Canada-map-",
    "url": "https://anacondy.github.io/3-Canada-map-/",
    "date": "2025-11-29",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-11-21",
    "date_gap": "8 days"
  },
  {
    "name": "3--Aussie-Political-MAP",
    "url": "https://anacondy.github.io/3--Aussie-Political-MAP/",
    "date": "2025-11-27",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-11-21",
    "date_gap": "6 days"
  },
  {
    "name": "3-LEGEND-RENAMER",
    "url": "https://anacondy.github.io/3-LEGEND-RENAMER/",
    "date": "2025-11-27",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-11-27",
    "date_gap": "0 days"
  },
  {
    "name": "3-24-25-26-",
    "url": "https://anacondy.github.io/3-24-25-26-/",
    "date": "2025-11-26",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-11-23",
    "date_gap": "3 days"
  },
  {
    "name": "3-Heli-24",
    "url": "https://anacondy.github.io/3-Heli-24/",
    "date": "2025-11-26",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-11-24",
    "date_gap": "2 days"
  },
  {
    "name": "3-West-world",
    "url": "https://anacondy.github.io/3-West-world/",
    "date": "2025-11-26",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-11-21",
    "date_gap": "5 days"
  },
  {
    "name": "3-L-trange-Experience",
    "url": "https://anacondy.github.io/3-L-trange-Experience/",
    "date": "2025-11-24",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-11-24",
    "date_gap": "0 days"
  },
  {
    "name": "3-Neon-pulse--24-bad-day-",
    "url": "https://anacondy.github.io/3-Neon-pulse--24-bad-day-/",
    "date": "2025-11-24",
    "status": "404",
    "workflow_version": "218",
    "created_at": "2025-11-24",
    "date_gap": "0 days"
  },
  {
    "name": "3-RetroDVD",
    "url": "https://anacondy.github.io/3-RetroDVD/",
    "date": "2025-11-24",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-11-24",
    "date_gap": "0 days"
  },
  {
    "name": "3-Regency-latern",
    "url": "https://anacondy.github.io/3-Regency-latern/",
    "date": "2025-11-22",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-11-22",
    "date_gap": "0 days"
  },
  {
    "name": "25--3-pro-test",
    "url": "https://anacondy.github.io/25--3-pro-test/",
    "date": "2025-11-21",
    "status": "404",
    "workflow_version": "218",
    "created_at": "2025-11-18",
    "date_gap": "3 days"
  },
  {
    "name": "deep-res-Job",
    "url": "https://anacondy.github.io/deep-res-Job/",
    "date": "2025-11-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-11-11",
    "date_gap": "1 days"
  },
  {
    "name": "GJ-Terminal-just-a-data-table-with-good-UI",
    "url": "https://anacondy.github.io/GJ-Terminal-just-a-data-table-with-good-UI/",
    "date": "2025-11-10",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-10-16",
    "date_gap": "25 days"
  },
  {
    "name": "paper-gemini-archieve-saving-progress-2-",
    "url": "https://anacondy.github.io/paper-gemini-archieve-saving-progress-2-/",
    "date": "2025-11-08",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-10-12",
    "date_gap": "27 days"
  },
  {
    "name": "Pint-site-saving-progress-1-",
    "url": "https://anacondy.github.io/Pint-site-saving-progress-1-/",
    "date": "2025-11-05",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-11-03",
    "date_gap": "2 days"
  },
  {
    "name": "MP-tracker-site-",
    "url": "https://anacondy.github.io/MP-tracker-site-/",
    "date": "2025-11-04",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-11-02",
    "date_gap": "2 days"
  },
  {
    "name": "alvido-test-5",
    "url": "https://anacondy.github.io/alvido-test-5/",
    "date": "2025-10-12",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-10-12",
    "date_gap": "0 days"
  },
  {
    "name": "stars-UI-3",
    "url": "https://anacondy.github.io/stars-UI-3/",
    "date": "2025-09-10",
    "status": "active",
    "workflow_version": "218",
    "created_at": "2025-09-10",
    "date_gap": "0 days"
  }
]
```

### FILE: Repository-Status-and-History.md
```markdown
# Repository Status and History

## Workflow #218 (8th Jun, 2026)
- Previous version (30th Mar, 2026): 90 repositories
- New version (8th Jun, 2026): 90 repositories
- Additions: 0 repositories
- Deletions: 0 repositories

| Repository Name       | Link                                  | Added Date       | Creation Date   | Date Gap       | Status       | Workflow Version |
|-----------------------|---------------------------------------|------------------|------------------|----------------|---------------|------------------|
| my-living-map | [Link](https://anacondy.github.io/my-living-map/) | 30th Mar, 2026 | 31st Aug, 2025 | 211 days | active | #218 |
| Q-A-parli | [Link](https://anacondy.github.io/Q-A-parli/) | 30th Mar, 2026 | 29th Mar, 2026 | 1 days | 404 | #218 |
| sansad-qa | [Link](https://anacondy.github.io/sansad-qa/) | 30th Mar, 2026 | 29th Mar, 2026 | 1 days | 404 | #218 |
| Void-Green | [Link](https://anacondy.github.io/Void-Green/) | 25th Mar, 2026 | 23rd Mar, 2026 | 2 days | active | #218 |
| Void-player- | [Link](https://anacondy.github.io/Void-player-/) | 25th Mar, 2026 | 24th Mar, 2026 | 1 days | active | #218 |
| CARTO-flight-Gemini | [Link](https://anacondy.github.io/CARTO-flight-Gemini/) | 16th Mar, 2026 | 15th Mar, 2026 | 1 days | active | #218 |
| 3-GAL | [Link](https://anacondy.github.io/3-GAL/) | 14th Mar, 2026 | 29th Nov, 2025 | 105 days | active | #218 |
| CSE-candidate-INDEX | [Link](https://anacondy.github.io/CSE-candidate-INDEX/) | 14th Mar, 2026 | 6th Mar, 2026 | 8 days | 404 | #218 |
| grok-cis | [Link](https://anacondy.github.io/grok-cis/) | 14th Mar, 2026 | 22nd Dec, 2025 | 82 days | active | #218 |
| 3-PS-Archieves | [Link](https://anacondy.github.io/3-PS-Archieves/) | 13th Mar, 2026 | 26th Nov, 2025 | 107 days | active | #218 |
| cinema-scanner- | [Link](https://anacondy.github.io/cinema-scanner-/) | 13th Mar, 2026 | 7th Dec, 2025 | 96 days | active | #218 |
| GITHUB-BOARD-profile-icon | [Link](https://anacondy.github.io/GITHUB-BOARD-profile-icon/) | 13th Mar, 2026 | 9th Mar, 2026 | 4 days | active | #218 |
| GITHUB-SOURCE | [Link](https://anacondy.github.io/GITHUB-SOURCE/) | 13th Mar, 2026 | 9th Mar, 2026 | 4 days | active | #218 |
| Grok-Scanner- | [Link](https://anacondy.github.io/Grok-Scanner-/) | 13th Mar, 2026 | 9th Dec, 2025 | 94 days | active | #218 |
| Qualified-Candidates-frontend- | [Link](https://anacondy.github.io/Qualified-Candidates-frontend-/) | 13th Mar, 2026 | 6th Mar, 2026 | 7 days | active | #218 |
| root_964_experience | [Link](https://anacondy.github.io/root_964_experience/) | 13th Mar, 2026 | 1st Dec, 2025 | 102 days | active | #218 |
| geopolitical-insights | [Link](https://anacondy.github.io/geopolitical-insights/) | 28th Feb, 2026 | 27th Feb, 2026 | 1 days | active | #218 |
| Grok-Sissy | [Link](https://anacondy.github.io/Grok-Sissy/) | 22nd Dec, 2025 | 18th Dec, 2025 | 4 days | active | #218 |
| 25-2-saving-pro-2 | [Link](https://anacondy.github.io/25-2-saving-pro-2/) | 12th Dec, 2025 | 19th Nov, 2025 | 23 days | active | #218 |
| 3-25-GJ-Terminal | [Link](https://anacondy.github.io/3-25-GJ-Terminal/) | 12th Dec, 2025 | 26th Nov, 2025 | 16 days | active | #218 |
| 3-Acid-Grauge-Exp | [Link](https://anacondy.github.io/3-Acid-Grauge-Exp/) | 12th Dec, 2025 | 7th Dec, 2025 | 5 days | active | #218 |
| 3-Bad-day-24-CRT-SPACESHIP- | [Link](https://anacondy.github.io/3-Bad-day-24-CRT-SPACESHIP-/) | 12th Dec, 2025 | 24th Nov, 2025 | 18 days | active | #218 |
| 3-desktop-refresher | [Link](https://anacondy.github.io/3-desktop-refresher/) | 12th Dec, 2025 | 7th Dec, 2025 | 5 days | active | #218 |
| 3-DVD-archieve | [Link](https://anacondy.github.io/3-DVD-archieve/) | 12th Dec, 2025 | 25th Nov, 2025 | 17 days | active | #218 |
| 3-ethereal-drift | [Link](https://anacondy.github.io/3-ethereal-drift/) | 12th Dec, 2025 | 27th Nov, 2025 | 15 days | active | #218 |
| 3-Gem-ind-via-VCS | [Link](https://anacondy.github.io/3-Gem-ind-via-VCS/) | 12th Dec, 2025 | 23rd Nov, 2025 | 19 days | active | #218 |
| 3-GEM-Map | [Link](https://anacondy.github.io/3-GEM-Map/) | 12th Dec, 2025 | 21st Nov, 2025 | 21 days | active | #218 |
| 3-Germany | [Link](https://anacondy.github.io/3-Germany/) | 12th Dec, 2025 | 21st Nov, 2025 | 21 days | active | #218 |
| 3-iran | [Link](https://anacondy.github.io/3-iran/) | 12th Dec, 2025 | 1st Dec, 2025 | 11 days | active | #218 |
| 3-mobile-indian-map | [Link](https://anacondy.github.io/3-mobile-indian-map/) | 12th Dec, 2025 | 23rd Nov, 2025 | 19 days | active | #218 |
| 3-Ouroboros-Terminal | [Link](https://anacondy.github.io/3-Ouroboros-Terminal/) | 12th Dec, 2025 | 1st Dec, 2025 | 11 days | active | #218 |
| 3-PS2-collection | [Link](https://anacondy.github.io/3-PS2-collection/) | 12th Dec, 2025 | 24th Nov, 2025 | 18 days | active | #218 |
| 3-Regency-Horror-Menu | [Link](https://anacondy.github.io/3-Regency-Horror-Menu/) | 12th Dec, 2025 | 22nd Nov, 2025 | 20 days | active | #218 |
| 3-Robust-S-S-Scrapper | [Link](https://anacondy.github.io/3-Robust-S-S-Scrapper/) | 12th Dec, 2025 | 23rd Nov, 2025 | 19 days | active | #218 |
| 3-SOTL-Speed-test | [Link](https://anacondy.github.io/3-SOTL-Speed-test/) | 12th Dec, 2025 | 28th Nov, 2025 | 14 days | active | #218 |
| 3-Sys-Repo-Access-READ-ONLY- | [Link](https://anacondy.github.io/3-Sys-Repo-Access-READ-ONLY-/) | 12th Dec, 2025 | 1st Dec, 2025 | 11 days | active | #218 |
| 3-System-registry- | [Link](https://anacondy.github.io/3-System-registry-/) | 12th Dec, 2025 | 22nd Nov, 2025 | 20 days | active | #218 |
| 3-USA-getting-live- | [Link](https://anacondy.github.io/3-USA-getting-live-/) | 12th Dec, 2025 | 21st Nov, 2025 | 21 days | active | #218 |
| 3-USA-Glassomorphic-MAP-2025 | [Link](https://anacondy.github.io/3-USA-Glassomorphic-MAP-2025/) | 12th Dec, 2025 | 21st Nov, 2025 | 21 days | active | #218 |
| 3-WestWorld-without-bounce- | [Link](https://anacondy.github.io/3-WestWorld-without-bounce-/) | 12th Dec, 2025 | 21st Nov, 2025 | 21 days | active | #218 |
| alvido-test-2 | [Link](https://anacondy.github.io/alvido-test-2/) | 12th Dec, 2025 | 12th Oct, 2025 | 61 days | active | #218 |
| alvido-test-4 | [Link](https://anacondy.github.io/alvido-test-4/) | 12th Dec, 2025 | 12th Oct, 2025 | 61 days | active | #218 |
| alvido-testing-1 | [Link](https://anacondy.github.io/alvido-testing-1/) | 12th Dec, 2025 | 12th Oct, 2025 | 61 days | active | #218 |
| Cover-posters | [Link](https://anacondy.github.io/Cover-posters/) | 12th Dec, 2025 | 3rd Dec, 2025 | 9 days | active | #218 |
| falling-leaves- | [Link](https://anacondy.github.io/falling-leaves-/) | 12th Dec, 2025 | 5th Nov, 2025 | 37 days | active | #218 |
| GJ-Terminal-2-sorting-card-page- | [Link](https://anacondy.github.io/GJ-Terminal-2-sorting-card-page-/) | 12th Dec, 2025 | 16th Oct, 2025 | 57 days | active | #218 |
| glassmorphic-site-card-Ui-html- | [Link](https://anacondy.github.io/glassmorphic-site-card-Ui-html-/) | 12th Dec, 2025 | 15th Oct, 2025 | 58 days | active | #218 |
| GPA-calculator | [Link](https://anacondy.github.io/GPA-calculator/) | 12th Dec, 2025 | 20th Aug, 2025 | 114 days | active | #218 |
| Indian-SC-verdicts-site | [Link](https://anacondy.github.io/Indian-SC-verdicts-site/) | 12th Dec, 2025 | 19th Oct, 2025 | 54 days | active | #218 |
| iran-grade-colors | [Link](https://anacondy.github.io/iran-grade-colors/) | 12th Dec, 2025 | 1st Dec, 2025 | 11 days | active | #218 |
| leaves-dying- | [Link](https://anacondy.github.io/leaves-dying-/) | 12th Dec, 2025 | 5th Nov, 2025 | 37 days | active | #218 |
| Legend-Player | [Link](https://anacondy.github.io/Legend-Player/) | 12th Dec, 2025 | 1st Dec, 2025 | 11 days | active | #218 |
| live-volcano-ui | [Link](https://anacondy.github.io/live-volcano-ui/) | 12th Dec, 2025 | 2nd Sep, 2025 | 101 days | active | #218 |
| login-input | [Link](https://anacondy.github.io/login-input/) | 12th Dec, 2025 | 5th Nov, 2025 | 37 days | active | #218 |
| mobile-comparison-site- | [Link](https://anacondy.github.io/mobile-comparison-site-/) | 12th Dec, 2025 | 22nd Aug, 2025 | 112 days | active | #218 |
| papers-gemini-archive-4- | [Link](https://anacondy.github.io/papers-gemini-archive-4-/) | 12th Dec, 2025 | 12th Oct, 2025 | 61 days | active | #218 |
| Papers-login-better-security- | [Link](https://anacondy.github.io/Papers-login-better-security-/) | 12th Dec, 2025 | 14th Oct, 2025 | 59 days | active | #218 |
| Poster-Scanner | [Link](https://anacondy.github.io/Poster-Scanner/) | 12th Dec, 2025 | 3rd Dec, 2025 | 9 days | active | #218 |
| Poster-scanner-2- | [Link](https://anacondy.github.io/Poster-scanner-2-/) | 12th Dec, 2025 | 3rd Dec, 2025 | 9 days | active | #218 |
| powershell-cl-sc-cases-site-htmls- | [Link](https://anacondy.github.io/powershell-cl-sc-cases-site-htmls-/) | 12th Dec, 2025 | 21st Oct, 2025 | 52 days | active | #218 |
| SC-site-with-home-page- | [Link](https://anacondy.github.io/SC-site-with-home-page-/) | 12th Dec, 2025 | 20th Oct, 2025 | 53 days | active | #218 |
| Silent-Hill-Transcriber | [Link](https://anacondy.github.io/Silent-Hill-Transcriber/) | 12th Dec, 2025 | 2nd Dec, 2025 | 10 days | active | #218 |
| stars-ui | [Link](https://anacondy.github.io/stars-ui/) | 12th Dec, 2025 | 1st Sep, 2025 | 102 days | active | #218 |
| stars-ui-2- | [Link](https://anacondy.github.io/stars-ui-2-/) | 12th Dec, 2025 | 10th Sep, 2025 | 93 days | active | #218 |
| termial-archieve-before-SQLite-imp | [Link](https://anacondy.github.io/termial-archieve-before-SQLite-imp/) | 12th Dec, 2025 | 12th Oct, 2025 | 61 days | active | #218 |
| Terminal-Archives-PYQs- | [Link](https://anacondy.github.io/Terminal-Archives-PYQs-/) | 12th Dec, 2025 | 10th Oct, 2025 | 63 days | active | #218 |
| terminal-site-post-mortem- | [Link](https://anacondy.github.io/terminal-site-post-mortem-/) | 12th Dec, 2025 | 15th Oct, 2025 | 58 days | active | #218 |
| URoot-964 | [Link](https://anacondy.github.io/URoot-964/) | 12th Dec, 2025 | 27th Nov, 2025 | 15 days | active | #218 |
| 3-car-grauge-exp-2- | [Link](https://anacondy.github.io/3-car-grauge-exp-2-/) | 9th Dec, 2025 | 7th Dec, 2025 | 2 days | active | #218 |
| Horror-dvd-wall | [Link](https://anacondy.github.io/Horror-dvd-wall/) | 9th Dec, 2025 | 3rd Dec, 2025 | 6 days | active | #218 |
| 3-CyperpunkSettings | [Link](https://anacondy.github.io/3-CyperpunkSettings/) | 30th Nov, 2025 | 24th Nov, 2025 | 6 days | active | #218 |
| MOUNTE-CRISTO | [Link](https://anacondy.github.io/MOUNTE-CRISTO/) | 30th Nov, 2025 | 27th Nov, 2025 | 3 days | active | #218 |
| 3-Canada-map- | [Link](https://anacondy.github.io/3-Canada-map-/) | 29th Nov, 2025 | 21st Nov, 2025 | 8 days | active | #218 |
| 3--Aussie-Political-MAP | [Link](https://anacondy.github.io/3--Aussie-Political-MAP/) | 27th Nov, 2025 | 21st Nov, 2025 | 6 days | active | #218 |
| 3-LEGEND-RENAMER | [Link](https://anacondy.github.io/3-LEGEND-RENAMER/) | 27th Nov, 2025 | 27th Nov, 2025 | 0 days | active | #218 |
| 3-24-25-26- | [Link](https://anacondy.github.io/3-24-25-26-/) | 26th Nov, 2025 | 23rd Nov, 2025 | 3 days | active | #218 |
| 3-Heli-24 | [Link](https://anacondy.github.io/3-Heli-24/) | 26th Nov, 2025 | 24th Nov, 2025 | 2 days | active | #218 |
| 3-West-world | [Link](https://anacondy.github.io/3-West-world/) | 26th Nov, 2025 | 21st Nov, 2025 | 5 days | active | #218 |
| 3-L-trange-Experience | [Link](https://anacondy.github.io/3-L-trange-Experience/) | 24th Nov, 2025 | 24th Nov, 2025 | 0 days | active | #218 |
| 3-Neon-pulse--24-bad-day- | [Link](https://anacondy.github.io/3-Neon-pulse--24-bad-day-/) | 24th Nov, 2025 | 24th Nov, 2025 | 0 days | 404 | #218 |
| 3-RetroDVD | [Link](https://anacondy.github.io/3-RetroDVD/) | 24th Nov, 2025 | 24th Nov, 2025 | 0 days | active | #218 |
| 3-Regency-latern | [Link](https://anacondy.github.io/3-Regency-latern/) | 22nd Nov, 2025 | 22nd Nov, 2025 | 0 days | active | #218 |
| 25--3-pro-test | [Link](https://anacondy.github.io/25--3-pro-test/) | 21st Nov, 2025 | 18th Nov, 2025 | 3 days | 404 | #218 |
| deep-res-Job | [Link](https://anacondy.github.io/deep-res-Job/) | 12th Nov, 2025 | 11th Nov, 2025 | 1 days | active | #218 |
| GJ-Terminal-just-a-data-table-with-good-UI | [Link](https://anacondy.github.io/GJ-Terminal-just-a-data-table-with-good-UI/) | 10th Nov, 2025 | 16th Oct, 2025 | 25 days | active | #218 |
| paper-gemini-archieve-saving-progress-2- | [Link](https://anacondy.github.io/paper-gemini-archieve-saving-progress-2-/) | 8th Nov, 2025 | 12th Oct, 2025 | 27 days | active | #218 |
| Pint-site-saving-progress-1- | [Link](https://anacondy.github.io/Pint-site-saving-progress-1-/) | 5th Nov, 2025 | 3rd Nov, 2025 | 2 days | active | #218 |
| MP-tracker-site- | [Link](https://anacondy.github.io/MP-tracker-site-/) | 4th Nov, 2025 | 2nd Nov, 2025 | 2 days | active | #218 |
| alvido-test-5 | [Link](https://anacondy.github.io/alvido-test-5/) | 12th Oct, 2025 | 12th Oct, 2025 | 0 days | active | #218 |
| stars-UI-3 | [Link](https://anacondy.github.io/stars-UI-3/) | 10th Sep, 2025 | 10th Sep, 2025 | 0 days | active | #218 |
```

---
End of bundle. Included: 13 | Skipped binary/error: 0
