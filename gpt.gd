extends Node

# Default values for a new query
var default_engine = "gpt-3.5-turbo-0125"
var default_temp: float = 0.5
var default_max_tokens: int = 1024

# List of HTTP objects
var http_pool = {}
var api_key
var headers
var url

# Logs the sent and received GPT messages in the Godot console
var VERBOSE_LOGGING = false

func _ready():
	
	# Load the API key from a file, excluded from GIT repo
	api_key = FileAccess.open("res://apikey.txt", FileAccess.READ).get_as_text()
	headers = ["Content-Type: application/json", "Authorization: Bearer " + api_key]
	url = "https://api.openai.com/v1/chat/completions"

# Sends a query data block to chatGPT and returns to the given callback function
func send(query_data, callback_func) -> void:

	# Save the name of the query, we use this a few times down the road
	var query_name = query_data.name

	# If we already have a query in the HTTP pool for that name, we're waiting for GPT response
	# TODO: Implement a max wait time check to see if ChatGPT is having issues, then resend the chat
	if(http_pool.has(query_name)):
		print("WARNING: Trying to send a new query that is already in procses!")
		return

	# Lambda for the receiving function
	var recv = func(result, response_code, response_headers, body):

		# Received a valid response
		if response_code == 200:

			# Process and log the raw response
			var raw_response = body.get_string_from_utf8()

			if VERBOSE_LOGGING:		
				print("")
				print("Received Response:")
				print(raw_response)
				print("")

			# Parse the JSON data
			var json = JSON.new()
			json.parse(raw_response)
			var response = json.get_data()

			# Extract the response text for our return var
			var return_content = response.choices[0].message.content

			# Create a new message and add it to the query data
			var new_message = {"role": "assistant", "content": return_content}
			query_data.messages.append(new_message)

			# Update the total token number
			query_data.total_tokens += response.usage.total_tokens
			
			# Save the query to the disk
			save(query_data)

			# Return to the original call back, giving the returned content
			callback_func.call(return_content)

		# Not a valid response
		else:
			
			# Error with HTTP response code
			print("ERROR! - Bad GPT Response: " + response_code)

		# Remove the HTTP object from the tree and erase from dict
		http_pool[query_name].queue_free()
		http_pool.erase(query_name)

		return #End of Receive Lambda 

	# Add the new HTTP bundle thingy to the dict
	http_pool[query_name] = HTTPRequest.new()
	self.add_child(http_pool[query_name])
	http_pool[query_name].connect("request_completed", recv)

	# Encode the query data into a ChatGPT expected format
	var body = JSON.stringify({
		"messages": query_data.messages,
		"temperature": query_data.temp,
		"max_tokens": query_data.max_tokens,
		"model": query_data.model
	})

	# Log the send
	# TODO: Better logging, possibly after we receive error
	if VERBOSE_LOGGING:		
		print("")
		print("Sending Query:")
		print(body)
		print("")

	# Send it, getting an error code
	var error = http_pool[query_name].request(url, headers, HTTPClient.METHOD_POST, body)
	
	# TODO : Eventually allow application level logging for general query errors
	if error != 0:
		print("Http Error Code: ", error)

# Saves the query to local disk
func save(query_data):

	# The name of the saved query data file
	var file_name = "user://" + query_data.name + ".json"
	
	# Delete the previous save file, there can be only one.
	if(FileAccess.file_exists(file_name)):
		DirAccess.remove_absolute(file_name)
	
	# Open a file handle, convert the text to a string, and store the string in the file
	var file = FileAccess.open(file_name, FileAccess.WRITE)
	var json_string = JSON.stringify(query_data)
	file.store_line(json_string)

# ================== #
# TEMPLATE FUNCTIONS #
# ================== #

# Quick template for a user prompt
func prompt(query_data, prompt):
	
	var new_message = {"role": "user", "content": prompt}
	query_data.messages.append(new_message)

# Used to pull a quick standard template for a query
func new(query_name, initial_prompt):
	
	var new_query = {
		"name" : query_name,
		"messages" : [{"role": "system", "content": initial_prompt}],
		"model" : default_engine,
		"temp" : default_temp,
		"max_tokens" : default_max_tokens,
		"total_tokens" : 0
	}
	
	return new_query
	
