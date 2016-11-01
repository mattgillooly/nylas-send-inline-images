require 'nylas'
require 'active_support/core_ext/hash'

NYLAS_APP_KEY = '...'
NYLAS_APP_SECRET='...'
TOKEN = '...'
EMAIL = '...@...'

nylas = Nylas::API.new(NYLAS_APP_KEY, NYLAS_APP_SECRET, TOKEN)

dir = File.expand_path('../', __FILE__)
path = File.join(dir, 'Mickey_Mouse.png')
p path

file = nylas.files.build(file: File.new(path, 'rb'))
file.save!

p file

body = <<-BODY
<p>I hope you get this in-line image!</p>
<img src="cid:#{file.id}" />
<p>It should appear above here.</p>
BODY

draft = nylas.drafts.build(
  to: [{email: EMAIL}],
  subject: 'Testing In-line Images',
  body: body
)

draft.attach(file)
draft.save!

p draft

message = draft.send!

p message
