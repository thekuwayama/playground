SecureHeaders::Configuration.default do |config|
  gravatar = "secure.gravatar.com"
  subdomain = ENV['REPORT_URI_SUBDOMAIN']
  report_uri = "https://#{subdomain}.report-uri.com/r/d/csp/reportOnly"
  config.csp_report_only = {
    default_src: %w('self'),
    img_src: ["'self'", gravatar],
    script_src: %w('self'),
    report_uri: [report_uri],
  }
  config.csp = SecureHeaders::OPT_OUT
  config.hsts = SecureHeaders::OPT_OUT
  config.x_frame_options = SecureHeaders::OPT_OUT
  config.x_content_type_options = SecureHeaders::OPT_OUT
  config.x_xss_protection = SecureHeaders::OPT_OUT
  config.x_permitted_cross_domain_policies = SecureHeaders::OPT_OUT
end
