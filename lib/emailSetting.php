<?php
return array(
  'SMTPDebug'=> 2,
	//Ask for HTML-friendly debug output
	'Debugoutput' => 'html',
	//Set the hostname of the mail server - use 'Host = gethostbyname('smtp.gmail.com'); if your network does not support SMTP over IPv6
	'Host'=> 'smtp.gmail.com2',
	//Set the SMTP port number - 587 for authenticated TLS, a.k.a. RFC4409 SMTP submission
	'Port'=> 587,
	//Set the encryption system to use - ssl (deprecated) or tls
	'SMTPSecure'=> 'tls',
	//Whether to use SMTP authentication
	'SMTPAuth'=> true,
	//Username to use for SMTP authentication - use full email address for gmail
	'Username'=> "blaquecry@gmail.com",
	//Password to use for SMTP authentication
	'Password'=> "valentine",
	//Set who the message is to be sent from
	'setFrom'=>'blaquecry@gmail.com',
	'setFromDisplayName'=>'blaquecry',  // tambahan
	//Set an alternative reply-to address
	'addReplyTo'=>'blaquecry@gmail.com'
);  
?>

