{literal} {if $report!=null} {/literal}	

  <div class="tengah textTitle" style="padding:2px"> Daily Report {literal} {$tgl} {/literal}  </div>

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

        {literal} {section name=i loop=$report} {/literal} 
        
        <tr align="right" class="textNormal" bgcolor="{cycle values="#DBE7F9,#E6F0FF"}">
            <td align="center">{literal} {$report[i].0} {/literal} </td>
        
            <!--- ADD LOOPING FOR COUNT TAG-NAME AND SPEC IF ANY-->
            <td> {literal} {if $report[i].1 !=null} {$report[i].1|string_format:"%.1f"}  {else} - {/if} {/literal}  </td>
			
            {literal} {if $report[i].2 >= 3000 } {/literal} 
            <td>{literal} {if $report[i].2 !=null} {$report[i].2|string_format:"%.1f"}  {else} - {/if} {/literal}  </td>
            {literal} {else} {/literal} 
        </tr>
        
        {literal} {/section} {/literal} 
      </table>
    </div>			
{literal} {/if} {/literal}
</div>
