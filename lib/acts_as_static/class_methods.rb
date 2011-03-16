module ActsAsStatic
  module ClassMethods
    def method_missing(method_name, *args)

      unless ActsAsStatic.member_classes[self.class_name].nil?
        acts_as_static_objects = ActsAsStatic.member_classes[self.class_name][:acts_as_static_objects]
      else
        return super
      end

      #for some reason i get weird behavior when I run this in staging/dev
      if RAILS_ENV != 'production' && found_object = find_static(method_name)
        found_object
      elsif !acts_as_static_objects[method_name].blank?
        acts_as_static_objects[method_name]
      elsif public_method_defined?(:caches) && acts_as_static_objects[method_name] = caches(:find_static, :with => method_name)
        acts_as_static_objects[method_name]
      elsif acts_as_static_objects[method_name] = find_static(method_name)
        acts_as_static_objects[method_name]
      else
        super
      end
    end


    private

    def find_static(search_string)
      acts_as_static_search_field = ActsAsStatic.member_classes[self.class_name][:acts_as_static_search_field]

      find(:first, :conditions => acts_as_static_search_field+"='"+search_string.id2name.gsub(/_/,' ')+"'")
    end
  end
end
