%div(class="!{widget_class} ui-widget")
  .ui-corner-all.ui-widget-content
    .year_selector
      %select(multiple="multiple")
        :each year in years
          :if year.selected 
            %option(value="!{year.value}" selected="selected" )
              !{year.value}
          :if false == year.selected
            %option(value="!{year.value}" )
              !{year.value}
    .expand_years.hide
      %label(for="expand_year")
        %input(id="expand_year" class="!{statement}_expand_year" type="checkbox")
        %span= msgs.msg_spreads_control_widget_expand_years
    .expand_quarters.hide
      %label(for="expand_quarter")
        %input(id="expand_quarter" class="!{statement}_expand_quarter" type="checkbox")
        %span= msgs.msg_spreads_control_widget_expand_quarters
:css


:javascript
  jQuery('.!{statement}_expand_year').click(function (){
    var bVal = jQuery(this).attr('checked') == 'checked';
    jQuery.cookie('!{statement}_spreads_expand_year', bVal, {expires: 30});
  });
  
  jQuery('.!{statement}_expand_quarter').click(function (){
    var bVal = jQuery(this).attr('checked') == 'checked';
    jQuery.cookie('!{statement}_spreads_expand_quarter', bVal, {expires: 30});
  });
  
  var bExpandYear = jQuery.cookie('!{statement}_spreads_expand_year');
  var bExpandQuarter = jQuery.cookie('!{statement}_spreads_expand_quarter');
  
  if(bExpandYear != null){
    bExpandYear = 'true' ==  bExpandYear;
    if(bExpandYear){
      jQuery('.!{statement}_expand_year').attr('checked','checked');
    }
    else{
      jQuery('.!{statement}_expand_year').removeAttr('checked');
    }
  }
  
  if(bExpandQuarter != null){
    bExpandQuarter = 'true' ==  bExpandQuarter;
    if(bExpandQuarter){
        jQuery('.!{statement}_expand_quarter').attr('checked','checked');
      }
      else{
        jQuery('.!{statement}_expand_quarter').removeAttr('checked');
      }
  }
