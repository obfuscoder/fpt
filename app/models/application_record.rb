class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  before_validation :nilify_blank_values

  def nilify_blank_values
    attributes.each { |column, _| self[column] = nil if self[column].blank? }
  end
end
