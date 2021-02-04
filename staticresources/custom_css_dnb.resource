#business-credit-report,
#select-account {
                margin-top: 8px;
}

#business-credit-report div.heading {
                background-color: #606060; 
                border: 1px solid #606060; 
                border-radius: 4px;
                color: #fff;
                margin: 12px 0 18px 0;
                padding: 12px 18px;
                
                -webkit-border-radius: 4px;
                -moz-border-radius: 4px;
}

#business-credit-report div.heading div.business-name {
                font-size: 18px;
                font-weight: bold;
                padding: 8px 0 0 0;
                text-transform: uppercase;
}

#business-credit-report div.heading div a {
                color: #fff;
                cursor: pointer;
                cursor: hand;
                padding: 10px 0 0 0;
}

#business-credit-report div.heading div.account-info {
                margin: 0;
                padding: 0;
}

#business-credit-report div.heading div p {
                margin: 3px 0 0 0;
}

#business-credit-report div table thead.thead-green {
                background-color: #548026;
                color: #fff;
}

#business-credit-report div table thead.thead-orange {
                background-color: #eba644;
                color: #fff;
}

#business-credit-report div table thead.thead-red {
                background-color: #9c3b32;
                color: #fff;
}

#business-credit-report div table tbody tr td.td-label,
#business-credit-report div table tbody tr:hover td.td-label  {
                background-color: #f9f9f9;
                color: #222;
}

#business-credit-report div table tbody tr td.center-align,
#business-credit-report div div table thead tr th.center-align {
                text-align: center;
}

#business-credit-report table tbody tr td.center-align span {
                text-align: center;
                width: 60%;
}

#business-credit-report div table thead,
.table thead {
                background-color: #ddeaba;
}

#business-credit-report div table tfoot,
.table tfoot {
                background-color: #dbdbdb;
}

#business-credit-report .table-hover tbody tr:hover > td {
                background-color: #eaf4fb;
}

.ucWords {
                text-transform: capitalize;
}

.std-bottom-margin {
                margin-bottom: 12px;
}

/*BEGIN: Print */
@media print {
                body * {
                                height: auto;
                                width: 100%;
                                visibility: hidden;
                }
                #business-credit-report, #business-credit-report * {
                                visibility: visible;
                }
                #business-credit-report {
                                left: 0;
                                position: absolute;
                                top: 0;
                }
                #business-credit-report table,
                #business-credit-report table tr th,
                #business-credit-report table tr td {
                                border: 1px solid #999;
                                border-collapse: none;
                }
}
/*END: Print */
