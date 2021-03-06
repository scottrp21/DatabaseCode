-- SUDO CODE FOR CIT 420 FINAL - PART 1

-- --------------------------------------------------------------
GET_SESSION
	(sessionid
	,userid
	,psswd
	,sv_remote_addr 	INOUT
	,sv_userid 				OUT
	,sv_client_info 	OUT
	,return_value 		OUT)

	SELECT   su.system_user_id
	,        su.system_user_name
	,        su.system_user_group_id
	,        ss.system_remote_address
	,        ss.system_session_id
	FROM     system_user su JOIN system_session ss
	ON       su.system_user_id = ss.system_user_id
	WHERE    ss.system_session_number = sessionid
	AND     (SYSDATE - ss.last_update_date) <= .003472222;

	if fetch then
		sv_userid = system_user_name

		if system_user_group_id = 0 then
			sv_client_info = system_user_group_id
		else
			sv_client_info = system_user_id

		if sv_remote_addr = system_sv_remote_addr
			update_session(sessionid,sv_remote_addr)
			return system_session_id
		else
			record_session(sessionid)
			return false

	else
		if (userid is not null) and (passwd is not null) then
			record_session(sessionid)
			return false
-- --------------------------------------------------------------

-- --------------------------------------------------------------
UPDATE_SESSION
	(sessionid
	,remote_address)

	UPDATE   system_session
	SET      last_update_date = NOW()
	WHERE    system_session_number = sessionid
	AND      system_remote_address = remote_address

	if not update then
		return false
-- --------------------------------------------------------------

-- --------------------------------------------------------------
RECORD_SESSION
	(sessionid
	,remote_address)

	INSERT INTO invalid_session VALUES
	(NULL,sessionid,remote_address,1,NOW(),1,NOW());

	if not insert then
		return false
-- --------------------------------------------------------------