# frozen_string_literal: true

module DBotQuery
  module Models
    # A reference.  This is a link to some information such as a CVE or a security advisory's URL.
    class Reference < Base
      attribute :url, :url
      alias_attribute :id, :url
    end
  end
end
