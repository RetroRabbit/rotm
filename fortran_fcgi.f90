!
! Fortran FastCGI stack
! Based on Fortran FastCGI by Ricolindo.Carino@gmail.com and arjen.markus895@gmail.com
!
! Requires:
!    - the FLIBS modules cgi_protocol and fcgi_protocol
!    - the FastCGI library
! See 'readme' for setup instructions
!

program test_fcgi

  use fcgi_protocol
  use jade
  use rotm

  implicit none

  type(DICT_STRUCT), pointer  :: dict => null() ! Initialisation is important!
  logical                     :: stopped = .false. ! set to true in respond() to terminate program
  integer                     :: unitNo ! unit number  for a scratch file

  ! open scratch file
  open(newunit=unitNo, status='scratch')
  ! comment previous line AND uncomment next line for debugging;
  !open(newunit=unitNo, file='fcgiout', status='unknown') ! file 'fcgiout' will show %REMARKS%

  ! wait for environment variables from webserver
  do while (fcgip_accept_environment_variables() >= 0)

      ! build dictionary from GET or POST data, environment variables
      call fcgip_make_dictionary( dict, unitNo )

      ! give dictionary to the user supplied routine
      ! routine writes the response to unitNo
      ! routine sets stopped to true to terminate program
      call respond(dict, unitNo, stopped)

      ! copy file unitNo to the webserver
      call fcgip_put_file( unitNo, 'text/html' )

      ! terminate?
      if (stopped) exit

  end do !  while (fcgip_accept_environment_variables() >= 0)

  ! before termination, it is good practice to close files that are open
  close(unitNo)

  ! webserver will return an error since this process will now terminate
  unitNo = fcgip_accept_environment_variables()


contains
  subroutine respond ( dict, unitNo, stopped )

      type(DICT_STRUCT), pointer        :: dict
      integer, intent(in)               :: unitNo
      logical, intent(out)              :: stopped

      ! the following are defined in fcgi_protocol
      !character(len=3), parameter :: AFORMAT = '(a)'
      !character(len=2), parameter :: CRLF = achar(13)//achar(10)
      !character(len=1), parameter :: NUL = achar(0)

      ! retrieve params from model and pass them to view
      character(len=50), dimension(10,2) :: pagevars
      character(len=50), dimension(8) :: name, email

      ! the script name
      logical :: canContinue
      character(len=80)  :: scriptName, query
      character(len=12000) :: templatefile

      logical                           :: okInputs
      integer                           :: counter

      character(len=50) :: item, description, reference
      real :: amount

      ! start of response
      ! lines starting with %REMARK% are for debugging & will not be copied to webserver
      write(unitNo, AFORMAT) &
          '%REMARK% respond() started ...', &
            '<!DOCTYPE html>', &
            '<html>', &
            '<head>', &
            '<meta charset="utf-8"/>', &

            '<meta id="vp" name="viewport" content="width=300, initial-scale=1">', &

            '<link rel="icon" type="image/x-icon" href="static/favicon.ico">', &
            '<meta content="follow,index" name="robots">', &
            '<meta content="http://retrorabbit.co.za/Resources/retro-rabbit-text-logo.png" name="og:image">', &
            '<meta property="og:url" content="http://retrorabbit.co.za/">', &
            '<meta property="og:site_name" content="Retro Rabbit">', &
            '<meta property="og:title" content="Retro Rabbit - Rabbits on the Move">', &
            '<meta property="og:image:width" content="1200">', &
            '<meta property="og:image:height" content="1200">', &

            '<meta name="google-signin-client_id" &
            & content="656447153174-gtke9rajrc3ntem9sneb79apl2o9mlpm.apps.googleusercontent.com"/>', &

            '<meta name="viewport" content="width=device-width, initial-scale=1"/>', &
            '<title>Rabbits on the Move</title>', &
            '<link rel="stylesheet" type="text/css" href="/static/bootstrap.min.css"/>', &
            '<link rel="stylesheet" type="text/css" href="/static/rotm.css"/>', &
            
            '<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">', &

          '<script src="https://apis.google.com/js/platform.js?onload=init" async defer></script>', &
          '</head>', &
          '<body>'
      ! retrieve script name (key=DOCUMENT_URI) from dictionary
      call cgi_get( dict, "DOCUMENT_URI", scriptName )

      canContinue = .TRUE.

    !   if (len(trim(scriptName)) > 1) then
    !     query = ''
    !     call cgi_get( dict, 'email', query)
  
    !     if (len(trim(query)) == 0) then
    !         write(unitNo, AFORMAT) '<script src="static/signout_f.js"></script>'
    !         canContinue = .FALSE.
    !     else
    !         canContinue = .TRUE.
    !     endif
    !   endif

      if (canContinue) then
        select case (trim(scriptName))
            case ('/')
                write(unitNo, AFORMAT) '<script src="https://smartlock.google.com/client"></script>'
                write(unitNo, AFORMAT) '<script src="static/signin.js"></script>'
                ! most pages look like this
                templatefile = 'template/index.jade'
                call jadefile(templatefile, unitNo)
            case ('/claims')
                call cgi_get( dict, 'item', item)
                call cgi_get( dict, 'description', description)
                call cgi_get( dict, 'reference', reference)
                call cgi_get( dict, 'amount', amount)
                write(unitNo, AFORMAT) item
                !character(len=50), dimension(4)	:: newClaimItem
                !newClaimItem=(item,description,reference,amount)
                call addClaimItem(1, item, description, reference, '', amount)
                !call addClaim(0, 0, 'TEST')
            case ('/profile-list')
                templatefile = 'template/profile-list.jade'
                call jadefile(templatefile, unitNo)
            case ('/profile')
                query = ''
                call cgi_get( dict, 'email', query)

                if (len(trim(query)) == 0) then
                    write(unitNo, AFORMAT) '<script src="static/signout_f.js"></script>'
                else
                    call getUserCount(counter)
                    
                    pagevars(1,1) = 'name'
                    call cgi_get( dict, 'name', pagevars(1,2))
                    pagevars(2,1) = 'email'
                    pagevars(2,2) = query
                    pagevars(3,1) = 'counter'
                    write(pagevars(3,2), '(I5)' ) counter
                    
                    templatefile = 'template/profile.jade'
                    call jadetemplate(templatefile, unitNo, pagevars)
                endif
            case ('/users')
                templatefile = 'template/users.jade'
                call jadefile(templatefile, unitNo)
            case DEFAULT
            ! your 404 page
            write(unitNo,AFORMAT) 'Page not found!'
        end select
      endif

      ! end of response
      write(unitNo,AFORMAT) '</body>', &
          '</html>', &
          '%REMARK% respond() completed ...'

      return

  end subroutine respond

end program test_fcgi
