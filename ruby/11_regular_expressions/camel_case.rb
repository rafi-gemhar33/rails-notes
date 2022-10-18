str = "CamelCasedString"
re = %r{[A-Z][a-z0-9]+}

p str.scan(re).join("_").downcase