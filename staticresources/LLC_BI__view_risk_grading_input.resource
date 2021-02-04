.risk_grade_input(id="!{oRiskGradeFactor.id}")
  :if isQuantitative(oRiskGradeFactor) && !bReadOnly
    :if oRiskGradeFactorValue != null && oRiskGradeFactorValue.quantitative != null
      %input.validate_risk_grade_input(value="!{oRiskGradeFactorValue.quantitative}")
    :if oRiskGradeFactorValue == null || oRiskGradeFactorValue.quantitative == null || oRiskGradeFactorValue.quantitative.length == 0
      %input.validate_risk_grade_input
  :if isQuantitative(oRiskGradeFactor) && bReadOnly
    :if oRiskGradeFactorValue != null && oRiskGradeFactorValue.quantitative != null 
      %input.validate_risk_grade_input(value="!{oRiskGradeFactorValue.quantitative}" disabled="disabled")
    :if oRiskGradeFactorValue == null || oRiskGradeFactorValue.quantitative == null || oRiskGradeFactorValue.quantitative.length == 0
      %input.validate_risk_grade_input(disabled="disabled")
  :if !isQuantitative(oRiskGradeFactor) && !bReadOnly
    %select.validate_risk_grade_input
      :each oRiskGradeCriteria in aoRiskGradeCriterias
        :if oRiskGradeFactorValue != null && oRiskGradeFactorValue.qualitative == oRiskGradeCriteria.description
          %option(value="!{oRiskGradeCriteria.id}" selected="selected")
            !{oRiskGradeCriteria.description}
        :if oRiskGradeFactorValue == null || (oRiskGradeFactorValue != null && oRiskGradeFactorValue.qualitative != oRiskGradeCriteria.description)
          %option(value="!{oRiskGradeCriteria.id}")
            !{oRiskGradeCriteria.description}
  :if !isQuantitative(oRiskGradeFactor) && bReadOnly
    %select.validate_risk_grade_input(disabled="disabled")
      :each oRiskGradeCriteria in aoRiskGradeCriterias
        :if oRiskGradeFactorValue != null && oRiskGradeFactorValue.qualitative == oRiskGradeCriteria.description
          %option(value="!{oRiskGradeCriteria.id}" selected="selected")
            !{oRiskGradeCriteria.description}
        :if oRiskGradeFactorValue == null || (oRiskGradeFactorValue != null && oRiskGradeFactorValue.qualitative != oRiskGradeCriteria.description)
          %option(value="!{oRiskGradeCriteria.id}")
            !{oRiskGradeCriteria.description}
