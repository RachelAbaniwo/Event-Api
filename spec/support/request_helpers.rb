module RequestHelpers
  def json
    JSON.parse(response.body)
  end

  def get_entries(entry)
    entries = {
      valid_new_user: { name: 'Lily Grant', email: 'lily.grant@gmail.com', password: 'lilygrant' },
      missing_name: { email: 'lily.grant@gmail.com', password: 'lilygrant' },
      missing_email: { name: 'Lily Grant', password: 'lilygrant' },
      missing_password: { name: 'Lily Grant', email: 'lily.grant@gmail.com' },
      invalid_email_new_user: { name: 'Lily Grant', email: 'lily.com', password: 'lilygrant' },
      invalid_password: { name: 'Lily Grant', email: 'lily.grant@gmail.com', password: 'lily' },
      sign_in_user: { email: 'lily.grant@gmail.com', password: 'lilygrant' },
      wrong_password: { email: 'lily.grant@gmail.com', password: 'lilygranny' },
      wrong_email: { email: 'mike.grant@gmail.com', password: 'lilygrant' },
      no_email_sign_in: { password: 'lilygrant' },
      no_password_sign_in: { email: 'lily.grant@gmail.com' }
    }
    entries[entry.to_sym]
  end

end