/*START DANIEL'S CSS*/

div[ng-controller="DashboardNavController as dvm"] .portal-center-column {
    margin-top: 0 !important;
}

.portal-topbar span[ng-controller="pso-nav-top-user-text"] {
    color: #4f6d8d;
}

.slds-size--1-of-1.slds-medium-size--2-of-6.slds-large-size--1-of-6.slds-order--1 {
    background: linear-gradient(to bottom, rgba(255,255,255,0.9) 0%,rgba(255,255,255,0.9) 84%,rgba(255,255,255,0) 100%);
    min-height: 780px;
}

/*{transform: all .3s ease; transition: all .3s ease}*/

/*
div.portal-wrapper {
    z-index: 1000;
    position: fixed;
    background-color: transparent !important;
}
*/

.tab-pane {
    padding: 0 15px 15px 15px;
}

.col-xs-6.powered-by {
    position: fixed;
    bottom: 5px;
    right: 33px;
    background-color: rgba(255,255,255,.9);
    width: 170px;
    padding: 10px 0 7px 19px;
    border-radius: 20px;
}

.portal-nav-section {
    background: linear-gradient(to bottom, rgba(255,255,255,0.9) 0%,rgba(255,255,255,0.9) 84%,rgba(255,255,255,0) 100%);
    min-height: 1200px;
    color: rgb(23, 88, 94);
}

@media (max-width: 768px) {
.portal-nav-section {
    background: initial;
    min-height: initial;
}
}

/*
div.portal-wrapper-full > div.slds-grid > div.portal-center-column {
   margin: 68px auto 0 auto !important;
}
*/

.slds-card__header h2.slds-text-heading--small.slds-truncate {
}

/*END DANIEL'S CSS*/

html.portal-html, body.portal-body {
	margin: 0;
	height: 100%;
	background-color: #FFFFFF;
}

body.portal-body div.slds-grid {
	width: 100%;
}

/*
div.portal-wrapper-full {
	min-height: 100%;
	height: auto !important;
	height: 100%;
	margin: 0 auto -48px; /* Negative value of footer height */
}
*/

div.portal-wrapper {
	background-color: #f2f5f8;
	/*width: 75%;*/
	margin: 0 auto 0 auto;
}

header.portal-topbar {
	background-color: #ffffff;
	box-shadow: 0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24);
}

/*
header.portal-topbar img.portal-topbar-logo {
	height: 30px;
}
*/

div.portal-center-column--prelim {
	margin: 0 auto 0 auto;
}

div.portal-center-column {
	margin: 0 auto 0 auto;
}

.portal-center-text {
	text-align: center;
}

div.portal-center-column .slds-form--stacked,
div.portal-center-column .portal-form-container {
	border: 1px solid #d8dde6;
	border-radius: 4px 4px 4px 4px;
}

ul.portal-checklist > li > img {
	height: 15px;
}

.slds small.portal-icon-container {
	vertical-align: text-top;
}

.slds img.portal-icon-small {
	height: 40px;
}

.slds div.portal-no-margin {
	margin-left: 0 !important;
	margin-right: 0 !important;
	margin-top: 0 !important;
	margin-bottom: 0 !important;
}

.slds div.portal-recaptcha {
	width: 304px;
	margin-left: auto;
	margin-right: auto;
}

.slds .portal-media-icon-parent {
	position: relative;
}

.slds .portal-media-icon-child {
	position: absolute;
	top: 0;
	left: 50%;
	transform: translate(-50%, -50%);
	background-color: #fe8456;
	padding: 18px;
}

.slds img.portal-security-badge {
	height: 50px;
	width: auto;
}

.slds div.portal-nav-wrapper {
	background-color: #FFFFFF;
}

.slds ul.portal-nav-items {
	margin-top: 27px;
}

.slds ul.portal-nav-items li {
	margin-bottom: 64px;
	font-size: 10pt;
	color: #0070d2;
}

.slds svg.portal-nav-gfx {
	margin-top: 20px;
}

.portal-line-visited {

}

.portal-circle-visited {

}

.portal-line-future {

}

.portal-circle-future {

}

.slds .portal-nav-text-child {
    color: #4a5e82;
}

.slds .portal-nav-text-parent {
    color: #4a5e82;
}

.slds .portal-primary-color-text {
	color: #4a5e82;
}

.slds div.portal-help-icon {
	padding-bottom: 8px;
}

.slds .portal-help-icon .slds-icon_container, .slds .portal-help-icon .portal-tooltip-label {
	cursor: pointer;
	color: #0070d2;
}

.slds .portal-help-icon .slds-icon {
	height: 20px;
	width: 20px;
	fill: #0070d2;
}

.slds .portal-help-icon span {
	color: #0070d2;
	font-size: 12px;
}

.slds div.portal-mobile-tooltip {
	max-width: 200px;
}

.slds .portal-tooltip-x-small .alert {
	margin-bottom: 0;
}

.slds .portal-tile-icon {
	position: relative;
	top: 30px;
	left: 50%;
	transform: translate(-50%, -50%);
	background-color: #fe8456;
	padding: 18px;
}

.slds .portal-text-light {
	color: #54698d;
}

.slds .portal-card-contents {
	background-color: #ffffff;
}

.slds .slds-card {
    box-shadow: 0 2px 8px -2px rgba(0,0,0,.3);
}

.slds .portal-success {
	background-color: #e1faef;
	color: #57cb86;
}

.slds .portal-success-text {
	color: #57cb86;
}

.slds .portal-success-text .slds-icon-text-default {
	fill: #57cb86;
}

div.portal-review-section {
    background-color: #FFFFFF;
	border:1px solid #d8dde6;
	border-radius: 4px 4px 4px 4px;
	padding:15px;
}

.slds .slds-badge-primary {
	background: #005fb2;
}

.slds div.portal-white-bg {
    background: #FFFFFF;
}

.slds div.portal-review-section .slds-button--neutral {
	line-height: 30px;
	padding-left: 14px;
	padding-right: 14px;
}

div.portal-review-section .slds-grid .slds-form-element__static {
	font-size: 14px;
	line-height: 18px;
	min-height: 30px;
}

.slds .portal-failure {
	background-color: #ffdedd;
	color: #c13f3c;
}

.slds .portal-failure strong {
	color: #c13f3c;
}

.portal-loader-overlay {
	position:fixed;
	top: 0;
	left: 0;
	height: 100%;
	width: 100%;
	z-index: 10;
	background-color: rgba(0,0,0,0.7);
}

.portal-loader-overlay .portal-loader-message {
	position: absolute;
	top: 60%;
	width: 100%;
	color: #fff;
}

.portal-loader-overlay .portal-loader-message img {
	display:block;
	margin:0 auto;
}

.slds div.portal-card-footer {
	margin-top: 0;
	text-align: left;
}

.slds .app-next-steps {
	margin-top: 30px;
}

.slds .app-next-steps li {
	margin-bottom: 20px;
	padding-left: 15px;
}

body.portal-body div.slds-notify_container {
	height: 0px;
}

body.portal-body div.slds-notify--toast {
	margin-top: 100px;
}

body.portal-body div.slds-notify div.slds-grid {
	width: auto;
}

body.portal-body div.slds-notify h2 {
	color: #fff;
}

body.portal-body div.slds-notify h2 {
	color: #fff;
}

body.portal-body div.slds-notify p {
	color: #fff;
}

.slds div.portal-lookup-menu {
	display: block;
}

.slds span.slds-icon_container > img.portal-list-icon {
	margin-right: 0px;
}

.slds div.portal-form-container hr {
	margin: 20px 0;
}

.slds .portal-tooltip-popover-text {
	color: #16325c;
}

div.slds-overflow--auto {
	overflow: auto;
}

.slds label.slds-form-element__label {
	font-weight: normal;
}

.slds .portal-tile-header {
}

.slds .portal-tile-body {
	border-top: 1px solid #d8dde6;
	background-color: #FFFFFF;
}

.slds .portal-nav-section {
	padding-top: 25px;
}

.slds .portal-content-section {
	border-left: 1px solid #fff;
}

.slds svg.portal-right-arrow {
	height: 20px;
	width: 20px;
	margin-left: 5px;
	-ms-transform: rotate(90deg); /* IE 9 */
	-webkit-transform: rotate(90deg); /* Chrome, Safari, Opera */
	transform: rotate(90deg);
	fill: #ffffff;
}

/*.slds .portal-tile-header {
	display:none;
}*/

.slds .portal-orbar-text {
	color:#54698d;
	font-size:14px;
}

.slds label.slds-checkbox {
	margin-bottom: 0;
}


button#registerUser {
    color:#adaecc
}


div[n-style="pso-failure-background"] div.portal-center-column {
    margin-top: 150px !important;
}


.slds .dashboard-nav-horizontal .is-active span {
	border-bottom: 5px solid #1b96ab;
}

.slds .dashboard-nav-horizontal .is-active:hover span {
	border-bottom: 5px solid #1b96ab;
}

.slds .slds-button--brand[disabled] {
	background-color: #e0e5ee !important;
}
Quick Link
Quick Console
Home
Quick Query
Execute Anonymous
Sobject fields
Quick ORG Describe
Replace API Names
Convert SF Id
Login As...
Games
Options
Hide
Wanna see your adv. here?
Sponsorship program