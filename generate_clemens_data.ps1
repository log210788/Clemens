# generate_clemens_data.ps1
# Generates lesson_data.js for Clemens B (Lesson: 24 October 2026)
$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "Compiling curated lesson data for Clemens B..."

$rawLines = [System.IO.File]::ReadAllLines("D:\Documents\Clemens B\Transcripts\10-24-2026.txt", [System.Text.Encoding]::UTF8)

# 1. Parse raw turns
$rawTurns = @()
$cSpk = ""
$cTime = ""
$cSb = [System.Text.StringBuilder]::new()

for ($i = 0; $i -lt $rawLines.Count; $i++) {
    $line = $rawLines[$i]
    if ($line -match "^(Lewis|Verena)\s*\|\s*(\d{2}:\d{2})") {
        if ($cSpk -ne "") {
            $rawTurns += [PSCustomObject]@{
                Speaker = $cSpk
                Time = $cTime
                Text = $cSb.ToString().Trim()
            }
            $cSb.Clear() | Out-Null
        }
        $cSpk = $matches[1]
        $cTime = $matches[2]
    } else {
        if ($cSpk -ne "") {
            $cSb.AppendLine($line) | Out-Null
        }
    }
}
if ($cSpk -ne "") {
    $rawTurns += [PSCustomObject]@{
        Speaker = $cSpk
        Time = $cTime
        Text = $cSb.ToString().Trim()
    }
}

Write-Host "Parsed $($rawTurns.Count) raw turns."

$bt = [char]96 # Backtick character

# Build JavaScript code
$sb = [System.Text.StringBuilder]::new()

$sb.AppendLine(@'
// =============================================================================
// LESSON DATA: Clemens B • 24 October 2026
// Tutor: Louie (Lewis O'Shea) | Student: Clemens B | Parent: Verena
// Topics: Mallorca Sun vs Berlin Grey, Aerodynamics, Remarque vs Starship Troopers
// =============================================================================
'@) | Out-Null

# Write VOCAB_DB
$sb.AppendLine("const VOCAB_DB = {") | Out-Null

$vocabItems = @(
  @{ key='serendipity'; word='serendipity'; ipa='/ˌser.ənˈdɪp.ə.ti/'; pos='noun'; level='C2'; time='07:11'; turnId='turn-60'; cat='culture-thought'; def='Finding valuable, pleasant, or fortunate things entirely by happy chance.'; quote='Louie (07:11): "It will already pick up the words, like serendipity—luck by happy chance."'; de='glücklicher Zufall / die Serendipität' },
  @{ key='unwind'; word='unwind'; ipa='/ʌnˈwaɪnd/'; pos='verb'; level='B2'; time='09:19'; turnId='turn-61'; cat='lifestyle'; def='To relax, destress, and let go of tension after intensive work or study.'; quote='Clemens (09:19): "Unwind." Louie: "And also the pronunciation—relaxing after a busy day."'; de='entspannen / abschalten' },
  @{ key='counterintuitive'; word='counterintuitive'; ipa='/ˌkaʊn.tər.ɪnˈtjuː.ɪ.tɪv/'; pos='adjective'; level='C1'; time='03:55'; turnId='turn-44'; cat='language-learning'; def='Contrary to what common sense or initial intuition would suggest.'; quote='Louie (03:55): "However, it is not that difficult; it is counterintuitive—the English ear listens for stressed syllables."'; de='kontraintuitiv / der Intuition widersprechend' },
  @{ key='stress-rhythm'; word='stress rhythm'; ipa='/stres ˈrɪð.əm/'; pos='noun'; level='B2'; time='03:55'; turnId='turn-44'; cat='language-learning'; def='The natural rhythmic pulse of speech created by alternating stressed and unstressed syllables.'; quote='Louie (03:55): "So the English ear, we hear for what is stressed, because we stress words."'; de='der Betonungsrhythmus / die Sprachmelodie' },
  @{ key='annotate'; word='annotate'; ipa='/ˈæn.ə.teɪt/'; pos='verb'; level='B2'; time='03:55'; turnId='turn-44'; cat='language-learning'; def='To add explanatory notes, critical commentary, or structural labels to a text.'; quote='Louie (03:55): "It is writing—it is annotating what we say so you can review key vocabulary afterwards."'; de='kommentieren / mit Anmerkungen versehen' },
  @{ key='turquoise'; word='turquoise'; ipa='/ˈtɜː.kwɔɪz/'; pos='adjective'; level='B2'; time='01:23'; turnId='turn-28'; cat='travel-nature'; def='A striking, clear greenish-blue colour characteristic of clean Mediterranean waters.'; quote='Clemens (01:23): "...and we got this turquoise water and Mediterranean sun in Mallorca."'; de='türkis / türkisblau' },
  @{ key='paragliding'; word='paragliding'; ipa='/ˈpær.əˌɡlaɪ.dɪŋ/'; pos='noun'; level='B2'; time='11:50'; turnId='turn-76'; cat='sports-physics'; def='The recreational and competitive adventure sport of flying lightweight, free-flying foot-launched gliders.'; quote='Louie (11:50): "Paragliding—you jump from a mountain and glide through the open sky."'; de='das Gleitschirmfliegen' },
  @{ key='glider'; word='glider'; ipa='/ˈɡlaɪ.dər/'; pos='noun'; level='B2'; time='12:19'; turnId='turn-78'; cat='sports-physics'; def='An unpowered aircraft or airfoil designed to fly through the air on aerodynamic lift.'; quote='Clemens (12:19): "It is like a pretty big wing that can glide through the air."'; de='das Segelflugzeug / der Gleiter' },
  @{ key='altitude'; word='altitude'; ipa='/ˈæl.tɪ.tjuːd/'; pos='noun'; level='B2'; time='12:45'; turnId='turn-85'; cat='sports-physics'; def='The vertical elevation or height of an object above sea level or the ground.'; quote='Clemens (12:45): "Altitude." Louie: "Good. And how do we actually increase altitude while flying?"'; de='die Höhe / Flughöhe' },
  @{ key='angle-of-attack'; word='angle of attack'; ipa='/ˈæŋ.ɡəl əv əˈtæk/'; pos='noun'; level='C1'; time='12:57'; turnId='turn-87'; cat='sports-physics'; def='The angle between a wing reference chord line and the direction of the oncoming airflow.'; quote='Clemens (12:57): "I think we increase the angle the glider is in the wind."'; de='der Anstellwinkel' },
  @{ key='thermal'; word='thermal'; ipa='/ˈθɜː.məl/'; pos='noun'; level='C1'; time='13:03'; turnId='turn-88'; cat='sports-physics'; def='An upward current of warm, rising air produced by heated terrain, used by gliders to gain height.'; quote='Louie (13:03): "Thermals is heat—warm air that rises off trees and heated ground."'; de='die Thermik / der Aufwind' },
  @{ key='cue-sport'; word='cue sport'; ipa='/kjuː spɔːt/'; pos='noun'; level='B2'; time='15:07'; turnId='turn-100'; cat='sports-physics'; def='A wide variety of games of skill played on a cloth-covered table using a cue stick, such as pool or billiards.'; quote='Louie (15:07): "With a cue stick—the English word is pool or billiards."'; de='der Billardsport' },
  @{ key='billiards'; word='billiards'; ipa='/ˈbɪl.jədz/'; pos='noun'; level='B2'; time='15:09'; turnId='turn-101'; cat='sports-physics'; def='A traditional indoor game played on a baize-covered table with balls struck by a long cue stick.'; quote='Clemens (15:09): "Billiards... sometimes when we are on holiday, there are tables and we love to play."'; de='das Billard' },
  @{ key='wicket'; word='wicket'; ipa='/ˈwɪk.ɪt/'; pos='noun'; level='B2'; time='14:13'; turnId='turn-94'; cat='sports-physics'; def='A set of three wooden stumps topped by two bails in the sport of cricket.'; quote='Louie (14:13): "A wicket—these are the wooden stumps you have to defend or hit with a ball."'; de='das Wicket / die Schlaghölzer' },
  @{ key='cricket-bat'; word='cricket bat'; ipa='/ˈkrɪk.ɪt bæt/'; pos='noun'; level='B2'; time='18:16'; turnId='turn-134'; cat='sports-physics'; def='A flat wooden blade made of willow used by batsmen in cricket to strike the ball.'; quote='Louie (18:16): "A bat—the cricket bat, the flat wooden blade you swing."'; de='der Cricketschläger' },
  @{ key='dentistry'; word='dentistry'; ipa='/ˈden.tɪ.stri/'; pos='noun'; level='B2'; time='21:12'; turnId='turn-147'; cat='culture-thought'; def='The branch of medicine devoted to the diagnosis, treatment, and care of the teeth and oral cavity.'; quote='Clemens (21:12): "He is 19... he studies dentistry at university."'; de='die Zahnmedizin' },
  @{ key='dentures'; word='dentures'; ipa='/ˈden.tʃəz/'; pos='noun'; level='B2'; time='23:34'; turnId='turn-172'; cat='culture-thought'; def='A removable artificial replacement for one or more missing natural teeth.'; quote='Louie (23:34): "A very old person has dentures? Artificial false teeth?"'; de='die Zahnprothese / das Gebiss' },
  @{ key='optical-illusion'; word='optical illusion'; ipa='/ˈɒp.tɪ.kəl ɪˈluː.ʒən/'; pos='noun'; level='B2'; time='22:46'; turnId='turn-162'; cat='abstract-philosophy'; def='A visually perceived image or phenomenon that deceives the eye and brain into seeing what is not physically there.'; quote='Clemens (22:46): "When you see something that is not actually there... an illusion."'; de='die optische Täuschung' },
  @{ key='nostalgia'; word='nostalgia'; ipa='/nɒsˈtæl.dʒə/'; pos='noun'; level='C1'; time='23:12'; turnId='turn-168'; cat='abstract-philosophy'; def='A sentimental longing or affectionate wistfulness for a period, feeling, or place in the past.'; quote='Clemens (23:12): "If you see something you were used to seeing as a child and it brings back warm feelings... nostalgia."'; de='die Nostalgie / die Wehmut' },
  @{ key='wisdom'; word='wisdom'; ipa='/ˈwɪz.dəm/'; pos='noun'; level='C1'; time='23:50'; turnId='turn-177'; cat='abstract-philosophy'; def='The quality of having deep experience, mature knowledge, and the sound judgment to discern the right path.'; quote='Clemens (23:50): "He has a lot of experience and knows the right path... wisdom."'; de='die Weisheit / die Lebenserfahrung' },
  @{ key='peer-pressure'; word='peer pressure'; ipa='/ˈpɪə ˌpreʃ.ər/'; pos='noun'; level='B2'; time='25:17'; turnId='turn-194'; cat='abstract-philosophy'; def='The psychological or social influence exerted by a peer group encouraging one to change their attitudes or behavior to conform.'; quote='Louie (25:17): "Peer pressure—friends who try to convince or push you to do something."'; de='der Gruppenzwang / der soziale Druck' },
  @{ key='underestimate'; word='underestimate'; ipa='/ˌʌn.dərˈes.tɪ.meɪt/'; pos='verb'; level='B2'; time='26:52'; turnId='turn-204'; cat='abstract-philosophy'; def='To rate, judge, or value someone or something below their true ability or worth.'; quote='Louie (26:52): "Maybe we underestimate ourselves, and good friends see what we are truly capable of."'; de='unterschätzen' },
  @{ key='self-conscious'; word='self-conscious'; ipa='/ˌselfˈkɒn.ʃəs/'; pos='adjective'; level='B2'; time='26:09'; turnId='turn-201'; cat='abstract-philosophy'; def='Feeling uncomfortably aware of one own appearance, behavior, or manner in front of others.'; quote='Louie & Clemens (26:09): "Gently noting the difference between feeling self-conscious (shy) vs self-confident (assured)."'; de='verlegen / gehemmt (vs. selbstbewusst)' },
  @{ key='self-confident'; word='self-confident'; ipa='/ˌselfˈkɒn.fɪ.dənt/'; pos='adjective'; level='B2'; time='26:09'; turnId='turn-201'; cat='abstract-philosophy'; def='Trusting in one own abilities, qualities, and judgment with inner certainty.'; quote='Louie (26:09): "When you are self-assured, you believe you can achieve the challenge."'; de='selbstbewusst / selbstsicher' },
  @{ key='jargon'; word='jargon'; ipa='/ˈdʒɑː.ɡən/'; pos='noun'; level='C1'; time='32:21'; turnId='turn-226'; cat='language-learning'; def='Specialized terminology, vocabulary, or idioms characteristic of a specific profession, trade, or subject.'; quote='Louie (32:21): "Terminology is like jargon—the insider words we use in particular fields."'; de='der Fachjargon / das Fachchinesisch' },
  @{ key='terminology'; word='terminology'; ipa='/ˌtɜː.mɪˈnɒl.ə.dʒi/'; pos='noun'; level='C1'; time='31:14'; turnId='turn-222'; cat='language-learning'; def='The technical vocabulary or body of terms used with particular meanings in a science, art, or discipline.'; quote='Clemens (31:14): "Terminology... I know the general direction, but need the exact words."'; de='die Terminologie / die Fachbegriffe' },
  @{ key='colloquial'; word='colloquial'; ipa='/kəˈləʊ.kwi.əl/'; pos='adjective'; level='C1'; time='34:02'; turnId='turn-228'; cat='language-learning'; def='Pertaining to everyday, familiar informal speech and conversation rather than formal literary prose.'; quote='Louie (34:02): "Colloquial words are the words native speakers actually use in natural daily conversation."'; de='umgangssprachlich / salopp' },
  @{ key='for-ages'; word='for ages'; ipa='/fər ˈeɪ.dʒɪz/'; pos='idiom'; level='B2'; time='34:31'; turnId='turn-232'; cat='language-idioms'; def='Informal British idiom meaning for an extremely long period of time.'; quote='Louie (34:31): "We say, \"I have not seen you for ages!\"—meaning a very long time."'; de='schon ewig / seit einer halben Ewigkeit' },
  @{ key='servus'; word='Servus'; ipa='/ˈzɛr.vuːs/'; pos='interjection'; level='B2'; time='34:14'; turnId='turn-230'; cat='culture-thought'; def='A traditional Bavarian and Austrian greeting meaning both hello and goodbye, rooted in Latin servus (at your service).'; quote='Louie (34:14): "In Bavaria they say \"Servus\" for hello or goodbye—it is wonderfully colloquial."'; de='Servus (bayerische Begrüßung)' },
  @{ key='all-quiet-on-the-western-front'; word='All Quiet on the Western Front'; ipa='/ɔːl ˈkwaɪ.ət ɒn ðə ˈwes.tən frʌnt/'; pos='proper'; level='B2'; time='36:02'; turnId='turn-239'; cat='literature-cinema'; def='Erich Maria Remarque landmark 1929 anti-war novel (Im Westen nichts Neues) and its 2022 film adaptation.'; quote='Clemens (36:02): "All Quiet on the Western Front... we read the book in school, and the film was epic."'; de='Im Westen nichts Neues' },
  @{ key='synopsis'; word='synopsis'; ipa='/sɪˈnɒp.sɪs/'; pos='noun'; level='C1'; time='40:00'; turnId='turn-262'; cat='literature-cinema'; def='A concise summary or general overview giving a clear, structured view of a narrative or academic work.'; quote='Louie (40:00): "Your synopsis—your analysis and views on this film are fantastic."'; de='die Zusammenfassung / der Überblick' },
  @{ key='epic'; word='epic'; ipa='/ˈep.ɪk/'; pos='adjective'; level='B2'; time='37:32'; turnId='turn-254'; cat='literature-cinema'; def='Heroic, grand in scale, imposing, or possessing monumental cinematic production value.'; quote='Louie (37:32): "This film is epic—a huge cinematic work whose production value is immense."'; de='monumental / episch' },
  @{ key='production-value'; word='production value'; ipa='/prəˈdʌk.ʃən ˌvæl.juː/'; pos='noun'; level='C1'; time='37:40'; turnId='turn-256'; cat='literature-cinema'; def='The combined technical and artistic quality of a film, play, or broadcast (cinematography, set design, audio, VFX).'; quote='Louie (37:40): "The production value is immense—the sound design, lighting, and gritty realism."'; de='der Produktionsaufwand / die Produktionsqualität' },
  @{ key='soldier-perspective'; word='soldier perspective'; ipa='/ˈsəʊl.dʒər pəˈspek.tɪv/'; pos='noun'; level='B2'; time='37:56'; turnId='turn-257'; cat='literature-cinema'; def='Experiencing events directly through the psychological and visceral viewpoint of an ordinary frontline combatant.'; quote='Clemens (37:56): "It puts you in the perspective of the young German soldier in the trenches."'; de='die Soldatenperspektive' },
  @{ key='trench-warfare'; word='trench warfare'; ipa='/ˈtrentʃ ˌwɔː.feər/'; pos='noun'; level='B2'; time='38:49'; turnId='turn-259'; cat='literature-cinema'; def='A type of combat in which opposing armed forces attack, counterattack, and defend from permanent systems of dug trenches.'; quote='Clemens (38:49): "The brutal conditions in the trenches on the Western Front... completely exhausting."'; de='der Grabenkrieg' },
  @{ key='purging'; word='purging'; ipa='/ˈpɜː.dʒɪŋ/'; pos='noun'; level='C2'; time='40:00'; turnId='turn-262'; cat='literature-cinema'; def='The forceful, ruthless removal, cleansing, or elimination of people or things deemed undesirable.'; quote='Louie (40:00): "Purging is to remove completely—in war, mercilessly expelling or slaughtering people."'; de='die Säuberung / das Ausmerzen' },
  @{ key='struck-me'; word='struck me'; ipa='/strʌk miː/'; pos='idiom'; level='B2'; time='42:36'; turnId='turn-269'; cat='culture-thought'; def='Made a deep, powerful emotional or psychological impression upon someone.'; quote='Clemens (42:36): "It really struck me emotionally—and it is always a good sign if a film moves you that way."'; de='hat mich tief berührt / ergriffen' },
  @{ key='parody'; word='parody'; ipa='/ˈpær.ə.di/'; pos='noun'; level='C1'; time='43:02'; turnId='turn-272'; cat='literature-cinema'; def='A deliberate humorous or satirical imitation of a serious piece of literature, art, film, or style to ridicule or comment upon it.'; quote='Louie (43:02): "Parody is when you mimic a genre or serious work to expose its absurdities."'; de='die Parodie / die Persiflage' },
  @{ key='satirical'; word='satirical'; ipa='/səˈtɪr.ɪ.kəl/'; pos='adjective'; level='C1'; time='48:13'; turnId='turn-292'; cat='literature-cinema'; def='Using humor, irony, exaggeration, or ridicule to expose and criticize human foolishness, corruption, or propaganda.'; quote='Louie (48:13): "Starship Troopers is satirical—it mimics wartime propaganda to criticize military fanaticism."'; de='satirisch / spöttisch' },
  @{ key='tongue-in-cheek'; word='tongue-in-cheek'; ipa='/ˌtʌŋ ɪn ˈtʃiːk/'; pos='idiom'; level='C1'; time='48:13'; turnId='turn-292'; cat='language-idioms'; def='Speaking or acting with insincere seriousness; ironic, slyly humorous, and not meant to be taken literally.'; quote='Louie (48:13): "It is satirical, tongue-in-cheek—it likes to poke fun at jingoistic military bravado."'; de='mit einem Augenzwinkern / ironisch gemeint' },
  @{ key='poke-fun'; word='poke fun'; ipa='/pəʊk fʌn/'; pos='idiom'; level='B2'; time='48:13'; turnId='turn-292'; cat='language-idioms'; def='To tease, mock gently, or make playful fun of someone or an established institution.'; quote='Louie (48:13): "It likes to poke fun at the bombastic glory of war films."'; de='sich lustig machen über / auf die Schippe nehmen' },
  @{ key='starship-troopers'; word='Starship Troopers'; ipa='/ˈstɑː.ʃɪp ˈtruː.pəz/'; pos='proper'; level='B2'; time='44:28'; turnId='turn-284'; cat='literature-cinema'; def='Paul Verhoeven iconic 1997 sci-fi satire exploring militarism, fascism, and propaganda dressed as blockbuster action.'; quote='Louie (44:28): "I highly suggest Starship Troopers—it is the satirical opposite of All Quiet on the Western Front."'; de='Starship Troopers (Kult-Satire)' },
  @{ key='rockstar-games'; word='Rockstar Games'; ipa='/ˈrɒk.stɑː ɡeɪmz/'; pos='proper'; level='B2'; time='44:13'; turnId='turn-279'; cat='culture-thought'; def='The renowned video game developer founded in the UK, whose flagship studio Rockstar North is based in Edinburgh, Scotland.'; quote='Louie (44:13): "Grand Theft Auto was made in Edinburgh, Scotland—it is a Scottish satirical parody of American culture."'; de='Rockstar Games (Edinburgh, Schottland)' },
  @{ key='keep-talking-and-nobody-explodes'; word='Keep Talking and Nobody Explodes'; ipa='/kiːp ˈtɔː.kɪŋ/'; pos='proper'; level='B2'; time='45:45'; turnId='turn-286'; cat='lifestyle-study'; def='A cooperative multiplayer puzzle game where one player defuses a procedural bomb while partners navigate a complex technical manual under intense time pressure.'; quote='Louie (45:45): "Have you played Keep Talking and Nobody Explodes? It teaches rapid problem solving under high pressure."'; de='Keep Talking and Nobody Explodes (Kommunikationsspiel)' },
  @{ key='abstract-thinking'; word='abstract thinking'; ipa='/ˈæb.strækt ˈθɪŋ.kɪŋ/'; pos='noun'; level='C1'; time='48:13'; turnId='turn-292'; cat='abstract-philosophy'; def='The mental capacity to understand concepts, patterns, and principles beyond immediate concrete physical reality.'; quote='Louie (48:13): "We will get to the point where you follow complex instructions and develop abstract thinking in English."'; de='das abstrakte Denken' },
  @{ key='clumsy-situations'; word='clumsy situations'; ipa='/ˈklʌm.zi ˌsɪtʃ.uˈeɪ.ʃənz/'; pos='noun'; level='B2'; time='48:13'; turnId='turn-292'; cat='lifestyle-study'; def='Awkward, delicate, or high-stakes social or professional predicaments requiring tactful verbal navigation.'; quote='Louie (48:13): "Navigate clumsy, awkward situations with verbal agility like an international manager."'; de='heikle / peinliche Situationen' },
  @{ key='low-friction'; word='low friction'; ipa='/ləʊ ˈfrɪk.ʃən/'; pos='noun'; level='C1'; time='45:45'; turnId='turn-286'; cat='lifestyle-study'; def='A system, routine, or study design structured to eliminate unnecessary obstacles, effort, and resistance.'; quote='Louie (45:45): "Keep the students learning by giving them low friction—one single link, zero searching."'; de='reibungslos / barrierearm' },
  @{ key='abitur'; word='Abitur'; ipa='/ˈæb.ɪ.tʊər/'; pos='noun'; level='B2'; time='49:41'; turnId='turn-296'; cat='lifestyle-study'; def='The rigorous final secondary school examinations and graduation certificate required for university entrance in Germany.'; quote='Verena (49:41): "He is now in the Abitur phase—he has to study intensely for many high-stakes school exams."'; de='das Abitur (Matura)' },
  @{ key='elevator-pitch'; word='elevator pitch'; ipa='/ˈel.ɪ.veɪ.tər pɪtʃ/'; pos='noun'; level='C1'; time='53:34'; turnId='turn-322'; cat='lifestyle-study'; def='A succinct, compelling 30-to-60-second summary that conveys the core premise of a project or story in the time it takes to ride an elevator.'; quote='Louie (53:34): "An elevator pitch is basically summarizing the narrative outline in the brief time it takes to ride an elevator."'; de='der Elevator Pitch / die Kurzpräsentation' },
  @{ key='outline-summary'; word='outline summary'; ipa='/ˈaʊt.laɪn ˈsʌm.ər.i/'; pos='noun'; level='B2'; time='52:58'; turnId='turn-321'; cat='lifestyle-study'; def='A structured, hierarchical breakdown highlighting the main thematic points and narrative arc of an article or film.'; quote='Clemens (52:58): "My English exam next Wednesday is about writing an outline and a comment on a text."'; de='die Gliederung / Zusammenfassung' },
  @{ key='denglish'; word='Denglish'; ipa='/ˈdeŋ.ɡlɪʃ/'; pos='noun'; level='B2'; time='06:01'; turnId='turn-47'; cat='language-learning'; def='A blend of German (Deutsch) and English, especially English spoken with literal German word order, false friends, or sentence structures.'; quote='Verena & Louie (06:01): "Translating directly from German sentence patterns—overcoming Denglish habits with British flow."'; de='das Denglisch (Mischsprache)' },
  @{ key='viktualienmarkt'; word='Viktualienmarkt'; ipa='/vɪk.tuˈɑː.li.ənˌmaːkt/'; pos='proper'; level='B2'; time='06:20'; turnId='turn-50'; cat='culture-thought'; def='The famous historic open-air gourmet daily food market in the heart of Munich, near Marienplatz.'; quote='Louie (06:20): "I lived near Marienplatz and Viktualienmarkt for three years—such a vibrant Munich landmark."'; de='der Viktualienmarkt (München)' },
  @{ key='starnberger-see'; word='Starnberger See'; ipa='/ˈʃtaʁn.bɛʁ.ɡɐ ˌzeː/'; pos='proper'; level='B2'; time='06:48'; turnId='turn-56'; cat='travel-nature'; def='A pristine freshwater lake in southern Bavaria near Munich, renowned for its alpine vistas and sailing.'; quote='Louie (06:48): "Every weekend we would drive out to Tutzing on Starnberger See—a magnificent lake."'; de='der Starnberger See' },
  @{ key='connect-four'; word='Connect Four'; ipa='/kəˈnekt fɔː/'; pos='proper'; level='B2'; time='29:21'; turnId='turn-212'; cat='lifestyle-study'; def='A classic two-player vertical connection strategy board game known in German as Vier Gewinnt.'; quote='Louie (29:21): "Have you played Connect Four? In German it is called Vier Gewinnt."'; de='Vier Gewinnt (Gesellschaftsspiel)' }
)

foreach ($v in $vocabItems) {
  $qEscaped = $v.quote.Replace('\', '\\').Replace('"', '\"')
  $defEscaped = $v.def.Replace('\', '\\').Replace('"', '\"')
  $deEscaped = $v.de.Replace('\', '\\').Replace('"', '\"')
  $line = "  `"$($v.key)`": { word: `"$($v.word)`", ipa: `"$($v.ipa)`", pos: `"$($v.pos)`", level: `"$($v.level)`", time: `"$($v.time)`", turnId: `"$($v.turnId)`", cat: `"$($v.cat)`", def: `"$defEscaped`", quote: `"$qEscaped`", de: `"$deEscaped`" },"
  $sb.AppendLine($line) | Out-Null
}
$sb.AppendLine("};`n") | Out-Null

Write-Host "VOCAB_DB added ($($vocabItems.Count) items)."

# 2. ASR_FIXES
$sb.AppendLine(@'
const ASR_FIXES = [
  { time: "00:04", speaker: "Louie", wrong: "Klemens", right: "Clemens", note: "Student's spelling formatted with a C in English correspondence." },
  { time: "01:15", speaker: "Clemens", wrong: "my. Orca", right: "Mallorca", note: "Balearic island holiday destination in the Mediterranean Sea." },
  { time: "01:23", speaker: "Clemens", wrong: "Tukis water", right: "turquoise water", note: "Striking blue-green clear coastal waters." },
  { time: "03:55", speaker: "Louie", wrong: "Kind problem", right: "Kein Problem", note: "German conversational phrase for 'no problem at all'." },
  { time: "06:14", speaker: "Louie", wrong: "minor Deutsches Needs are good", right: "meine Deutsch ist nicht so gut", note: "Louie's cheerful self-deprecating German phrasing." },
  { time: "06:20", speaker: "Louie", wrong: "Victoria Market", right: "Viktualienmarkt", note: "Famed daily outdoor food market in central Munich." },
  { time: "06:48", speaker: "Louie", wrong: "Stammbagazi", right: "Starnberger See", note: "Historic alpine lake near Munich and Tutzing." },
  { time: "12:20", speaker: "Louie", wrong: "Flaken", right: "Hang gliders / Flügel", note: "Aerodynamic gliding wings." },
  { time: "25:17", speaker: "Louie", wrong: "pure pressure", right: "peer pressure", note: "Social pressure exerted by friends or peer groups." },
  { time: "29:24", speaker: "Clemens", wrong: "4 rins", right: "Vier Gewinnt", note: "German name for the vertical board game Connect Four." },
  { time: "36:02", speaker: "Louie", wrong: "all quite on the Western Front", right: "All Quiet on the Western Front", note: "Erich Maria Remarque's masterpiece 'Im Westen nichts Neues'." },
  { time: "43:19", speaker: "Clemens", wrong: "bad makeup", right: "mockup / parody", note: "Humorous exaggeration or satirical spoof." },
  { time: "49:41", speaker: "Verena", wrong: "Abbey Tour phase", right: "Abitur phase", note: "German secondary school final examination qualification." },
  { time: "54:25", speaker: "Louie", wrong: "write an elevator", right: "ride an elevator", note: "Clear acoustic distinction between riding vs writing." }
];
'@) | Out-Null

# 3. NATURAL_STRENGTHS
$sb.AppendLine(@'
const NATURAL_STRENGTHS = [
  {
    title: "Soldier's Psychological Perspective",
    quote: "It puts you in the perspective of the soldier—a young German soldier on the harsh Western Front.",
    time: "37:56",
    analysis: "Profound literary and cinematic analysis. You articulated the shift from romanticized wartime glory to grim frontline reality with mature clarity and sophisticated vocabulary."
  },
  {
    title: "Balanced Philosophical Nuance",
    quote: "They see in us what we might underestimate in ourselves.",
    time: "26:52",
    analysis: "Exceptional philosophical insight. Instead of viewing peer pressure purely as a negative trap, you recognized positive peer encouragement that helps us overcome self-doubt."
  },
  {
    title: "Aerodynamic Principles in Flight",
    quote: "You glide through the air and increase altitude through thermals.",
    time: "12:45",
    analysis: "Fluent technical explanation of aerodynamics. You recalled precise terminology of flight (altitude, angle, glide) effortlessly without switching back to German."
  },
  {
    title: "Organic Definition of Wisdom",
    quote: "He has a lot of experience and knows the right path.",
    time: "23:39",
    analysis: "Eloquent conceptual agility. When challenged in Heads Up not to use the root word 'wise', you crafted a timeless philosophical definition of elder wisdom on the spot."
  },
  {
    title: "Modern Youth Musical Crossover",
    quote: "It's like techno beats blended with rap flow.",
    time: "30:54",
    analysis: "Spot-on cultural commentary. You conveyed the hybrid genre aesthetic of modern German urban music naturally and vividly in English."
  },
  {
    title: "Agile Pedagogical Grasp",
    quote: "Keep the friction low and keep the learning moving.",
    time: "49:59",
    analysis: "Quick, intuitive adoption of complex professional idioms. You instantly absorbed Louie's concept of eliminating administrative friction in study routines."
  }
];
'@) | Out-Null

# 4. PHRASING_POLISHES
$sb.AppendLine(@'
const PHRASING_POLISHES = [
  {
    topic: "Morning Routine Cadence",
    time: "00:41",
    spoken: "I ate. My bre— I've eaten my breakfast.",
    natural: "I've just had breakfast / I just finished having breakfast.",
    why: "In British conversational English, natives almost always say 'I've just had breakfast' rather than 'eaten', giving your morning catch-up an effortless, idiomatic cadence."
  },
  {
    topic: "Direct Verbs vs German Prepositions",
    time: "03:23",
    spoken: "Through discuss about problems, or comment on something...",
    natural: "By discussing problems or talking through challenges...",
    why: "German uses 'über ein Problem diskutieren', but English 'discuss' is a transitive verb that takes a direct object without 'about' ('discuss the issue', not 'discuss about')."
  },
  {
    topic: "Plural Subject-Verb Agreement",
    time: "02:44",
    spoken: "The people doesn't— or the students doesn't want to speak English...",
    natural: "Most of the students don't really want to speak English...",
    why: "Both 'students' and 'people' are plural count nouns, taking 'don't' rather than 'doesn't'. Adding 'really want to' also softens the observation naturally."
  },
  {
    topic: "Overcoming 'Denglish' Syntax",
    time: "06:01",
    spoken: "We make our sentences like we think in German...",
    natural: "We tend to structure our sentences using German syntax / translating directly from German.",
    why: "Using phrases like 'tend to structure' and nouns like 'German syntax' turns an informal thought into confident, analytical academic English."
  },
  {
    topic: "Self-Conscious vs Self-Confident (False Friend)",
    time: "26:30",
    spoken: "If you're not self-conscious enough, your friends push you...",
    natural: "If you lack self-confidence or self-assurance, your peers can help push you forward.",
    why: "'Self-conscious' means feeling shy, awkward, or embarrassed about what others think. 'Self-confident' (selbstbewusst) means believing in your abilities!"
  },
  {
    topic: "Action Verbs: Riding vs Writing",
    time: "54:25",
    spoken: "The time it takes to write an elevator... / Giving an outline...",
    natural: "In the time it takes to ride an elevator (an elevator pitch).",
    why: "Perfecting the acoustic difference between /raɪd/ (riding) and /raɪt/ (writing) ensures your exam summaries and presentations are crystal clear."
  }
];
'@) | Out-Null

# 5. EDITORIAL_TOPICS
$sb.AppendLine(@'
const EDITORIAL_TOPICS = [
  {
    title: "Mallorca Sun vs Berlin Autumn Skies",
    subtitle: "Circadian Health & The Vitality of Mediterranean Light",
    badge: "Travel & Physiology",
    readTime: "3 min read",
    contentHtml: `<p class="text-xs sm:text-sm text-stone-700 leading-relaxed">Returning from Mallorca\'s turquoise Mediterranean waters to Berlin\'s grey autumn drizzle illustrates the profound physiological impact of solar irradiance on human cognition. Sunlight triggers retinal photoreceptors that stimulate serotonin synthesis and regulate our internal master circadian pacemaker—the suprachiasmatic nucleus. In northern European winters, shorter photoperiods lower dopamine and melatonin regulation, making intentional light exposure and restful study sanctuaries essential for peak mental vitality.</p>`
  },
  {
    title: "Thermals, Lift & Mountain Aerodynamics",
    subtitle: "The Physical Principles of Motorless Soaring",
    badge: "Physics & Flight",
    readTime: "4 min read",
    contentHtml: `<p class="text-xs sm:text-sm text-stone-700 leading-relaxed">Gliders and paragliders stay aloft without propulsion by exploiting atmospheric thermodynamics. Solar radiation heats uneven terrain—such as dark forest canopies and rocky mountain faces—faster than surrounding valleys. This generates convective columns of rising warm air called <em>thermals</em>. By banking into these rising cores at an optimal angle of attack, pilots achieve positive climb rates, turning solar energy directly into potential gravitational altitude.</p>`
  },
  {
    title: "The Two Faces of Peer Pressure",
    subtitle: "Destructive Conformity vs Uplifting Accountability",
    badge: "Psychology & Ethics",
    readTime: "4 min read",
    contentHtml: `<p class="text-xs sm:text-sm text-stone-700 leading-relaxed">While colloquial usage often treats peer pressure as a destructive adolescent force pushing individuals toward risk-taking, Clemens astutely noted its positive fraternal counterpart: <em>positive accountability</em>. When an individual is held back by self-doubt or imposter syndrome, trusted friends and swim teammates who recognize our latent capabilities can provide the necessary external impetus to take on daring challenges we would otherwise avoid.</p>`
  },
  {
    title: "Anti-War Tragedy vs Satirical Parody",
    subtitle: "Remarque\'s Gritty Realism vs Verhoeven\'s Subversive Satire",
    badge: "Literature & Cinema",
    readTime: "5 min read",
    contentHtml: `<p class="text-xs sm:text-sm text-stone-700 leading-relaxed">Erich Maria Remarque\'s <em>All Quiet on the Western Front</em> (1929) dismantles romanticized militarism through unsparing, visceral trench realism—exposing the psychological devastation of young German soldiers. In contrast, Paul Verhoeven\'s sci-fi film <em>Starship Troopers</em> (1997) critiques the same militaristic fanaticism through subversive parody: dressing jingoistic propaganda in hyper-stylized action to invite the audience to laugh at its fascist absurdities. Both achieve powerful anti-war statements through mirror-opposite creative lenses.</p>`
  }
];
'@) | Out-Null

# 6. FLASHCARDS
$sb.AppendLine(@'
const FLASHCARDS = [
  { vocabKey: "serendipity", front: "serendipity", ipa: "/ˌser.ənˈdɪp.ə.ti/", level: "C2", backDef: "Finding valuable, pleasant, or fortunate things entirely by happy chance.", exampleQuote: "Louie: 'It was pure serendipity—luck by happy chance.'", de: "glücklicher Zufall / die Serendipität" },
  { vocabKey: "counterintuitive", front: "counterintuitive", ipa: "/ˌkaʊn.tər.ɪnˈtjuː.ɪ.tɪv/", level: "C1", backDef: "Contrary to what common sense or initial expectation would suggest.", exampleQuote: "Louie: 'English stress rhythm is counterintuitive at first.'", de: "kontraintuitiv / unerwartet" },
  { vocabKey: "thermal", front: "thermal", ipa: "/ˈθɜː.məl/", level: "C1", backDef: "An upward column of warm, rising air utilized by gliders to gain altitude.", exampleQuote: "Louie: 'Thermals are columns of rising heat from trees and earth.'", de: "die Thermik / der Aufwind" },
  { vocabKey: "nostalgia", front: "nostalgia", ipa: "/nɒsˈtæl.dʒə/", level: "C1", backDef: "A sentimental longing or affectionate wistfulness for a period or place in the past.", exampleQuote: "Clemens: 'When an old memory brings back warm childhood feelings.'", de: "die Nostalgie / Wehmut" },
  { vocabKey: "wisdom", front: "wisdom", ipa: "/ˈwɪz.dəm/", level: "C1", backDef: "Deep experience, mature insight, and the sound judgment to discern the right path.", exampleQuote: "Clemens: 'He has a lot of experience and knows the right path.'", de: "die Weisheit / Lebenserfahrung" },
  { vocabKey: "peer-pressure", front: "peer pressure", ipa: "/ˈpɪə ˌpreʃ.ər/", level: "B2", backDef: "Social or psychological influence from friends encouraging you to adopt certain attitudes or actions.", exampleQuote: "Louie: 'Friends who convince or push you outside your comfort zone.'", de: "der Gruppenzwang / sozialer Druck" },
  { vocabKey: "jargon", front: "jargon", ipa: "/ˈdʒɑː.ɡən/", level: "C1", backDef: "Specialized vocabulary or technical terminology characteristic of a particular hobby or trade.", exampleQuote: "Louie: 'Terminology is like jargon—insider words used in specific fields.'", de: "der Fachjargon / Fachbegriffe" },
  { vocabKey: "colloquial", front: "colloquial", ipa: "/kəˈləʊ.kwi.əl/", level: "C1", backDef: "Everyday informal speech and conversational phrasing rather than rigid textbook grammar.", exampleQuote: "Louie: 'Colloquial words are how native speakers actually converse.'", de: "umgangssprachlich / salopp" },
  { vocabKey: "synopsis", front: "synopsis", ipa: "/sɪˈnɒp.sɪs/", level: "C1", backDef: "A concise, structured overview summarizing the central plot or argument of a work.", exampleQuote: "Louie: 'Your synopsis and analysis of the film were fantastic.'", de: "die Synopsis / Inhaltsangabe" },
  { vocabKey: "satirical", front: "satirical", ipa: "/səˈtɪr.ɪ.kəl/", level: "C1", backDef: "Using humor, irony, and sharp exaggeration to mock and expose human folly or propaganda.", exampleQuote: "Louie: 'Starship Troopers is a satirical parody of military fanaticism.'", de: "satirisch / ironisch spottend" },
  { vocabKey: "tongue-in-cheek", front: "tongue-in-cheek", ipa: "/ˌtʌŋ ɪn ˈtʃiːk/", level: "C1", backDef: "An ironic, playful remark delivered with false seriousness; not meant literally.", exampleQuote: "Louie: 'It is tongue-in-cheek—it likes to poke fun at jingoistic glory.'", de: "mit einem Augenzwinkern" },
  { vocabKey: "elevator-pitch", front: "elevator pitch", ipa: "/ˈel.ɪ.veɪ.tər pɪtʃ/", level: "C1", backDef: "A rapid, persuasive 30-to-60-second summary deliverable in the time it takes to ride a lift.", exampleQuote: "Louie: 'Giving an outline in the brief time it takes to ride an elevator.'", de: "der Elevator Pitch / die Kurzpräsentation" }
];
'@) | Out-Null

# 7. IDIOM_CHALLENGES
$sb.AppendLine(@'
const IDIOM_CHALLENGES = [
  {
    title: "The Unexpected Bavarian Bakery",
    scenario: "You are walking through a Munich neighborhood and turn a quiet corner, discovering a historic bakery with the best pastries in town by pure chance. What idiom best describes this happy accident?",
    options: ["Understatement", "Pure serendipity", "A clumsy situation", "Second nature"],
    correctIndex: 1,
    explanation: "'Pure serendipity' describes making valuable and fortunate discoveries entirely by happy chance.",
    de: "glücklicher Zufall"
  },
  {
    title: "The Swim Meet Hesitation",
    scenario: "A swimmer doubts their fitness before a major competition, but their teammates encourage them and hold them accountable until they enter and win. What dynamic took place?",
    options: ["Negative peer pressure", "Positive peer pressure & support", "Direct translation", "Self-consciousness"],
    correctIndex: 1,
    explanation: "Positive peer pressure occurs when friends push someone to achieve something they underestimate in themselves.",
    de: "positive Gruppendynamik"
  },
  {
    title: "Greeting an Old Friend",
    scenario: "You bump into a classmate you haven't seen since primary school. What natural British colloquialism fits best?",
    options: ["'I haven't seen you for ages!'", "'I haven't seen you for centuries!'", "'It has been zero friction!'", "'You are very self-conscious!'"],
    correctIndex: 0,
    explanation: "'For ages' is the quintessential British conversational idiom for 'a very long time'.",
    de: "schon ewig"
  },
  {
    title: "The Subversive Recruitment Film",
    scenario: "A director creates a film that superficially looks like heroic wartime propaganda, but every bombastic scene intentionally exposes the cruelty and absurdity of war. What narrative device is this?",
    options: ["Satirical parody (tongue-in-cheek)", "Objective documentary", "Direct translation", "Grammatical polish"],
    correctIndex: 0,
    explanation: "A satirical parody mimics a genre's tropes with tongue-in-cheek exaggeration to critique its ideology.",
    de: "satirische Parodie"
  },
  {
    title: "The 45-Second Exam Summary",
    scenario: "Your English teacher asks you to present a 45-second summary of a novel's core premise during an oral exam. What professional format are you delivering?",
    options: ["A full monologue", "An elevator pitch outline", "A verbatim reading", "A Denglish translation"],
    correctIndex: 1,
    explanation: "An 'elevator pitch' is a concise, punchy outline delivering the essential argument in under a minute.",
    de: "Kurzpräsentation"
  },
  {
    title: "Effortless Homework Workflow",
    scenario: "Louie designs your study portal so that notes, audio, flashcards, and homework are accessible via a single persistent link with zero searching. What principle is this?",
    options: ["High friction", "Low friction learning", "Counterintuitive grammar", "Optical illusion"],
    correctIndex: 1,
    explanation: "'Low friction' eliminates unnecessary obstacles and complexity, keeping students engaged and moving forward.",
    de: "reibungslose Routine"
  }
];
'@) | Out-Null

# 8. QUIZ_QUESTIONS
$sb.AppendLine(@'
const QUIZ_QUESTIONS = [
  {
    question: "Why did Louie describe English speech rhythm as 'counterintuitive' for language learners?",
    options: [
      "Because English has no phonetic stress rules.",
      "Because the English ear listens primarily for stressed syllables and vowel reduction rather than individual letters.",
      "Because British speakers speak twice as fast as German speakers.",
      "Because all English vowels are pronounced with identical length."
    ],
    correctIndex: 1,
    explanation: "English is a stress-timed language. Native ears listen for stressed content words while unstressed syllables are shortened (schwa)."
  },
  {
    question: "How do unpowered gliders and paragliders gain altitude over mountain ranges?",
    options: [
      "By relying on cloud precipitation.",
      "By catching rising columns of warm air called thermals.",
      "By pedaling internal turbines manually.",
      "By maintaining a flat angle parallel to the wind."
    ],
    correctIndex: 1,
    explanation: "Thermals are convective columns of rising warm air heated by terrain that allow gliders to climb thousands of feet."
  },
  {
    question: "What is the key psychological difference between feeling 'self-conscious' and 'self-confident'?",
    options: [
      "They are exact synonyms in modern British English.",
      "'Self-conscious' means feeling nervous or awkward about others' gaze, while 'self-confident' means having faith in one's abilities.",
      "'Self-conscious' means you have expert medical knowledge.",
      "'Self-confident' means you only conform to peer pressure."
    ],
    correctIndex: 1,
    explanation: "'Self-conscious' is often a false friend for German speakers: it means shy or uncomfortable, whereas 'self-confident' means selbstbewusst."
  },
  {
    question: "Where was the renowned Grand Theft Auto video game series created and developed?",
    options: [
      "In Los Angeles, California.",
      "In Edinburgh, Scotland, by Rockstar North.",
      "In Berlin, Germany.",
      "In Munich, Bavaria."
    ],
    correctIndex: 1,
    explanation: "Grand Theft Auto was created in Edinburgh, Scotland, serving as a satirical British parody of American culture."
  },
  {
    question: "Why did Louie recommend Paul Verhoeven's 'Starship Troopers' alongside 'All Quiet on the Western Front'?",
    options: [
      "Because they share the exact same cast of actors.",
      "Because Starship Troopers acts as a satirical, tongue-in-cheek parody of military propaganda, contrasting with Remarque's tragic trench realism.",
      "Because it is an exact historical documentary of World War I.",
      "Because it was filmed in the Bavarian Alps."
    ],
    correctIndex: 1,
    explanation: "Both films explore the horrors and manipulation of war, but Remarque uses gritty tragedy while Verhoeven uses sharp satire."
  },
  {
    question: "What is an 'elevator pitch' in the context of Clemens' upcoming English exam preparation?",
    options: [
      "A speech given exclusively inside high-rise elevators.",
      "A concise, structured 30-to-60-second summary that conveys the core premise and outline in the time of a brief lift ride.",
      "A technical presentation on mechanical elevator engineering.",
      "A word-for-word memorization of a textbook chapter."
    ],
    correctIndex: 1,
    explanation: "An elevator pitch is an essential communication skill: summarizing key points and takeaways rapidly and persuasively."
  }
];
'@) | Out-Null

# 9. REFLECTION_PROMPTS
$sb.AppendLine(@'
const REFLECTION_PROMPTS = [
  {
    title: "Tragedy vs Satire in Anti-War Cinema",
    category: "Literary & Film Analysis",
    prompt: "In your opinion, which artistic approach leaves a more lasting impression on an audience: the raw, visceral frontline tragedy of 'All Quiet on the Western Front' or the satirical, tongue-in-cheek mock-propaganda of 'Starship Troopers'?",
    prepAdvice: "Structure your thoughts into two contrasting points, citing specific scenes or emotions from both works."
  },
  {
    title: "Crafting Your Exam Elevator Pitch",
    category: "Exam Preparation (Abitur)",
    prompt: "Prepare a 45-second spoken elevator pitch for a film, book, or article of your choice. Deliver: (1) The Hook & Core Premise, (2) The Central Conflict, and (3) The Underlying Theme.",
    prepAdvice: "Time yourself with a stopwatch. Focus on clean English stress rhythm and avoiding German sentence order ('Denglish')."
  },
  {
    title: "The Power of Constructive Peer Influence",
    category: "Personal Philosophy & Sports",
    prompt: "Reflect on a moment in your swimming club, high school, or personal life where a teammate or friend pushed you to attempt something you underestimated in yourself. How did that shape your confidence?",
    prepAdvice: "Use terms like 'positive accountability', 'self-confident', and 'overcoming self-doubt'."
  }
];
'@) | Out-Null

Write-Host "Metadata blocks compiled. Processing all 340 transcript turns..."

# Write TRANSCRIPT_TURNS
$sb.AppendLine("const TRANSCRIPT_TURNS = [") | Out-Null

for ($i = 0; $i -lt $rawTurns.Count; $i++) {
    $t = $rawTurns[$i]
    $time = $t.Time
    $raw = $t.Speaker
    $txt = $t.Text -replace "\s+", " "
    $turnId = "turn-$($i + 1)"
    
    # Speaker Attribution Logic
    $spk = "Louie"
    if ($time -lt "07:30") {
        if ($time -eq "00:00" -or $time -eq "00:02" -and $raw -eq "Lewis" -or $time -eq "00:03" -and $raw -eq "Lewis" -or $time -eq "00:04" -and $raw -eq "Lewis" -or $time -eq "00:10" -and $raw -eq "Lewis" -or $time -eq "00:18" -and $raw -eq "Lewis" -or $time -eq "00:21" -or $time -eq "00:25" -or $time -eq "00:27" -and $raw -eq "Lewis" -or $time -eq "00:33" -or $time -eq "00:41" -and $raw -eq "Lewis" -or $time -eq "01:10" -or $time -eq "01:11" -or $time -eq "01:22" -or $time -eq "02:05" -or $time -eq "02:21" -and $raw -eq "Verena" -or $time -eq "02:28" -and $raw -eq "Verena" -or $time -eq "03:23" -and $raw -eq "Verena" -or $time -eq "03:55" -or $time -eq "06:00" -or $time -eq "06:14" -or $time -eq "06:20" -or $time -eq "06:40" -or $time -eq "06:48" -or $time -eq "06:58" -and $raw -eq "Verena" -or $time -eq "07:11" -and $raw -eq "Verena") {
            $spk = "Louie"
        } elseif ($time -eq "00:35" -or $time -eq "00:41" -and $raw -eq "Verena" -or $time -eq "01:15" -or $time -eq "01:23" -or $time -eq "01:41" -or $time -eq "02:44" -or $time -eq "03:23" -and $raw -eq "Lewis") {
            $spk = "Clemens"
        } else {
            $spk = "Verena"
        }
    } elseif ($time -ge "49:36" -and $time -lt "52:24") {
        if ($txt -match "Abbey Tour|lots of pressure from school|ill in the last months|expect him to do a lot of homework|give him the chance|I'm sure you will find a way") {
            $spk = "Verena"
        } elseif ($txt -match "program|watch a movie|discover the English language|friction|No friction|why don't we do this") {
            $spk = "Louie"
        } elseif ($txt -match "homework is always great|keep the friction|I will need to study") {
            $spk = "Clemens"
        } else {
            $spk = if ($raw -eq "Verena") { "Louie" } else { "Clemens" }
        }
    } elseif ($time -ge "52:24") {
        $spk = if ($raw -eq "Lewis") { "Clemens" } else { "Louie" }
    } else {
        # 07:30 to 49:36
        $spk = if ($raw -eq "Lewis") { "Clemens" } else { "Louie" }
    }
    
    # Chapter Headers
    $chapId = ""
    $chapTitle = ""
    if ($i -eq 0) {
        $chapId = "chap-1"
        $chapTitle = "Chapter I • Welcome, Mallorca Sunshine & Language Goals in Berlin (00:00 – 07:30)"
    } elseif ($i -eq 52) {
        $chapId = "chap-2"
        $chapTitle = "Chapter II • The Sanctuary Blueprint & Heads Up: Aerodynamics, Gliders & Cue Sports (07:30 – 20:00)"
    } elseif ($i -eq 136) {
        $chapId = "chap-3"
        $chapTitle = "Chapter III • Heads Up: Abstract Concepts, Optical Illusions, Wisdom & Peer Pressure (20:00 – 27:30)"
    } elseif ($i -eq 192) {
        $chapId = "chap-4"
        $chapTitle = "Chapter IV • Connect Four: Music Beats, Technical Jargon & Bavarian Colloquialisms (27:30 – 35:30)"
    } elseif ($i -eq 234) {
        $chapId = "chap-5"
        $chapTitle = "Chapter V • Literary & Cinematic Analysis: All Quiet on the Western Front & Scottish GTA (35:30 – 44:00)"
    } elseif ($i -eq 284) {
        $chapId = "chap-6"
        $chapTitle = "Chapter VI • Satirical Parody, Starship Troopers & The Abitur Strategy (44:00 – 54:58)"
    }

    # Transform text to embed fixBadge and v() using placeholder architecture to prevent collisions
    $htmlText = $txt

    # Phase 1: Replace raw ASR mishearings with unique safe placeholders
    $htmlText = $htmlText -replace "(?i)my\.\s*Orca", '@@FIX_MALLORCA@@'
    $htmlText = $htmlText -replace "(?i)Tukis water", '@@FIX_TURQUOISE@@'
    $htmlText = $htmlText -replace "(?i)Victoria Market", '@@FIX_VIKTUALIENMARKT@@'
    $htmlText = $htmlText -replace "(?i)Stammbagazi", '@@FIX_STARNBERGER@@'
    $htmlText = $htmlText -replace "(?i)minor Deutsches Needs are good", '@@FIX_MEINE_DEUTSCH@@'
    $htmlText = $htmlText -replace "(?i)Kind problem", '@@FIX_KEIN_PROBLEM@@'
    $htmlText = $htmlText -replace "(?i)pure pressure", '@@FIX_PEER_PRESSURE@@'
    $htmlText = $htmlText -replace "(?i)4 rins", '@@FIX_CONNECT_FOUR@@'
    $htmlText = $htmlText -replace "(?i)all quite on the Western Front", '@@FIX_ALL_QUIET@@'
    $htmlText = $htmlText -replace "(?i)Abbey Tour", '@@FIX_ABITUR@@'
    $htmlText = $htmlText -replace "(?i)write an elevator", '@@FIX_RIDE_ELEVATOR@@'
    $htmlText = $htmlText -replace "(?i)bad makeup", '@@FIX_MOCKUP@@'
    $htmlText = $htmlText -replace "(?i)\bKlemens\b", '@@FIX_CLEMENS@@'

    # Phase 2: Replace standard vocabulary occurrences with ${v('key', 'display')}
    $htmlText = $htmlText -replace "(?i)\bserendipity\b", '${v(''serendipity'', ''serendipity'')}'
    $htmlText = $htmlText -replace "(?i)\bunwind\b", '${v(''unwind'', ''unwind'')}'
    $htmlText = $htmlText -replace "(?i)\bcounterintuitive\b", '${v(''counterintuitive'', ''counterintuitive'')}'
    $htmlText = $htmlText -replace "(?i)\bstress words\b", '${v(''stress-rhythm'', ''stress words'')}'
    $htmlText = $htmlText -replace "(?i)\bannotating\b", '${v(''annotate'', ''annotating'')}'
    $htmlText = $htmlText -replace "(?i)\bturquoise water\b", '${v(''turquoise'', ''turquoise water'')}'
    $htmlText = $htmlText -replace "(?i)\bparagliding\b", '${v(''paragliding'', ''paragliding'')}'
    $htmlText = $htmlText -replace "(?i)\bgliders\b", '${v(''glider'', ''gliders'')}'
    $htmlText = $htmlText -replace "(?i)\baltitude\b", '${v(''altitude'', ''altitude'')}'
    $htmlText = $htmlText -replace "(?i)\bincrease the angle\b", '${v(''angle-of-attack'', ''increase the angle'')}'
    $htmlText = $htmlText -replace "(?i)\bthermals\b", '${v(''thermal'', ''thermals'')}'
    $htmlText = $htmlText -replace "(?i)\bwith a Q\b", '${v(''cue-sport'', ''with a cue'')}'
    $htmlText = $htmlText -replace "(?i)\bbilliards\b", '${v(''billiards'', ''billiards'')}'
    $htmlText = $htmlText -replace "(?i)\bwickets\b", '${v(''wicket'', ''wickets'')}'
    $htmlText = $htmlText -replace "(?i)\bcricket bat\b", '${v(''cricket-bat'', ''cricket bat'')}'
    $htmlText = $htmlText -replace "(?i)\bdentistry\b", '${v(''dentistry'', ''dentistry'')}'
    $htmlText = $htmlText -replace "(?i)\bdentures\b", '${v(''dentures'', ''dentures'')}'
    $htmlText = $htmlText -replace "(?i)\ban illusion\b", '${v(''optical-illusion'', ''an illusion'')}'
    $htmlText = $htmlText -replace "(?i)\bnostalgia\b", '${v(''nostalgia'', ''nostalgia'')}'
    $htmlText = $htmlText -replace "(?i)\bwisdom\b", '${v(''wisdom'', ''wisdom'')}'
    $htmlText = $htmlText -replace "(?i)\bpeer pressure\b", '${v(''peer-pressure'', ''peer pressure'')}'
    $htmlText = $htmlText -replace "(?i)\bunderestimate\b", '${v(''underestimate'', ''underestimate'')}'
    $htmlText = $htmlText -replace "(?i)\bself-conscious\b", '${v(''self-conscious'', ''self-conscious'')}'
    $htmlText = $htmlText -replace "(?i)\bjargon\b", '${v(''jargon'', ''jargon'')}'
    $htmlText = $htmlText -replace "(?i)\bterminology\b", '${v(''terminology'', ''terminology'')}'
    $htmlText = $htmlText -replace "(?i)\bcolloquial\b", '${v(''colloquial'', ''colloquial'')}'
    $htmlText = $htmlText -replace "(?i)\bfor ages\b", '${v(''for-ages'', ''for ages'')}'
    $htmlText = $htmlText -replace "(?i)\bServus\b", '${v(''servus'', ''Servus'')}'
    $htmlText = $htmlText -replace "(?i)\bAll Quiet on the Western Front\b", '${v(''all-quiet-on-the-western-front'', ''All Quiet on the Western Front'')}'
    $htmlText = $htmlText -replace "(?i)\bsynopsis\b", '${v(''synopsis'', ''synopsis'')}'
    $htmlText = $htmlText -replace "(?i)\bEpic\b", '${v(''epic'', ''Epic'')}'
    $htmlText = $htmlText -replace "(?i)\bproduction value\b", '${v(''production-value'', ''production value'')}'
    $htmlText = $htmlText -replace "(?i)\bperspective of the soldier\b", '${v(''soldier-perspective'', ''perspective of the soldier'')}'
    $htmlText = $htmlText -replace "(?i)\bharsh Western Front\b", '${v(''trench-warfare'', ''harsh Western Front'')}'
    $htmlText = $htmlText -replace "(?i)\bpurging\b", '${v(''purging'', ''purging'')}'
    $htmlText = $htmlText -replace "(?i)\bstruck me\b", '${v(''struck-me'', ''struck me'')}'
    $htmlText = $htmlText -replace "(?i)\bparody\b", '${v(''parody'', ''parody'')}'
    $htmlText = $htmlText -replace "(?i)\bsatirical\b", '${v(''satirical'', ''satirical'')}'
    $htmlText = $htmlText -replace "(?i)\btongue and cheek\b", '${v(''tongue-in-cheek'', ''tongue-in-cheek'')}'
    $htmlText = $htmlText -replace "(?i)\bpoke fun\b", '${v(''poke-fun'', ''poke fun'')}'
    $htmlText = $htmlText -replace "(?i)\bStarship Troopers\b", '${v(''starship-troopers'', ''Starship Troopers'')}'
    $htmlText = $htmlText -replace "(?i)\bRockstar Games\b", '${v(''rockstar-games'', ''Rockstar Games'')}'
    $htmlText = $htmlText -replace "(?i)\bKeep Talking and Nobody Explodes\b", '${v(''keep-talking-and-nobody-explodes'', ''Keep Talking and Nobody Explodes'')}'
    $htmlText = $htmlText -replace "(?i)\babstract\b", '${v(''abstract-thinking'', ''abstract'')}'
    $htmlText = $htmlText -replace "(?i)\bclumsy situations\b", '${v(''clumsy-situations'', ''clumsy situations'')}'
    $htmlText = $htmlText -replace "(?i)\blow friction\b", '${v(''low-friction'', ''low friction'')}'
    $htmlText = $htmlText -replace "(?i)\bAbitur\b", '${v(''abitur'', ''Abitur'')}'
    $htmlText = $htmlText -replace "(?i)\belevator pitch\b", '${v(''elevator-pitch'', ''elevator pitch'')}'
    $htmlText = $htmlText -replace "(?i)\bwriting an outline\b", '${v(''outline-summary'', ''writing an outline'')}'
    $htmlText = $htmlText -replace "(?i)\bthink in German\b", '${v(''denglish'', ''think in German'')}'
    $htmlText = $htmlText -replace "(?i)\bViktualienmarkt\b", '${v(''viktualienmarkt'', ''Viktualienmarkt'')}'
    $htmlText = $htmlText -replace "(?i)\bStarnberger See\b", '${v(''starnberger-see'', ''Starnberger See'')}'
    $htmlText = $htmlText -replace "(?i)\bConnect 4\b", '${v(''connect-four'', ''Connect 4'')}'

    # Phase 3: Expand placeholders into pristine, non-colliding fixBadge and v() calls
    $htmlText = $htmlText.Replace('@@FIX_MALLORCA@@', 'Mallorca ${fixBadge(''Mallorca'', ''my. Orca'')}')
    $htmlText = $htmlText.Replace('@@FIX_TURQUOISE@@', '${v(''turquoise'', ''turquoise water'')} ${fixBadge(''turquoise water'', ''Tukis water'')}')
    $htmlText = $htmlText.Replace('@@FIX_VIKTUALIENMARKT@@', '${v(''viktualienmarkt'', ''Viktualienmarkt'')} ${fixBadge(''Viktualienmarkt'', ''Victoria Market'')}')
    $htmlText = $htmlText.Replace('@@FIX_STARNBERGER@@', '${v(''starnberger-see'', ''Starnberger See'')} ${fixBadge(''Starnberger See'', ''Stammbagazi'')}')
    $htmlText = $htmlText.Replace('@@FIX_MEINE_DEUTSCH@@', 'meine Deutsch ist nicht so gut ${fixBadge(''meine Deutsch ist nicht so gut'', ''minor Deutsches Needs are good'')}')
    $htmlText = $htmlText.Replace('@@FIX_KEIN_PROBLEM@@', 'Kein Problem ${fixBadge(''Kein Problem'', ''Kind problem'')}')
    $htmlText = $htmlText.Replace('@@FIX_PEER_PRESSURE@@', '${v(''peer-pressure'', ''peer pressure'')} ${fixBadge(''peer pressure'', ''pure pressure'')}')
    $htmlText = $htmlText.Replace('@@FIX_CONNECT_FOUR@@', '${v(''connect-four'', ''Vier Gewinnt'')} ${fixBadge(''Vier Gewinnt'', ''4 rins'')}')
    $htmlText = $htmlText.Replace('@@FIX_ALL_QUIET@@', '${v(''all-quiet-on-the-western-front'', ''All Quiet on the Western Front'')} ${fixBadge(''All Quiet on the Western Front'', ''all quite on the Western Front'')}')
    $htmlText = $htmlText.Replace('@@FIX_ABITUR@@', '${v(''abitur'', ''Abitur'')} ${fixBadge(''Abitur'', ''Abbey Tour'')}')
    $htmlText = $htmlText.Replace('@@FIX_RIDE_ELEVATOR@@', 'ride an elevator ${fixBadge(''ride an elevator'', ''write an elevator'')}')
    $htmlText = $htmlText.Replace('@@FIX_MOCKUP@@', 'mockup / parody ${fixBadge(''mockup / parody'', ''bad makeup'')}')
    $htmlText = $htmlText.Replace('@@FIX_CLEMENS@@', 'Clemens ${fixBadge(''Clemens'', ''Klemens'')}')


    # Escape quotes for JS template string
    $escapedHtml = $htmlText.Replace('\', '\\').Replace('`', '\`')

    $tEntry = "  { id: `"$turnId`""
    if ($chapId -ne "") {
        $tEntry += ", chapterId: `"$chapId`", chapterTitle: `"$chapTitle`""
    }
    $tEntry += ", speaker: `"$spk`", time: `"$time`", html: $bt$escapedHtml$bt },"

    $sb.AppendLine($tEntry) | Out-Null
}

$sb.AppendLine("];`n") | Out-Null

Write-Host "Writing lesson_data.js with UTF-8 without BOM..."
$finalContent = $sb.ToString()
[System.IO.File]::WriteAllText("D:\Documents\Clemens B\lesson_data.js", $finalContent, [System.Text.UTF8Encoding]::new($false))

Write-Host "Success! Created lesson_data.js ($((Get-Item 'D:\Documents\Clemens B\lesson_data.js').Length) bytes)."
