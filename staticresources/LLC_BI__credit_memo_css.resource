table {
	font-size: 1em;
}

table.vertical td {
	border-left: 1px solid #ddd;
}

table.vertical th {
	border-right: 2px solid #ddd;
}

table.vertical {
	border: 1px solid #ddd;
}

table.spread_table.styled {
	width: auto;
	margin-left: 0;
	background: white;
	box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.5);
}

.spread_table.styled > thead > tr:first-child > th:first-child {
	width: 270px;
	min-width: 270px;
	height: 40px;
	background: #EAEAEA;
}

.spread_table.styled > thead > tr:first-child > th {
	width: 200px;
	min-width: 100px;
	height: 40px;
	background: #F5F5F5;
	text-align: center;
}

.spread_table.styled > * > tr > *:first-child {
	width: 270px;
	min-width: 270px;
	height: 40px;
	background: #F5F5F5;
}

.spread_table.styled > * > tr > *:not(:first-child) {
	width: 200px;
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
	text-align: right;
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
	text-align: right;
}

.save_version_overflow {
	overflow: visible !important;
}
#placeholder_chosen .chosen-results {
	max-height:150px;
}