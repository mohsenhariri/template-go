### API ###
ping:
		$(CURL) $(URL)/ping

endpoint-post:
		$(CURL) $(URL)/route/post \
			--include \
			--header "Content-Type: application/json" \
			--request "POST" \
			--data '{"key": "value"}'
            
endpoint-get:
		$(CURL) $(URL)/route/get

endpoint-cookie:
		curl -v --cookie "name=value" $(URL)/cookie

