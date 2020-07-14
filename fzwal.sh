#/bin/sh 

# TODO:
# - [ ] Clean up escaping
# - [ ] Go through wal flags and set where needed
# - [ ] Add ability to use multiple flags at the same time
# - [ ] Add the ability to curl a directory of themes and FZF through them. Then create 
    # a repsoitory for themes that people can upload to. 
# - [ ] Do I need to create a variable and then set the them again? I am assuming this is to prevent 
    # i3 etc from reloading everytime. 
# - [ ] Add a better Help Message
# - [ ] Make the default case better by including part(s) of the help message
# - [ ] Ensure cross compatibility between bsd(macOS)/linux

# Save Current Theme 
cp -f ~/.cache/wal/colors.json /tmp/fzwal-backup.json

if [ $# -eq 0 ]; then
  THEME=$(wal --theme | 
      sed '/Light Themes/,$d' | 
      sed -e 's/ - //' -e '/:$/d' -e 's/(.*)//' |
      fzf --preview='wal -qet --theme {} && wal --preview')
  wal -q --theme $THEME
  exit 0
else 
  case "$1" in
    -h|--help)
      # Write a better help to clearly seperate flags and their usage. Look at other helps as a guide. 
      echo "This application shows a preview of pywal's built-in dark themes by defualt.For light themes please use the -l or --light flag. You can also display saved themes in a given directory with the -d or --directory flag. If you would like to display a random theme please use the --random_dark or --random_light flags."
      exit 0
      ;;
    -l|--light)
      THEME=$(wal --theme |
        sed '1,/Light Themes/d;/Extra/,$d' |
        sed -e 's/ - //' -e '/:$/d' -e 's/(.*)//' |
        fzf --preview='wal -qetl --theme {} && wal --preview')
      wal -ql --theme $THEME
      exit 0 
      ;;
    --random_dark)
      wal -qet --theme random_dark
      exit 0
      ;;
    --random_light)
      wal -qetl --theme random_light
      exit 0 
      ;;
    --directory|-d)
      THEME=$(/bin/ls ''"$2"''|
        fzf --preview='echo '"$2"'{} && wal -qet --theme '"\"$2\""'{} && wal --preview')
      echo "'$2$THEME'"  
      wal --theme "$2""$THEME"
      exit 0
      ;;
    *)
      # Add Help Text
      echo "Unknown Command"
      exit 0 
      ;; 
  esac
fi
