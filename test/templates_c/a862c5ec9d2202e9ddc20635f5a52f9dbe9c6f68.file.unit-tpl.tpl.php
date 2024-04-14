<?php /* Smarty version Smarty-3.1.13, created on 2015-08-20 01:13:33
         compiled from "unit-tpl.tpl" */ ?>
<?php /*%%SmartyHeaderCode:525955d4b48bb71b08-69762131%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    'a862c5ec9d2202e9ddc20635f5a52f9dbe9c6f68' => 
    array (
      0 => 'unit-tpl.tpl',
      1 => 1440007990,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '525955d4b48bb71b08-69762131',
  'function' => 
  array (
  ),
  'version' => 'Smarty-3.1.13',
  'unifunc' => 'content_55d4b48be11137_64152854',
  'has_nocache_code' => false,
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_55d4b48be11137_64152854')) {function content_55d4b48be11137_64152854($_smarty_tpl) {?> {if $report!=null} 	
  <table border="1" width="100%" cellspacing="0" cellpadding="0" align="center">
    <tr align="center" >
      <td rowspan="2" width="4%"> <font size='3'> <b>Time</b> </font> </td>
      <td colspan="2" > <font size='3'> <b>AHU 14A</b> </font></td>
      <td colspan="3" > <font size='3'> <b>AHU 14B</b> </font></td>
      <td colspan="3"> <font size='3'> <b>AHU 16</b> </font></td>
      <td > <font size='3'> <b>AHU 17</b> </font></td>
      <td colspan="3"> <font size='3'> <b>AHU 9.4</b> </font></td>
    </tr>
    <tr align="center"  >
      <td width="8%"><font size='2.5'> <b>Supply Temp.</b> </font></td>	
      <td width="8%"><font size='2.5'> <b>Min Air Flow<br>3000 CFM<br />aktual </b></font></td>
      <td width="8%"><font size='2.5'> <b>Supply Temp.</b> </font></td>
      <td width="8%"><font size='2.5'> <b>Supply RH</b> </p> </font></td>
      <td width="8%"><font size='2.5'> <b>Min Air Flow<br>3000 CFM<br />aktual </b> </font></td>
      <td width="8%"><font size='2.5'> <b>Supply CC Temp.</b> </font></td>
      <td width="8%"><font size='2.5'> <b> Supply RH </b> </font></td>
      <td width="8%"><font size='2.5'> <b>Min Air Flow<br>3000 CFM<br />aktual </b> </font></td>
      <td width="8%"><font size='2.5'> <b>Supply Temp.</b> </font></td>
      <td width="8%"><font size='2.5'> <b>Supply Temp.</b> </font></td>
      <td width="8%"><font size='2.5'> <b>Supply </br>RH</b> </font></td>
      <td width="8%"><font size='2.5'> <b>Min Air Flow<br>3000 CFM<br />aktual </b> </font></td>
    </tr>

     {section name=i loop=$report} 
      <tr  align="right" >
        <td align="center"><font size='2.5'>  {$report[i].0} </font></td> <!-- time -->
        <td><font size='2.5'>  {if $report[i].1 !=null}  {$report[i].1|string_format:"%.1f"} {else} - {/if} </font></td>
      </tr>
     {/section} 
  </table>
</div>
 {/if} <?php }} ?>