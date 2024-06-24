# Mode is shown before `fish_prompt`
# Non-empty mode will break line before `fish_prompt`
function fish_mode_prompt
	#fish_default_mode_prompt
end
function fish_prompt --description 'Write out the prompt'
	set -l last_pipestatus $pipestatus

	set -l ucolor brblue
	if functions -q fish_is_root_user; and fish_is_root_user
		set -l ucolor brred
	end

	set -l color \
		"$ucolor" \
		brblack   \
		yellow    \
		brblack   \
		brgreen   \
		brblack   \
		brblue


	set -l line_len \
		(string length "$USER")         \
		(string length '@')             \
		(string length "$hostname")     \
		(string length ":")             \
		(string length "$(prompt_pwd)")
	set -l empty_len (math $(stty size | cut -d ' ' -f2) - $(string join '-' $line_len) - (string trim "$(fish_vcs_prompt)" | string length))
	set -l line_len $line_len "$empty_len" (string trim "$(fish_vcs_prompt)" | string length)

	set -l prompt \
		"$USER" \
		"@" \
		"$hostname" \
		":" \
		"$(prompt_pwd)"
	set -l prompt $prompt "$(string repeat -Nn $empty_len ' ')" (string trim "$(fish_vcs_prompt)")

	for i in (seq (count $color))
		if test "$color[$i]" = "brblack"
			set_color "$color[$i]"
		else
			set_color --dim --bold "$color[$i]"
		end
		string repeat -Nn "$line_len[$i]" '_'
		set_color normal
	end

	echo

	for i in (seq (count $color))
		if test "$color[$i]" = "brblack"
			set_color "$color[$i]"
		else
			set_color --dim "$color[$i]"
		end
		echo -n "$prompt[$i]"
		set_color normal
	end

	echo

	set_color --italics brblack
	if test -n "$(string replace -a ' ' '' $last_pipestatus | string join '' | string trim -c 0)"
		echo -n -s "[$(string join '|' $last_pipestatus)]"
	end

	set -l suffix '>'
	if functions -q fish_is_root_user; and fish_is_root_user
		set -l suffix '#'
	end
	echo -n -s "$suffix" ' '
	set_color normal
end
