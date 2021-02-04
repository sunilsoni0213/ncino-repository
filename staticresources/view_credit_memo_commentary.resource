.credit_memo_commentary_container(id="!{data.sectionId}")
  :if data.allowCommentary
    .credit_memo_commentary_section_clear
  .credit_memo_commentary_comments_container
    %p.credit_memo_stress_text=msgs.msg_credit_memo_paste
    .controls
      .paste
        %span.ui-icon.ui-icon-clipboard(style="float: left; margin-right: .3em;")
        %a(id="!{data.sectionId}" href="#" onclick="return showCutAndPasteSection(this, true);")=msgs.msg_credit_memo_add_commentary
      .save(style="display:none;")
        %span.ui-icon.ui-icon-locked(style="float: left; margin-right: .3em;")
        %a(id="!{data.sectionId}" href="#" onclick="return saveCutAndPasteSection(this);")=msgs.msg_credit_memo_save_commentary
      .clear(style="display:none;")
        %span.ui-icon.ui-icon-trash(style="float: left; margin-right: .3em;")
        %a(id="!{data.sectionId}" href="#" onclick="return clearCutAndPasteSection(this);")=msgs.msg_credit_memo_clear_commentary
    %div
      :each comment in data.commentaries
        .credit_memo_commentary.dataTable
          .credit_memo_cut_and_paste_persisted(style="display:none")
      .credit_memo_commentary.dataTable
        .credit_memo_cut_and_paste
      .help(style="display:none; font-style:italic;")
        %a(id="!{data.sectionId}" style="display:inline; float: left;" href="#" onclick="showCommentaryHelp(this);return false;")=msgs.msg_credit_memo_paste_help
        %span.ui-icon.ui-icon-lightbulb(style="display:inline; float: left; margin-left: .3em;")
  .credit_memo_commentary_instructions(style="display: none;")
    .help_content
      .ui-corner-all.caution
        .dialog-box.caution(style="border: none;")
          %p=msgs.msg_credit_memo_commentary_help_content
        .dialog-box.caution(style="border: none;")
          %p=msgs.msg_credit_memo_commentary_help_content_bullet_1
        .dialog-box.caution(style="border: none;")
          %p=msgs.msg_credit_memo_commentary_help_content_bullet_2
      
  .credit_memo_commentary_section_clear
:javascript
  function showCutAndPasteSection(that, isClicked){
    var data = retrieveSectionData(jQuery(that).attr('id')); 
    jQuery(that).parent().hide();
    jQuery(that).parent().parent().find('.clear').show();
    jQuery(that).parent().parent().find('.save').show();
    
    jQuery(that).parent().parent().parent().find(
      '.credit_memo_cut_and_paste').show();
    
    jQuery(that).parent().parent().parent().find(
      '.credit_memo_cut_and_paste').handsontable({
        rows: 5, 
        cols: 10, 
        minSpareCols: 1, 
        minSpareRows: 1, 
        contextMenu: true});
    
    if(isClicked){
      jQuery(that).parent().parent().parent().find(
        '.credit_memo_cut_and_paste').handsontable('selectCell', 0, 0, 0, 0, scrollToSelection=true);

      jQuery(that).parent().parent().parent().find(
        '.credit_memo_cut_and_paste').handsontable('setDataAtCell', 0, 0, msgs.msg_credit_memo_paste_start_instruction);

      jQuery(that).parent().parent().parent().find(
        '.credit_memo_cut_and_paste').handsontable('selectCell', 0, 0, 0, 0, scrollToSelection=true);
      //console.log('triggering...');
      //console.log(jQuery(that).parent().parent().parent().find(
      //  '.credit_memo_cut_and_paste').handsontable('getSelected'));
      
      //jQuery(that).parent().parent().parent().find(
      //'.credit_memo_cut_and_paste').find('.handsontableInput').triggerHandler(
      //  'paste');
    }
    else if(data.commentaries.length > 0){
    
      var contents = jQuery.parseJSON(
            data.commentaries[data.commentaries.length-1].text);
      
      jQuery(that).parent().parent().parent().find(
        '.credit_memo_cut_and_paste').handsontable(
          'loadData', 
          contents);
    }
    jQuery(that).parent().parent().parent().find('div.help').show();
    return false;
  }
  function saveCutAndPasteSection(that){
    var data = retrieveSectionData(jQuery(that).attr('id')); 
    data.commentaries.push({
      id: null, 
      text: JSON.stringify(
        jQuery(that).parent().parent().parent().find('.credit_memo_cut_and_paste').handsontable('getData'))
      });
      setSectionData(
        data.sectionId, 
        JSON.stringify(data));
    
    return false;
  }
  function hideCutAndPasteSection(that){
    jQuery(that).parent().parent().find('.paste').show();
    jQuery(that).parent().parent().find('.clear').hide();
    jQuery(that).parent().parent().find('.save').hide();
    jQuery(that).parent().parent().parent().find('div.help').hide();
    
    jQuery(that).parent().parent().parent().find(
      '.credit_memo_cut_and_paste').hide();

  }
  function clearCutAndPasteSection(that){
    jQuery(that).parent().parent().parent().find(
      '.credit_memo_cut_and_paste').handsontable('clear');
      
    saveCutAndPasteSection(that);
    hideCutAndPasteSection(that);
    return false;
  }
  function showCommentaryHelp(that){
    var dialogHtml = jQuery(that).parent().parent().parent().parent().find(
      '.credit_memo_commentary_instructions div.help_content').clone();
    
    jQuery(dialogHtml).dialog({
      autoOpen: 'true',
      modal: 'true',
      draggable: 'false',
      resizable: false,
      title: msgs.msg_credit_memo_commentary_help_title,
      closeText: msgs.msg_credit_memo_commentary_help_button_ok,
      buttons: 
          [{
              text: msgs.msg_credit_memo_commentary_help_button_ok,
              click: function() { 
                 jQuery(dialogHtml).dialog('close');
              }
          }],
      close: function(event, ui) {
      }
    });
  }
