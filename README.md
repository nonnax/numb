Numb: non unified mapper, B)

```ruby
require 'numb'

Numb.new do

  get do
    res.write 'hello'
  end

  on '/:any' do
    res.redirect '/'
  end


end
```
