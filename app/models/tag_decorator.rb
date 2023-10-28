module TagDecorator
  extend ActiveSupport::Concern

  class_methods do
    # rubocop:disable Airbnb/OptArgParameters

    def ransackable_attributes(auth_object = nil)
      ["created_at", "id", "name", "taggings_count", "updated_at"]
    end

    # rubocop:enable Airbnb/OptArgParameters
  end
end

ActsAsTaggableOn::Tag.include TagDecorator
