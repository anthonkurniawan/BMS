{literal} {if $report!=null} {/literal}	
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

    {literal} {section name=i loop=$report} {/literal}
      <tr  align="right" >
        <td align="center"><font size='2.5'> {literal} {$report[i].0} {/literal}</font></td> <!-- time -->
        <td><font size='2.5'> {literal} {if $report[i].1 !=null}  {$report[i].1|string_format:"%.1f"} {else} - {/if} {/literal}</font></td>
      </tr>
    {literal} {/section} {/literal}
  </table>
</div>
{literal} {/if} {/literal}