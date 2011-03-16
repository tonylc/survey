class FamilyReporter < User
  belongs_to :family

  def is_family_reporter?
    return true
  end
end