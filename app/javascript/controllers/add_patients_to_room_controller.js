import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="add-patients-to-room"
export default class extends Controller {
  static targets = [ 'patientCheckbox', 'errorMessagesDiv' ]
  static values = {
    spotsInRoom: Number
  }

  connect() {
  }

  checkSpotsInRoom(event) {
    const clickedCheckbox = event.currentTarget

    if (clickedCheckbox.checked) {
      this.spotsInRoomValue -= 1

      if (this.spotsInRoomValue === 0) (this.disableBlankCheckboxes())

    } else {
      if (this.spotsInRoomValue === 0) (this.enableBlankCheckboxes())

      this.spotsInRoomValue += 1
    }
  }

  disableBlankCheckboxes() {
    this.patientCheckboxTargets.forEach((checkbox) => {
      if (!checkbox.checked) (checkbox.setAttribute('disabled', true))
    });

    const errorMessages = ["Room capacity reached!"]
    this.displayErrorMessages(errorMessages)
  }

  enableBlankCheckboxes() {
    this.patientCheckboxTargets.forEach((checkbox) => {
      if (!checkbox.checked) (checkbox.removeAttribute('disabled'))
    });

    this.clearErrorMessages()
  }

  displayErrorMessages(errorMessages = []) {
    let errorStringParams = {}
    errorMessages.forEach ((message, index) => {
        errorStringParams[`error_${index + 1}`] = message
    });

    const errorString = this.setQueryString(errorStringParams)

    const url = `${location.pathname}?${errorString}`
    const options = {
      headers: { "Accept": "application/json" }
    }

    fetch(url, options)
      .then(response => response.json())
      .then((data) => {
        this.errorMessagesDivTarget.innerHTML = data['errorMessages=']
      })
  }

  setQueryString(queryStringParams = {}) {
    const searchParams = new URLSearchParams("");

    Object.entries(queryStringParams).forEach (([key, value] ) => {
      searchParams.append(key, value);
    });

    return `${searchParams.toString()}`
  }

  clearErrorMessages() {
    this.errorMessagesDivTarget.childNodes.forEach((child) => {
      this.errorMessagesDivTarget.removeChild(child)
    })
  }
}
