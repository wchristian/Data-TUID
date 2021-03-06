use inc::Module::Install;

name     'Data-TUID';
all_from 'lib/Data/TUID.pm';
author   'Robert Krimen <rkrimen@cpan.org>';
license  'perl';

resources repository => 'http://github.com/robertkrimen/Data-TUID/tree/master';

{
    require ExtUtils::MakeMaker;
    use strict;
    no strict 'refs';

    my $libscan = \&{"ExtUtils::MM_Any::libscan"};
    *{"ExtUtils::MM_Any::libscan"} = sub {
        return '' unless $libscan->(@_);
        return '' if $_[1] =~ /\.sw[p-z]$/;
        return $_[1];
    };
}

{
    map { my ($pk, $vr) = split m/\s/; build_requires $pk => $vr || 0 } grep { ! /^\s*#/ } split m/\n/, <<_END_;
Test::Most
_END_

    map { my ($pk, $vr) = split m/\s/; requires $pk => $vr || 0 } grep { ! /^\s*#/ } split m/\n/, <<_END_;
Encode::Base32::Crockford
_END_

    features(
        'LibUUID support (for systems where it can be compiled)' => [
            -default => 1,
            recommends( 'Data::UUID::LibUUID' => '0' ),
        ],
        'fallback Data::UUID support (everywhere else)' => [
            -default => 0,
            recommends( 'Data::UUID' => '0' ),
        ],
    );

}

if (-e 'inc/.author') {
    my $all_from = join '/', 'lib', split m/-/, name . '.pm';
    `perldoc -tF $all_from > README` if ! -e 'README' || (stat $all_from)[9] > (stat 'README')[9];
}

auto_install;

WriteAll;

