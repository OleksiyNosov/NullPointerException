module EmailValidations
  extend ActiveSupport::Concern
  included do
    validate :email_check
  end

  private
  def email_check
    errors.add :email, 'is invalid' unless email&.match?(email_regex)
  end

  def email_regex
    /\A\s*([#{"^@\\s"}]{1,64})@((?:[-\p{L}\d]+\.)+\p{L}{2,})\s*\z/i
  end
end
