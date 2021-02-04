/* global fix for slds's use of position "fixed" on modal containers. */
.slds div.slds-modal {
	overflow-x: auto
}

/* global fix for alert messages. */
.force .ui-container .body div.alert.alert-warning {
	width:100%;
	text-align: center;
}

.force .ui-container .body div.alert.alert-warning h4 {
	margin-top: 0;
}

.force ul.slds-tabs--scoped__nav, .force ul.slds-grid {
	list-style: none;
}

td.noSidebarCell {
	padding: 0;
}

#ncCollateral2 {
	background-color: white;
	margin-top: 10px;
	margin-left: 16px;
	margin-right: 16px;
}

.slds .slds-checkbox span.slds-checkbox--faux{
	content: '';
	border-color: #1589ee;
	box-shadow: 0 0 3px #0070D2;
	width: 1rem;
	height: 1rem;
	cursor: pointer;
}

.slds .slds-checkbox [type=checkbox]:checked~.slds-checkbox--faux:after{
	border-color: #36a0fe;
	display: block;
	content: '';
	height: 6px;
	width: 10px;
	position: absolute;
	top: 42%;
	left: 51.5%;
}

.slds .slds-checkbox [type=checkbox][disabled]+span.slds-checkbox--faux{
	box-shadow: none;
	cursor: default;
}

.slds svg.slds-icon.slds-icon--small.slds-m-right--small.small-arrow {
	margin-top: 4px;
}

.slds .lookup-results--container label.slds-checkbox__label {
	margin-top: 1px;
}