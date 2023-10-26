module TagDecorator
  extend ActiveSupport::Concern

  class_methods do
    def ransackable_attributes(auth_object = nil)
      ["created_at", "id", "name", "taggings_count", "updated_at"]
    end
  end
end

ActsAsTaggableOn::Tag.include TagDecorator
