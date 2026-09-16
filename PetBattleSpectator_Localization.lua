local _, addon = ...

addon.L = addon.L or {}

local L = addon.L

function addon:GetLocalizedString(key)
  return L[key] or key
end

L["LOADED"] = "Loaded - open with |cffFFFF00/pbs|r, |cffFFFF00/pbspec|r or |cffFFFF00/petbattlespectator|r"
L["OPTIONS_TITLE"] = "Pet Battle Spectator Options"
L["FONT_SIZE"] = "Font Size: "
L["FRAME_HEIGHT"] = "Frame Height (in lines): "
L["SHOW_TIMER"] = "Show Log Duration: "
L["SEC"] = "sec"
L["BACKGROUND_OPACITY"] = "Background Opacity: "
L["RESET_LOGS"] = "Reset Logs Positions"
L["RESET_TIMER"] = "Reset Timer Position"
L["ONLY_PVP"] = " Show the timer (only in PvP)"

if GetLocale() == "deDE" then
  L["LOADED"] = "Geladen – öffnen mit |cffFFFF00/pbs|r, |cffFFFF00/pbspec|r oder |cffFFFF00/petbattlespectator|r"
  L["OPTIONS_TITLE"] = "Pet Battle Spectator – Optionen"
  L["FONT_SIZE"] = "Schriftgröße: "
  L["FRAME_HEIGHT"] = "Fensterhöhe (in Zeilen): "
  L["SHOW_TIMER"] = "Log-Dauer anzeigen: "
  L["SEC"] = "Sek."
  L["BACKGROUND_OPACITY"] = "Hintergrund-Deckkraft: "
  L["RESET_LOGS"] = "Log-Positionen zurücksetzen"
  L["RESET_TIMER"] = "Timer-Position zurücksetzen"
  L["ONLY_PVP"] = "Timer anzeigen (nur im PvP)"
end

if GetLocale() == "esES" then
  L["LOADED"] = "Cargado: abre con |cffFFFF00/pbs|r, |cffFFFF00/pbspec|r o |cffFFFF00/petbattlespectator|r"
  L["OPTIONS_TITLE"] = "Opciones de Pet Battle Spectator"
  L["FONT_SIZE"] = "Tamaño de fuente: "
  L["FRAME_HEIGHT"] = "Altura del marco (en líneas): "
  L["SHOW_TIMER"] = "Mostrar duración del registro: "
  L["SEC"] = "s"
  L["BACKGROUND_OPACITY"] = "Opacidad del fondo: "
  L["RESET_LOGS"] = "Restablecer posiciones de los registros"
  L["RESET_TIMER"] = "Restablecer posición del temporizador"
  L["ONLY_PVP"] = "Mostrar el temporizador (solo en JcJ)"
end

if GetLocale() == "esMX" then
  L["LOADED"] = "Cargado - abre con |cffFFFF00/pbs|r, |cffFFFF00/pbspec|r o |cffFFFF00/petbattlespectator|r"
  L["OPTIONS_TITLE"] = "Opciones de Pet Battle Spectator"
  L["FONT_SIZE"] = "Tamaño de fuente: "
  L["FRAME_HEIGHT"] = "Altura del marco (en líneas): "
  L["SHOW_TIMER"] = "Mostrar duración del registro: "
  L["SEC"] = "seg"
  L["BACKGROUND_OPACITY"] = "Opacidad del fondo: "
  L["RESET_LOGS"] = "Reiniciar posiciones de los registros"
  L["RESET_TIMER"] = "Reiniciar posición del temporizador"
  L["ONLY_PVP"] = " Mostrar el temporizador (solo en JcJ)"
end

if GetLocale() == "frFR" then
  L["LOADED"] = "Chargé - ouvrez avec |cffFFFF00/pbs|r, |cffFFFF00/pbspec|r ou |cffFFFF00/petbattlespectator|r"
  L["OPTIONS_TITLE"] = "Options de Pet Battle Spectator"
  L["FONT_SIZE"] = "Taille de la police : "
  L["FRAME_HEIGHT"] = "Hauteur du cadre (en lignes) : "
  L["SHOW_TIMER"] = "Afficher la durée du journal : "
  L["SEC"] = "s"
  L["BACKGROUND_OPACITY"] = "Opacité de l'arrière-plan : "
  L["RESET_LOGS"] = "Réinitialiser la position des journaux"
  L["RESET_TIMER"] = "Réinitialiser la position du minuteur"
  L["ONLY_PVP"] = "Afficher le minuteur (JcJ uniquement)"
end

if GetLocale() == "itIT" then
  L["LOADED"] = "Caricato - apri con |cffFFFF00/pbs|r, |cffFFFF00/pbspec|r o |cffFFFF00/petbattlespectator|r"
  L["OPTIONS_TITLE"] = "Opzioni di Pet Battle Spectator"
  L["FONT_SIZE"] = "Dimensione carattere: "
  L["FRAME_HEIGHT"] = "Altezza riquadro (in righe): "
  L["SHOW_TIMER"] = "Mostra durata log: "
  L["SEC"] = "sec"
  L["BACKGROUND_OPACITY"] = "Opacità sfondo: "
  L["RESET_LOGS"] = "Ripristina posizione log"
  L["RESET_TIMER"] = "Ripristina posizione timer"
  L["ONLY_PVP"] = " Mostra il timer (solo in PvP)"
end

if GetLocale() == "koKR" then
  L["LOADED"] = "로드됨 - |cffFFFF00/pbs|r, |cffFFFF00/pbspec|r 또는 |cffFFFF00/petbattlespectator|r로 실행"
  L["OPTIONS_TITLE"] = "애완동물 대전 관전 설정"
  L["FONT_SIZE"] = "글꼴 크기: "
  L["FRAME_HEIGHT"] = "프레임 높이 (줄 수): "
  L["SHOW_TIMER"] = "로그 지속 시간 표시: "
  L["SEC"] = "초"
  L["BACKGROUND_OPACITY"] = "배경 불투명도: "
  L["RESET_LOGS"] = "로그 위치 초기화"
  L["RESET_TIMER"] = "타이머 위치 초기화"
  L["ONLY_PVP"] = " 타이머 표시 (PvP에서만)"
end

if GetLocale() == "ptBR" then
  L["LOADED"] = "Carregado - abra com |cffFFFF00/pbs|r, |cffFFFF00/pbspec|r ou |cffFFFF00/petbattlespectator|r"
  L["OPTIONS_TITLE"] = "Opções do Pet Battle Spectator"
  L["FONT_SIZE"] = "Tamanho da Fonte: "
  L["FRAME_HEIGHT"] = "Altura da Janela (em linhas): "
  L["SHOW_TIMER"] = "Mostrar Duração do Registro: "
  L["SEC"] = "seg"
  L["BACKGROUND_OPACITY"] = "Opacidade do Fundo: "
  L["RESET_LOGS"] = "Redefinir Posições dos Registros"
  L["RESET_TIMER"] = "Redefinir Posição do Cronômetro"
  L["ONLY_PVP"] = " Mostrar cronômetro (apenas em PvP)"
end

if GetLocale() == "ruRU" then
  L["LOADED"] =
  "Загружено — откройте с помощью |cffFFFF00/pbs|r, |cffFFFF00/pbspec|r или |cffFFFF00/petbattlespectator|r"
  L["OPTIONS_TITLE"] = "Настройки Pet Battle Spectator"
  L["FONT_SIZE"] = "Размер шрифта: "
  L["FRAME_HEIGHT"] = "Высота окна (в строках): "
  L["SHOW_TIMER"] = "Показывать длительность лога: "
  L["SEC"] = "сек."
  L["BACKGROUND_OPACITY"] = "Прозрачность фона: "
  L["RESET_LOGS"] = "Сбросить положение логов"
  L["RESET_TIMER"] = "Сбросить положение таймера"
  L["ONLY_PVP"] = "Показывать таймер (только в PvP)"
end

if GetLocale() == "zhCN" then
  L["LOADED"] = "已加载 - 使用 |cffFFFF00/pbs|r、|cffFFFF00/pbspec|r 或 |cffFFFF00/petbattlespectator|r 打开"
  L["OPTIONS_TITLE"] = "宠物对战观战选项"
  L["FONT_SIZE"] = "字体大小: "
  L["FRAME_HEIGHT"] = "框架高度 (行数): "
  L["SHOW_TIMER"] = "显示记录持续时间: "
  L["SEC"] = "秒"
  L["BACKGROUND_OPACITY"] = "背景不透明度: "
  L["RESET_LOGS"] = "重置记录位置"
  L["RESET_TIMER"] = "重置计时器位置"
  L["ONLY_PVP"] = " 显示计时器 (仅限 PvP)"
end

if GetLocale() == "zhTW" then
  L["LOADED"] = "已載入 - 使用 |cffFFFF00/pbs|r、|cffFFFF00/pbspec|r 或 |cffFFFF00/petbattlespectator|r 開啟"
  L["OPTIONS_TITLE"] = "寵物對戰觀戰選項"
  L["FONT_SIZE"] = "字體大小："
  L["FRAME_HEIGHT"] = "幀高度（行）："
  L["SHOW_TIMER"] = "顯示日誌持續時間："
  L["SEC"] = "秒"
  L["BACKGROUND_OPACITY"] = "背景不透明度："
  L["RESET_LOGS"] = "重置日誌位置"
  L["RESET_TIMER"] = "重設計時器位置"
  L["ONLY_PVP"] = "顯示計時器（僅在 PvP 模式下）"
end
