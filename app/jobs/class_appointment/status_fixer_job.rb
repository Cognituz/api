class ClassAppointment::StatusFixerJob < ApplicationJob
  queue_as :default

  def perform(class_appointment)
    class_appointment.fix_status!
  end
end
