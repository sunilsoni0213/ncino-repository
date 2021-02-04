public class CSA_OverviewController {

	public Map<String, List<CSA_StageBreakdown>> overviewList {get;Set;}
	public List<Overview_Properties__c> stageProperties {get;Set;}
	public List<Overview_Properties__c> statusProperties {get;Set;}
	public List<Overview_Properties__c> productLineProperties {get;Set;}
	public String[] selectedProductLines {get;Set;}
	public String[] selectedStages {get;Set;}
	public String[] selectedStatus {get;Set;}
	public String selectedBranch {get;Set;}
	public String selectedLoanTeamMember {get;Set;}
	public Map<String, Overview_Properties__c> overviewMap {get;Set;}
	public AggregateResult[] loanList {get;Set;}

	public CSA_OverviewController() {
		this.overviewList = new Map<String, List<CSA_StageBreakdown>>();
		this.overviewMap = new Map<String, Overview_Properties__c>();
		this.stageProperties = getOverviewProperties(USABLESTAGE);
		this.statusProperties = getOverviewProperties(USABLESTATUS);
		this.productLineProperties = getOverviewProperties(USABLEPRODUCTLINE);

		this.selectedProductLines = getUsableList(this.productLineProperties);
		this.selectedStages = getUsableList(this.stageProperties);
		this.selectedStatus = getUsableList(this.statusProperties);

		for (Overview_Properties__c op: this.stageProperties) {
			this.overviewMap.put(op.Stage_Status_Product_Line_Name__c, op);
		}

		this.selectedBranch = NONE;
		this.selectedLoanTeamMember = NONE;

		this.overviewList = getOverviewList(this.selectedBranch, this.selectedLoanTeamMember);
	}

	public void applyFilter() {
		this.overviewList = getOverviewList(this.selectedBranch, this.selectedLoanTeamMember);
	}

	private Map<String, List<CSA_StageBreakdown>> getOverviewList(String branch, String loanTeam) {
		Map<String, List<CSA_StageBreakdown>> newOList = new Map<String, List<CSA_StageBreakdown>>();
		this.loanList = new AggregateResult[]{};
		if (branch != NONE && loanTeam != NONE) {
			this.loanList = getLoansWithTeamMemberAndBranch(loanTeam, branch);
		} else if (branch != NONE && loanTeam == NONE) {
			this.loanList = getLoansWithBranch(branch);
		} else if (branch == NONE && loanTeam != NONE) {
			this.loanList = getLoansWithTeamMember(loanTeam);
		} else {
			this.loanList = getLoans();
		}

		for (String spl: this.selectedProductLines) {
			List<CSA_StageBreakdown> stageList = new List<CSA_StageBreakdown>();
			Integer count = 1;
			for (String ss: this.selectedStages) {
				stageList.add(new CSA_StageBreakdown(this.loanList, ss, this.selectedStatus, count, this.overviewMap, spl));
				count += 1;
			}
			newOList.put(spl, stageList);
		}

		return newOList;
	}

	public Boolean getCheckMapSize() {
		return this.overviewList.isEmpty();
	}

	public List<SelectOption> getBranchesPicklist() {
        List<SelectOption> newSO = new List<SelectOption>();
		newSO.add(new SelectOption(NONE, NONESELECT));
        for (LLC_BI__Branch__c b: getBranches()) {
            newSO.add(new SelectOption(b.Id, b.Name));
        }

        return newSO;
    }

	private List<LLC_BI__Branch__c> getBranches() {
		return [SELECT
					Id,
					Name
				FROM 
					LLC_BI__Branch__c];
	}

	public List<SelectOption> getLoanTeamMembersPicklist() {
        Set<SelectOption> newSO = new Set<SelectOption>();
		newSO.add(new SelectOption(NONE, NONESELECT));
        for (LLC_BI__LoanTeam__c lt: getLoanTeamMembers()) {
            newSO.add(new SelectOption(lt.LLC_BI__User__c, lt.LLC_BI__User__r.Name));
        }
		
		List<SelectOption> newS = new List<SelectOption>();
		newS.addAll(newSO);
        return newS;
    }

	private List<LLC_BI__LoanTeam__c> getLoanTeamMembers() {
		return [SELECT
					Id,
					LLC_BI__User__c,
					LLC_BI__User__r.Name
				FROM 
					LLC_BI__LoanTeam__c];
	}

	private String[] getUsableList(List<Overview_Properties__c> properties) {
		String[] val = new List<String>();
		for (Overview_Properties__c op: properties) {
			val.add(op.Stage_Status_Product_Line_Name__c);
		}

		return val;
	}

	private List<Overview_Properties__c> getOverviewProperties(String category) {
		return [SELECT
					Id,
					Name,
					Stage_Status_Product_Line_Name__c,
					Category_Name__c,
					Report_Name__c,
					Report_Id__c, 
					Is_Active__c
				FROM
					Overview_Properties__c
				WHERE 
					Category_Name__c = :category
				AND 
					Is_Active__c = true
				ORDER BY 
					Order__c ASC];
	}

	private AggregateResult[] getLoans() {
		return [SELECT 
					Count(Id)total,
					LLC_BI__Stage__c,
					LLC_BI__Status__c,
					LLC_BI__Product_Line__c
				FROM 
					LLC_BI__Loan__c
				GROUP BY
					LLC_BI__Product_Line__c, 
					LLC_BI__Stage__c, 
					LLC_BI__Status__c];
	}

	private AggregateResult[] getLoansWithTeamMember(Id userId) {
		return [SELECT 
					Count(Id)total,
					LLC_BI__Stage__c,
					LLC_BI__Status__c,
					LLC_BI__Product_Line__c
				FROM 
					LLC_BI__Loan__c
				WHERE 
					Id IN (SELECT
								LLC_BI__Loan__c 
							FROM 
								LLC_BI__LoanTeam__c
							WHERE
								LLC_BI__User__c = :userId)
				GROUP BY
					LLC_BI__Product_Line__c, 
					LLC_BI__Stage__c, 
					LLC_BI__Status__c];
	}

	private AggregateResult[] getLoansWithTeamMemberAndBranch(Id userId, Id branchId) {
		return [SELECT 
					Count(Id)total,
					LLC_BI__Stage__c,
					LLC_BI__Status__c,
					LLC_BI__Product_Line__c
				FROM 
					LLC_BI__Loan__c
				WHERE 
					LLC_BI__branch__c =: branchId
				AND
					Id IN (SELECT
								LLC_BI__Loan__c 
							FROM 
								LLC_BI__LoanTeam__c
							WHERE
								LLC_BI__User__c = :userId)
				GROUP BY
					LLC_BI__Product_Line__c, 
					LLC_BI__Stage__c, 
					LLC_BI__Status__c];
	}

	private AggregateResult[] getLoansWithBranch(Id branchId) {
		return [SELECT 
					Count(Id)total,
					LLC_BI__Stage__c,
					LLC_BI__Status__c,
					LLC_BI__Product_Line__c
				FROM 
					LLC_BI__Loan__c
				WHERE 
					LLC_BI__Branch__c =: branchId
				GROUP BY
					LLC_BI__Product_Line__c, 
					LLC_BI__Stage__c, 
					LLC_BI__Status__c];
	}

	private static final String USABLESTAGE = 'Usable_Stage';
	private static final String USABLESTATUS = 'Usable_Status';
	private static final String USABLEPRODUCTLINE = 'Usable_Product_Line';
	private static final String BLANK = '';
	private static final String NONESELECT = '-- None --';
	private static final String NONE = 'None';
}