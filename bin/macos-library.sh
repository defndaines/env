###
# Functions that only make sense on a macos machine.

function alert() {
  say -v Kyoko "終わったよ"
  say -v Moira "Well ... that went well."
  osascript -e 'tell application "Finder" to display dialog "DONE!"'
}

# Open a man page as a PDF in Preview
function postman() {
  man -t $1 | open -f -a Preview.app
}
