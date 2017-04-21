﻿// Originally submitted to OSEHRA 2/21/2017 by DSS, Inc. 
// Authored by DSS, Inc. 2014-2017

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using VA.Gov.Artemis.UI.Data.Models.Patient;

namespace VA.Gov.Artemis.UI.Data.Models.Pregnancy
{
    public class EditPregnancyHistory: PatientRelatedModel
    {
        //public BasePatient Patient { get; set; }

        public PregnancyHistory History { get; set; }

        public string ReturnUrl { get; set; }
    }
}
