use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'CTT',
    AUTHOR              => q{Bruno Martins <bscmartins@gmail.com>},
    VERSION_FROM        => 'lib/CTT.pm',
    ABSTRACT_FROM       => 'lib/CTT.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'CTT-*' },
);
