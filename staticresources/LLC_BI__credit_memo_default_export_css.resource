@page {
	size: auto;/* width height */
	margin: 6em 2em 3em;
	@top-left {
		content: element(logoImage);
	}
	@top-center {
		content: element(loanName);
	}
	@top-right {
		content: element(creditMemoName);
	}
	@bottom-left {
		content: element(generatedBy);
	}
	@bottom-center {
		content: element(footer);
	}
	@bottom-right {
		content: element(currentTimestamp);
	}
}
body {
	font-family: sans-serif, SansSerif, Times;
}
div.logoImage {
	padding: 10px;
	position: running(logoImage);
	font-family: sans-serif, SansSerif, Times;
}
div.loanName {
	padding: 10px;
	position: running(loanName);
	font-family: sans-serif, SansSerif, Times;
}
div.creditMemoName {
	padding: 10px;
	position: running(creditMemoName);
	font-family: sans-serif, SansSerif, Times;
	text-align: right;
}
div.currentTimestamp {
	padding: 10px;
	position: running(currentTimestamp);
	font-family: sans-serif, SansSerif, Times;
	text-align: right;
}
div.generatedBy {
	padding: 10px;
	position: running(generatedBy);
	font-family: sans-serif, SansSerif, Times;
}
div.footer {
	display: block;
	padding: 5px;
	position: running(footer);
	font-family: sans-serif, SansSerif, Times;
}
.pagenumber:before {
	content: counter(page);
}
.pagecount:before {
	content: counter(pages);
}
.hidden-print {
	display:none;
}
.table>thead>tr>th, .table>tbody>tr>th, .table>tfoot>tr>th, .table>thead>tr>td, .table>tbody>tr>td, .table>tfoot>tr>td {
	font-size: .8em;
	padding: 1px !important;
}

table.spread_table.styled {
	width: auto;
	margin-left: 0;
	background: white;
	box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.5);
}

.spread_table.styled > thead > tr:first-child > th:first-child {
	width: 150px;
	height: 40px;
	background: #EAEAEA;
}

.spread_table.styled > thead > tr:first-child > th {
	min-width: 75px;
	height: 40px;
	background: #F5F5F5;
	text-align: center;
}

.spread_table.styled > * > tr > *:first-child {
	width: 150px;
	height: 40px;
	background: #F5F5F5;
}

.spread_table.styled > * > tr > *:not(:first-child) {
	min-width: 150px;
	height: 40px;
}

.spread_table.styled .spread_record {}

.spread_table.styled .spread_record_title {}

.spread_table.styled .spread_record_exclude {
	float: right;
	color: #999;
	cursor: pointer;
}

.spread_table.styled .spread_record_value {
	text-align: center;
}

.spread_table.styled .spread_period_total {
	font-weight: bold;
}

.spread_table.styled .spread_period_total > td {
	border-top-width: 1px;
	border-top-style: solid;
	border-top-color: #555;
}

.spread_table.styled .spread_period_total_title {}

.spread_table.styled .spread_period_total_value {
	text-align: center;
}
