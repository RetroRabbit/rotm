! sample model for Fortran.io and SQLite database
! table should already be created

module rotm
  use sqlite
  use string_helpers

  implicit none

  type(SQLITE_DATABASE)                       :: db
  type(SQLITE_STATEMENT)                      :: stmt
  type(SQLITE_COLUMN), dimension(:), pointer  :: column
  integer                                     :: i
  logical                                     :: finished

  contains

  subroutine addUser(defaultBankDetailsId, employeeId, firstName, lastName, isAdmin, cellNumber, email)
    ! columns
    character(len=50)			:: employeeId, firstName, lastName, cellNumber, email
    integer  			        :: defaultBankDetailsId, isAdmin

    call sqlite3_open('rotm.sqlite3', db)

    allocate( column(7) )    
    call sqlite3_set_column( column(1), defaultBankDetailsId )
    call sqlite3_set_column( column(2), employeeId )
    call sqlite3_set_column( column(3), firstName )
    call sqlite3_set_column( column(4), lastName )
    call sqlite3_set_column( column(5), isAdmin )
    call sqlite3_set_column( column(6), cellNumber )
    call sqlite3_set_column( column(7), email )
    call sqlite3_insert( db, 'User', column )
    call sqlite3_commit( db )
  endsubroutine 

  subroutine getAllUsers(counter)
      ! columns
      integer :: counter

      character(len=50), dimension(counter)	:: employeeId, firstName, lastName, cellNumber, email
      integer, dimension(counter)	          :: id, defaultBankDetailsId, isAdmin

      call sqlite3_open('rotm.sqlite3', db)
      
      allocate( column(7) )    
      call sqlite3_column_query( column(1), 'Id', SQLITE_INT )
      call sqlite3_column_query( column(2), 'DefaultBankDetailsId', SQLITE_CHAR )
      call sqlite3_column_query( column(3), 'EmployeeId', SQLITE_INT )
      call sqlite3_column_query( column(4), 'FirstName', SQLITE_CHAR )
      call sqlite3_column_query( column(5), 'LastName', SQLITE_CHAR )
      call sqlite3_column_query( column(6), 'IsAdmin' , SQLITE_INT )
      call sqlite3_column_query( column(7), 'CellNumber', SQLITE_CHAR )
      call sqlite3_column_query( column(8), 'Email', SQLITE_CHAR )

      call sqlite3_prepare_select( db, 'User', column, stmt, "")

      i = 1
      do
        call sqlite3_next_row(stmt, column, finished)
        if (finished) exit 

        call sqlite3_get_column(column(1), id(i))
        call sqlite3_get_column(column(1), defaultBankDetailsId(i))
        call sqlite3_get_column(column(1), employeeId(i))
        call sqlite3_get_column(column(1), firstName(i))
        call sqlite3_get_column(column(1), lastName(i))
        call sqlite3_get_column(column(1), isAdmin(i))
        call sqlite3_get_column(column(1), cellNumber(i))
        call sqlite3_get_column(column(1), email(i))
        
        i = i + 1
      end do
  endsubroutine  
  
  subroutine getUserCount(counter)
    !columns
    integer :: counter

    call sqlite3_open('rotm.sqlite3', db)

    allocate( column(1) )
    call sqlite3_column_query( column(1), 'id', SQLITE_INT )

    call sqlite3_prepare_select( db, 'user', column, stmt, "")
    i = 1
    do
      call sqlite3_next_row(stmt, column, finished)
      if (finished) exit 
      i = i + 1
    end do
  endsubroutine

  subroutine addClaim(bankDetailsId, userId, date)
    ! columns
    character(len=50)			:: date
    integer  			        :: bankDetailsId, userId

    call sqlite3_open('rotm.sqlite3', db)

    allocate( column(3) )    
    call sqlite3_set_column( column(1), bankDetailsId )
    call sqlite3_set_column( column(2), userId )
    call sqlite3_set_column( column(3), date )
    call sqlite3_insert( db, 'Claim', column )
    call sqlite3_commit( db )
  endsubroutine 

  subroutine getClaimCount(counter)
    !columns
    integer :: counter

    call sqlite3_open('rotm.sqlite3', db)

    allocate( column(1) )
    call sqlite3_column_query( column(1), 'id', SQLITE_INT )

    call sqlite3_prepare_select( db, 'Claim', column, stmt, "")
    i = 1
    do
      call sqlite3_next_row(stmt, column, finished)
      if (finished) exit 
      i = i + 1
    end do
  endsubroutine

  subroutine getAllClaims(counter)
    ! columns
    integer :: counter

    character(len=50), dimension(counter)	:: date 
    integer, dimension(counter)	          :: id, bankDetailsId, userId

    call sqlite3_open('rotm.sqlite3', db)
    
    allocate( column(4) )    
    call sqlite3_column_query( column(1), 'Id', SQLITE_INT )
    call sqlite3_column_query( column(2), 'BankDetailsId', SQLITE_INT )
    call sqlite3_column_query( column(3), 'UserId', SQLITE_INT )
    call sqlite3_column_query( column(4), 'Date', SQLITE_CHAR ) 

    call sqlite3_prepare_select( db, 'Claim', column, stmt, "")

    i = 1
    do
      call sqlite3_next_row(stmt, column, finished)
      if (finished) exit 

      call sqlite3_get_column(column(1), id(i))
      call sqlite3_get_column(column(2), bankDetailsId(i))
      call sqlite3_get_column(column(3), userId(i))
      call sqlite3_get_column(column(4), date(i))
      
      i = i + 1
    end do
  endsubroutine

  subroutine addClaimItem(claimId, claimItem, description, date, slipLink, amount)
    ! columns
    character(len=50)			:: claimItem, description, date, slipLink
    integer  			        :: claimId
    real                  :: amount

    call sqlite3_open('rotm.sqlite3', db)

    allocate( column(6) )     
    call sqlite3_set_column( column(1), claimId )
    call sqlite3_set_column( column(2), claimItem )
    call sqlite3_set_column( column(3), description )
    call sqlite3_set_column( column(4), date )
    call sqlite3_set_column( column(5), slipLink )
    call sqlite3_set_column( column(6), amount )
    call sqlite3_insert( db, 'ClaimItem', column )
    call sqlite3_commit( db )
    
  endsubroutine 

  subroutine getClaimItemCount(counter)
    !columns
    integer :: counter

    call sqlite3_open('rotm.sqlite3', db)

    allocate( column(1) )
    call sqlite3_column_query( column(1), 'id', SQLITE_INT )

    call sqlite3_prepare_select( db, 'ClaimItem', column, stmt, "")
    i = 1
    do
      call sqlite3_next_row(stmt, column, finished)
      if (finished) exit 
      i = i + 1
    end do
  endsubroutine

  subroutine getAllClaimItems(counter)
    ! columns
    integer :: counter

    character(len=50), dimension(counter)			:: claimItem, description, date, slipLink
    integer, dimension(counter)  			        :: id, claimId
    real, dimension(counter)                  :: amount

    call sqlite3_open('rotm.sqlite3', db)
    
    allocate( column(7) )    
    call sqlite3_column_query( column(1), 'Id', SQLITE_INT )
    call sqlite3_column_query( column(2), 'ClaimId', SQLITE_INT )
    call sqlite3_column_query( column(3), 'ClaimItem', SQLITE_INT )
    call sqlite3_column_query( column(4), 'Description', SQLITE_CHAR ) 
    call sqlite3_column_query( column(5), 'Date', SQLITE_CHAR ) 
    call sqlite3_column_query( column(6), 'SlipLink', SQLITE_CHAR ) 
    call sqlite3_column_query( column(7), 'Amount', SQLITE_REAL ) 

    call sqlite3_prepare_select( db, 'Claim', column, stmt, "")

    i = 1
    do
      call sqlite3_next_row(stmt, column, finished)
      if (finished) exit 

      call sqlite3_get_column( column(1), id(i) )
      call sqlite3_get_column( column(2), claimId(i) )
      call sqlite3_get_column( column(3), claimItem(i) )
      call sqlite3_get_column( column(4), description(i) ) 
      call sqlite3_get_column( column(5), date(i) ) 
      call sqlite3_get_column( column(6), slipLink(i) ) 
      call sqlite3_get_column( column(7), amount(i) ) 
      
      i = i + 1
    end do
  endsubroutine
    
  subroutine getUserClaimItems(counter, userClaimId)
    ! columns
    integer :: counter, userClaimId

    character(len=50), dimension(counter)			:: claimItem, description, date, slipLink
    integer, dimension(counter)  			        :: id, claimId
    real, dimension(counter)                  :: amount
    character(len=50)                         :: queryClaimId

    call sqlite3_open('rotm.sqlite3', db)
    
    allocate( column(7) )    
    call sqlite3_column_query( column(1), 'Id', SQLITE_INT )
    call sqlite3_column_query( column(2), 'ClaimId', SQLITE_INT )
    call sqlite3_column_query( column(3), 'ClaimItem', SQLITE_INT )
    call sqlite3_column_query( column(4), 'Description', SQLITE_CHAR ) 
    call sqlite3_column_query( column(5), 'Date', SQLITE_CHAR ) 
    call sqlite3_column_query( column(6), 'SlipLink', SQLITE_CHAR ) 
    call sqlite3_column_query( column(7), 'Amount', SQLITE_REAL ) 

    write(queryClaimId,'(I5)') userClaimId
    call sqlite3_prepare_select( db, 'Claim', column, stmt, "WHERE ClaimId = " // queryClaimId)

    i = 1
    do
      call sqlite3_next_row(stmt, column, finished)
      if (finished) exit 

      call sqlite3_get_column( column(1), id(i) )
      call sqlite3_get_column( column(2), claimId(i) )
      call sqlite3_get_column( column(3), claimItem(i) )
      call sqlite3_get_column( column(4), description(i) ) 
      call sqlite3_get_column( column(5), date(i) ) 
      call sqlite3_get_column( column(6), slipLink(i) ) 
      call sqlite3_get_column( column(7), amount(i) ) 
      
      i = i + 1
    end do
  endsubroutine
endmodule
