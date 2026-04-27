// Import and register all your controllers from the importmap via controllers/**/*_controller
import { Application } from "@hotwired/stimulus"

const application = Application.start()
application.debug = false
window.Stimulus = application

export { application }

import ScheduleController from "./schedule_controller"
application.register("schedule", ScheduleController)
