notify() {
	chatid=your_chat_id                         # Your chat id
	token=your_token_bot                        # Your Bot's token
	default_message="Hello,I am running perfectly!"

	if [ -z "$@" ]
	then
		curl -s --data-urlencode "text=$default_message" "https://api.telegram.org/bot$token/sendMessage?chat_id=$chatid" > /dev/null
	else
		# shellcheck disable=SC2145
		curl -s --data-urlencode "text=$@" "https://api.telegram.org/bot$token/sendMessage?chat_id=$chatid" > /dev/null
	fi
}

alias notify=notify
