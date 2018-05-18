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
    call sqlite3_set_column( column(1), 'DefaultBankDetailsId' )
    call sqlite3_set_column( column(2), 'EmployeeId' )
    call sqlite3_set_column( column(3), 'FirstName' )
    call sqlite3_set_column( column(4), 'LastName' )
    call sqlite3_set_column( column(5), 'IsAdmin' )
    call sqlite3_set_column( column(6), 'CellNumber' )
    call sqlite3_set_column( column(7), 'Email' )
    call sqlite3_insert( db, 'rotm', column )
  endsubroutine 

  subroutine getAllUsers(counter)
      ! columns
      integer :: counter

      character(len=50), dimension(counter)	:: employeeId, firstName, lastName, cellNumber, email
      integer, dimension(counter)	          :: id, defaultBankDetailsId, isAdmin

      call sqlite3_open('rotm.sqlite3', db)
      
      allocate( column(7) )    
      call sqlite3_column_query( column(1), 'Id', SQLITE_CHAR )
      call sqlite3_column_query( column(2), 'DefaultBankDetailsId', SQLITE_CHAR )
      call sqlite3_column_query( column(3), 'EmployeeId', SQLITE_INT )
      call sqlite3_column_query( column(4), 'FirstName', SQLITE_CHAR )
      call sqlite3_column_query( column(5), 'LastName', SQLITE_CHAR )
      call sqlite3_column_query( column(6), 'IsAdmin' , SQLITE_INT )
      call sqlite3_column_query( column(7), 'CellNumber', SQLITE_CHAR )
      call sqlite3_column_query( column(8), 'Email', SQLITE_CHAR )

      call sqlite3_prepare_select( db, 'rotm', column, stmt, "")

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
    call sqlite3_column_query( column(1), 'id', SQLITE_CHAR )

    call sqlite3_prepare_select( db, 'rotm', column, stmt, "")
    i = 1
    do
      call sqlite3_next_row(stmt, column, finished)
      if (finished) exit 
      i = i + 1
    end do
  endsubroutine
endmodule
