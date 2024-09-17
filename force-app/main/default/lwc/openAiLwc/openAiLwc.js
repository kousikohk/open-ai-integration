import { LightningElement, track } from 'lwc';
import getOpenAIResponse from '@salesforce/apex/OpenAIIntegration.getOpenAIResponse';

export default class OpenAiLwc extends LightningElement {
    @track prompt = ''; // To store user input prompt
    @track response = ''; // To store the response from OpenAI
    @track error = ''; // To handle any error messages

    // Handles changes in the prompt input
    handlePromptChange(event) {
        this.prompt = event.target.value;
    }

    // Calls the Apex method when the user clicks the button
    handleSubmit() {
        if (this.prompt) {
            getOpenAIResponse({ prompt: this.prompt })
                .then(result => {
                    this.response = result;
                    this.error = undefined;
                })
                .catch(error => {
                    this.error = error.body.message;
                    this.response = undefined;
                });
        } else {
            this.error = 'Please enter a prompt';
        }
    }
}
