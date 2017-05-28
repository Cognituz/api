class ClassAppointmentsMailer < ApplicationMailer
  def creation_notification(class_appointment)
    mail \
      to: class_appointment.teacher.email,
      subject: "[Cognituz.com] Clase ##{class_appointment.id}: pendiente de confirmación",
      body: "Clase ##{class_appointment.id}"
  end

  def confirmation_notification(class_appointment)
    mail \
      to: class_appointment.student.email,
      subject: "[Cognituz.com] Clase ##{class_appointment.id}: confirmada",
      body: "Clase ##{class_appointment.id}"
  end

  def cancelation_notification(class_appointment)
    mail \
      to: [
        class_appointment.teacher.email,
        class_appointment.student.email
      ],
      subject: "[Cognituz.com] Clase ##{class_appointment.id}: cancelada",
      body: "Clase ##{class_appointment.id}"
  end
end
