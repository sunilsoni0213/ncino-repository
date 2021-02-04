.docman-container{
	border: 1px solid #ECEBEA;
	box-shadow: 0 0 3px rgba(0, 0, 0, .025);
	height: 881px;
	-webkit-border-radius: 0 0 3px 3px;
	-moz-border-radius: 0 0 3px 3px;
	-khtml-border-radius: 0 0 3px 3px;
	border-radius: 0 0 3px 3px;
	position: relative;
}
.docman-header-column {
	background: #F4F6F9;
	outline: none;
	height: 38px;
	padding-top: 12px;
	border-bottom: 1px solid #ddd;
	border-top: 1px solid #ddd;
}
.docman-fixed-height{
	height: 730px;
	overflow-x: hidden;
	overflow-y: auto;
}
.version-fixed-height{
	max-height: 200px;
	overflow-y: auto;
	overflow-x: hidden;
}
.docman-header-icon{
	height: 10px;
	width: 10px;
}
.docman-prewrap {
	white-space: pre-wrap;
}
.overrideMarginsAndPadding{
	padding: 0px !important;
	margin: 0px !important;
}
.no-gutter{
	padding-left:0;
	padding-right:0;
	padding-bottom:0;
}
.disabledAction {
	display: none !important;
}
.enabledAction {
	display: initial;
}
.dateFormat {
	visibility: hidden;
}
.blueText{
	color:#007DFF !important;
}
.clickFocus{
	cursor:pointer;
	outline:none;
}
.turnRed{
	background-color: red;
}
.searchBar{
	padding: 15px 15px 0 15px;
}
div.hiddenRow {
	padding: 0;
	background-color: #FFFFFF !important;
}
.panelOverride {
	margin: 0 !important;
	padding: 0 !important;
	border-bottom: 1px solid #ddd !important;
	border-top: none !important;
	border-left: none !important;
	border-right: none !important;
	background-color: #FFFFFF !important;
}
.uploadingFile {
	padding: 10px 0 0 0;
	color:rgba(0,0,0,0.54);
	line-height: 2.3;
	background-color: #FFFFFF;
	height: 48px;
}
div.panel-collapse > *{
	padding: 8px 0;
}
.dropAndBrowseContainer{
	padding:0 20px;
}
div.dropAndBrowse {
	border:1px dashed #4D6892;
	border-radius:5px;
	height:797px;
	width:90%;
	margin:0 auto;
	padding:45% 10px 0 10px !important;
	text-align: center;
}
div.dropAndBrowse span {
	vertical-align: middle;
}
div.stageDragged {
	border-color: #448AFF;
	background:rgba(0,125,255,0.15);
}
.truncate{
	width:95%;
	white-space:nowrap;
	overflow:hidden;
	text-overflow:ellipsis;
}
[ng\:cloak], [ng-cloak], .ng-cloak {
	display: none !important;
}
span.requiredInput,
input.requiredInput,
select.requiredInput,
textarea.requiredInput {
	border-left: 3px solid red !important;
}
div.bottomAlert {
	width: 100% !important;
	height: 36px !important;
	text-align: left !important;
	margin-bottom: 0px !important;
	padding-top: 7px !important;
	padding-bottom: 0 !important;
	margin-left: 15px !important;
}

span.closeButton {
	font-size: 25pt;
	color: #FFFFFF;
}
div.slds-modal {
	background: rgba(0, 0, 0, 0.5);
}

.paddingTop10 {
	padding-top:10px;
}

span.deleteWarning {
	font-weight: bold;
}

.mimmic-slds-form-element__label{
	color:#54698d !important;
}

div.modalBackground {
	z-index: 500;
	opacity: 0.3;
}

div.centerRelative {
	z-index: 10000 !important;
	position: absolute !important;
	left: 50% !important;
	top: 50% !important;
	transform: translate(-50%,-50%) !important;
}

md-progress-linear .md-bar {
	background-color: #0070D2 !important;
}

a.disabled {
	pointer-events: none;
	cursor: default;
}

div.buttonSeparator {
	padding: 15px 0px 0px 0px;
}
.force .dropdown-menu > li > a.sldsButtonText {
	color: #0070d2;
}

span.itemCounter {
	padding-left: 15px;
}

.disabledCustomLink{
	color: #D8DDE6;
	pointer-events: none;
	cursor: default;
}

.versionLinks.disabledCustomLink > img {
    opacity: 0.5;
}

.slds .slds-theme--info {
	background-color: #54698d!important;
	color: #fff!important;
}

.slds-notify.slds-notify--toast {
    min-width: 50%;
    max-width: 50%;
}

.slds-modal .slds-notify.slds-notify--toast {
    max-width: 99%;
    min-width: 99%;
}

.force .ui-container .slds-notify p {
    color: #ffffff;
    margin: 0;
}
.force .ui-container .slds .slds-text-heading--small {
    font-size: 18px;
    font-weight: 300;
    line-height: 1.25;
    margin: 0;
}
.force .ui-container .slds .slds-text-heading--medium {
    font-size: 24px;
    font-weight: 300;
    line-height: 1.25;
    margin: 0;
}
.force .ui-container .slds-badge.statusIcons .caret {
    margin-top: -2px;
}
.force .ui-container .col-xl-10 {
    width: 75%!important;
}
.truncate.full {
    width: 100%;
}

@media(max-width: 768px){
	.slds-notify.slds-notify--toast {
        min-width: 90%;
        max-width: 90%;
    }
}

#placeholderSearchBar {
	transition: all 300ms ease;
}

#placeholderSearchBar :hover{
	transition: all 300ms ease 300ms;
}

#placeholderSearchBar :focus{
	box-shadow: 0 4px 16px rgba(0,0,0,.25);
	height: 60px;
}

.italic {
	font-style: italic;
}

.rightNav{
	opacity: .96;
}

.picklistArrowRight.classicStyle,
.picklistArrowLeft.classicStyle {
	height: 20px !important;
	margin: 0 8px;
	width: 30px;
}

.docman-container .slds-modal .multiSelectPicklistTable .multiSelectPicklistCell {
	width: 38px;
}

input.bold {
	font-weight: bold!important;
}

select.classicStyle {
	width: 100%!important;
}

.slds-modal--medium.request-documents .slds-modal__container {
	width: 60%;
	max-width: 700px;
}

.slds-text-heading--large.title-text {
	font-size: 23px;
	font-weight: 400;
}
.slds-text-heading--smaller.sub-text {
	font-size: 13px;
	line-height: 1.6;
	color: #777777;
}

.previewUnavailableBox {
	width: 161px;
	height: 209px;
	border: 2px solid #CFD5E0;
	background: white;
}

.previewUnavailableText {
	font-family: Avenir;
	position: relative;
	float: left;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
}

.slds-section__title.modal-section {
	border-radius: 5px;
}

.uploading-status-theme {
	background-color: #919191 !important;
	color: white !important;
}

.ready-to-tag-status-theme {
	background-color: #0070d2 !important;
	color: white !important;
}

div.previewTopbar {
	position: fixed;
	background-color: rgba(0,0,0,0.9);
	top: 0;
	left: 0;
	width: 100%;
	height: 50px;
	z-index: 200000;
}
div.bottomBar {
	position: fixed;
	background-color: rgba(0,0,0,0.9);
	bottom: 0;
	left: 0;
	width: 100%;
	height: 50px;
	z-index: 200000;
}
div.expandedPreviewBackground {
	background-color: rgba(0,0,0,0.8);
	width: 100%;
	height: 100%;
	z-index: 100000;
	top: 0;
	left: 0;
	position: fixed;
	overflow: scroll;
}
img.centeredImage {
	margin: 100px 0 100px 50%;
	-ms-transform: translateX(-50%);
	-webkit-transform: translateX(-50%);
	-moz-transform: translateX(-50%);
	transform: translateX(-50%);
	max-width: 50%;
	min-width: 40%;
	background-color: white;
}
.loadingContainer {
	position: fixed;
	height: 150vh;
	width: 100vw;
	overflow: hidden;
	z-index: 9050;
	visibility: visible;
	opacity: 1;
	-webkit-transition: opacity 0.2s ease, visibility 0s;
	transition: opacity 0.2s ease, visibility 0s;
	-webkit-transition-delay: 0s, 0.3s;
	transition-delay: 0s, 0.3s;
}

div.loadingContainer > div {
	text-align: center;
	margin-top: 25vh;
}

.loadingText {
	color: #DDD !important;
	font-size: 2rem !important;
	white-space: nowrap;
	font-weight: bold !important;
}
.loadingTextSmall {
	color: #DDD !important;
	font-size: .875rem !important;
	font-weight: bold !important;
}
.centeredLoadingImage {
	height: 3.5rem;
	width: 3.5rem;
}
div.expandedPreviewTitle {
	color: white;
	padding: 15px 0 0 15px;
	font-weight: bold;
}
div.closeExpandedPreview {
	color: #FFF;
	padding-top: 10px;
	font-weight: bold;
	font-size: 20px;
}

div.expandedPreviewControls.toolbar.bottom {
	white-space: nowrap;
	font-size: .8125rem;
	color: white;
	position: fixed;
	z-index: 1;
	bottom: 0;
	margin: 20px auto;
	padding: 13px 0;
	left: 50%;
	-webkit-transform: translateX(-50%);
	-ms-transform: translateX(-50%);
	transform: translateX(-50%);
	border-radius: 5px;
	box-shadow: 0 0 2px 0 rgb(188, 188, 188);
	background-color: rgba(0,0,0,.8);
	font-weight: bold;
}

div.expandedPreviewControls input {
	outline: none;
	margin: 0 5px;
	padding: 3px 0;
	font-weight: 300;
	border-radius: 8px;
	border-color: transparent;
	font-family: inherit;
	font-size: inherit;
	line-height: inherit;
	font-weight: bold;
	color: #000;
	text-align: center;
	min-width: 2.5em;
	overflow: visible;
	text-overflow: ellipsis;
	white-space: nowrap;
}

div.expandedPreviewControls button {
	outline: none;
	background: none;
	border: none;
	-webkit-transition: all .5s ease-in-out;
	transition: all .5s ease-in-out;
	padding: 9px;
	margin: 0 3px;
	border-radius: 5px;
}

div.expandedPreviewControls span.lowercase {
	text-transform: lowercase;
}

div.expandedPreviewControls button svg {
	fill: #FFF;
	height: 16px;
	width: 16px;
}

div.expandedPreviewControls button:disabled svg {
	fill: #c9c7c5;
}

div.expandedPreviewControls input[type=number]::-webkit-inner-spin-button,
div.expandedPreviewControls input[type=number]::-webkit-outer-spin-button {
	-webkit-appearance: none;
	margin: 0;
}

.rightNavContainer{
	padding:0 !important;
	margin: 0px !important;
	background-color:#EEF1F6;
	position:absolute;
	right:-345px;
	top:0;
	height:880px;
	width:325px;
	overflow:hidden;
	box-shadow:-3px 0px 3px 0px rgba(0,0,0,0.16);
	z-index:15;
	border-right:1px solid #ECEBEA;
	opacity:0;
	transition-duration: 300ms;
	transition-property: right;
	transition-timing-function: ease-in-out
}

.rightNavContainer.side-show{
	right:0px;
	opacity: 0.96;
}

.rightNavContainer.side-show-add-active{
	opacity: 0.96;
}

.rightNavContainer.side-show-remove-active{
	opacity: 0.96;
}

.rightNavHeader{
	color:#16325C;
	font-size:14px;
	font-weight:normal;
	font-family:'Avenir-Roman',sans-serif;
	height:59px;
	width:100%;
	padding-top:20px;
	text-align:center !important;
}
.rightNavHeaderIcon{
	padding:20px 15px 0 0;
}
.rightNavSearchBar{
	padding:0 20px 20px 20px;
}
.rightNavRelationshipRow{
	background-color:#FFFFFF;
	border-bottom:1px solid #CFD5E0;
	margin:0 !important;
}
.rightNavRelationshipData{
	height: 48px;
	padding-top:16px !important;
	padding-right:20px !important;
	vertical-align:middle !important;
	color:#16325C;
}
.rightNavCollateralRow{
	background-color:#FFFFFF;
	border-bottom:1px solid #CFD5E0;
	margin:0 !important;
}
.rightNavCollateralData{
	height: 60px;
	padding-top:5px !important;
	padding-right:20px !important;
	vertical-align:middle !important;
	color:#16325C;
}
.rightNavCollateralDataIcon{
	padding-right: 20px !important;
	padding-top: 23px !important;
	color: #16325C;
}
.rightNavRelationshipScrollable{
	height:821px;
	overflow-y:auto;
	overflow-x:hidden;
	border-top:1px solid #CFD5E0;
}
.rightNavFileStagingData{
	height: 48px;
	color:#16325C;
	padding-top:17px;
}
.rightNavFileStagingDataTitle{
	padding-left:20px;
}
.rightNavFileDetailRow{
	border-bottom:1px solid #CFD5E0;
	height:64px;
	margin:0 !important;
	background-color:#F4F6F9;
}
.rightNavTableFileDetailData{
	vertical-align: middle !important;
	padding-left:20px !important;
	padding-top:16px !important;
	margin:0 !important;
}
.rightNavTableFileDetailDataOne{
	font-size:11px;
	vertical-align: middle !important;
}
.rightNavTableFileDetailDataTwo{
	font-size:11px;
	vertical-align: middle !important;
	padding-right:20px !important;
	padding-top:20px;
	text-align:right;
}
.rightNavFileStagingDataScrollable{
	height:772px;
	overflow-y:auto;
	overflow-x:hidden;
	border-top:1px solid #CFD5E0;
}
.rightNavArchiveScrollable{
	height:772px;
	overflow-y:auto;
	overflow-x:hidden;
	border-top:1px solid #CFD5E0;
}
.rightNavArchiveRow{
	border-bottom:1px solid #CFD5E0;
}
.rightNavArchiveSearchBar{
	padding: 0 15px 0 15px;
}
.rightNavBlueLink{
	color:#007DFF !important;
	display:inline-block;
	margin-right:16px !important;
	float:right;
}
.grayText{
	color: gray !important;
	font-size: 10px;
}
.noSpace{
	margin-bottom: -3px !important;
}
.panelOverrideRightNav{
	margin: 0 !important;
	padding: 0 !important;
	border: none !important;
	background-color: #FFFFFF !important;
}
@media (max-width: 767px){
	.rightNav{
		height: auto;
		overflow: auto;
		z-index: 10;
	}
}
.leftNav{
	background-color: #EEF1F6;
	height: 880px;
	color: #54698D !important;
	box-shadow: 1px 0px 0px 0px #D9DEEA;
	z-index: 10;
	position: relative;
}

.bold{
	font-weight: bold;
}

.allDocumentsPadding{
	padding-top: 23px;
}

.headers{
	padding-left: 20px;
	padding-bottom: 3%;
}

.modalFormPad{
	padding-bottom: 10px;
}

.leftNavAddNewButton{
	padding-top: 15px;
	padding-bottom: 15px;
	display: inline-block;
}

.leftNavSeparator{
	margin: 10px 10% !important;
}

.countCircle{
	margin-right:5px;
	float:left;
	display: block;
	padding-top:4px;
	height: 25px;
	width: 25px;
	-moz-border-radius: 50%;
	border-radius: 50%;
	background-color: white;
	color: #54698D !important;
	text-align: center;
	font-size: .8em;
}

.noCircleHorizontalAlign{
	padding-left: 52px;
}


.slds .slds-pill{
	background-color: transparent;
	position: static;
}

.slds .slds-scrollable--y{
	max-height: 34rem;
}

@media(max-width: 767px){
	.leftNav{
		height: auto;
	}
	.slds .slds-modal__container{
		width: 80%;
	}

	.slds-button-group.add-new-group{
		float: left !important;
	}
}

@media(min-width: 767px) and (max-width: 840px){
	.add-new-group .slds-button{
		padding: 0px 8px;
	}
}

.docman-placeholder-row {
	height: 48px;
	padding-top: 14px;
	border: 1px solid transparent;
	border-width: 1px 1px 1px 2px;
}
.docman-placeholder-row:hover {
	background-color: #F4F6F9;
}
.docman-placeholder-row:focus {
	outline: none;
}
.docman-placeholder-row.fileHover .row-child {
	pointer-events: none;
}
.docman-placeholder-row.fileHover {
	border: 1px solid #1173CF;
	border-width: 1px 1px 1px 2px;
	background-color: #E8F2FB;
}
.expandedPlaceholder {
	background:rgba(0,125,255,0.15);
	box-shadow:0px 1px 0px 0px #CFD5E0, 0px 0px 0px 0px #CFD5E0;
}
.expandedPlaceholderContainer{
	padding:20px;
}
.archiveAndDownloadLinks{
	float:left;
	padding-top:10px;
	padding-right:10px;
}
.versionLinks{
	float:left;
	padding-right:15px;
}
div.placeholderForm{
	border-top:1px solid #ddd;
}
.redExceptionDate {
	color: red;
}
.placeholderDropAndBrowse{
	border:1px dashed #A7B8D1;
	border-radius:3px;
	width:90% !important;
	margin:0 auto;
	padding:35% 10px 35% 10px !important;
	text-align: center;
}
.imagePreview{
	border:1px solid #ddd !important;
}
.slds-badge.statusIcons {
	margin-left: 0 !important;
	width:auto;
	max-width:120%;
	padding: 4px 12px 4px 8px;
	text-align: left;
}
.slds-badge.statusIcons.medium {
	max-width:100%;
}
.slds-badge.statusIcons .caret {
	margin-left: 4px;
}

button.slds-badge.statusIcons {
	background-image:none;
	border: none;
}
button.slds-badge.statusIcons.openStatusIcon,
.openStatusIcon {
	border: 1px solid #16325c;
}
div.iconPositioning {
	position: absolute;
	bottom: 20px;
}
div > ul > li.hoverAction:hover {
	background-color: #F4F6F9;
}
.wrapDescription {
	overflow-wrap: break-word;
}
.imageDrag{
	opacity: 0.001;
}
.expansionArrow {
	max-width: 50px;
	max-height: 50px;
}
.versionHistoryHeaderRow {
	height: 48px;
	padding-top: 14px;
	border-top: 1px solid #ddd;
	border-bottom: 1px solid #ddd;
}
.versionHistoryContentRow{
	height: 48px;
	padding-top: 14px !important;
	border-bottom: 1px solid #ddd;
}
.versionHistoryContentRow:hover{
	background-color: #F4F6F9;
}

.slds .slds-icon--small.portal-enabled {
	width: 27px;
	height: 27px;
	fill: #b0adab;
}

@media(min-width: 1440px){
	.col-xl-10 {
		width: 83.333%!important;
	}
}
.force .btn-default.productDropdownButtonHover{
	margin-top: 0px !important;
	border: 1px solid #ccc;
	line-height: 32px;
}
.productDropdownButtonHover:hover{
	background-color: #F4F6F9 !important;
}
.productDropdownButtonText{
	text-align:left;
	color:#54698D;
	font-family: Salesforce Sans;
	display: inline-block;
	vertical-align: top;
	max-width: 80% !important;
}
.productDropdownCaret{
	margin-left: 5% !important;
	color:#54698D;
}
.productDropdownContainer{
	right:15px;
	height:300px;
	overflow-x:hidden;
	color:#54698D;
}
.productDropdownList {
	padding-top:10px;
	height:39px;
	border-bottom:1px solid #D8DDE6;
	color:#16325C;
}
.productDropdownList:hover {
	background-color: #F4F6F9;
}
.productDropdownSearch{
	color:rgba(0,0,0,0.40);
	height:39px;
	border-bottom:1px solid #D8DDE6;
}
.slds .slds-input-has-icon button.slds-input__icon{
	right: 5px;
}

.slds .slds-input-has-icon nds-icon-utility-event.hydrated{
	display: flex;
}

.slds .slds-datepicker__filter_month.slds-grid.slds-grid_align-spread.slds-grow{
	justify-content: center;
}

.slds abbr{
	text-decoration: none;
}

.slds .slds-align_absolute-center{
	display: -webkit-box;
	display: -ms-flexbox;
	display: flex;
	-webkit-box-pack: center;
	-ms-flex-pack: center;
	justify-content: center;
	-ms-flex-line-pack: center;
	align-content: center;
	-webkit-box-align: center;
	-ms-flex-align: center;
	align-items: center;
	margin: auto;
}

/* Datepicker styles - remove after upgrading to SLDS ^2.5.2 */
.slds-dropdown-trigger_click .slds-dropdown,
.slds-dropdown-trigger--click .slds-dropdown {
	display: none;
}
.slds nds-input-datepicker .slds-dropdown-trigger_click.slds-is-open .slds-dropdown,
.slds nds-input-datepicker .slds-dropdown-trigger--click.slds-is-open .slds-dropdown {
	display: block;
	visibility: visible;
	opacity: 1;
}
.slds nds-input-datepicker .slds-datepicker__filter_month {
	padding: 0 0.25rem 0 0;
}
.slds nds-input-datepicker .slds-datepicker__filter_month.slds-grid.slds-grid_align-spread.slds-grow {
	-webkit-box-pack: justify;
	-ms-flex-pack: justify;
	justify-content: space-between;
}
.slds nds-input-datepicker .slds-button_icon-container {
	width: 2rem;
	height: 2rem;
}
/* End datepicker styles */

.slds-input-has-icon {
	position: relative;
}

nds-input-time span.slds-icon_container.slds-icon-utility-clock.slds-input__icon.slds-input__icon_right {
	margin-top: -0.65rem;
}

.slds-input-has-icon_right .slds-input__icon, .slds-input-has-icon--right .slds-input__icon {
	right: 0.45rem;
}

.slds-form-element__control .slds-icon.slds-icon_x-small, 
.slds-form-element__control .slds-icon--x-small {
	width: 16px;
	height: 16px;
	line-height: 1;
}
