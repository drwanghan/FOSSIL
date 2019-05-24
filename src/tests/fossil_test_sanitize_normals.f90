!< FOSSIL, test normals *sanitization*.

program fossil_test_sanitize_normals
!< FOSSIL, test normals *sanitization*.

use flap, only : command_line_interface
use fossil, only : file_stl_object, surface_stl_object
use penf, only : I4P, R8P

implicit none

type(file_stl_object)    :: file_stl            !< STL file.
type(surface_stl_object) :: surface             !< STL surface.
character(999)           :: file_name_stl       !< Input STL file name.
logical                  :: are_tests_passed(2) !< Result of tests check.

are_tests_passed = .false.

call cli_parse
call file_stl%load_from_file(facet=surface%facet, file_name=trim(adjustl(file_name_stl)), guess_format=.true.)
call surface%analize

print*, 'volume before sanitize normals: ', surface%volume
are_tests_passed(1) = surface%volume <= 0._R8P
call surface%sanitize_normals
call surface%compute_volume
print*, 'volume after sanitize normals:  ', surface%volume
are_tests_passed(2) = nint(surface%volume) == 1

print '(A,L1)', 'Are all tests passed? ', all(are_tests_passed)
contains
  subroutine cli_parse()
  !< Build and parse test cli.
  type(command_line_interface) :: cli   !< Test command line interface.
  integer(I4P)                 :: error !< Error trapping flag.

  call cli%init(progname='fossil_test_sanitize_normals',                              &
                authors='S. Zaghi',                                                   &
                help='Usage: ',                                                       &
                examples=["fossil_test_sanitize_normals --stl src/tests/dragon.stl"], &
                epilog=new_line('a')//"all done")

  call cli%add(switch='--stl',                        &
               help='STL (input) file name',          &
               required=.false.,                      &
               def='src/tests/cube-inconsistent.stl', &
               act='store')

  call cli%parse(error=error) ; if (error/=0) stop

  call cli%get(switch='--stl', val=file_name_stl, error=error) ; if (error/=0) stop
  endsubroutine cli_parse
endprogram fossil_test_sanitize_normals
