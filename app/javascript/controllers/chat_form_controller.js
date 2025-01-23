import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["chatMessageInput", "loadingIcon", "submitIcon", "form", "submitButton"]

  connect() {
    this.chatMessageInputTarget.focus();
  }

  submit(event) {
    event.preventDefault()
    this.submitButtonTarget.disabled = true
    const message = this.chatMessageInputTarget.value.trim()
    if (message === "") {
      this.chatMessageInputTarget.focus();
      return;
    } 
    
    // Show loading state
    this.submitIconTarget.classList.add("hidden")
    this.loadingIconTarget.classList.remove("hidden")
    
    // Submit the form
    this.formTarget.requestSubmit()
    
    this.chatMessageInputTarget.value = ""
    this.chatMessageInputTarget.focus();
  }

  submitEnd() {
    this.submitButtonTarget.disabled = false
    this.submitIconTarget.classList.remove("hidden")
    this.loadingIconTarget.classList.add("hidden")
  }

  openModal() {
    this.element.classList.remove("hidden");
  }

  closeModal() {
    this.element.classList.add("hidden");
  }
} 