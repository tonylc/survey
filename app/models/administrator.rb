class Administrator < User
  def is_admin?
    return true
  end

  def is_family_reporter?
    return false
  end
end