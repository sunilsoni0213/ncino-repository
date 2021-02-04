/* Layout */

.ncino {
	background: #acacac;
	padding: 12px 12px 12px 0;
	
	-moz-border-radius: 4px;
	-webkit-border-radius: 4px;
	border-radius: 4px;
}

.ncino .top-banner {
	background: #fff;
	height: 51px;
	margin: 0 0 18px 12px;
	padding: 6px 12px;
	
	-moz-border-radius: 4px;
	-webkit-border-radius: 4px;
	border-radius: 4px;
}

.ncino .top-banner .left {
	float: left;
	width: 14%;
}

.ncino .top-banner .left .logo {
	height: 49px;
	width: 150px;
}

.ncino .top-banner .right {
	float: left;
	margin: 5px 0 0 0;
	width: 85%;
}

.ncino .top-banner .right ul {
	list-style: none;
	margin: 0;
	padding: 0;
}

.ncino .top-banner .right ul li {
	margin: 0;
}

.ncino .top-banner .right ul li.loan-name {
	color: #236fbd;
	font-size: 18px;
	margin-bottom: 5px;
}

.ncino .top-banner .right ul li.loan-name span {
	color: #222;
	font-weight: bold;
}

.ncino .workspace {
	display: table;
	width: 100%;
}

.ncino .workspace .left {
	padding: 0;
	display: table-cell;
	width: 15%;
}

.ncino .workspace .right {
	display: table-cell;
	width: 85%;
}

.ncino .workspace .right .tabs {
	display: table-row;
	overflow: hidden;
}

.ncino .workspace .right .tabs a {
	background: #595959;
	color: #fff;
	display: block;
	float: left;
	margin: 0 5px 0 0;
	padding: 8px 16px;
	text-decoration: none;
	
	-moz-border-radius: 4px 4px 0 0;
	-webkit-border-radius: 4px 4px 0 0;
	border-radius: 4px 4px 0 0;
}

.ncino .workspace .right .tabs a.active,
.ncino .workspace .right .tabs a.active:hover {
	background: #fff;
	color: #222;
}

.ncino .workspace .right .tabs a:hover {
	background: #6f6e6e;
}

.ncino .workspace .right .body {
	background: #fff;
	display: table-inline;
	margin-bottom: -1px;
	padding: 18px 12px 12px 12px;
	
	min-height: 490px;
	height:auto !important;
	height: 490px;
	
	-moz-border-radius: 0 4px 4px 4px;
	-webkit-border-radius: 0 4px 4px 4px;
	border-radius: 0 4px 4px 4px;
}

/* Navigation */


.ncino .left .menu {
	display: block;
	width: 100%;
}

.ncino .left .menu a,
.ncino .left .menu .active {
	background: #595959;
	border: 1px solid #707070;
	border-width: 0 0 1px 0;
	color: #fff;
	margin: 0;
	display: block;
	padding: 12px 16px;
	text-decoration: none;
}

.ncino .left .menu a:hover {
	background: #6f6e6e;
}

.ncino .left .menu .active,
.ncino .left .menu .active:hover {
	background: #686868;
}

.ncino .left .menu .sub {
	background: #d7d7d7;
	border: 1px solid #ccc;
	border-width: 0 0 1px 0;
	color: #222;
}

.ncino .left .menu .sub:hover {
	background: #f7f7f7;
	color: #222;
}

.ncino .left .menu .sub.active {
	background: #fff;
}

.ncino .left .menu i {
	float: right;
}

/* General */

.ncino .clear-fix {
	clear: both;
}

.ncino .divider {
	border-top:1px solid;
	border-color: #F0EEEE;
}

.ncino table {
	border-collapse: collapse;
}

.ncino .tertiaryPalette{
	border-color: #ffffff !important;
	margin-bottom: 10px;
}

.ncino .bEditBlock .pbHeader>table, .ncino .apexp .bPageBlock.apexDefaultPageBlock .pbHeader>table, .ncino #ep.bLayoutBlock .pbHeader>table {
	border-bottom: 0px;
}

.ncino .apexp .bPageBlock .pbHeader .btn, .apexp .bPageBlock .pbBottomButtons .btn{
	background: #2773c1;
	color: #ffffff;
	padding: 10px;
	-moz-border-radius:4px;
	-webkit-border-radius:4px;
	border-radius:4px;
}

.ncino .bPageBlock .detailList {
	margin-top: 0px;
}

.ncino body, .bDetailBlock.bPageBlock .pbBody .labelCol, body .bDetailBlock.bPageBlock .pbBody .dataCol, body .bDetailBlock.bPageBlock .pbBody .data2Col, body .bPageBlock.bEditBlock .pbBody .labelCol, body .bPageBlock.bEditBlock .pbBody .dataCol, body .bPageBlock.bEditBlock .pbBody .data2Col {
	padding-top: 10px !important;
	padding-bottom: 10px !important;
}

.ncino .messages .alert,
.ncino .force .alert {
	margin: 0 0 12px 0;
}

.ncino h4,
.ncino .force h4 {
	display: block;
	margin: 0 0 12px 0;
	font-size: 15px;
}

.ncino .force .row-fluid .left span {
	margin-right: 12px;
}

.ncino .data-grid {
	margin-top: 18px;
}

.ncino .divider,
.ncino .formDivider {
	border: 1px solid #f7f7f7;
	border-width: 0 0 1px 0;
	display: block;
	margin-bottom: 16px;
	padding-top: 12px;
}

.ncino .formDivider {
	border-color: #ececec;
	margin-bottom: 0;
	padding-top: 0;
}

.ncino .addUpdate .row-fluid {
	min-width: 980px;
}

.ncino .addUpdate .left {
	float: left;
	min-width: 40%;
	width: 40%;
}

.ncino .addUpdate .right {
	float: left;
	min-width: 60%;
	width: 60%;
}

.ncino .addUpdate .right input[type="text"] {
	margin-right: 8px;
	margin-bottom: -2px;
	min-width: 250px;
}

.ncino .inlineEditWrite,
.ncino .inlineEditWriteOn {
	cursor: pointer;
	cursor: hand;
	height: 24px;
}

.ncino .table .none-found {
	background-color: #fffae4;
}

.ncino .handle {
	cursor: pointer;
	cursor: hand;
}

.ncino .text,
.ncino .textFocus {
	font-weight: normal;
}

.ncino .textFocus {
	color: #426600;
}

.ncino .table-hover tbody tr:hover > td {
	background-color: #eaf4fb;
}

.ncino .table td .disabled {
	margin-left: -1px;
}

.ncino .table .notSortable {
	-ms-filter: "progid:DXImageTransform.Microsoft.Alpha(Opacity=50)";
	filter: alpha(opacity=50);
	-moz-opacity: 0.5;
	-khtml-opacity: 0.5;
	opacity: 0.5;
}

.ncino .table tr td label {
	margin: 6px 12px 0 0;
}

.ncino .table tr td label input[type="checkbox"] {
	margin-bottom: 5px;
}

.ncino .select-onchange {
	background: #f7f7f7;
	border: 1px solid #ccc;
	border-width: 1px 0;
	margin-bottom: 16px;
	padding: 8px 12px;
}

.ncino .select-onchange span {
	color: #426600;
	font-size: 14px;
	margin: 0 8px 0 0;
}

.ncino th.right-aligned,
.ncino td.right-aligned {
	text-align: right;
}

.ncino .dataCell {
	padding: 8px 12px;
}

.ncino .dataCol textarea {
	height: 48px;
	width: 168px;
}

.ncino .list {
	border-width: 0 0 1px 0 !important;
	padding-top: 2px !important; 
}

.ncino .headerRow {
	background: none !important;
	border-width: 0 0 1px 0 !important;
}

.ncino .clear {
	clear: both;
}

.ncino .btn {
	background: #1e65ac !important;
	border: none;
	color: #fff;
	font-size: 14px;
	font-weight: normal !important;
	margin: 0;
	text-shadow: none !important;
	
	-moz-border-radius: 4px;
	-webkit-border-radius: 4px;
	border-radius: 4px;
}

.ncino .btn:hover {
	background: #1d76d0 !important;
}

.ncino .btn-primary,
.ncino .submitButton {
	margin-right: 12px !important;
	padding: 8px 24px !important;
}

.ncino .btn-search {
	margin-right: 12px !important;
	padding: 5px 15px !important;
}

.ncino .btn-search:hover {
	color: #fff !important;
}

.ncino .btn-mini {
	font-size: 12px;
	margin: 0 6px 0 0 !important;
	padding: 1px 12px !important;
}

.ncino .btn-mini:hover {
	background: #1d76d0 !important;
	color: #fff !important;
}

.ncino .disabled,
.ncino .disabled:hover {
	background: #ccc !important;
	color: #333 !important;
}