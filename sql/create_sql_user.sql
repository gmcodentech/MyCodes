--create a login
create login <LOGINNAME> with password = '<PWD>'

--create a user account for the login in a database
Use finDB
create user <UserName> for login <LoginName>

--assigning a role to the user
exec sp_addrolemember N'db_owner',N'<UserName>'