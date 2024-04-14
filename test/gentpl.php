
<?php
require( "../lib/Smarty/libs/Smarty.class.php" );
$smarty = new Smarty;

$unit= array(
    "unitname"=>"AHU1",
    "format"=>array(
        "AHU 14A"=>array(
            "Supply Temp.",
            "Min Air Flow<br>3000 CFM ",
        ),
        "AHU 14B"=>array(
            "Supply Temp.",
            "Supply RH",
            "Min Air Flow<br>5400 CFM",
        ),        
        "AHU 16"=>array(
            "Supply CC Temp.",
            "Supply RH" ,
            "Min Air Flow<br>2800 CFM",
        ),
        "AHU 17"=>array(
            "Supply Temp.",
        ),
        "AHU 14A"=>array(
            "Supply Temp.",
            "Supply <br>RH",
            "Min Air Flow<br>5500 CFM",
        ),
    ),
);    // echo "<pre>"; print_r($unit); echo "</pre>"; die();

$unit= array(
    "unitname"=>"AHU1",
    "data"=>array(
        array(
            "group_label"=>"AHU 14A",
            "member"=>array(
                "Supply Temp.",
                htmlspecialchars("Min Air Flow<br>3000 CFM "),
            ),
        ),
        array(
            "group_label"=>"AHU 14B",
            "member"=>array(
                "Supply Temp.",
                "Supply RH",
                htmlspecialchars("Min Air Flow<br>5400 CFM"),
            ),
        ),        
        array(
            "group_label"=>"AHU 16",
            "member"=>array(
                "Supply CC Temp.",
                "Supply RH" ,
                htmlspecialchars("Min Air Flow<br>2800 CFM"),
            ),
        ),
        array(
            "group_label"=>"AHU 17",
            "member"=>array(
                htmlspecialchars("Supply Temp."),
            ),
        ),
        array(
            "group_label"=>"AHU 14A",
            "member"=>array(
                htmlspecialchars("Supply Temp."),
                htmlspecialchars("Supply <br>RH"),
                htmlspecialchars("Min Air Flow<br>5500 CFM"),
            ),
        ),
    ),
);     echo "<pre>"; print_r($unit); echo "</pre>"; //die();

$smarty->assign( "msg", "test var" ); 
//$smarty->display( "query.tpl" );
$source = $smarty->fetch("sources/unit-sample1.tpl");  // capture the output
echo $source;  // // do something with $output here 
    
$output = "output/unit-sample1.tpl";
echo file_put_contents($output, $source);  // save code to file
/*
SAMPLE FORMAT PARAMS TAGS REPORT :

UNIT-NAME : AHU1

AHU 14A
    Supply Temp.
    Min Air Flow<br>3000 CFM 
AHU 14B
    Supply Temp.
    Supply RH
    Min Air Flow<br>5400 CFM 
AHU 16
    Supply CC Temp.
    Supply RH 
    Min Air Flow<br>2800 CFM
AHU 17
    Supply Temp.
AHU 14A
    Supply Temp.
    Supply <br>RH
    Min Air Flow<br>5500 CFM
*/
