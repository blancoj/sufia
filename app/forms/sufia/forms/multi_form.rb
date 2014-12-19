module Sufia::Forms
  module MultiForm
    extend ActiveSupport::Concern
    included do
      class_attribute :required_fields
    end

    def initialize(model)
      super
      initialize_fields
    end

    def required?(key)
      required_fields.include?(key)
    end

    def [](key)
      @attributes[key.to_s]
    end

    def []=(key, value)
      @attributes[key.to_s] = value
    end

    module ClassMethods
      def model_attributes(form_params)
        clean_params = form_params.dup
        terms.each do |key|
          if clean_params[key] == ['']
            clean_params[key] = []
          end
        end
        clean_params
      end
    end

    protected
      # override this method if you need to initialize more complex RDF assertions (b-nodes)
      def initialize_fields
        @attributes = model.attributes
        terms.select { |key| self[key].blank? }.each do |key|
          # if value is empty, we create an one element array to loop over for output
          if self.class.multiple?(key)
            self[key] = ['']
          else
            self[key] = ''
          end
        end
      end
  end
end