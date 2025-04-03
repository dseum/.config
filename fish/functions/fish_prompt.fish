function fish_prompt
    set -l cols (tput cols)
    echo (string repeat -n "$cols" "─")
    echo -n (set_color cyan -o)(prompt_pwd)\n(set_color normal)(set_color black -b white)" $(whoami) "(set_color normal)(set_color white)" "(set_color normal)
end
