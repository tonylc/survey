require 'acts_as_static/class_methods'

module ActsAsStatic
  mattr_accessor :member_classes

  def self.setup
    #p "acts as static setup"
    @@member_classes = Hash.new
  end

  module Mixin
    def acts_as_static(search_field = "name")
      #p "#{self.class_name} initializing acts_as_static"

      initialize_member_acts_as_static_class(search_field)

      extend ClassMethods
    end

    private

    def initialize_member_acts_as_static_class(search_field)
      ActsAsStatic.member_classes[self.class_name] ||= member_class_attributes(search_field)
    end

    def member_class_attributes(search_field)
      { :acts_as_static_search_field => search_field,
        :acts_as_static_objects => Hash.new}
    end
  end
end
