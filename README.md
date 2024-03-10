# GPTQuery
I've been working on a text based RPG using ChatGPT and I needed an easy to use GPT Interface, thus this script was born. It's quite usable, but needs a lot of polish that I'm not really focused on right now. I'm hoping someone can at least find this useful to start working with ChatGPT in Godot.

## Single Prompt
Here is a simple single prompt. We create a new query and send that query to ChatGPT with the desired callback function. 
![Simple Single Prompt](https://github.com/AdvAndInt/GPTQuery/assets/94275417/54df5ae5-9207-4259-a92a-eb48817a2a47)

This is the output in the Godot console.
![Simple Single Prompt Response](https://github.com/AdvAndInt/GPTQuery/assets/94275417/ccce6c1e-fc93-45bb-991d-9cd602e56bda)


## Modifying The Prompt
Note that you can modify the model and temperature of the query. 
![Modified Single Prompt](https://github.com/AdvAndInt/GPTQuery/assets/94275417/f3c88035-7043-430e-9f94-205f50dadc48)

![Modified Single Response](https://github.com/AdvAndInt/GPTQuery/assets/94275417/115db356-8b9f-4595-9728-02ec9632092e)


## Multi Prompt
Another thing you can do is create multiple queries from the same prompt. I'd imagine this would be useful if you did something like generate and return 10 random quest ideas, then send those ideas as another query and ask ChatGPT to pick the most creative one. I haven't used these too much, but I wanted to make sure the script was capable of it.
![Multi Prompt](https://github.com/AdvAndInt/GPTQuery/assets/94275417/f9ff9da7-e565-42f9-b2ba-dd8ffd2922f9)

The output from the multiprompt. Note that the content won't identify the query information, it's just the text from the LLM. 
![Multi Response](https://github.com/AdvAndInt/GPTQuery/assets/94275417/3f109184-a3f9-4f54-8dce-0965ab007107)

