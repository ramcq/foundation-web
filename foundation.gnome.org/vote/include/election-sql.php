<?php

$has_config = FALSE;

$mysql_host = "";
$mysql_user = "";
$mysql_password = "";
$mysql_db = "";

$elections_table = "elections";
$choices_table = "election_choices";
$anon_tokens_table = "election_anon_tokens";
$tmp_tokens_table = "election_tmp_tokens";
$votes_table = "election_votes";
$members_table = "foundationmembers";

if (is_readable ("include/localconfig.php")) {
  /* You can use such a file to have a local config for testing purpose. */
  include ("include/localconfig.php");
  $has_config = TRUE;
}

if (is_readable ("/home/admin/secret/anonvoting")) {
  include ("/home/admin/secret/anonvoting");
  $has_config = TRUE;
}

if (!$has_config) {
  trigger_error ("No configuration found.");
}

function elec_sql_open () {
  global $mysql_host;
  global $mysql_user;
  global $mysql_password;
  global $mysql_db;

  $handle = mysql_connect ("$mysql_host", "$mysql_user", "$mysql_password");
  if (!$handle) {
    return FALSE;
  }

  $select_base = mysql_select_db ($mysql_db, $handle); 
  if (!$select_base) {
    elec_sql_close ($handle);
    return FALSE;
  }

  return $handle;
}

function elec_sql_close ($handle) {
    if ($handle === FALSE)
      return;

    mysql_close ($handle);
}

function elec_sql_start_transaction ($handle) {
  if ($handle === FALSE)
    return FALSE;

  $result = mysql_query ("START TRANSACTION", $handle);

  return ($result !== FALSE);
}

function elec_sql_commit ($handle) {
  if ($handle === FALSE)
    return FALSE;

  $result = mysql_query ("COMMIT", $handle);

  return ($result !== FALSE);
}

function elec_sql_rollback ($handle) {
  if ($handle === FALSE)
    return FALSE;

  $result = mysql_query ("ROLLBACK", $handle);

  return ($result !== FALSE);
}

function elec_get_by_date_desc_with_where ($handle, $where = "") {
  global $elections_table;

  if ($handle === FALSE)
    return FALSE;

  $query = "SELECT * FROM " . $elections_table;
  if (isset ($where) && $where != "") {
    $query .= " " . $where;
  }
  $query .= " ORDER BY voting_start desc";

  $result = mysql_query ($query, $handle);

  if (!$result) {
    $retval = FALSE;
  } else {
    $result_array = array ();
    while ($buffer = mysql_fetch_assoc ($result)) {
      $result_array[] = $buffer;
    }
    $retval = $result_array;
  }

  return $retval;
}

function elec_get_current_by_date_desc ($handle) {
  $gmdate = gmdate ("Y-m-d H:i:s");
  $where = "WHERE '".$gmdate."' >= voting_start AND '".$gmdate."' <= voting_end";
  return elec_get_by_date_desc_with_where ($handle, $where);
}

function elec_get_previous_by_date_desc ($handle) {
  $gmdate = gmdate ("Y-m-d H:i:s");
  $where = "WHERE '".$gmdate."' > voting_start AND '".$gmdate."' > voting_end";
  return elec_get_by_date_desc_with_where ($handle, $where);
}

function elec_verify_email_tmp_token ($handle, $election_id, $email, $tmp_token) {
  global $tmp_tokens_table;
  global $members_table;

  if ($handle === FALSE)
    return FALSE;

  $escaped_election_id = mysql_real_escape_string ($election_id, $handle);
  $escaped_email = mysql_real_escape_string ($email, $handle);
  $escaped_tmp_token = mysql_real_escape_string ($tmp_token, $handle);

  $query = "SELECT COUNT(*) FROM " . $tmp_tokens_table . " AS tt, " . $members_table . " AS mt";
  $query .= " WHERE tt.election_id = '".$escaped_election_id."'";
  $query .= " AND tt.tmp_token = '".$escaped_tmp_token."'";
  $query .= " AND tt.member_id = mt.id";
  $query .= " AND mt.email = '".$escaped_email."'";

  $result = mysql_query ($query, $handle);
  if (!$result)
    return FALSE;

  return (mysql_result ($result, 0, 0) == 1);
}

function elec_choices_get ($handle, $election_id) {
  global $choices_table;

  if ($handle === FALSE)
    return FALSE;

  $escaped_election_id = mysql_real_escape_string ($election_id, $handle);

  $query = "SELECT * FROM " . $choices_table;
  $query .= " WHERE election_id = '".$escaped_election_id."'";

  $result = mysql_query ($query, $handle);

  if (!$result) {
    $retval = FALSE;
  } else {
    $result_array = array ();
    while ($buffer = mysql_fetch_assoc ($result)) {
      $result_array[] = $buffer;
    }
    $retval = $result_array;
  }

  return $retval;
}

function elec_verify_elections ($choices_nb, $choices) {
  if ($choices_nb === FALSE || $choices === FALSE)
    return FALSE;

  if ($choices_nb < 1)
    return FALSE;

  if (count ($choices) < $choices_nb || count ($choices) <= 1)
    return FALSE;

  return TRUE;
}

function elec_get_election ($handle, $election_id) {
  global $elections_table;

  if ($handle === FALSE)
    return FALSE;

  $escaped_election_id = mysql_real_escape_string ($election_id, $handle);

  $query = "SELECT * FROM " . $elections_table;
  $query .= " WHERE id = '".$escaped_election_id."'";

  $result = mysql_query ($query, $handle);

  if (!$result)
    return FALSE;

  return mysql_fetch_assoc ($result);
}

function elec_election_is_current ($election) {
  $gmdate = gmdate ("Y-m-d H:i:s");
  return ($gmdate >= $election["voting_start"] && $gmdate <= $election["voting_end"]);
}

function elec_election_has_ended ($election) {
  $gmdate = gmdate ("Y-m-d H:i:s");
  return ($gmdate > $election["voting_start"] && $gmdate > $election["voting_end"]);
}

function elec_election_get_type ($election) {
  if ($election["type"] == "referendum")
    return "referendum";
  else
    return "election";
}

function elec_vote_get_votes_from_post ($choices) {
  $votes_array = array ();

  foreach ($choices as $choice) {
    $name = "vote".$choice["id"];
    if (isset ($_POST[$name]) && $_POST[$name] != "") {
      array_push ($votes_array, $choice["id"]);
    }
  }

  return $votes_array;
}

function elec_verify_vote_is_valid ($choices_nb, $choices, $vote, $votes_array) {
  if ($choices_nb == 1)
    return "";

  if (count ($votes_array) > $choices_nb) {
    return "you chose ".count ($votes_array)." answers, while you can't choose more than ".$choices_nb." answers.";
  }
  
  return "";
}

function elec_insert_new_anon_token ($handle, $election_id, $anon_token) {
  global $anon_tokens_table;

  if ($handle === FALSE)
    return FALSE;

  $escaped_election_id = mysql_real_escape_string ($election_id, $handle);
  $escaped_anon_token = mysql_real_escape_string ($anon_token, $handle);

  $query = "SELECT COUNT(*) FROM " . $anon_tokens_table;
  $query .= " WHERE anon_token = '".$escaped_anon_token."'";

  $result = mysql_query ($query, $handle);
  if (!$result)
    return FALSE;

  if (mysql_result ($result, 0, 0) != 0)
    return FALSE;

  $query = "INSERT INTO " . $anon_tokens_table . " (anon_token, election_id)";
  $query .= " VALUES ('".$escaped_anon_token."', '".$escaped_election_id."')";

  $result = mysql_query ($query, $handle);
  if (!$result)
    return FALSE;

  return mysql_insert_id ($handle);
}

function elec_insert_new_vote ($handle, $anon_token_id, $vote) {
  global $votes_table;

  if ($handle === FALSE)
    return FALSE;

  $escaped_vote = mysql_real_escape_string ($vote, $handle);
  $escaped_anon_token_id = mysql_real_escape_string ($anon_token_id, $handle);

  $query = "INSERT INTO " . $votes_table . " (choice_id, anon_id)";
  $query .= " VALUES ('".$escaped_vote."', '".$escaped_anon_token_id."')";

  $result = mysql_query ($query, $handle);
  if (!$result)
    return FALSE;

  return TRUE;
}

function elec_sql_remove_tmp_token ($handle, $election_id, $email, $tmp_token) {
  global $members_table;
  global $tmp_tokens_table;

  if ($handle === FALSE)
    return FALSE;

  $escaped_election_id = mysql_real_escape_string ($election_id, $handle);
  $escaped_email = mysql_real_escape_string ($email, $handle);
  $escaped_tmp_token = mysql_real_escape_string ($tmp_token, $handle);

  $query = "DELETE FROM " . $tmp_tokens_table;
  $query .= " USING ". $tmp_tokens_table . " AS tt, " . $members_table . " AS mt";
  $query .= " WHERE tt.election_id = '".$escaped_election_id."'";
  $query .= " AND tt.tmp_token = '".$escaped_tmp_token."'";
  $query .= " AND tt.member_id = mt.id";
  $query .= " AND mt.email = '".$escaped_email."'";

  $result = mysql_query ($query, $handle);
  if (!$result)
    return FALSE;

  return TRUE;
}

function elec_get_anon_tokens_for_election ($handle, $election_id) {
  global $anon_tokens_table;

  if ($handle === FALSE)
    return FALSE;

  $escaped_election_id = mysql_real_escape_string ($election_id, $handle);

  $query = "SELECT * FROM " . $anon_tokens_table;
  $query .= " WHERE election_id = '".$escaped_election_id."'";
  $query .= " ORDER BY anon_token";

  $result = mysql_query ($query, $handle);

  if (!$result) {
    $retval = FALSE;
  } else {
    $result_array = array ();
    while ($buffer = mysql_fetch_assoc ($result)) {
      $result_array[] = $buffer;
    }
    $retval = $result_array;
  }

  return $retval;
}

function elec_get_results_election ($handle, $election_id) {
  global $anon_tokens_table;
  global $votes_table;

  if ($handle === FALSE)
    return FALSE;

  $escaped_election_id = mysql_real_escape_string ($election_id, $handle);

  $query = "SELECT choice_id, COUNT(choice_id) AS total_choice FROM " . $anon_tokens_table . " AS att, " . $votes_table . " AS vt";
  $query .= " WHERE att.election_id = '".$escaped_election_id."'";
  $query .= " AND att.id = vt.anon_id";
  $query .= " GROUP BY choice_id";
  $query .= " ORDER BY total_choice DESC";

  $result = mysql_query ($query, $handle);

  if (!$result) {
    $retval = FALSE;
  } else {
    $result_array = array ();
    while ($buffer = mysql_fetch_assoc ($result)) {
      $result_array[] = $buffer;
    }
    $retval = $result_array;
  }

  return $retval;
}

function elec_get_votes_for_anon_token ($handle, $anon_token_id) {
  global $votes_table;

  if ($handle === FALSE)
    return FALSE;

  $escaped_anon_token_id = mysql_real_escape_string ($anon_token_id, $handle);

  $query = "SELECT choice_id FROM " . $votes_table;
  $query .= " WHERE anon_id = '".$escaped_anon_token_id."'";
  $query .= " ORDER BY choice_id";

  $result = mysql_query ($query, $handle);

  if (!$result) {
    $retval = FALSE;
  } else {
    $result_array = array ();
    while ($buffer = mysql_fetch_assoc ($result)) {
      $result_array[] = $buffer["choice_id"];
    }
    $retval = $result_array;
  }

  return $retval;
}

?>