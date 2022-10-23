# cookies in Rails

## Plain text: 

- These cookies can be viewed and changed by a user.
```rb
def show
  cookies[:welcome_message_shown] = "true"
end
```
- will add a `Set-Cookie` **HTTP header** to the response; with the value `welcome_message_shown=true`

## Signed: 

- Signed cookies look like gibberish but they can easily be decoded by a user although they can't be modified as they are cryptographically signed. 
- Rails uses the **`ActiveSupport::MessageVerifier`** API to encode and sign the cookie data.
- can also be read in JavaScript 

```rb
def show
  cookies.signed[:user_id] = "42"
end
### "eyJfcmFpbHMiOnsibWVzc2FnZSI6IklqUXlJZz09IiwiZXhwIjpudWxsLCJwdXIiOiJjb29raWUudXNlcl9pZCJ9fQ%3D%3D--94afbf4575daf37313f40d6342a994a5e1719d79"
```
- two parts to this string 
- they're separated by the `--`.
  - The first part is a Base64 encoded JSON object containing the value we stored 
  - the second part is a cryptographically generated digest. 

- When Rails receives a signed cookie, it compares the value to the digest and if they don't match, the cookie's value will set as `nil`


### Decoding signed cookies

```rb
cookie = cookies.signed[:user_id] = "42"
cookie_value = URI.unescape(cookie.split("--").first)
cookie_payload = JSON.parse Base64.decode64(cookie_value)

# cookie_payload = { 
#   "_rails"=> {
#     "message"=>"IjQyIg==", 
#     "exp"=>nil, 
#     "pur"=>"cookie.user_id"
#   }
# }

#  The message is also a `Base64 encoded` JSON object so we decode it the same way as above:

decoded_stored_value = Base64.decode64 cookie_payload["_rails"]["message"]
stored_value = JSON.parse decoded_stored_value # => "42"

```

#### in JavaScript

```js
let cookie = "eyJfcmFpbHMiOnsibWVzc2FnZSI6IklqUXlJZz09IiwiZXhwIjpudWxsLCJwdXIiOiJjb29raWUudXNlcl9pZCJ9fQ%3D%3D--94afbf4575daf37313f40d6342a994a5e1719d79"
let cookie_value = unescape(cookie.split("--")[0])
let cookie_payload = JSON.parse(atob(cookie_value))

let decoded_stored_value = atob(cookie_payload._rails.message)
let stored_value = JSON.parse(decoded_stored_value)

console.log(stored_value) // => "42"
```

- we can store any JSON serializable object 
- However to store other kinds of objects, it needs to be placed in a Hash with the key value.

```rb
def show
cookies.signed[:preferences] = { 
  value: {
    use_dark_mode: true
  }
}
end
```

### How the digest is computed
-  calculated using `OpenSSL` with the `SHA1` hash function as the default
  - updated `config.action_dispatch.signed_cookie_digest` in `applicatoin.rb`

- secret is also calculated using `OpenSSL` 
  - is based on the `secret_key_base` that you find in your credentials.yml 
  - another string called a `salt`. 
    - By default the salt is `"signed cookie"`, but it can be changed by setting `config.action_dispatch.signed_cookie_salt`.

```rb
cookie = "eyJfcmFpbHMiOnsibWVzc2FnZSI6IklqUXlJZz09IiwiZXhwIjpudWxsLCJwdXIiOiJjb29raWUudXNlcl9pZCJ9fQ%3D%3D--94afbf4575daf37313f40d6342a994a5e1719d79"
cookie_value = URI.unescape(cookie.split("--").first)

secret = Rails.application.secret_key_base
key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(secret, "signed cookie", 1000, 64)
digest = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.const_get("SHA1").new, key, cookie_value)  # => "94afbf4575daf37313f40d6342a994a5e1719d79"

digest == cookie.split("--").second  # => true
```

-  Rails uses **`ActiveSupport::KeyGenerator`** and **`ActiveSupport::MessageVerifier`** to abstract away the OpenSSL functions.


## Encrypted: 
- Encrypted cookies can't be decoded by a user (not easily, anyway) 
- nor can they be modified as they are authenticated at the time of decryption.


- Encrypted cookies are serialized in the same way as signed cookies 
- they're encrypted using **`ActiveSupport::MessageEncryptor`** (which uses OpenSSL under the hood). 

```rb
def show
  cookies.encrypted[:remember_token] = "token"
end

"aDkxgmW4kaxoXBGnjxAaBY7D47WUOveFdeai5kk2hHlYVqDo7xtzZJup5euTdH5ja5iOt37MMS4SVXQT5RteaZjvpdlA%2FLQi7IYSPZLz--2A6LCUu%2F5AsLfSez--QD%2FwiA2t8QQrKk6rrROlPQ%3D%3D"
```

- divided into 3 parts separated by `--`, 
- All three parts are Base64 encoded.

1. 1st part is the **encrypted data**. 
2. 2nd part is the **initialization vector**
   - which is a random input to the encryption algorithm. 
3. 3rd part is an **authentication tag**, which is similar to the digest of a signed cookie. 

---

- default, cookies are encrypted with `AES` using a 256-bit key in `Galois/Counter Mode` (`aes-256-gcm`). 
- This can be changed by setting **`config.action_dispatch.encrypted_cookie_cipher`** to any valid `OpenSSL::Cipher` algorithm.

### Decrypting encrypted cookies
- The cookie is encrypted with a key that's generated in the same way as the key used to calculate the digest of a signed cookie.
- we'll need the application's `secret_key_base` to be able to decrypt the cookie

- By default, the salt is `"authenticated encrypted cookie"` 
  - but it can be changed by **`setting config.action_dispatch.authenticated_encrypted_cookie_salt`**.

```rb
cookie = "aDkxgmW4kaxoXBGnjxAaBY7D47WUOveFdeai5kk2hHlYVqDo7xtzZJup5euTdH5ja5iOt37MMS4SVXQT5RteaZjvpdlA%2FLQi7IYSPZLz--2A6LCUu%2F5AsLfSez--QD%2FwiA2t8QQrKk6rrROlPQ%3D%3D"
cookie = URI.unescape(cookie)
data, iv, auth_tag = cookie.split("--").map do |v| 
  Base64.strict_decode64(v)
end
cipher = OpenSSL::Cipher.new("aes-256-gcm")

# Compute the encryption key
secret_key_base = Rails.application.secret_key_base
secret = OpenSSL::PKCS5.pbkdf2_hmac_sha1(secret_key_base, "authenticated encrypted cookie", 1000, cipher.key_len)

# Setup cipher for decryption and add inputs
cipher.decrypt
cipher.key = secret
cipher.iv  = iv
cipher.auth_tag = auth_tag
cipher.auth_data = ""

# Perform decryption
cookie_payload = cipher.update(data)
cookie_payload << cipher.final
cookie_payload = JSON.parse cookie_payload
# => {"_rails"=>{"message"=>"InRva2VuIg==", "exp"=>nil, "pur"=>"cookie.remember_token"}}

# Decode Base64 encoded stored data
decoded_stored_value = Base64.decode64 cookie_payload["_rails"]["message"]
stored_value = JSON.parse decoded_stored_value
# => "token"
```

## Lifetime of a Cookie
- By default, a cookie expires with the browser's "session"
- made to persist between sessions
```rb
def show
  cookies[:welcome_message_shown] = {
    value: "true",
    expires: 7.days
  }
end

#### special permanent cookie which sets the expiry date for 20 years in the future. ####

def show
  cookies.permanent[:welcome_message_shown] = "true"
end

#### Signed and encrypted cookies can be chained with the permanent type ####

def show
  cookies.signed.permanent[:user_id] = "42"
end

def show
  cookies.encrypted.permanent[:remember_token] = "token"
end
```

## special session cookie
- Rails provides a session cookie
- encrypted cookie and stores the user's data in a Hash
- Rails stores Flash data in the session cookie.

```rb
def create
  session[:auth_token] = "token"
end
```