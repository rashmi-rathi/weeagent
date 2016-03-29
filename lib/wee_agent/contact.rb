module WeeAgent
  class Contact < API
    def create(organisation_name:, first_name:, last_name:, email:)
      response = request(
        verb: :post,
        path: 'contacts',
        query: contact_query(organisation_name, first_name, last_name, email)
      )
      response
    end

    private

    def contact_query(organisation_name, first_name, last_name, email)
      {
        contact: {
          organisation_name: organisation_name,
          first_name: first_name,
          last_name: last_name,
          email: email
        }
      }
    end
  end
end
