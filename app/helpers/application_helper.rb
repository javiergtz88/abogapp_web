module ApplicationHelper
  def site_name
    'AppLeyes'
  end

  def site_url
    if Rails.env.production?
      # Place your production URL in the quotes below
      'http://appleyes.dev'
    else
      # Our dev & test URL
      'http://www.example.com/'
    end
  end

  def meta_author
    # Change the value below between the quotes.
    'Mexducando SA de CV'
  end

  def meta_description
    # Change the value below between the quotes.
    'AppLeyes description: Add your website description here'
  end

  def meta_keywords
    # Change the value below between the quotes.
    'AppLeyes App Leyes Mexducando'
  end

  # Returns the full title on a per-page basis.
  # No need to change any of this we set page_title and site_name elsewhere.
  def full_title(page_title)
    if page_title.empty?
      site_name
    else
      "#{page_title} | #{site_name}"
    end
  end
end
