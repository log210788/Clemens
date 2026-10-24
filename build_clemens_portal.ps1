# PowerShell Portal Generator for Louie's English Studio & Student Sanctuary
# Student: Clemens B • Lesson: 24 October 2026
$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "Compiling Louie's English Sanctuary for Clemens B (Lesson 10-24-2026)..."

# Read curated data from lesson_data.js
$dataPath = "d:\Documents\Clemens B\lesson_data.js"
if (-not (Test-Path $dataPath)) {
    throw "Data file not found at $dataPath"
}

$raw = [System.IO.File]::ReadAllText($dataPath, [System.Text.Encoding]::UTF8)

# Extract core JS structures
function Extract-Block($varName) {
    $idx = $raw.IndexOf("const $varName =")
    if ($idx -lt 0) { throw "Cannot find $varName" }
    $after = $raw.Substring($idx)
    if ($after -match "^const $varName = ([\s\S]*?\n(?:\};|\];))") {
        return $matches[1]
    }
    throw "Failed to extract $varName"
}

$vocabDbBlock = Extract-Block "VOCAB_DB"
$asrFixesBlock = Extract-Block "ASR_FIXES"
$naturalStrengthsBlock = Extract-Block "NATURAL_STRENGTHS"
$phrasingPolishesBlock = Extract-Block "PHRASING_POLISHES"
$transcriptTurnsBlock = Extract-Block "TRANSCRIPT_TURNS"
$editorialTopicsBlock = Extract-Block "EDITORIAL_TOPICS"
$flashcardsBlock = Extract-Block "FLASHCARDS"
$idiomChallengesBlock = Extract-Block "IDIOM_CHALLENGES"
$quizQuestionsBlock = Extract-Block "QUIZ_QUESTIONS"
$reflectionPromptsBlock = Extract-Block "REFLECTION_PROMPTS"

Write-Host "All data blocks extracted successfully."

# Construct HTML Header and Body Structure using LITERAL heredoc (@' ... '@)
$htmlMarkup = @'
<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Louie's English Studio | Clemens B • 24 October 2026</title>

  <!-- Google Fonts: Cormorant Garamond, Plus Jakarta Sans, JetBrains Mono -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,500;0,600;0,700;1,400;1,600&family=JetBrains+Mono:wght@400;500;600&family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">

  <!-- Tailwind CSS CDN -->
  <script src="https://cdn.tailwindcss.com"></script>
  <script>
    tailwind.config = {
      theme: {
        extend: {
          fontFamily: {
            serif: ['"Cormorant Garamond"', 'Georgia', 'serif'],
            sans: ['"Plus Jakarta Sans"', 'system-ui', 'sans-serif'],
            mono: ['"JetBrains Mono"', 'monospace'],
          },
          colors: {
            parchment: {
              50: '#fbf9f5',
              100: '#f6f1e7',
              200: '#ede3d1',
              300: '#dfd0b5',
              400: '#cbb38e',
              500: '#b6966b',
            },
            autumn: {
              50: '#fcf6f0',
              100: '#f7e9db',
              200: '#eed0b5',
              300: '#e2b086',
              400: '#d38c57',
              500: '#be6f38',
              600: '#a3582b',
              700: '#854524',
              800: '#6c3921',
            },
            sage: {
              50: '#f4f7f5',
              100: '#e4ece7',
              200: '#cadad1',
              300: '#a5bfb1',
              400: '#7b9f8d',
              500: '#5b826f',
              600: '#476858',
              700: '#3a5448',
              800: '#30443b',
            },
            slatewarm: {
              700: '#3d4441',
              800: '#2b312e',
              900: '#1e2321',
            }
          }
        }
      }
    }
  </script>

  <!-- Lucide Icons -->
  <script src="https://unpkg.com/lucide@latest"></script>

  <!-- GSAP -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.5/gsap.min.js"></script>

  <!-- Popper & Tippy.js -->
  <script src="https://unpkg.com/@popperjs/core@2"></script>
  <script src="https://unpkg.com/tippy.js@6"></script>
  <link rel="stylesheet" href="https://unpkg.com/tippy.js@6/animations/shift-away.css" />

  <!-- Canvas Confetti -->
  <script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.9.3/dist/confetti.browser.min.js"></script>

  <style>
    :root {
      --bg-base: #f9f6f0;
      --bg-card: rgba(255, 253, 249, 0.94);
      --bg-subcard: rgba(255, 255, 255, 0.96);
      --border-soft: #e6decb;
      --border-accent: #d9c8b0;
      --text-main: #2b312e;
      --text-muted: #5c6660;
      --grad-1: rgba(238, 208, 181, 0.40);
      --grad-2: rgba(202, 218, 209, 0.45);
      --grad-3: rgba(246, 241, 231, 0.65);
    }

    body[data-theme="winchester"] {
      --bg-base: #f3f6f5;
      --bg-card: rgba(252, 254, 253, 0.94);
      --bg-subcard: rgba(255, 255, 255, 0.96);
      --border-soft: #d7e2dc;
      --border-accent: #b8ccc2;
      --text-main: #26312d;
      --text-muted: #52635c;
      --grad-1: rgba(202, 218, 209, 0.48);
      --grad-2: rgba(219, 228, 238, 0.45);
      --grad-3: rgba(244, 240, 230, 0.52);
    }

    body[data-theme="twilight"] {
      --bg-base: #f5efe6;
      --bg-card: rgba(253, 249, 242, 0.94);
      --bg-subcard: rgba(255, 252, 247, 0.97);
      --border-soft: #e2d2be;
      --border-accent: #cfaea0;
      --text-main: #2d2622;
      --text-muted: #665850;
      --grad-1: rgba(226, 176, 134, 0.35);
      --grad-2: rgba(214, 196, 176, 0.40);
      --grad-3: rgba(235, 220, 202, 0.52);
    }

    body {
      background-color: var(--bg-base);
      background-image:
        radial-gradient(at 6% 4%, var(--grad-1) 0px, transparent 50%),
        radial-gradient(at 94% 16%, var(--grad-2) 0px, transparent 50%),
        radial-gradient(at 50% 90%, var(--grad-3) 0px, transparent 55%);
      background-attachment: fixed;
      color: var(--text-main);
      transition: background-color 0.5s ease, color 0.4s ease;
      overflow-x: hidden;
    }

    .sanctuary-card {
      background: var(--bg-card);
      backdrop-filter: blur(14px);
      -webkit-backdrop-filter: blur(14px);
      border: 1px solid var(--border-soft);
      box-shadow: 0 10px 30px -10px rgba(91, 130, 111, 0.07), 0 4px 12px -3px rgba(43, 49, 46, 0.04);
      transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
    }

    .sanctuary-subcard {
      background: var(--bg-subcard);
      border: 1px solid var(--border-soft);
      box-shadow: 0 4px 12px -4px rgba(43, 49, 46, 0.04);
      transition: all 0.25s ease;
    }

    /* Inline Vocabulary Highlight in Transcript */
    .vocab-mark {
      display: inline-block;
      padding: 0 0.35rem;
      margin: 0 0.1rem;
      border-radius: 0.375rem;
      background: linear-gradient(120deg, rgba(238, 208, 181, 0.55), rgba(226, 176, 134, 0.45));
      border-bottom: 2px solid #be6f38;
      color: #2b312e;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.2s ease;
    }
    .vocab-mark:hover {
      background: #be6f38;
      color: #ffffff;
      transform: translateY(-1px);
      box-shadow: 0 4px 10px -2px rgba(190, 111, 56, 0.4);
    }
    .vocab-mark.active-vocab {
      background: #5b826f;
      color: #ffffff;
      border-bottom-color: #3a5448;
      box-shadow: 0 4px 12px -2px rgba(91, 130, 111, 0.45);
    }

    body.hide-vocab-highlights .vocab-mark {
      background: transparent !important;
      border-bottom: 1px dashed #be6f38 !important;
      color: inherit !important;
      font-weight: inherit !important;
      padding: 0 !important;
    }

    /* ASR Forensic Note-Taker Fix Pill */
    .asr-fix-pill {
      display: inline-flex;
      align-items: center;
      gap: 0.3rem;
      padding: 0.1rem 0.5rem;
      margin: 0 0.15rem;
      font-size: 0.72rem;
      font-family: 'JetBrains Mono', monospace;
      border-radius: 9999px;
      background: rgba(91, 130, 111, 0.12);
      border: 1px solid rgba(91, 130, 111, 0.35);
      color: #3a5448;
      font-weight: 600;
      vertical-align: middle;
      transition: all 0.2s ease;
    }
    .asr-fix-pill:hover {
      background: rgba(91, 130, 111, 0.22);
      border-color: #5b826f;
      transform: scale(1.02);
    }
    body.hide-asr-fixes .asr-fix-pill {
      display: none !important;
    }

    /* Flashcard 3D Perspective */
    .flashcard-inner {
      transform-style: preserve-3d;
      transition: transform 0.6s cubic-bezier(0.4, 0, 0.2, 1);
    }
    .flashcard-inner.flipped {
      transform: rotateY(180deg);
    }
    .flashcard-front, .flashcard-back {
      backface-visibility: hidden;
      -webkit-backface-visibility: hidden;
    }
    .flashcard-back {
      transform: rotateY(180deg);
    }

    /* Golden Pulse on Jump to Transcript */
    @keyframes gentleGlow {
      0% { background-color: rgba(226, 176, 134, 0.55); transform: scale(1.008); }
      50% { background-color: rgba(165, 191, 177, 0.42); }
      100% { background-color: transparent; transform: scale(1); }
    }
    .turn-highlight-flash {
      animation: gentleGlow 2.8s ease-out;
    }

    /* Custom Tippy Tooltip Theme */
    .tippy-box[data-theme~='autumn-sanctuary'] {
      background-color: #fffdf9;
      color: #2b312e;
      border: 1px solid #dfd0b5;
      border-radius: 1rem;
      box-shadow: 0 20px 38px -8px rgba(61, 68, 65, 0.16), 0 6px 16px -4px rgba(163, 88, 43, 0.08);
      padding: 0.35rem;
      font-family: 'Plus Jakarta Sans', sans-serif;
    }
    .tippy-box[data-theme~='autumn-sanctuary'][data-placement^='top'] > .tippy-arrow::before {
      border-top-color: #dfd0b5;
    }
    .tippy-box[data-theme~='autumn-sanctuary'][data-placement^='bottom'] > .tippy-arrow::before {
      border-bottom-color: #dfd0b5;
    }

    @media print {
      .no-print, #autumn-breeze-canvas { display: none !important; }
      body { background: #fff !important; }
      .sanctuary-card, .sanctuary-subcard { box-shadow: none !important; border: 1px solid #ccc !important; }
    }
  </style>
</head>
<body data-theme="kensington" class="font-sans antialiased min-h-screen selection:bg-autumn-200 selection:text-slatewarm-900 relative">

  <!-- CALMING LONDON AUTUMN BREEZE CANVAS OVERLAY -->
  <canvas id="autumn-breeze-canvas" class="fixed inset-0 pointer-events-none z-20 opacity-80"></canvas>

  <!-- TOP MULTI-LESSON & PRE-LESSON ARCHIVE BAR -->
  <aside class="bg-gradient-to-r from-sage-800 via-sage-700 to-autumn-700 text-white text-xs py-2 px-4 shadow-sm relative z-50 flex items-center justify-between gap-3 flex-wrap">
    <div class="flex items-center gap-2 flex-wrap">
      <span class="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full bg-white/20 text-white font-mono text-[11px] font-bold">
        🌿 Lesson 01 • Latest
      </span>
      <span class="font-medium">Louie's English Studio: Saturday Session (24 October 2026)</span>
    </div>
    <div class="flex items-center gap-2">
      <span class="text-amber-200 text-[11px] font-semibold">Student: Clemens B (Berlin, Germany)</span>
      <a href="#how-it-works" class="underline font-semibold hover:text-parchment-100 transition text-[11px] ml-2">How It Works ↓</a>
    </div>
  </aside>

  <!-- STICKY PEACEFUL NAVIGATION & ATMOSPHERE BAR -->
  <header class="sticky top-0 z-40 border-b border-[#e6decb]/90 bg-[#fbf9f5]/85 backdrop-blur-md no-print">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-2.5 flex flex-wrap items-center justify-between gap-3">
      
      <!-- Brand Identity -->
      <div class="flex items-center gap-3">
        <div class="w-10 h-10 rounded-2xl bg-gradient-to-br from-sage-600 via-sage-500 to-autumn-500 flex items-center justify-center text-white font-serif text-xl font-bold shadow-sm">
          L
        </div>
        <div>
          <div class="flex items-center gap-2">
            <span class="font-serif font-bold text-lg sm:text-xl tracking-tight text-slatewarm-900">Louie's English Studio</span>
            <span class="hidden sm:inline-flex items-center gap-1 px-2.5 py-0.5 text-[11px] font-medium rounded-full bg-sage-100 text-sage-800 border border-sage-200">
              <i data-lucide="sparkles" class="w-3 h-3 text-autumn-600"></i>
              Literature, Flight &amp; Abitur Preparation
            </span>
          </div>
          <p class="text-[11px] text-stone-500 hidden md:block">Full cleaned transcript, inline B2–C2 lexicon, German translations, gentle phrasing upgrades &amp; UK audio</p>
        </div>
      </div>

      <!-- Calming Atmosphere Controls -->
      <div class="flex flex-wrap items-center gap-2">
        
        <!-- London Breeze Audio Player -->
        <div class="flex items-center gap-1.5 bg-white/90 border border-[#dfd0b5] rounded-xl px-2.5 py-1 shadow-sm">
          <button id="soundscape-btn" onclick="toggleSoundscape()" class="flex items-center gap-1.5 text-xs font-semibold text-sage-700 hover:text-sage-900 transition px-1.5 py-0.5 rounded-lg" title="Play soothing ambient soundscape">
            <i data-lucide="wind" id="soundscape-icon" class="w-3.5 h-3.5 text-autumn-600"></i>
            <span id="soundscape-label">Autumn Breeze: Off</span>
          </button>
          <select id="soundscape-preset" onchange="changeSoundscapePreset(this.value)" class="text-[11px] bg-parchment-50 border border-parchment-200 rounded-lg px-1.5 py-0.5 text-stone-700 focus:outline-none">
            <option value="breeze">🍂 Autumn Breeze</option>
            <option value="rain">🌧️ Soft Rain</option>
            <option value="study">🕯️ Warm Study Hearth</option>
          </select>
          <input id="soundscape-volume" type="range" min="0.05" max="0.6" step="0.05" value="0.22" oninput="updateSoundscapeVolume(this.value)" class="w-14 accent-sage-600 cursor-pointer hidden sm:block" />
        </div>

        <!-- Falling Leaves Toggle -->
        <button id="leaves-toggle-btn" onclick="cycleLeafBreeze()" class="px-2.5 py-1.5 rounded-xl bg-white/90 hover:bg-autumn-50 border border-[#dfd0b5] text-xs font-medium text-stone-700 flex items-center gap-1.5 shadow-sm transition">
          <i data-lucide="leaf" class="w-3.5 h-3.5 text-autumn-600"></i>
          <span id="leaves-label" class="hidden sm:inline">Leaves: Gentle</span>
        </button>

        <!-- UK Voice Speed -->
        <div class="flex items-center gap-1 bg-white/90 border border-[#dfd0b5] rounded-xl px-2 py-1 shadow-sm text-xs">
          <i data-lucide="volume-2" class="w-3.5 h-3.5 text-sage-600"></i>
          <button onclick="setVoiceRate(0.85)" id="rate-slow" class="px-1.5 py-0.5 rounded-md text-[11px] text-stone-600 hover:bg-parchment-100 transition">0.85×</button>
          <button onclick="setVoiceRate(1.0)" id="rate-normal" class="px-1.5 py-0.5 rounded-md text-[11px] bg-sage-600 text-white font-semibold transition">UK 1×</button>
        </div>

        <!-- Theme Mood Selector -->
        <div class="hidden lg:flex items-center gap-1 bg-white/90 border border-[#dfd0b5] rounded-xl p-1 text-[11px] shadow-sm">
          <button onclick="setThemeMood('kensington')" id="theme-kensington" class="px-2 py-0.5 rounded-lg bg-autumn-100 text-autumn-800 font-semibold transition">Bath Stone</button>
          <button onclick="setThemeMood('winchester')" id="theme-winchester" class="px-2 py-0.5 rounded-lg text-stone-600 hover:text-stone-900 transition">Winchester Mist</button>
          <button onclick="setThemeMood('twilight')" id="theme-twilight" class="px-2 py-0.5 rounded-lg text-stone-600 hover:text-stone-900 transition">Warm Study</button>
        </div>
      </div>

    </div>
  </header>

  <!-- MAIN CONTAINER -->
  <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-7 space-y-7 relative z-10">

    <!-- HERO / LESSON OVERVIEW -->
    <section class="sanctuary-card rounded-3xl p-6 sm:p-9 relative overflow-hidden">
      <div class="absolute -right-12 -top-12 w-64 h-64 bg-autumn-200/30 rounded-full blur-3xl pointer-events-none"></div>
      <div class="absolute -left-12 -bottom-12 w-64 h-64 bg-sage-200/35 rounded-full blur-3xl pointer-events-none"></div>

      <div class="relative z-10 grid grid-cols-1 lg:grid-cols-12 gap-7 items-center">
        <div class="lg:col-span-8 space-y-3.5">
          <div class="inline-flex flex-wrap items-center gap-2 px-3 py-1 rounded-full bg-sage-100/90 border border-sage-200 text-sage-800 text-xs font-medium">
            <i data-lucide="compass" class="w-3.5 h-3.5 text-autumn-600"></i>
            <span>Lesson 01 • 24 October 2026 • 55-Minute Full Session</span>
          </div>

          <h1 class="font-serif text-3xl sm:text-4xl lg:text-[2.65rem] font-bold text-slatewarm-900 leading-[1.16]">
            From Mallorca Turquoise Waters to Remarque's <span class="text-autumn-700 italic font-semibold">Trench Realism &amp; Starship Troopers</span>
          </h1>

          <p class="text-stone-600 text-sm sm:text-base leading-relaxed max-w-3xl">
            In today's lesson, we explored a rich conversational tapestry: transitioning from Mallorca's sunshine to grey Berlin autumn skies, overcoming "Denglish" sentence habits, the aerodynamics of gliders and thermal lift, cue sports and cricket, optical illusions vs elder wisdom, positive peer pressure, technical jargon vs Bavarian colloquialisms (<em>"Servus"</em>, <em>"for ages"</em>), and contrasting Erich Maria Remarque's <strong>All Quiet on the Western Front</strong> with Paul Verhoeven's satirical parody <strong>Starship Troopers</strong> in preparation for Clemens' upcoming English Abitur exam.
          </p>

          <!-- 4 Pillars for the Student -->
          <div class="grid grid-cols-1 sm:grid-cols-2 gap-2.5 pt-2 text-xs">
            <div class="flex items-start gap-2 bg-parchment-100/80 p-2.5 rounded-xl border border-parchment-300">
              <i data-lucide="check-circle" class="w-4 h-4 text-sage-600 shrink-0 mt-0.5"></i>
              <div>
                <strong class="text-slatewarm-900">Zero Note-Taking Friction:</strong> All 340 spoken turns chronologically organized across 6 chapters with per-turn British audio synthesis.
              </div>
            </div>
            <div class="flex items-start gap-2 bg-parchment-100/80 p-2.5 rounded-xl border border-parchment-300">
              <i data-lucide="check-circle" class="w-4 h-4 text-sage-600 shrink-0 mt-0.5"></i>
              <div>
                <strong class="text-slatewarm-900">54 Curated Lexicon Items:</strong> Hover or click any highlighted term for IPA phonetics, CEFR level, German translations, and spoken quotes.
              </div>
            </div>
            <div class="flex items-start gap-2 bg-parchment-100/80 p-2.5 rounded-xl border border-parchment-300">
              <i data-lucide="check-circle" class="w-4 h-4 text-sage-600 shrink-0 mt-0.5"></i>
              <div>
                <strong class="text-slatewarm-900">Natural Strengths &amp; Upgrades:</strong> Celebrating 6 high-level idiomatic expressions followed by 6 gentle phrasing polishes.
              </div>
            </div>
            <div class="flex items-start gap-2 bg-parchment-100/80 p-2.5 rounded-xl border border-parchment-300">
              <i data-lucide="check-circle" class="w-4 h-4 text-sage-600 shrink-0 mt-0.5"></i>
              <div>
                <strong class="text-slatewarm-900">Note-Taker Fixes Log:</strong> All speech-to-text slips (e.g. <em>my. Orca</em>, <em>Tukis water</em>, <em>Abbey Tour</em>, <em>pure pressure</em>) forensically resolved.
              </div>
            </div>
          </div>
        </div>

        <!-- Quick Lesson Stats Cards -->
        <div class="lg:col-span-4 grid grid-cols-2 gap-3">
          <div onclick="switchTab('transcript')" class="cursor-pointer p-4 rounded-2xl bg-parchment-50/95 border border-parchment-300 hover:border-autumn-400 transition shadow-sm group">
            <div class="text-[11px] font-mono font-semibold uppercase text-autumn-700 flex items-center justify-between">
              <span>Section 1</span>
              <i data-lucide="scroll-text" class="w-4 h-4 group-hover:scale-110 transition"></i>
            </div>
            <div class="font-serif font-bold text-slatewarm-900 text-lg mt-0.5">Full Transcript</div>
            <p class="text-[11px] text-stone-600 mt-0.5">6 chapters • 00:00 to 54:58</p>
          </div>

          <div onclick="switchTab('vocab')" class="cursor-pointer p-4 rounded-2xl bg-sage-50/95 border border-sage-200 hover:border-sage-400 transition shadow-sm group">
            <div class="text-[11px] font-mono font-semibold uppercase text-sage-700 flex items-center justify-between">
              <span>Section 2</span>
              <i data-lucide="book-marked" class="w-4 h-4 group-hover:scale-110 transition"></i>
            </div>
            <div class="font-serif font-bold text-slatewarm-900 text-lg mt-0.5">Flagged Lexicon</div>
            <p class="text-[11px] text-stone-600 mt-0.5">54 B2–C2 terms with German</p>
          </div>

          <div onclick="switchTab('fixes')" class="cursor-pointer p-4 rounded-2xl bg-autumn-50/95 border border-autumn-200 hover:border-autumn-400 transition shadow-sm group">
            <div class="text-[11px] font-mono font-semibold uppercase text-autumn-700 flex items-center justify-between">
              <span>Section 3</span>
              <i data-lucide="wand-sparkles" class="w-4 h-4 group-hover:scale-110 transition"></i>
            </div>
            <div class="font-serif font-bold text-slatewarm-900 text-lg mt-0.5">Strengths &amp; Fixes</div>
            <p class="text-[11px] text-stone-600 mt-0.5">Confidence boosters &amp; polishes</p>
          </div>

          <div onclick="switchTab('practice')" class="cursor-pointer p-4 rounded-2xl bg-parchment-50/95 border border-parchment-300 hover:border-sage-400 transition shadow-sm group">
            <div class="text-[11px] font-mono font-semibold uppercase text-sage-700 flex items-center justify-between">
              <span>Section 4</span>
              <i data-lucide="coffee" class="w-4 h-4 group-hover:scale-110 transition"></i>
            </div>
            <div class="font-serif font-bold text-slatewarm-900 text-lg mt-0.5">Peaceful Review</div>
            <p class="text-[11px] text-stone-600 mt-0.5">Flashcards, Idiom Gym &amp; quiz</p>
          </div>
        </div>
      </div>
    </section>

    <!-- 5-TAB NAVIGATION BAR -->
    <nav class="sanctuary-card rounded-2xl p-2 flex flex-wrap items-center justify-between gap-2 no-print">
      <div class="flex flex-wrap items-center gap-1.5 w-full sm:w-auto">
        <button onclick="switchTab('transcript')" id="tab-btn-transcript" class="tab-btn flex-1 sm:flex-initial px-4 py-2.5 rounded-xl text-xs sm:text-sm font-semibold transition flex items-center justify-center gap-2 bg-sage-700 text-white shadow-sm">
          <i data-lucide="message-square-quote" class="w-4 h-4"></i>
          <span>1. Cleaned Transcript</span>
          <span class="px-2 py-0.5 text-[10px] rounded-full bg-white/20 text-white font-mono">00:00–54:58</span>
        </button>

        <button onclick="switchTab('vocab')" id="tab-btn-vocab" class="tab-btn flex-1 sm:flex-initial px-4 py-2.5 rounded-xl text-xs sm:text-sm font-semibold transition flex items-center justify-center gap-2 text-stone-700 hover:bg-parchment-100">
          <i data-lucide="book-marked" class="w-4 h-4 text-autumn-600"></i>
          <span>2. Vocabulary Dictionary</span>
          <span id="vocab-total-badge" class="px-2 py-0.5 text-[10px] rounded-full bg-autumn-100 text-autumn-800 font-mono">54 Words</span>
        </button>

        <button onclick="switchTab('fixes')" id="tab-btn-fixes" class="tab-btn flex-1 sm:flex-initial px-4 py-2.5 rounded-xl text-xs sm:text-sm font-semibold transition flex items-center justify-center gap-2 text-stone-700 hover:bg-parchment-100">
          <i data-lucide="sparkles" class="w-4 h-4 text-sage-600"></i>
          <span>3. Note-Taker Fixes &amp; Gentle Notes</span>
        </button>

        <button onclick="switchTab('editorials')" id="tab-btn-editorials" class="tab-btn flex-1 sm:flex-initial px-4 py-2.5 rounded-xl text-xs sm:text-sm font-semibold transition flex items-center justify-center gap-2 text-stone-700 hover:bg-parchment-100">
          <i data-lucide="landmark" class="w-4 h-4 text-autumn-600"></i>
          <span>4. Literature &amp; Culture Editorials</span>
        </button>

        <button onclick="switchTab('practice')" id="tab-btn-practice" class="tab-btn flex-1 sm:flex-initial px-4 py-2.5 rounded-xl text-xs sm:text-sm font-semibold transition flex items-center justify-center gap-2 text-stone-700 hover:bg-parchment-100">
          <i data-lucide="coffee" class="w-4 h-4 text-sage-600"></i>
          <span>5. Peaceful Practice Sanctuary</span>
        </button>
      </div>

      <div class="hidden sm:block">
        <button onclick="copyPreplySummary()" class="px-3.5 py-2 rounded-xl bg-autumn-600 hover:bg-autumn-700 text-white font-semibold text-xs flex items-center gap-1.5 shadow-sm transition">
          <i data-lucide="clipboard-copy" class="w-3.5 h-3.5"></i>
          <span>Copy Preply Lesson Note</span>
        </button>
      </div>
    </nav>

    <!-- =================================================================== -->
    <!-- TAB 1: FULL CLEANED TRANSCRIPT & SPOTLIGHT                          -->
    <!-- =================================================================== -->
    <section id="tab-panel-transcript" class="tab-panel space-y-6">
      
      <div class="sanctuary-card rounded-3xl p-5 sm:p-6 space-y-4">
        <div class="flex flex-col lg:flex-row lg:items-center justify-between gap-4 border-b border-[#e6decb] pb-4">
          <div>
            <div class="flex items-center gap-2">
              <h2 class="font-serif text-2xl font-bold text-slatewarm-900">Interactive Lesson Transcript</h2>
              <span class="px-2.5 py-0.5 rounded-full text-xs font-mono font-semibold bg-sage-100 text-sage-800">
                55-Minute Full Session
              </span>
            </div>
            <p class="text-xs text-stone-500 mt-1">
              Click any <span class="vocab-mark">highlighted phrase</span> to inspect in the Spotlight. Hover for instant British pronunciation &amp; German translations.
            </p>
          </div>

          <!-- Controls: Speaker filter, badge toggles -->
          <div class="flex flex-wrap items-center gap-2 text-xs">
            <!-- Speaker Filter Buttons -->
            <div class="flex items-center gap-1 bg-parchment-100 p-1 rounded-xl border border-parchment-300">
              <button id="spk-all-btn" onclick="filterSpeaker('all')" class="px-3 py-1.5 rounded-xl text-xs font-semibold bg-sage-700 text-white shadow-xs transition">All</button>
              <button id="spk-louie-btn" onclick="filterSpeaker('Louie')" class="px-3 py-1.5 rounded-xl text-xs font-semibold bg-white border border-stone-200 text-stone-700 hover:bg-parchment-100 transition">Louie</button>
              <button id="spk-clemens-btn" onclick="filterSpeaker('Clemens')" class="px-3 py-1.5 rounded-xl text-xs font-semibold bg-white border border-stone-200 text-stone-700 hover:bg-parchment-100 transition">Clemens</button>
            </div>

            <!-- Fix Badges Toggle -->
            <button onclick="toggleAsrBadges()" class="px-3 py-1.5 rounded-xl bg-white border border-stone-200 hover:bg-parchment-100 text-stone-700 font-medium transition flex items-center gap-1.5">
              <i data-lucide="wand-2" class="w-3.5 h-3.5 text-sage-600"></i>
              <span id="asr-btn-text">Note-Taker Fixes: Visible</span>
            </button>

            <!-- Highlights Toggle -->
            <button onclick="toggleVocabHighlights()" class="px-3 py-1.5 rounded-xl bg-white border border-stone-200 hover:bg-parchment-100 text-stone-700 font-medium transition flex items-center gap-1.5">
              <i data-lucide="highlighter" class="w-3.5 h-3.5 text-autumn-600"></i>
              <span id="vocab-btn-text">Vocab Highlights: On</span>
            </button>
          </div>
        </div>

        <!-- Search Bar -->
        <div class="relative">
          <i data-lucide="search" class="w-4 h-4 text-stone-400 absolute left-3.5 top-1/2 -translate-y-1/2"></i>
          <input id="transcript-search" oninput="filterTranscript()" type="text" placeholder="Search spoken dialogue, vocabulary, topics (e.g. 'All Quiet', 'thermals', 'peer pressure', 'Munich')..." class="w-full pl-10 pr-10 py-2.5 rounded-2xl bg-white border border-[#dfd0b5] text-xs sm:text-sm text-slatewarm-900 focus:outline-none focus:border-sage-500 shadow-xs placeholder:text-stone-400" />
          <button id="clear-search-btn" onclick="clearTranscriptSearch()" class="hidden absolute right-3 top-1/2 -translate-y-1/2 text-stone-400 hover:text-stone-600">
            <i data-lucide="x" class="w-4 h-4"></i>
          </button>
        </div>
      </div>

      <!-- Main Two-Column Layout: Turns on Left, Sticky Spotlight on Right -->
      <div class="grid grid-cols-1 lg:grid-cols-12 gap-6 items-start">
        
        <!-- Left: Transcript Turns -->
        <div class="lg:col-span-8 space-y-4" id="transcript-turns-container">
          <!-- Populated via renderTranscript() -->
        </div>

        <!-- Right: Sticky Spotlight Panel -->
        <div class="lg:col-span-4 sticky top-20 space-y-4">
          <div class="sanctuary-card rounded-3xl p-5 sm:p-6 space-y-4 border-t-4 border-t-autumn-500 shadow-md">
            
            <div class="flex items-center justify-between border-b border-[#e6decb] pb-3">
              <div class="flex items-center gap-2">
                <i data-lucide="sparkles" class="w-4 h-4 text-autumn-600"></i>
                <h3 class="font-serif font-bold text-base text-slatewarm-900 uppercase tracking-wide">Vocabulary Spotlight</h3>
              </div>
              <span id="spotlight-badge" class="px-2 py-0.5 rounded-full text-[10px] font-mono font-bold bg-autumn-100 text-autumn-800">
                Click any word
              </span>
            </div>

            <!-- Spotlight Content -->
            <div id="spotlight-body" class="space-y-3.5 text-xs">
              <p class="text-stone-500 italic">Select any highlighted phrase in the transcript or vocabulary grid to inspect definitions, phonetics, and lesson context.</p>
            </div>

            <!-- Helpful Study Tip -->
            <div class="pt-3 border-t border-[#e6decb] text-[11px] text-stone-500 flex items-start gap-2">
              <i data-lucide="info" class="w-3.5 h-3.5 text-sage-600 shrink-0 mt-0.5"></i>
              <span>Hovering over phrases in the transcript triggers an instant pronunciation card with German translations.</span>
            </div>
          </div>

          <!-- Quick Homework Box -->
          <div class="sanctuary-card rounded-3xl p-5 space-y-2.5 bg-gradient-to-br from-parchment-100/90 to-autumn-50/70 border border-autumn-200">
            <div class="flex items-center justify-between">
              <span class="text-[11px] font-mono font-bold uppercase text-autumn-800 flex items-center gap-1.5">
                <i data-lucide="target" class="w-3.5 h-3.5"></i>
                Targeted Homework
              </span>
              <span class="text-[10px] px-2 py-0.5 rounded bg-autumn-200/60 text-autumn-900 font-mono">Exam Focus</span>
            </div>
            <h4 class="font-serif font-bold text-sm text-slatewarm-900">Starship Troopers Elevator Pitch</h4>
            <p class="text-[11px] text-stone-600 leading-relaxed">
              Watch Paul Verhoeven's <em>Starship Troopers</em> in your spare time. In the Preply app, draft a 45-second <strong>elevator pitch outline</strong> analyzing how it satirizes military propaganda, preparing you for next Wednesday's English exam summary!
            </p>
          </div>
        </div>

      </div>

    </section>

    <!-- =================================================================== -->
    <!-- TAB 2: SEARCHABLE VOCABULARY DICTIONARY                             -->
    <!-- =================================================================== -->
    <section id="tab-panel-vocab" class="tab-panel hidden space-y-6">
      
      <div class="sanctuary-card rounded-3xl p-6 sm:p-7 space-y-4">
        <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 border-b border-[#e6decb] pb-4">
          <div>
            <h2 class="font-serif text-2xl font-bold text-slatewarm-900">Interactive Vocabulary Sanctuary</h2>
            <p class="text-xs text-stone-500 mt-1">54 B2–C2 words, idioms, and expressions with German translations and UK audio synthesis.</p>
          </div>
          
          <div class="flex items-center gap-2">
            <!-- Level Filter Pills -->
            <div class="flex items-center gap-1 bg-parchment-100 p-1 rounded-xl border border-parchment-300 text-xs">
              <button id="lvl-all" onclick="filterVocabLevel('all')" class="px-2.5 py-1 rounded-lg bg-autumn-600 text-white font-bold transition text-xs">All</button>
              <button id="lvl-B2" onclick="filterVocabLevel('B2')" class="px-2.5 py-1 rounded-lg bg-white border border-stone-200 text-stone-700 hover:bg-parchment-100 font-bold transition text-xs">B2</button>
              <button id="lvl-C1" onclick="filterVocabLevel('C1')" class="px-2.5 py-1 rounded-lg bg-white border border-stone-200 text-stone-700 hover:bg-parchment-100 font-bold transition text-xs">C1</button>
              <button id="lvl-C2" onclick="filterVocabLevel('C2')" class="px-2.5 py-1 rounded-lg bg-white border border-stone-200 text-stone-700 hover:bg-parchment-100 font-bold transition text-xs">C2</button>
            </div>
          </div>
        </div>

        <!-- Category Filter Pills & Search -->
        <div class="flex flex-col md:flex-row gap-3 items-center justify-between">
          <div class="flex flex-wrap items-center gap-1.5 text-xs w-full md:w-auto">
            <button id="cat-all" onclick="filterVocabCategory('all')" class="px-3 py-1.5 rounded-xl text-xs font-semibold bg-sage-700 text-white shadow-xs transition">All Categories</button>
            <button id="cat-travel-nature" onclick="filterVocabCategory('travel-nature')" class="px-3 py-1.5 rounded-xl text-xs font-semibold bg-white border border-stone-200 text-stone-700 hover:bg-parchment-100 transition">Travel &amp; Nature</button>
            <button id="cat-sports-physics" onclick="filterVocabCategory('sports-physics')" class="px-3 py-1.5 rounded-xl text-xs font-semibold bg-white border border-stone-200 text-stone-700 hover:bg-parchment-100 transition">Sports &amp; Aerodynamics</button>
            <button id="cat-abstract-philosophy" onclick="filterVocabCategory('abstract-philosophy')" class="px-3 py-1.5 rounded-xl text-xs font-semibold bg-white border border-stone-200 text-stone-700 hover:bg-parchment-100 transition">Abstract Thought</button>
            <button id="cat-literature-cinema" onclick="filterVocabCategory('literature-cinema')" class="px-3 py-1.5 rounded-xl text-xs font-semibold bg-white border border-stone-200 text-stone-700 hover:bg-parchment-100 transition">Cinema &amp; Literature</button>
            <button id="cat-language-learning" onclick="filterVocabCategory('language-learning')" class="px-3 py-1.5 rounded-xl text-xs font-semibold bg-white border border-stone-200 text-stone-700 hover:bg-parchment-100 transition">Language &amp; Idioms</button>
            <button id="cat-lifestyle-study" onclick="filterVocabCategory('lifestyle-study')" class="px-3 py-1.5 rounded-xl text-xs font-semibold bg-white border border-stone-200 text-stone-700 hover:bg-parchment-100 transition">Study &amp; Abitur</button>
          </div>

          <div class="relative w-full md:w-72">
            <i data-lucide="search" class="w-4 h-4 text-stone-400 absolute left-3 top-1/2 -translate-y-1/2"></i>
            <input id="vocab-search" oninput="renderVocabGrid()" type="text" placeholder="Search words, definitions, German..." class="w-full pl-9 pr-3 py-2 rounded-xl bg-white border border-[#dfd0b5] text-xs text-slatewarm-900 focus:outline-none focus:border-sage-500 shadow-xs" />
          </div>
        </div>
      </div>

      <!-- Grid of Cards -->
      <div id="vocab-cards-grid" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
        <!-- Populated via renderVocabGrid() -->
      </div>

    </section>

    <!-- =================================================================== -->
    <!-- TAB 3: NOTE-TAKER FIXES & GENTLE NOTES                              -->
    <!-- =================================================================== -->
    <section id="tab-panel-fixes" class="tab-panel hidden space-y-6">
      
      <!-- Part 1: Your Natural Strengths -->
      <div class="sanctuary-card rounded-3xl p-6 sm:p-8 space-y-4">
        <div class="border-b border-[#e6decb] pb-3">
          <div class="flex items-center gap-2">
            <i data-lucide="sparkles" class="w-5 h-5 text-amber-600"></i>
            <h2 class="font-serif text-2xl font-bold text-slatewarm-900">Your Natural Strengths in Action</h2>
          </div>
          <p class="text-xs text-stone-500 mt-0.5">Six high-level expressions and analytical insights you articulated naturally during the lesson</p>
        </div>

        <div id="strengths-container" class="grid grid-cols-1 md:grid-cols-2 gap-4 pt-2">
          <!-- Populated via renderStrengths() -->
        </div>
      </div>

      <!-- Part 2: Gentle Phrasing Polishes -->
      <div class="sanctuary-card rounded-3xl p-6 sm:p-8 space-y-4">
        <div class="border-b border-[#e6decb] pb-3">
          <div class="flex items-center gap-2">
            <i data-lucide="feather" class="w-5 h-5 text-sage-600"></i>
            <h2 class="font-serif text-2xl font-bold text-slatewarm-900">Gentle Phrasing Polishes</h2>
          </div>
          <p class="text-xs text-stone-500 mt-0.5">Encouraging upgrades to overcome German syntactic patterns and sound effortless</p>
        </div>

        <div id="phrasing-container" class="grid grid-cols-1 md:grid-cols-2 gap-4 pt-2">
          <!-- Populated via renderPhrasing() -->
        </div>
      </div>

      <!-- Part 3: Speech-to-Text Corrections Log -->
      <div class="sanctuary-card rounded-3xl p-6 sm:p-8 space-y-4">
        <div class="border-b border-[#e6decb] pb-3">
          <div class="flex items-center gap-2">
            <i data-lucide="wrench" class="w-5 h-5 text-autumn-600"></i>
            <h2 class="font-serif text-2xl font-bold text-slatewarm-900">Forensic Note-Taker Fixes Log</h2>
          </div>
          <p class="text-xs text-stone-500 mt-0.5">How automated speech-to-text algorithms stumbled on proper nouns, accents, and German terms</p>
        </div>

        <div id="asr-fixes-container" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3.5 pt-2">
          <!-- Populated via renderAsrFixes() -->
        </div>
      </div>

    </section>

    <!-- =================================================================== -->
    <!-- TAB 4: LITERATURE & CULTURE EDITORIALS                              -->
    <!-- =================================================================== -->
    <section id="tab-panel-editorials" class="tab-panel hidden space-y-6">
      
      <div class="sanctuary-card rounded-3xl p-6 sm:p-8 space-y-3">
        <div class="flex items-center gap-2">
          <i data-lucide="landmark" class="w-5 h-5 text-autumn-600"></i>
          <h2 class="font-serif text-2xl font-bold text-slatewarm-900">Literature, Flight &amp; Culture Editorials</h2>
        </div>
        <p class="text-xs text-stone-500">
          Four deep editorial essays exploring the core scientific, philosophical, and cinematic themes covered in today's conversation.
        </p>
      </div>

      <div id="editorial-cards-container" class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <!-- Populated via renderEditorialTopics() -->
      </div>

    </section>

    <!-- =================================================================== -->
    <!-- TAB 5: PEACEFUL PRACTICE SANCTUARY                                  -->
    <!-- =================================================================== -->
    <section id="tab-panel-practice" class="tab-panel hidden space-y-7">
      
      <!-- Interactive Flashcard Deck -->
      <div class="sanctuary-card rounded-3xl p-6 sm:p-8 space-y-5">
        <div class="flex items-center justify-between border-b border-[#e6decb] pb-3">
          <div>
            <div class="flex items-center gap-2">
              <i data-lucide="layers" class="w-5 h-5 text-sage-600"></i>
              <h2 class="font-serif text-2xl font-bold text-slatewarm-900">Interactive Vocabulary Flashcards</h2>
            </div>
            <p class="text-xs text-stone-500 mt-0.5">Click any card to flip and reveal definitions, German equivalents, and lesson context</p>
          </div>
          
          <div class="flex items-center gap-2">
            <span id="fc-counter" class="text-xs font-mono font-bold text-stone-500">1 / 12</span>
            <div class="flex items-center gap-1">
              <button onclick="prevFlashcard()" class="p-1.5 rounded-lg bg-parchment-100 hover:bg-parchment-200 text-stone-700 transition">
                <i data-lucide="chevron-left" class="w-4 h-4"></i>
              </button>
              <button onclick="nextFlashcard()" class="p-1.5 rounded-lg bg-parchment-100 hover:bg-parchment-200 text-stone-700 transition">
                <i data-lucide="chevron-right" class="w-4 h-4"></i>
              </button>
            </div>
          </div>
        </div>

        <!-- Card Container with 3D Flip -->
        <div class="max-w-xl mx-auto perspective-[1000px] py-4">
          <div id="flashcard" onclick="flipFlashcard()" class="flashcard-inner relative w-full h-72 cursor-pointer rounded-3xl shadow-sm border border-[#dfd0b5] bg-gradient-to-br from-parchment-50 to-white p-7 flex flex-col justify-between">
            
            <!-- Front Face -->
            <div class="flashcard-front absolute inset-0 p-7 flex flex-col justify-between">
              <div class="flex items-center justify-between">
                <span id="fc-badge-front" class="px-2.5 py-0.5 rounded-full text-[10px] font-mono font-bold bg-autumn-100 text-autumn-800">C2 • Noun</span>
                <span class="text-[11px] text-stone-400 font-mono">Click to flip ↷</span>
              </div>
              <div class="text-center my-auto space-y-1.5">
                <h3 id="fc-word-front" class="font-serif text-3xl font-bold text-slatewarm-900">serendipity</h3>
                <p id="fc-ipa-front" class="font-mono text-xs text-stone-500">/ˌser.ənˈdɪp.ə.ti/</p>
              </div>
              <div class="text-center text-[11px] text-stone-400">
                Louie's English Studio Practice
              </div>
            </div>

            <!-- Back Face -->
            <div class="flashcard-back absolute inset-0 p-7 flex flex-col justify-between bg-gradient-to-br from-white to-parchment-50 rounded-3xl">
              <div class="flex items-center justify-between">
                <span id="fc-badge-back" class="px-2.5 py-0.5 rounded-full text-[10px] font-mono font-bold bg-sage-100 text-sage-800">C2 • Noun</span>
                <span class="text-[11px] text-stone-400 font-mono">Click to flip ↶</span>
              </div>
              <div class="space-y-2.5 my-auto text-left">
                <p id="fc-def-back" class="text-xs sm:text-sm text-slatewarm-900 font-medium leading-relaxed">Finding valuable, pleasant things entirely by happy chance.</p>
                <div id="fc-de-back" class="p-2 rounded-xl bg-parchment-100 border border-parchment-300 text-xs font-semibold text-autumn-800">🇩🇪 Deutsch: glücklicher Zufall</div>
                <blockquote id="fc-quote-back" class="border-l-2 border-stone-300 pl-2 text-[11px] italic text-stone-500 font-serif">"Louie: It was pure serendipity."</blockquote>
              </div>
              <div class="text-center text-[11px] text-stone-400">
                Louie's English Studio Practice
              </div>
            </div>

          </div>
        </div>

        <div class="text-center">
          <button onclick="speakCurrentFlashcard()" class="px-4 py-2 rounded-xl bg-parchment-100 hover:bg-parchment-200 border border-parchment-300 text-slatewarm-900 font-semibold text-xs inline-flex items-center gap-2 transition">
            <i data-lucide="volume-2" class="w-4 h-4 text-autumn-600"></i>
            <span>Listen to Pronunciation</span>
          </button>
        </div>
      </div>

      <!-- The Idiom Gym: Scenario Matcher -->
      <div class="sanctuary-card rounded-3xl p-6 sm:p-8 space-y-5">
        <div class="border-b border-[#e6decb] pb-3">
          <div class="flex items-center gap-2">
            <i data-lucide="dumbbell" class="w-5 h-5 text-autumn-600"></i>
            <h2 class="font-serif text-2xl font-bold text-slatewarm-900">The Idiom Gym: Scenario Matcher</h2>
          </div>
          <p class="text-xs text-stone-500 mt-0.5">Select the idiomatic phrase that best matches each real-world conversational challenge</p>
        </div>

        <div id="idiom-gym-container" class="space-y-4 pt-2">
          <!-- Populated via renderIdiomGym() -->
        </div>
      </div>

      <!-- 6-Question Context Quiz -->
      <div class="sanctuary-card rounded-3xl p-6 sm:p-8 space-y-5">
        <div class="flex items-center justify-between border-b border-[#e6decb] pb-3">
          <div>
            <div class="flex items-center gap-2">
              <i data-lucide="check-square" class="w-5 h-5 text-sage-600"></i>
              <h2 class="font-serif text-2xl font-bold text-slatewarm-900">Context &amp; Science Quiz</h2>
            </div>
            <p class="text-xs text-stone-500 mt-0.5">Test your recall of flight physics, Remarque's cinema, and English expressions</p>
          </div>
          <div id="quiz-score-badge" class="px-3 py-1 rounded-full bg-sage-100 text-sage-800 font-mono font-bold text-xs">
            Score: 0 / 6
          </div>
        </div>

        <div id="quiz-questions-container" class="space-y-5 pt-2">
          <!-- Populated via renderQuiz() -->
        </div>
      </div>

      <!-- Next Lesson Reflections -->
      <div class="sanctuary-card rounded-3xl p-6 sm:p-8 space-y-4">
        <div class="border-b border-[#e6decb] pb-3">
          <div class="flex items-center gap-2">
            <i data-lucide="feather" class="w-5 h-5 text-autumn-600"></i>
            <h2 class="font-serif text-2xl font-bold text-slatewarm-900">Reflections for Wednesday's Exam Preparation</h2>
          </div>
          <p class="text-xs text-stone-500 mt-0.5">Three thought-provoking prompts to prepare for your English exam outline and comment</p>
        </div>

        <div id="reflections-container" class="grid grid-cols-1 md:grid-cols-3 gap-4 pt-2">
          <!-- Populated via renderReflections() -->
        </div>
      </div>

    </section>

    <!-- FOOTER -->
    <footer id="how-it-works" class="sanctuary-card rounded-3xl p-6 sm:p-8 text-center space-y-3 no-print">
      <div class="w-10 h-10 rounded-2xl bg-gradient-to-br from-sage-600 to-autumn-600 flex items-center justify-center text-white font-serif text-xl font-bold mx-auto">
        L
      </div>
      <h3 class="font-serif font-bold text-xl text-slatewarm-900">Louie's English Sanctuary • Preply Partner Portal</h3>
      <p class="text-xs text-stone-500 max-w-xl mx-auto leading-relaxed">
        Crafted with calm attention to detail for Clemens' lesson (24 October 2026). Designed to provide zero-stress review, pristine audio synthesis, and lasting confidence on the global stage.
      </p>
      <div class="pt-2 text-[11px] font-mono text-stone-400">
        Bath Stone &bull; Winchester Mist &bull; Twilight Study &bull; Built with Tailwind CSS, Lucide, Tippy.js &amp; Web Audio API
      </div>
    </footer>

  </main>
'@

# Literal JavaScript helper functions
$jsPrefix = @'
  <script>
    function v(key, displayWord) {
      var item = (typeof VOCAB_DB !== 'undefined' && VOCAB_DB[key]) ? VOCAB_DB[key] : null;
      var label = displayWord || (item ? item.word : key);
      return '<span class="vocab-mark" data-vkey="' + key + '" onclick="inspectVocab(\'' + key + '\')">' + label + '</span>';
    }

    function fixBadge(corrected, rawMistake) {
      return '<span class="asr-fix-pill" title="Note-taker misheard \'' + corrected + '\' as \'' + rawMistake + '\'">⚡ Fixed: "' + corrected + '" <span class="text-stone-400 font-normal">(heard: "' + rawMistake + '")</span></span>';
    }

    const VOCAB_DB = 
'@

$jsMid1 = @'
;
    const ASR_FIXES = 
'@

$jsMid2 = @'
;
    const NATURAL_STRENGTHS = 
'@

$jsMid3 = @'
;
    const PHRASING_POLISHES = 
'@

$jsMid4 = @'
;
    const TRANSCRIPT_TURNS = 
'@

$jsMid5 = @'
;
    const EDITORIAL_TOPICS = 
'@

$jsMid6 = @'
;
    const FLASHCARDS = 
'@

$jsMid7 = @'
;
    const IDIOM_CHALLENGES = 
'@

$jsMid8 = @'
;
    const QUIZ_QUESTIONS = 
'@

$jsMid9 = @'
;
    const REFLECTION_PROMPTS = 
'@

$jsSuffix = @'
;
    // State Management
    var activeTab = 'transcript';
    var activeSpeakerFilter = 'all';
    var activeVocabCategory = 'all';
    var activeVocabLevel = 'all';
    var currentFlashcardIndex = 0;
    var isFlashcardFlipped = false;
    var currentVoiceRate = 1.0;
    var quizAnswers = {};
    var idiomAnswers = {};

    function switchTab(tabId) {
      activeTab = tabId;
      var tabs = ['transcript', 'vocab', 'fixes', 'editorials', 'practice'];
      
      tabs.forEach(function(t) {
        var panel = document.getElementById('tab-panel-' + t);
        var btn = document.getElementById('tab-btn-' + t);
        if (panel) {
          panel.classList.toggle('hidden', t !== tabId);
        }
        if (btn) {
          if (t === tabId) {
            btn.className = 'tab-btn flex-1 sm:flex-initial px-4 py-2.5 rounded-xl text-xs sm:text-sm font-semibold transition flex items-center justify-center gap-2 bg-sage-700 text-white shadow-sm';
          } else {
            btn.className = 'tab-btn flex-1 sm:flex-initial px-4 py-2.5 rounded-xl text-xs sm:text-sm font-semibold transition flex items-center justify-center gap-2 text-stone-700 hover:bg-parchment-100';
          }
        }
      });

      window.scrollTo({ top: 400, behavior: 'smooth' });
    }

    function inspectVocab(key) {
      var item = VOCAB_DB[key];
      if (!item) return;

      document.querySelectorAll('.vocab-mark').forEach(function(el) {
        el.classList.toggle('active-vocab', el.getAttribute('data-vkey') === key);
      });

      var badge = document.getElementById('spotlight-badge');
      if (badge) {
        badge.textContent = item.level + ' • ' + (item.pos || 'term');
      }

      var body = document.getElementById('spotlight-body');
      if (body) {
        var cleanWord = (item.word || '').replace(/'/g, "\\'");
        body.innerHTML = 
          '<div class="space-y-3">' +
            '<div class="flex items-baseline justify-between">' +
              '<h3 class="font-serif font-bold text-2xl text-slatewarm-900 leading-tight">' + item.word + '</h3>' +
              '<button onclick="speakWord(\'' + cleanWord + '\')" class="p-1.5 text-stone-400 hover:text-autumn-600 transition" title="Listen">' +
                '<i data-lucide="volume-2" class="w-4 h-4"></i>' +
              '</button>' +
            '</div>' +
            '<p class="font-mono text-xs text-stone-500">' + item.ipa + '</p>' +
            '<div class="p-2.5 rounded-xl bg-parchment-100 text-xs font-semibold text-autumn-800 border border-parchment-300">🇩🇪 Deutsch: ' + (item.de || 'Übersetzung') + '</div>' +
            '<p class="text-xs text-stone-700 font-sans leading-relaxed">' + item.def + '</p>' +
            (item.quote ? '<blockquote class="border-l-2 border-stone-300 pl-2.5 text-[11px] italic text-stone-500 leading-relaxed font-serif">“' + item.quote + '”</blockquote>' : '') +
            '<div class="pt-2 border-t border-stone-200/60 flex items-center justify-between text-xs">' +
              '<span class="text-stone-400 font-mono text-[11px]">🕒 ' + (item.time || '--:--') + '</span>' +
              '<button onclick="jumpToTranscriptTurn(\'' + (item.turnId || '') + '\', \'' + key + '\')" class="text-autumn-700 hover:text-autumn-800 font-semibold flex items-center gap-1 transition">' +
                '<span>View in turn</span>' +
                '<i data-lucide="arrow-up-right" class="w-3.5 h-3.5"></i>' +
              '</button>' +
            '</div>' +
          '</div>';
        if (typeof lucide !== 'undefined' && lucide.createIcons) lucide.createIcons();
      }
    }

    function initTippyTooltips() {
      if (typeof tippy !== 'function') return;
      document.querySelectorAll('.vocab-mark').forEach(function(el) {
        var key = el.getAttribute('data-vkey');
        var item = VOCAB_DB[key];
        if (!item) return;

        if (el._tippy) el._tippy.destroy();

        var cleanWord = (item.word || '').replace(/'/g, "\\'");
        tippy(el, {
          theme: 'autumn-sanctuary',
          allowHTML: true,
          interactive: true,
          animation: 'shift-away',
          maxWidth: 320,
          content: 
            '<div class="p-2.5 space-y-2 text-left">' +
              '<div class="flex items-center justify-between gap-2 border-b border-parchment-200 pb-1.5">' +
                '<div>' +
                  '<span class="font-serif font-bold text-base text-slatewarm-900">' + item.word + '</span>' +
                  '<span class="block font-mono text-[10px] text-stone-500">' + item.ipa + ' • ' + (item.pos || '') + '</span>' +
                '</div>' +
                '<span class="px-1.5 py-0.5 rounded bg-autumn-100 text-autumn-800 font-mono text-[10px] font-bold">' + item.level + '</span>' +
              '</div>' +
              '<p class="text-xs text-stone-700 leading-snug">' + item.def + '</p>' +
              '<div class="flex items-center justify-between pt-1 text-[11px] border-t border-parchment-200">' +
                '<span class="text-sage-800 font-semibold">🇩🇪 ' + (item.de || '') + '</span>' +
                '<button onclick="speakWord(\'' + cleanWord + '\')" class="px-2 py-0.5 rounded bg-sage-700 text-white text-[10px] font-semibold">🔊 Listen UK</button>' +
              '</div>' +
            '</div>'
        });
      });
    }

    function renderTranscript() {
      var container = document.getElementById('transcript-turns-container');
      if (!container) return;
      var search = (document.getElementById('transcript-search').value || '').toLowerCase().trim();
      var html = '';
      var currentChapter = '';

      TRANSCRIPT_TURNS.forEach(function(turn) {
        if (activeSpeakerFilter !== 'all' && turn.speaker.toLowerCase() !== activeSpeakerFilter.toLowerCase()) {
          return;
        }

        if (search) {
          var textToSearch = (turn.speaker + ' ' + turn.time + ' ' + turn.html.replace(/<[^>]*>/g, '')).toLowerCase();
          if (!textToSearch.includes(search)) return;
        }

        if (turn.chapterTitle && turn.chapterTitle !== currentChapter) {
          currentChapter = turn.chapterTitle;
          html += '<div id="' + (turn.chapterId || '') + '" class="py-3 px-4 rounded-2xl bg-parchment-200/70 border border-parchment-300 flex items-center justify-between text-xs font-serif font-bold text-slatewarm-900 mt-6 mb-2 shadow-xs">' +
            '<span class="flex items-center gap-2"><i data-lucide="bookmark" class="w-4 h-4 text-autumn-600"></i>' + currentChapter + '</span>' +
            '<span class="font-mono text-[11px] text-stone-500 font-normal">🕒 ' + turn.time + '</span>' +
          '</div>';
        }

        var isLouie = turn.speaker.toLowerCase() === 'louie';
        var isVerena = turn.speaker.toLowerCase() === 'verena';
        var borderStyle = isLouie ? 'border-l-4 border-l-sage-600 bg-sage-50/40' : (isVerena ? 'border-l-4 border-l-amber-600 bg-amber-50/30' : 'border-l-4 border-l-autumn-500 bg-parchment-50/50');
        var avatarBg = isLouie ? 'bg-sage-600 text-white' : (isVerena ? 'bg-amber-600 text-white' : 'bg-autumn-500 text-white');
        var speakerLabel = isLouie ? '🍂 Louie (Tutor)' : (isVerena ? '🌸 Verena (Mom)' : '🌿 Clemens (Student)');
        var cleanSpoken = turn.html.replace(/<[^>]*>/g, '').replace(/'/g, "\\'");

        html += '<div id="' + turn.id + '" class="sanctuary-subcard rounded-2xl p-4 sm:p-5 ' + borderStyle + ' space-y-2.5 transition hover:shadow-sm">' +
          '<div class="flex items-center justify-between gap-2 border-b border-stone-200/60 pb-2">' +
            '<div class="flex items-center gap-2.5">' +
              '<div class="w-7 h-7 rounded-full ' + avatarBg + ' flex items-center justify-center font-bold text-xs">' + turn.speaker.charAt(0) + '</div>' +
              '<div>' +
                '<span class="font-bold text-xs sm:text-sm text-slatewarm-900">' + speakerLabel + '</span>' +
                '<span class="ml-2 font-mono text-[11px] text-stone-400">🕒 ' + turn.time + '</span>' +
              '</div>' +
            '</div>' +
            '<button onclick="speakText(\'' + cleanSpoken + '\', \'en-GB\')" class="p-1.5 rounded-lg text-stone-400 hover:text-autumn-600 hover:bg-parchment-100 transition" title="Listen to this turn">' +
              '<i data-lucide="volume-2" class="w-4 h-4"></i>' +
            '</button>' +
          '</div>' +
          '<div class="text-xs sm:text-sm text-slatewarm-900 leading-relaxed font-sans turn-body">' + turn.html + '</div>' +
        '</div>';
      });

      if (!html) {
        html = '<div class="text-center py-12 text-stone-500 font-serif text-base">No turns match your search criteria.</div>';
      }

      container.innerHTML = html;
      if (typeof lucide !== 'undefined' && lucide.createIcons) lucide.createIcons();
      initTippyTooltips();
    }

    function filterTranscript() {
      var val = document.getElementById('transcript-search').value;
      document.getElementById('clear-search-btn').classList.toggle('hidden', !val);
      renderTranscript();
    }

    function clearTranscriptSearch() {
      document.getElementById('transcript-search').value = '';
      document.getElementById('clear-search-btn').classList.add('hidden');
      renderTranscript();
    }

    function filterSpeaker(speaker) {
      activeSpeakerFilter = speaker;
      ['all', 'Louie', 'Clemens'].forEach(function(s) {
        var btn = document.getElementById('spk-' + s.toLowerCase() + '-btn');
        if (btn) {
          if (s === speaker) {
            btn.className = 'px-3 py-1.5 rounded-xl text-xs font-semibold bg-sage-700 text-white shadow-xs transition';
          } else {
            btn.className = 'px-3 py-1.5 rounded-xl text-xs font-semibold bg-white border border-stone-200 text-stone-700 hover:bg-parchment-100 transition';
          }
        }
      });
      renderTranscript();
    }

    function toggleAsrBadges() {
      document.body.classList.toggle('hide-asr-fixes');
      var hidden = document.body.classList.contains('hide-asr-fixes');
      document.getElementById('asr-btn-text').textContent = hidden ? 'Note-Taker Fixes: Hidden' : 'Note-Taker Fixes: Visible';
    }

    function toggleVocabHighlights() {
      document.body.classList.toggle('hide-vocab-highlights');
      var hidden = document.body.classList.contains('hide-vocab-highlights');
      document.getElementById('vocab-btn-text').textContent = hidden ? 'Vocab Highlights: Off' : 'Vocab Highlights: On';
    }

    function jumpToTranscriptTurn(turnId, vocabKey) {
      switchTab('transcript');
      if (vocabKey) inspectVocab(vocabKey);

      setTimeout(function() {
        var el = document.getElementById(turnId);
        if (el) {
          el.scrollIntoView({ behavior: 'smooth', block: 'center' });
          el.classList.add('turn-highlight-flash');
          setTimeout(function() { el.classList.remove('turn-highlight-flash'); }, 2900);
        }
      }, 150);
    }

    function renderVocabGrid() {
      var container = document.getElementById('vocab-cards-grid');
      if (!container) return;
      var searchVal = (document.getElementById('vocab-search').value || '').toLowerCase().trim();
      var html = '';
      var count = 0;

      Object.keys(VOCAB_DB).forEach(function(key) {
        var item = VOCAB_DB[key];
        if (!item) return;

        if (activeVocabCategory !== 'all') {
          if (item.cat !== activeVocabCategory) return;
        }

        if (activeVocabLevel !== 'all' && !item.level.startsWith(activeVocabLevel)) {
          return;
        }

        if (searchVal) {
          var combined = ((item.word || '') + ' ' + (item.def || '') + ' ' + (item.de || '') + ' ' + (item.cat || '') + ' ' + (item.quote || '')).toLowerCase();
          if (!combined.includes(searchVal)) return;
        }

        count++;
        var cleanWord = (item.word || '').replace(/'/g, "\\'");

        html += '<div class="sanctuary-subcard rounded-2xl p-5 space-y-3.5 transition hover:shadow-md flex flex-col justify-between border-t-2 border-t-autumn-400">' +
          '<div class="space-y-2">' +
            '<div class="flex items-center justify-between gap-2">' +
              '<span class="px-2 py-0.5 rounded-full text-[10px] font-mono font-bold bg-autumn-100 text-autumn-800">' + item.level + '</span>' +
              '<span class="px-2 py-0.5 rounded text-[10px] font-mono text-stone-500 capitalize bg-stone-100">' + item.cat + '</span>' +
            '</div>' +
            '<div class="flex items-baseline justify-between">' +
              '<div>' +
                '<h3 class="font-serif font-bold text-xl text-slatewarm-900">' + item.word + '</h3>' +
                '<p class="font-mono text-xs text-stone-500">' + item.ipa + '</p>' +
              '</div>' +
              '<button onclick="speakWord(\'' + cleanWord + '\')" class="p-1.5 text-stone-400 hover:text-autumn-600 transition" title="Listen">' +
                '<i data-lucide="volume-2" class="w-4 h-4"></i>' +
              '</button>' +
            '</div>' +
            '<p class="text-xs text-stone-700 font-sans leading-relaxed">' + item.def + '</p>' +
            (item.de ? '<div class="p-2.5 rounded-xl bg-gradient-to-r from-parchment-100 to-autumn-50/50 border border-autumn-200/70 text-xs font-medium text-slatewarm-900">🇩🇪 <strong>Deutsch:</strong> ' + item.de + '</div>' : '') +
            (item.quote ? '<blockquote class="border-l-2 border-stone-300 pl-2.5 text-[11px] italic text-stone-500 leading-relaxed font-serif">“' + item.quote + '”</blockquote>' : '') +
          '</div>' +
          '<div class="pt-3 border-t border-stone-100 flex items-center justify-between text-xs">' +
            '<span class="text-stone-400 font-mono text-[11px]">🕒 ' + (item.time || '--:--') + '</span>' +
            '<button onclick="jumpToTranscriptTurn(\'' + (item.turnId || '') + '\', \'' + key + '\')" class="text-autumn-700 hover:text-autumn-800 font-semibold flex items-center gap-1 transition">' +
              '<span>View in turn</span>' +
              '<i data-lucide="arrow-up-right" class="w-3.5 h-3.5"></i>' +
            '</button>' +
          '</div>' +
        '</div>';
      });

      if (!html) {
        html = '<div class="col-span-full text-center py-12 sanctuary-card rounded-3xl p-6 text-stone-500 space-y-2">' +
          '<i data-lucide="book-x" class="w-8 h-8 mx-auto text-stone-400"></i>' +
          '<p class="font-serif text-base">No vocabulary items matched your filter.</p>' +
        '</div>';
      }

      container.innerHTML = html;
      var countEl = document.getElementById('vocab-total-badge');
      if (countEl) countEl.textContent = count + ' Words';
      if (typeof lucide !== 'undefined' && lucide.createIcons) lucide.createIcons();
    }

    function filterVocabCategory(cat) {
      activeVocabCategory = cat;
      ['all', 'travel-nature', 'sports-physics', 'abstract-philosophy', 'literature-cinema', 'language-learning', 'lifestyle-study'].forEach(function(c) {
        var btn = document.getElementById('cat-' + c);
        if (btn) {
          if (c === cat) {
            btn.className = 'px-3 py-1.5 rounded-xl text-xs font-semibold bg-sage-700 text-white shadow-xs transition';
          } else {
            btn.className = 'px-3 py-1.5 rounded-xl text-xs font-semibold bg-white border border-stone-200 text-stone-700 hover:bg-parchment-100 transition';
          }
        }
      });
      renderVocabGrid();
    }

    function filterVocabLevel(lvl) {
      activeVocabLevel = lvl;
      ['all', 'B2', 'C1', 'C2'].forEach(function(l) {
        var btn = document.getElementById('lvl-' + l);
        if (btn) {
          if (l === lvl) {
            btn.className = 'px-2.5 py-1 rounded-lg bg-autumn-600 text-white font-bold transition text-xs';
          } else {
            btn.className = 'px-2.5 py-1 rounded-lg bg-white border border-stone-200 text-stone-700 hover:bg-parchment-100 font-bold transition text-xs';
          }
        }
      });
      renderVocabGrid();
    }

    function renderStrengths() {
      var container = document.getElementById('strengths-container');
      if (!container) return;
      container.innerHTML = NATURAL_STRENGTHS.map(function(item, idx) {
        return '<div class="sanctuary-subcard p-5 rounded-2xl border-l-4 border-l-sage-500 space-y-2">' +
          '<div class="flex items-center justify-between text-xs">' +
            '<span class="font-mono text-sage-800 font-bold">' + (idx + 1) + '. ' + item.title + '</span>' +
            '<span class="font-mono text-stone-400">🕒 ' + item.time + '</span>' +
          '</div>' +
          '<p class="font-serif italic text-sm text-stone-800">"' + item.quote + '"</p>' +
          '<p class="text-xs text-stone-600"><strong>Why this stood out:</strong> ' + item.analysis + '</p>' +
        '</div>';
      }).join('');
      if (typeof lucide !== 'undefined' && lucide.createIcons) lucide.createIcons();
    }

    function renderPhrasing() {
      var container = document.getElementById('phrasing-container');
      if (!container) return;
      container.innerHTML = PHRASING_POLISHES.map(function(item, idx) {
        return '<div class="sanctuary-subcard p-5 rounded-2xl border-l-4 border-l-autumn-500 space-y-2.5">' +
          '<div class="flex items-center justify-between text-xs">' +
            '<span class="font-mono text-autumn-800 font-bold">' + (idx + 1) + '. ' + item.topic + '</span>' +
            '<span class="font-mono text-stone-400">🕒 ' + item.time + '</span>' +
          '</div>' +
          '<div class="p-2.5 rounded-xl bg-autumn-50/70 border border-autumn-200/80 text-xs text-stone-600">' +
            '<span class="font-semibold text-autumn-800">In the moment spoken:</span> "' + item.spoken + '"' +
          '</div>' +
          '<div class="p-2.5 rounded-xl bg-sage-50 border border-sage-200 text-xs text-slatewarm-900 font-semibold text-sage-800">' +
            '<span>✨ Natural Polish:</span> "' + item.natural + '"' +
          '</div>' +
          '<p class="text-xs text-stone-600 leading-relaxed"><strong>Why it elevates your voice:</strong> ' + item.why + '</p>' +
        '</div>';
      }).join('');
      if (typeof lucide !== 'undefined' && lucide.createIcons) lucide.createIcons();
    }

    function renderAsrFixes() {
      var container = document.getElementById('asr-fixes-container');
      if (!container) return;
      container.innerHTML = ASR_FIXES.map(function(item) {
        return '<div class="sanctuary-subcard p-4 rounded-2xl border border-stone-200 space-y-1.5">' +
          '<div class="flex items-center justify-between text-[11px] font-mono">' +
            '<span class="text-autumn-800 font-bold">' + item.speaker + '</span>' +
            '<span class="text-stone-400">🕒 ' + item.time + '</span>' +
          '</div>' +
          '<div class="text-xs line-through text-stone-400">Note-taker: "' + item.wrong + '"</div>' +
          '<div class="text-xs font-semibold text-sage-800">⚡ Spoken: "' + item.right + '"</div>' +
          '<p class="text-[11px] text-stone-500 mt-1">' + item.note + '</p>' +
        '</div>';
      }).join('');
    }

    function renderEditorialTopics() {
      var container = document.getElementById('editorial-cards-container');
      if (!container) return;
      container.innerHTML = EDITORIAL_TOPICS.map(function(card) {
        return '<article class="sanctuary-card rounded-3xl p-6 sm:p-7 space-y-3.5 border-t-4 border-t-sage-600">' +
          '<div class="flex items-center justify-between gap-2">' +
            '<span class="px-2.5 py-0.5 rounded-full text-[10px] font-mono font-bold bg-sage-100 text-sage-800">' + card.badge + '</span>' +
            '<span class="text-[11px] text-stone-400 font-mono">' + card.readTime + '</span>' +
          '</div>' +
          '<div>' +
            '<h3 class="font-serif font-bold text-xl sm:text-2xl text-slatewarm-900 leading-snug">' + card.title + '</h3>' +
            '<h4 class="text-xs text-autumn-700 font-medium mt-0.5">' + card.subtitle + '</h4>' +
          '</div>' +
          '<div class="pt-2 border-t border-stone-200/60 leading-relaxed font-sans">' + card.contentHtml + '</div>' +
        '</article>';
      }).join('');
      if (typeof lucide !== 'undefined' && lucide.createIcons) lucide.createIcons();
    }

    function updateFlashcardUI() {
      var card = FLASHCARDS[currentFlashcardIndex];
      if (!card) return;

      var counterEl = document.getElementById('fc-counter');
      if (counterEl) counterEl.textContent = (currentFlashcardIndex + 1) + ' / ' + FLASHCARDS.length;

      var fc = document.getElementById('flashcard');
      if (fc) {
        fc.classList.toggle('flipped', isFlashcardFlipped);
      }

      document.getElementById('fc-word-front').textContent = card.front;
      document.getElementById('fc-ipa-front').textContent = card.ipa;
      document.getElementById('fc-badge-front').textContent = card.level + ' • Vocab';

      document.getElementById('fc-def-back').textContent = card.backDef;
      document.getElementById('fc-de-back').textContent = '🇩🇪 Deutsch: ' + card.de;
      document.getElementById('fc-quote-back').textContent = '“' + card.exampleQuote + '”';
      document.getElementById('fc-badge-back').textContent = card.level + ' • Practice';
    }

    function flipFlashcard() {
      isFlashcardFlipped = !isFlashcardFlipped;
      var fc = document.getElementById('flashcard');
      if (fc) fc.classList.toggle('flipped', isFlashcardFlipped);
    }

    function nextFlashcard() {
      isFlashcardFlipped = false;
      currentFlashcardIndex = (currentFlashcardIndex + 1) % FLASHCARDS.length;
      updateFlashcardUI();
    }

    function prevFlashcard() {
      isFlashcardFlipped = false;
      currentFlashcardIndex = (currentFlashcardIndex - 1 + FLASHCARDS.length) % FLASHCARDS.length;
      updateFlashcardUI();
    }

    function speakCurrentFlashcard() {
      var card = FLASHCARDS[currentFlashcardIndex];
      if (card) speakWord(card.front);
    }

    function renderIdiomGym() {
      var container = document.getElementById('idiom-gym-container');
      if (!container) return;
      container.innerHTML = IDIOM_CHALLENGES.map(function(item, idx) {
        var answered = idiomAnswers.hasOwnProperty(idx);
        var chosen = idiomAnswers[idx];

        var optHtml = item.options.map(function(opt, oIdx) {
          var btnClass = 'p-3 rounded-xl border text-xs font-semibold text-left transition ';
          if (!answered) {
            btnClass += 'border-stone-200 bg-white hover:bg-parchment-100 text-stone-800';
          } else {
            if (oIdx === item.correctIndex) {
              btnClass += 'border-sage-500 bg-sage-100 text-sage-900 font-bold';
            } else if (oIdx === chosen) {
              btnClass += 'border-red-400 bg-red-50 text-red-800';
            } else {
              btnClass += 'border-stone-200 bg-stone-50 text-stone-400 opacity-60';
            }
          }
          return '<button onclick="answerIdiom(' + idx + ', ' + oIdx + ')" ' + (answered ? 'disabled' : '') + ' class="' + btnClass + '">' + opt + '</button>';
        }).join('');

        return '<div class="sanctuary-subcard rounded-2xl p-5 space-y-3">' +
          '<div class="flex items-center justify-between text-xs font-mono">' +
            '<span class="font-bold text-autumn-800">Challenge ' + (idx + 1) + ': ' + item.title + '</span>' +
            '<span class="text-stone-400">🇩🇪 ' + item.de + '</span>' +
          '</div>' +
          '<p class="text-xs text-stone-700 leading-relaxed font-sans">' + item.scenario + '</p>' +
          '<div class="grid grid-cols-1 sm:grid-cols-2 gap-2 pt-1">' + optHtml + '</div>' +
          (answered ? '<div class="p-3 rounded-xl bg-sage-50 border border-sage-200 text-xs text-sage-900 leading-relaxed"><strong>Why this fits:</strong> ' + item.explanation + '</div>' : '') +
        '</div>';
      }).join('');
    }

    function answerIdiom(challengeIdx, optionIdx) {
      if (idiomAnswers.hasOwnProperty(challengeIdx)) return;
      idiomAnswers[challengeIdx] = optionIdx;
      if (optionIdx === IDIOM_CHALLENGES[challengeIdx].correctIndex) {
        if (typeof confetti === 'function') {
          confetti({ particleCount: 35, spread: 50, origin: { y: 0.8 } });
        }
      }
      renderIdiomGym();
    }

    function renderQuiz() {
      var container = document.getElementById('quiz-questions-container');
      if (!container) return;

      var answeredCount = Object.keys(quizAnswers).length;
      var correctCount = 0;
      Object.keys(quizAnswers).forEach(function(k) {
        if (quizAnswers[k] === QUIZ_QUESTIONS[k].correctIndex) correctCount++;
      });
      document.getElementById('quiz-score-badge').textContent = 'Score: ' + correctCount + ' / ' + QUIZ_QUESTIONS.length;

      container.innerHTML = QUIZ_QUESTIONS.map(function(q, qIdx) {
        var answered = quizAnswers.hasOwnProperty(qIdx);
        var chosen = quizAnswers[qIdx];

        var optHtml = q.options.map(function(opt, oIdx) {
          var btnClass = 'p-3 rounded-xl border text-xs text-left transition font-sans ';
          if (!answered) {
            btnClass += 'border-stone-200 bg-white hover:bg-parchment-100 text-stone-800';
          } else {
            if (oIdx === q.correctIndex) {
              btnClass += 'border-sage-500 bg-sage-100 text-sage-900 font-bold';
            } else if (oIdx === chosen) {
              btnClass += 'border-red-400 bg-red-50 text-red-800';
            } else {
              btnClass += 'border-stone-200 bg-stone-50 text-stone-400 opacity-60';
            }
          }
          return '<button onclick="answerQuiz(' + qIdx + ', ' + oIdx + ')" ' + (answered ? 'disabled' : '') + ' class="' + btnClass + '">' + opt + '</button>';
        }).join('');

        return '<div class="sanctuary-subcard rounded-2xl p-5 space-y-3">' +
          '<div class="flex items-center justify-between text-xs">' +
            '<span class="font-mono font-bold text-sage-800">Question ' + (qIdx + 1) + ' of ' + QUIZ_QUESTIONS.length + '</span>' +
          '</div>' +
          '<h3 class="font-serif font-bold text-base text-slatewarm-900">' + q.question + '</h3>' +
          '<div class="grid grid-cols-1 gap-2 pt-1">' + optHtml + '</div>' +
          (answered ? '<div class="p-3 rounded-xl bg-sage-50 border border-sage-200 text-xs text-sage-900 leading-relaxed font-sans"><strong>Explanation:</strong> ' + q.explanation + '</div>' : '') +
        '</div>';
      }).join('');
    }

    function answerQuiz(qIdx, oIdx) {
      if (quizAnswers.hasOwnProperty(qIdx)) return;
      quizAnswers[qIdx] = oIdx;
      if (oIdx === QUIZ_QUESTIONS[qIdx].correctIndex) {
        if (typeof confetti === 'function') {
          confetti({ particleCount: 45, spread: 60, origin: { y: 0.8 } });
        }
      }
      renderQuiz();
    }

    function renderReflections() {
      var container = document.getElementById('reflections-container');
      if (!container) return;
      container.innerHTML = REFLECTION_PROMPTS.map(function(ref, idx) {
        return '<div class="sanctuary-subcard rounded-2xl p-5 space-y-2.5 flex flex-col justify-between border-t-2 border-t-autumn-500">' +
          '<div class="space-y-2">' +
            '<div class="flex items-center justify-between text-[11px]">' +
              '<span class="font-mono font-bold text-autumn-800">Prompt 0' + (idx + 1) + '</span>' +
              '<span class="px-2 py-0.5 rounded bg-stone-100 text-stone-500 font-mono text-[10px]">' + ref.category + '</span>' +
            '</div>' +
            '<h4 class="font-serif font-bold text-base text-slatewarm-900">' + ref.title + '</h4>' +
            '<p class="text-xs text-stone-700 leading-relaxed font-sans">' + ref.prompt + '</p>' +
          '</div>' +
          '<div class="p-2.5 rounded-xl bg-parchment-100 border border-parchment-200 text-[11px] text-stone-600 font-mono">' +
            '💡 <strong>Prep Tip:</strong> ' + ref.prepAdvice +
          '</div>' +
        '</div>';
      }).join('');
    }

    // Audio Speech Synthesis
    function speakWord(word) {
      if (!('speechSynthesis' in window)) return;
      window.speechSynthesis.cancel();
      var u = new SpeechSynthesisUtterance(word);
      u.lang = 'en-GB';
      u.rate = currentVoiceRate;
      window.speechSynthesis.speak(u);
    }

    function speakText(text, lang) {
      if (!('speechSynthesis' in window)) return;
      window.speechSynthesis.cancel();
      var u = new SpeechSynthesisUtterance(text);
      u.lang = lang || 'en-GB';
      u.rate = currentVoiceRate;
      window.speechSynthesis.speak(u);
    }

    function setVoiceRate(rate) {
      currentVoiceRate = rate;
      var btnSlow = document.getElementById('rate-slow');
      var btnNormal = document.getElementById('rate-normal');
      if (rate === 0.85) {
        if (btnSlow) btnSlow.className = 'px-1.5 py-0.5 rounded-md text-[11px] bg-sage-600 text-white font-semibold transition';
        if (btnNormal) btnNormal.className = 'px-1.5 py-0.5 rounded-md text-[11px] text-stone-600 hover:bg-parchment-100 transition';
      } else {
        if (btnSlow) btnSlow.className = 'px-1.5 py-0.5 rounded-md text-[11px] text-stone-600 hover:bg-parchment-100 transition';
        if (btnNormal) btnNormal.className = 'px-1.5 py-0.5 rounded-md text-[11px] bg-sage-600 text-white font-semibold transition';
      }
    }

    // Web Audio API Soundscape Synthesizer
    var audioCtx = null;
    var soundscapeSource = null;
    var soundscapeGain = null;
    var isSoundscapePlaying = false;
    var currentSoundscapePreset = 'breeze';

    function initAudioContext() {
      if (!audioCtx) {
        var AudioContextClass = window.AudioContext || window.webkitAudioContext;
        audioCtx = new AudioContextClass();
      }
      if (audioCtx.state === 'suspended') {
        audioCtx.resume();
      }
    }

    function createPinkNoiseNode() {
      var bufferSize = audioCtx.sampleRate * 2;
      var buffer = audioCtx.createBuffer(1, bufferSize, audioCtx.sampleRate);
      var output = buffer.getChannelData(0);
      var b0 = 0, b1 = 0, b2 = 0, b3 = 0, b4 = 0, b5 = 0, b6 = 0;
      for (var i = 0; i < bufferSize; i++) {
        var white = Math.random() * 2 - 1;
        b0 = 0.99886 * b0 + white * 0.0555179;
        b1 = 0.99332 * b1 + white * 0.0750759;
        b2 = 0.96900 * b2 + white * 0.1538520;
        b3 = 0.86650 * b3 + white * 0.3104856;
        b4 = 0.55000 * b4 + white * 0.5329522;
        b5 = -0.7616 * b5 - white * 0.0168980;
        output[i] = b0 + b1 + b2 + b3 + b4 + b5 + b6 + white * 0.5362;
        output[i] *= 0.11;
        b6 = white * 0.115926;
      }
      var whiteNoise = audioCtx.createBufferSource();
      whiteNoise.buffer = buffer;
      whiteNoise.loop = true;
      return whiteNoise;
    }

    function startSoundscape() {
      initAudioContext();
      if (soundscapeSource) {
        try { soundscapeSource.stop(); } catch(e) {}
      }

      soundscapeSource = createPinkNoiseNode();
      soundscapeGain = audioCtx.createGain();
      var filter = audioCtx.createBiquadFilter();

      if (currentSoundscapePreset === 'rain') {
        filter.type = 'lowpass';
        filter.frequency.value = 1100;
        soundscapeGain.gain.value = 0.25;
      } else if (currentSoundscapePreset === 'study') {
        filter.type = 'lowpass';
        filter.frequency.value = 450;
        soundscapeGain.gain.value = 0.28;
      } else {
        filter.type = 'lowpass';
        filter.frequency.value = 650;
        soundscapeGain.gain.value = 0.22;
      }

      soundscapeSource.connect(filter);
      filter.connect(soundscapeGain);
      soundscapeGain.connect(audioCtx.destination);
      soundscapeSource.start();
      isSoundscapePlaying = true;

      var label = document.getElementById('soundscape-label');
      if (label) label.textContent = 'Autumn Breeze: Playing';
      var icon = document.getElementById('soundscape-icon');
      if (icon) icon.className = 'w-3.5 h-3.5 text-sage-600 animate-pulse';
    }

    function stopSoundscape() {
      if (soundscapeSource) {
        try { soundscapeSource.stop(); } catch(e) {}
        soundscapeSource = null;
      }
      isSoundscapePlaying = false;
      var label = document.getElementById('soundscape-label');
      if (label) label.textContent = 'Autumn Breeze: Off';
      var icon = document.getElementById('soundscape-icon');
      if (icon) icon.className = 'w-3.5 h-3.5 text-autumn-600';
    }

    function toggleSoundscape() {
      if (isSoundscapePlaying) {
        stopSoundscape();
      } else {
        startSoundscape();
      }
    }

    function changeSoundscapePreset(preset) {
      currentSoundscapePreset = preset;
      if (isSoundscapePlaying) {
        stopSoundscape();
        startSoundscape();
      }
    }

    function updateSoundscapeVolume(val) {
      if (soundscapeGain && audioCtx) {
        soundscapeGain.gain.setValueAtTime(parseFloat(val), audioCtx.currentTime);
      }
    }

    // HTML5 Canvas Falling Autumn Leaves Animation
    var leafMode = 'gentle';
    var canvas, ctx, animFrameId;
    var leaves = [];

    function initLeafCanvas() {
      canvas = document.getElementById('autumn-breeze-canvas');
      if (!canvas) return;
      ctx = canvas.getContext('2d');

      function resize() {
        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;
      }
      window.addEventListener('resize', resize);
      resize();

      leaves = [];
      var leafCount = 28;
      var colors = ['#be6f38', '#d38c57', '#e2b086', '#5b826f', '#cadad1'];

      for (var i = 0; i < leafCount; i++) {
        leaves.push({
          x: Math.random() * canvas.width,
          y: Math.random() * canvas.height,
          size: Math.random() * 8 + 6,
          speedY: Math.random() * 0.8 + 0.4,
          speedX: Math.random() * 0.6 - 0.2,
          rot: Math.random() * 360,
          rotSpeed: Math.random() * 1.5 - 0.75,
          color: colors[Math.floor(Math.random() * colors.length)],
          alpha: Math.random() * 0.45 + 0.25
        });
      }

      animateLeaves();
    }

    function animateLeaves() {
      if (!ctx || !canvas) return;
      ctx.clearRect(0, 0, canvas.width, canvas.height);

      if (leafMode !== 'off') {
        leaves.forEach(function(leaf) {
          ctx.save();
          ctx.translate(leaf.x, leaf.y);
          ctx.rotate((leaf.rot * Math.PI) / 180);
          ctx.fillStyle = leaf.color;
          ctx.globalAlpha = leaf.alpha;
          
          ctx.beginPath();
          ctx.moveTo(0, -leaf.size);
          ctx.quadraticCurveTo(leaf.size * 0.8, 0, 0, leaf.size);
          ctx.quadraticCurveTo(-leaf.size * 0.8, 0, 0, -leaf.size);
          ctx.fill();
          ctx.restore();

          var mult = leafMode === 'breeze' ? 2.2 : 1.0;
          leaf.y += leaf.speedY * mult;
          leaf.x += leaf.speedX * mult;
          leaf.rot += leaf.rotSpeed * mult;

          if (leaf.y > canvas.height + 20) {
            leaf.y = -20;
            leaf.x = Math.random() * canvas.width;
          }
          if (leaf.x > canvas.width + 20) leaf.x = -20;
          if (leaf.x < -20) leaf.x = canvas.width + 20;
        });
      }

      animFrameId = requestAnimationFrame(animateLeaves);
    }

    function cycleLeafBreeze() {
      var label = document.getElementById('leaves-label');
      if (leafMode === 'gentle') {
        leafMode = 'breeze';
        if (label) label.textContent = 'Leaves: Breeze';
      } else if (leafMode === 'breeze') {
        leafMode = 'off';
        if (label) label.textContent = 'Leaves: Still (Off)';
      } else {
        leafMode = 'gentle';
        if (label) label.textContent = 'Leaves: Gentle';
      }
    }

    function setThemeMood(theme) {
      document.body.setAttribute('data-theme', theme);
      ['kensington', 'winchester', 'twilight'].forEach(function(t) {
        var btn = document.getElementById('theme-' + t);
        if (btn) {
          if (t === theme) {
            btn.className = 'px-2 py-0.5 rounded-lg bg-autumn-100 text-autumn-800 font-semibold transition';
          } else {
            btn.className = 'px-2 py-0.5 rounded-lg text-stone-600 hover:text-stone-900 transition';
          }
        }
      });
    }

    function copyPreplySummary() {
      var summaryText = 
        "🌿 Louie's English Studio - Lesson Notes (24 Oct 2026)\n" +
        "Student: Clemens B. | Tutor: Louie\n\n" +
        "✨ Topics Covered Today:\n" +
        "• Mallorca Sun & Turquoise Waters vs Grey Berlin Autumn\n" +
        "• Overcoming Denglish sentence patterns & large-class hesitation\n" +
        "• Aerodynamics: Gliders, angle of attack, altitude & thermals\n" +
        "• Cue sports (pool/billiards), cricket wickets & long-distance running\n" +
        "• Abstract thought: Illusions, nostalgia, elder wisdom & positive peer pressure\n" +
        "• Jargon vs Bavarian colloquialisms ('Servus', 'for ages')\n" +
        "• Erich Maria Remarque's 'All Quiet on the Western Front' vs Paul Verhoeven's 'Starship Troopers' (Satirical parody)\n" +
        "• Abitur Exam Strategy: Writing an outline & comment, delivering an elevator pitch\n\n" +
        "🌟 6 Natural Strengths Celebrated & 6 Gentle Phrasing Polishes\n" +
        "🎯 Homework: Watch Starship Troopers & draft a 45-second elevator pitch outline for next class!\n\n" +
        "Explore your full interactive sanctuary notes, audio pronunciations, and flashcards on GitHub Pages!";

      navigator.clipboard.writeText(summaryText).then(function() {
        alert('✨ Preply lesson summary copied to your clipboard!');
      }).catch(function() {
        alert('Could not copy automatically. Please copy the text from the notes tab.');
      });
    }

    // Isolated Error Boundary safeRender helper
    function safeRender(name, renderFn, containerId) {
      try {
        renderFn();
      } catch (err) {
        console.error('Error rendering ' + name + ':', err);
        var el = document.getElementById(containerId);
        if (el) {
          el.innerHTML = '<div class="p-6 bg-autumn-50 border border-autumn-200 rounded-2xl text-autumn-800 text-sm">' +
            '<p class="font-bold mb-1">Notice: ' + name + ' is updating...</p>' +
            '<p class="text-xs text-autumn-600">' + err.message + '</p>' +
          '</div>';
        }
      }
    }

    // Startup DOM Listener
    window.addEventListener('DOMContentLoaded', function() {
      safeRender('Transcript', renderTranscript, 'transcript-turns-container');
      safeRender('Vocabulary Dictionary', renderVocabGrid, 'vocab-cards-grid');
      safeRender('Natural Strengths', renderStrengths, 'strengths-container');
      safeRender('Phrasing Polishes', renderPhrasing, 'phrasing-container');
      safeRender('ASR Fixes Log', renderAsrFixes, 'asr-fixes-container');
      safeRender('Editorial Topics', renderEditorialTopics, 'editorial-cards-container');
      safeRender('Flashcards', updateFlashcardUI, 'flashcard');
      safeRender('Idiom Gym', renderIdiomGym, 'idiom-gym-container');
      safeRender('Context Quiz', renderQuiz, 'quiz-questions-container');
      safeRender('Reflections', renderReflections, 'reflections-container');

      try { initLeafCanvas(); } catch (e) { console.warn(e); }
      try {
        var firstKey = Object.keys(VOCAB_DB)[0];
        if (firstKey) inspectVocab(firstKey);
      } catch (e) { console.warn(e); }

      try {
        if (typeof lucide !== 'undefined' && lucide.createIcons) {
          lucide.createIcons();
        }
      } catch (e) { console.warn(e); }
    });
  </script>
</body>
</html>
'@

# Assemble full document cleanly
$fullHtml = $htmlMarkup + "`n" + $jsPrefix + $vocabDbBlock + $jsMid1 + $asrFixesBlock + $jsMid2 + $naturalStrengthsBlock + $jsMid3 + $phrasingPolishesBlock + $jsMid4 + $transcriptTurnsBlock + $jsMid5 + $editorialTopicsBlock + $jsMid6 + $flashcardsBlock + $jsMid7 + $idiomChallengesBlock + $jsMid8 + $quizQuestionsBlock + $jsMid9 + $reflectionPromptsBlock + $jsSuffix

Write-Host "Writing index.html and lesson_10-24-2026.html with UTF-8 without BOM..."

[System.IO.File]::WriteAllText("d:\Documents\Clemens B\index.html", $fullHtml, [System.Text.UTF8Encoding]::new($false))
[System.IO.File]::WriteAllText("d:\Documents\Clemens B\lesson_10-24-2026.html", $fullHtml, [System.Text.UTF8Encoding]::new($false))

Write-Host "Success! Generated clean index.html and lesson_10-24-2026.html"
Write-Host "index.html file size: $((Get-Item 'd:\Documents\Clemens B\index.html').Length) bytes"
Write-Host "lesson_10-24-2026.html file size: $((Get-Item 'd:\Documents\Clemens B\lesson_10-24-2026.html').Length) bytes"
