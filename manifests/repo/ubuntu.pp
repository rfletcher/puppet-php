# Configure ubuntu ppa
#
# === Parameters
#
# [*version*]
#   PHP version to manage (e.g. 5.6)
#
# [*ppa*]
#   Use a specific PPA, e.g "ondrej/php5-5.6" (without the "ppa:")
#
class php::repo::ubuntu (
  $version   = undef,
  $ppa       = undef,
) {
  include '::apt'

  if($version == undef) {
    $version_real = '5.5'
  } else {
    $version_real = $version
  }

  validate_re($version_real, '^\d\.\d')

  $version_repo = $version_real ? {
    '5.4' => 'ondrej/php5-oldstable',
    '5.5' => 'ondrej/php5',
    '5.6' => 'ondrej/php5-5.6',
    '7.0' => 'ondrej/php'
  }

  if ($version != undef and $ppa != undef) {
    fail('Only one of $version and $ppa can be specified.')
  }

  if ($ppa) {
    $safe_ppa = regsubst($ppa, '\/', '-')

    ::apt::key { '14AA40EC0831756756D7F66C4F4EA0AAE5267A6C': } ->
    ::apt::pin { $safe_ppa:
      originator => "LP-PPA-${safe_ppa}",
      priority   => 600,
    } ->
    ::apt::ppa { "ppa:${ppa}": }
  } else {
    ::apt::ppa { "ppa:${version_repo}": }
  }
}
