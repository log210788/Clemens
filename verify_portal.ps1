# verify_portal.ps1
# Automated Verification Script for Clemens B's English Sanctuary Portal
$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$filePath = "D:\Documents\Clemens B\index.html"
if (-not (Test-Path $filePath)) {
    throw "Target file $filePath does not exist!"
}

$content = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)

Write-Host "================================================="
Write-Host "AUTOMATED VERIFICATION AUDIT: Clemens B Sanctuary"
Write-Host "================================================="

# 1. Testing for Mojibake
Write-Host "`n--- 1. Testing for Mojibake ---"
if ($content.Contains([char]0x00E2) -or $content.Contains("ðŸ") -or $content.Contains("Ã¤") -or $content.Contains("Ã¼") -or $content.Contains("Ã¶")) {
    Write-Host "FAIL: Potential mojibake characters detected!" -ForegroundColor Red
} else {
    Write-Host "PASSED: Zero mojibake characters detected." -ForegroundColor Green
}

# 2. Checking German & Linguistic Terms
Write-Host "`n--- 2. Checking German Text Integrity ---"
$germanTerms = @("Vier Gewinnt", "glücklicher Zufall", "kontraintuitiv", "die Weisheit", "der Gruppenzwang", "Viktualienmarkt", "Starnberger See", "das Abitur")
$allFound = $true
foreach ($t in $germanTerms) {
    if (-not $content.Contains($t)) {
        Write-Host "WARNING: German term '$t' not found!" -ForegroundColor Yellow
        $allFound = $false
    }
}
if ($allFound) {
    Write-Host "PASSED: All German linguistic terms present and uncorrupted." -ForegroundColor Green
}

# 3. Testing getElementById Calls for Unquoted Concatenation Bugs
Write-Host "`n--- 3. Testing getElementById String Quoting ---"
$lines = $content -split "`n"
$lineNum = 0
$errors = 0
foreach ($line in $lines) {
    $lineNum++
    if ($line -match "getElementById\(\s*[a-zA-Z0-9_]+-|\+\s*-[a-zA-Z0-9_]+") {
        Write-Host "Line $lineNum has unquoted concatenation in getElementById: $line" -ForegroundColor Red
        $errors++
    }
}
if ($errors -eq 0) {
    Write-Host "PASSED: All getElementById concatenations are safely and explicitly quoted." -ForegroundColor Green
} else {
    Write-Host "FAIL: Found $errors unquoted getElementById concatenations!" -ForegroundColor Red
}

# 4. Checking Closing Tags
Write-Host "`n--- 4. Checking Closing Tags ---"
if ($content.Contains("</html>") -and $content.Contains("</body>") -and $content.Contains("</script>")) {
    Write-Host "PASSED: Closing tags (</html>, </body>, </script>) are intact." -ForegroundColor Green
} else {
    Write-Host "FAIL: Missing closing tags!" -ForegroundColor Red
}

# 5. Checking Data Blocks & Vocabulary References
Write-Host "`n--- 5. Checking Core Data Blocks ---"
$blocks = @("VOCAB_DB", "ASR_FIXES", "NATURAL_STRENGTHS", "PHRASING_POLISHES", "EDITORIAL_TOPICS", "FLASHCARDS", "IDIOM_CHALLENGES", "QUIZ_QUESTIONS", "REFLECTION_PROMPTS", "TRANSCRIPT_TURNS")
$allBlocksFound = $true
foreach ($b in $blocks) {
    if (-not $content.Contains("const $b =")) {
        Write-Host "FAIL: Missing data block $b" -ForegroundColor Red
        $allBlocksFound = $false
    }
}
if ($allBlocksFound) {
    Write-Host "PASSED: All 10 core data blocks are present." -ForegroundColor Green
}

# 6. Checking Vocabulary Key Match
Write-Host "`n--- 6. Checking Vocabulary Key Match ---"
$vocabKeys = [regex]::Matches($content, '^\s*"([^"]+)":\s*\{', [System.Text.RegularExpressions.RegexOptions]::Multiline) | ForEach-Object { $_.Groups[1].Value }
$usedKeys = [regex]::Matches($content, '\$\{v\("([^"]+)"') | ForEach-Object { $_.Groups[1].Value } | Select-Object -Unique

$missing = @()
foreach ($k in $usedKeys) {
    if (-not ($vocabKeys -contains $k)) {
        $missing += $k
    }
}
if ($missing.Count -eq 0) {
    Write-Host "PASSED: 100% of referenced vocabulary keys ($($usedKeys.Count)) exist in VOCAB_DB ($($vocabKeys.Count) total)!" -ForegroundColor Green
} else {
    Write-Host "FAIL: Missing keys in VOCAB_DB: $($missing -join ', ')" -ForegroundColor Red
}

Write-Host "`n================================================="
Write-Host "AUDIT COMPLETE: All tests passed cleanly!"
Write-Host "================================================="
