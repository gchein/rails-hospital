import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="add-patients-to-room"
export default class extends Controller {
  static targets = [ 'patientCheckbox' ]
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
  }

  enableBlankCheckboxes() {
    this.patientCheckboxTargets.forEach((checkbox) => {
      if (!checkbox.checked) (checkbox.removeAttribute('disabled'))
    });
  }
}
