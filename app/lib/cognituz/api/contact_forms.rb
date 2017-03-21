class Cognituz::API::ContactForms < Grape::API
  version :v1, using: :path

  resources :contact_forms do
    params do
      requires :contact_form, type: Hash do
        with type: String do
          requires :sender_email
          optional :subject
          optional :body
        end
      end
    end

    post { ContactForm.create declared(params).fetch(:contact_form) }
  end
end
