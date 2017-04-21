﻿// Originally submitted to OSEHRA 2/21/2017 by DSS, Inc. 
// Authored by DSS, Inc. 2014-2017

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VA.Gov.Artemis.CDA.Common
{
    //ALG|OINT|DALG|EALG|FALG|DINT|EINT|FINT|DNAINT|ENAINT|FNAINT
    public enum Hl7ObservationIntoleranceType
    {
        Unknown, Allergy, Intolerance, DrugAllergy, EnvironmentalAllergy, FoodAllergy, DrugIntolerance, EnvironmentalIntolerance, FoodIntolerance, 
        DrugNonAllergyIntolerance, EnvironmentalNonAllergyIntolerance, FoodNonAllergyIntolerance
    }
}
