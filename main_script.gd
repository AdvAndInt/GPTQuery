extends Node

@onready var gpt = $GPT

func _ready():
	simple_single_query()
	# modified_simple_query()
	# multi_query()

	pass
	
# Create a new query, passing a query name and the initial prompt
func simple_single_query():

	var query = gpt.new("JokeQuery","Tell me a short oneliner joke.")
	gpt.send(query, simple_single_query_callback)
	print(query)

func simple_single_query_callback(content):
	print(content)
	
	
	
func modified_simple_query():
	
	var query = gpt.new("JokeQuery","Tell me a short oneliner joke.")
	
	# You can change the model or temperature of the query
	query.model = "gpt-4"
	query.temp = 0.8
	
	gpt.send(query, modified_simple_query_callback)	
	print(query)
	
func modified_simple_query_callback(content):
	print(content)


# Creates 10 queries from a single prompt
func multi_query():
	
	var num_of_queries = 10	
	for i in range(num_of_queries):		
		var query_name = "MultiQuery" + str(i)		
		var query = gpt.new(query_name,"Tell me a short oneliner joke.")
		
		# Scale the temp
		query.temp = i * 0.1
		
		# Send the query to ChatGPT and provide the callback
		gpt.send(query, multi_query_callback)

# Prints each of multi queries
func multi_query_callback(content):
	print(content)
