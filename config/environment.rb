# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Fortysquires::Application.initialize!

require 'foursquare'
OAUTH_KEY = 'COEZLURWYDIFG5D4UQ0GLONWSBHY5H1WSUHOLP5ERQLWHFKN'
OAUTH_SECRET = '0RGTST5U30VXNWPMHXYSD4WFBJB5SUIC2MRZPB1IYMKVU3TL'

require 'digest/sha1'
require 'andand'
