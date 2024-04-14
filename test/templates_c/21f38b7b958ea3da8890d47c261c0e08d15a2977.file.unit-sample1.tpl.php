<?php /* Smarty version Smarty-3.1.21-dev, created on 2016-12-18 10:41:28
         compiled from "sources/unit-sample1.tpl" */ ?>
<?php /*%%SmartyHeaderCode:118516858158560568110880-13071118%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '21f38b7b958ea3da8890d47c261c0e08d15a2977' => 
    array (
      0 => 'sources/unit-sample1.tpl',
      1 => 1448024835,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '118516858158560568110880-13071118',
  'function' => 
  array (
  ),
  'has_nocache_code' => false,
  'version' => 'Smarty-3.1.21-dev',
  'unifunc' => 'content_585605681ae113_33926435',
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_585605681ae113_33926435')) {function content_585605681ae113_33926435($_smarty_tpl) {?><?php if (!is_callable('smarty_function_cycle')) include '/mnt/DATA/app/PHP/XXX/lib/Smarty/libs/plugins/function.cycle.php';
?> {if $report!=null} 	

  <div class="tengah textTitle" style="padding:2px"> Daily Report  {$tgl}   </div>

  <div class="view1">

    <table class="tbl_unit left" cellspacing="1" style="margin:0">
      <tr bgcolor="#1484BF" class="textCaption">
        <td rowspan="2"> <div class="Header">Time</div> </td>
        <!--- ADD LOOPING FOR TAGS GROUP NAME -->
        <td colspan="2"> AHU 14A </td>
        <td colspan="3"> AHU 14B </td>
        <td colspan="3"> AHU 16 </td>
        <td> AHU 17 </td>
        <td colspan="3"> AHU 9.4 </td>
      </tr>
      <tr bgcolor="#1484BF" class="textCaption">
      <!--- ADD LOOPING FOR TAG-NAME -->
        <td><div class="Header">Supply Temp.</div> </td>
        <td><div class="Header">Min Air Flow<br>3000 CFM </div></td>
        <td><div class="Header">Supply Temp.</div> </td>
        <td><div class="Header">Supply RH</div> </td>
        <td><div class="Header">Min Air Flow<br>5400 CFM </div> </td>
        <td><div class="Header">Supply CC Temp.</div> </td>
        <td><div class="Header">Supply RH </div> </td>
        <td><div class="Header">Min Air Flow<br>2800 CFM</div> </td>
        <td><div class="Header">Supply Temp.</div> </td>
        <td><div class="Header">Supply Temp.</div> </td>
        <td><div class="Header">Supply <br>RH</div> </td>
        <td><div class="Header">Min Air Flow<br>5500 CFM </div> </td>
      </tr>
    </table>
    <div class="clear"></div>

    <div id="table_div">
      <table class="tbl_unit" cellspacing="1">
        <tr id="firstTr">
          <!--- ADD LOOPING FOR COUNT TAG-NAME -->
          <td width="85px"></td> <td width="70px"></td> <td width="95px"></td> <td width="70px"></td> 
          <td width="70px"></td> <td width="95px"></td> <td width="95px"></td> <td width="70px"></td>
          <td width="95px"></td> <td width="70px"></td> <td width="70px"></td> <td width="70px"></td> <td width="95px"></td>
        </tr>

         {section name=i loop=$report}  
        
        <tr align="right" class="textNormal" bgcolor="<?php echo smarty_function_cycle(array('values'=>"#DBE7F9,#E6F0FF"),$_smarty_tpl);?>
">
            <td align="center"> {$report[i].0}  </td>
        
            <!--- ADD LOOPING FOR COUNT TAG-NAME AND SPEC IF ANY-->
            <td>  {if $report[i].1 !=null} {$report[i].1|string_format:"%.1f"}  {else} - {/if}   </td>
			
             {if $report[i].2 >= 3000 }  
            <td> {if $report[i].2 !=null} {$report[i].2|string_format:"%.1f"}  {else} - {/if}   </td>
             {else}  
        </tr>
        
         {/section}  
      </table>
    </div>			
 {/if} 
</div>
<?php }} ?>
