module WeeAgent
  module Contact

    def free_agent_url
      "#{API.base_url}/contacts/#{find_or_create_free_agent_contact}"
    end

    private

    def find_or_create_free_agent_contact
      if free_agent_id.blank?
        create_free_agent_contact
      end
      free_agent_id
    end

    def create_free_agent_contact
      contact_response = HTTParty.post("#{API.base_url}/contacts",
        headers: API.headers,
        :query => {
          :contact => {
            :organisation_name => company_name,
            :first_name => first_name,
            :last_name => last_name,
            :email => email
          }
        }
      )
      unless contact_response.blank?
        self.free_agent_id = contact_response["contact"]["url"].split("/").last
        self.save
      end
    end
  end
end
