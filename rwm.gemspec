Gem::Specification.new {|g|
    g.name          = 'rwm'
    g.version       = '0.0.1.alpha.1'
    g.author        = 'shura'
    g.email         = 'shura1991@gmail.com'
    g.homepage      = 'http://github.com/shurizzle/rwm'
    g.platform      = Gem::Platform::RUBY
    g.description   = 'Simple ruby written windows manager'
    g.summary       = g.description.dup
    g.files         = Dir.glob('lib/**/*')
    g.require_path  = 'lib'
    g.executables   = ['rwm']
    g.has_rdoc      = true

    g.add_dependency('ffi')
}
