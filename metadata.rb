name             'backend'
maintainer       'Alaa Qutaish'
maintainer_email 'alaa.qutaish@gmail.com'
license          'All rights reserved'
description      'Installs/Configures backend'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'base', '~> 0.1.0'
depends 'nginx', '~> 2.7.4'
depends 'unicorn', '~> 2.0.0'
