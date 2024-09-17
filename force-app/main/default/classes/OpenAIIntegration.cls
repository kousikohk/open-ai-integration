public class OpenAIIntegration {
    private static final String OPENAI_NAMED_CREDENTIAL = 'callout:OpenAI'; // Reference to the Named Credential
    
    @AuraEnabled
    public static String getOpenAIResponse(String prompt) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(OPENAI_NAMED_CREDENTIAL + '/v1/completions');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');

        String body = '{"model": "gpt-4", "prompt": "' + prompt + '", "max_tokens": 100}';
        request.setBody(body);

        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() == 200) {
            // Deserialize the response body
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

            // Extract the 'choices' array and cast it as a list
            List<Object> choices = (List<Object>) responseMap.get('choices');

            if (choices != null && !choices.isEmpty()) {
                // Get the first object from the list and cast it to a map
                Map<String, Object> choice = (Map<String, Object>) choices[0];

                // Return the 'text' field from the first choice
                return (String) choice.get('text');
            } else {
                return 'No response from OpenAI';
            }
        } else {
            return 'Error: ' + response.getStatus();
        }
    }
}