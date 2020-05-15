Gem::Specification.new do |s|
  s.name        = 'jwt_extended'
  s.version     = '0.1.3'
  s.date        = '2020-04-29'
  s.summary     = 'jwt_extend'
  s.description = 'A simple jwt gem for me'
  s.authors     = ['JeongWooYeong']
  s.email       = 'rubyonrails@kakao.com'
  s.files       = ['lib/jwt_base.rb']
  s.add_dependency('jwt', '~> 2.2.1')
  s.add_dependency('rails', '~>6.0.2')
  s.homepage    =
  s.license = 'MIT'
end